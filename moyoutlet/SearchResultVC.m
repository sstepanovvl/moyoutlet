//
//  SearchResultVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 29.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "SearchResultVC.h"
#import "OfferCollectionViewCell.h"
#import "OfferVC.h"

@interface SearchResultVC ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end


#define kCellsPerRow 2

@implementation SearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigationItems];

    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];


    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [_searchBar sizeToFit];
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Поиск в MoyOutlet";
    [[UISearchBar appearance] setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.navigationItem.titleView = _searchBar;
    self.definesPresentationContext = YES;
    _searchBar.text = _searchString;

    _collectionView.alwaysBounceVertical = YES;
    _collectionView.alwaysBounceHorizontal = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;

    [_collectionView registerNib:[UINib nibWithNibName:@"OfferCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OfferCollectionViewCell"];


    CGFloat availableWidthForCells = CGRectGetWidth(self.view.frame) - _flowLayout.sectionInset.left - _flowLayout.sectionInset.right - _flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);

    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
//    CGFloat cellWidth = 165.f;

    _flowLayout.itemSize = CGSizeMake(cellWidth, _flowLayout.itemSize.height);

}

-(void)initNavigationItems {

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];

    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;
    self.navigationItem.titleView = _searchBar;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%f,%f",self.view.frame.size.width,self.view.frame.size.height);

    if (![_searchResults count]) {

        [MBProgressHUD showHUDAddedTo:_collectionView animated:YES];

        [API requestWithMethod:@"searchOffers"
                       andData:@{@"search":_searchString}
                   withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       NSError* err;
                       NSDictionary* resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                       if (!resp) {
                           NSLog(@"Request error: %@",err.localizedDescription);
                       } else {
                           NSMutableArray* arr = [NSMutableArray array];
                           for (NSDictionary* offer in [resp valueForKey:@"offers"]) {
                               OfferItem* item = [[OfferItem alloc] initWith:offer];
                               [arr addObject:item];
                           }
                           _searchResults = arr;

                           dispatch_async(dispatch_get_main_queue(), ^{
                               [_collectionView reloadData];
                               [_collectionView layoutIfNeeded];
                               [MBProgressHUD hideHUDForView:_collectionView animated:YES];
                           });
                       }
                   }];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    _searchString = searchBar.text;

    [MBProgressHUD showHUDAddedTo:_collectionView animated:YES];

    [API requestWithMethod:@"searchOffers"
                   andData:@{@"search":searchBar.text}
               withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   NSError* err;
                   NSDictionary* resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                   if (!resp) {
                       NSLog(@"Request error: %@",err.localizedDescription);
                   } else {
//                       NSLog(@"%@",resp);
                       NSMutableArray* arr = [NSMutableArray array];
                       for (NSDictionary* offer in [resp valueForKey:@"offers"]) {
                           OfferItem* item = [[OfferItem alloc] initWith:offer];
                           [arr addObject:item];
                       }
                       _searchResults = arr;

                       dispatch_async(dispatch_get_main_queue(), ^{
                           [_collectionView reloadData];
                           [_collectionView layoutIfNeeded];
                           [MBProgressHUD hideHUDForView:_collectionView animated:YES];
                       });
                   }
               }];
    [searchBar resignFirstResponder];

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {");
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {");

}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {

    NSLog(@"- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar ");
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar");


}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    NSLog(@"%@",searchText);
    NSLog(@"- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText");

}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text  {
    NSLog(@"%@",text);
    NSLog(@"- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text");
    return YES;
}


#pragma mark - CollectionView with Offers delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if ([_searchResults count] && [[_searchResults objectAtIndex:0] isKindOfClass:[OfferItem class]]) {
        return [_searchResults count];
    } else  {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    OfferCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OfferCollectionViewCell"
                                                                              forIndexPath:indexPath];

    if (!cell) {
        cell = [[OfferCollectionViewCell alloc] init];
    }

        cell.item = [_searchResults objectAtIndex:indexPath.row];
        cell.brandLabel.text = cell.item.brandName;
        cell.titleLabel.text = cell.item.name;
        cell.likesCount.text = [cell.item.likesCount stringValue];

        cell.priceView.layer.cornerRadius = 4.0f;
        cell.priceView.layer.masksToBounds = YES;
        cell.priceView.backgroundColor = [UIColor appRedColor];

        cell.cellView.layer.borderColor = [[UIColor appLightGrayColor] CGColor];
        cell.cellView.layer.borderWidth = 0.5f;
        cell.cellView.layer.masksToBounds = YES;

        cell.priceLabel.text = [self printPriceWithCurrencySymbol: cell.item.price];
        cell.imageView.backgroundColor = [UIColor whiteColor];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[cell.item.photoUrls objectAtIndex:0]]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                                 }];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    OfferCollectionViewCell* cell = (OfferCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    OfferVC* vc = [sb instantiateViewControllerWithIdentifier:@"OfferVC"];

    vc.offerItem = cell.item;

    [self.navigationController pushViewController:vc animated:YES];

}


@end
