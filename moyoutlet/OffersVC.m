//
//  OffersVC.m
//  moyoutlet
//
//  Created by Stepan Stepanov on 25.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "OffersVC.h"
#import "LoginVC.h"
#import "OfferVC.h"
#import "OfferCollectionViewCell.h"
#import "customNavigationController.h"
#import "createOfferVC.h"




NSString *kCellID = @"OfferCollectionViewCell";

#define kCellsPerRow 2

@interface OffersVC ()
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray* categoryButtons;
@property (strong, nonatomic) NSMutableArray* arrOffers;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;
@end

@implementation OffersVC
//@synthesize refreshControl = _refreshControl;
//@synthesize categoryButtons = _categoryButtons;
//@synthesize arrOffers = _arrOffers;


#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
//    [_offersCollectionView registerClass:[OfferCollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl addTarget:self
                        action:@selector(startRefresh:)
              forControlEvents:UIControlEventValueChanged];

    [_offersCollectionView addSubview:_refreshControl];

    _offersCollectionView.alwaysBounceVertical = YES;
    _offersCollectionView.alwaysBounceHorizontal = NO;

    _offersCollectionView.backgroundColor = [UIColor clearColor];

    _offersCollectionView.delegate = self;
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_offersCollectionView.collectionViewLayout;
    CGFloat availableWidthForCells = CGRectGetWidth(self.view.bounds) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);

    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
    CGSize itemSize = CGSizeZero;
    if (IS_IPHONE_6P) {
        itemSize = CGSizeMake(cellWidth, 230.0f);
    } else if (IS_IPHONE_6) {
        itemSize = CGSizeMake(cellWidth, 210.0f);
    } else {
        itemSize = CGSizeMake(cellWidth, 180.0f);

    }

    flowLayout.itemSize = itemSize;

    if (!_category_id) {
        _arrOffers = [[[AppManager sharedInstance].offers allKeys] mutableCopy];

    } else {
        _arrOffers = [[AppManager sharedInstance].offers valueForKey:[NSString stringWithFormat:@"%li",(long)self.category_id]];
    }

    if (![_arrOffers count]) {

        [MBProgressHUD showHUDAddedTo:_offersCollectionView animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [[AppManager sharedInstance] loadOffersFromServerFor:self.category_id offset:0 WithSuccessBlock:^(BOOL response) {
                if (response) {
                    _arrOffers = [[AppManager sharedInstance].offers valueForKey:[NSString stringWithFormat:@"%li",(long)self.category_id]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_offersCollectionView reloadData];
                        [_offersCollectionView layoutIfNeeded];
                        NSLog(@"[_offersCollectionView layoutIfNeeded];");
                        [MBProgressHUD hideHUDForView:_offersCollectionView animated:YES];
                    });
                }
            } andFailureBlock:^(NSError *error) {
                [self throughError:error];
            }];

        });

    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews {

    [super viewDidLayoutSubviews];

}

-(void)loadView {
    [super loadView];

}

#pragma mark - CollectionView with Offers delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if ([_arrOffers count] && [[_arrOffers objectAtIndex:0] isKindOfClass:[OfferItem class]]) {
        return [_arrOffers count];
    } else  {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    OfferCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID
                                                                              forIndexPath:indexPath];
        NSArray* items = [[AppManager sharedInstance].offers valueForKey:[NSString stringWithFormat:@"%li",(long)self.category_id]];
            if ([items count] && [[items objectAtIndex:indexPath.row] isKindOfClass:[OfferItem class]]) {
            cell.item = [_arrOffers objectAtIndex:indexPath.row];
            cell.brandLabel.text = cell.item.brandName;
            cell.titleLabel.text = cell.item.name;
            cell.likesCount.text = [cell.item.likesCount stringValue];
//            cell.priceLabel.text = [NSString stringWithFormat:@"%.f ₽",cell.item.price];
            cell.priceLabel.text = [NSString stringWithFormat:@"%.f руб.",cell.item.price];
            cell.priceView.layer.cornerRadius = 4.0f;
            cell.priceView.layer.masksToBounds = YES;
            cell.priceView.backgroundColor = [UIColor appRedColor];
            cell.cellView.layer.borderColor = [[UIColor appLightGrayColor] CGColor];
            cell.cellView.layer.borderWidth = 0.5f;
            cell.cellView.layer.masksToBounds = YES;
            
            cell.imageView.backgroundColor = [UIColor whiteColor];
//
            [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[cell.item mainThumbUrl]]
                              placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                                  cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                                     }];
        } else {
            if (debug_enabled) {
                NSLog(@"Empty category!");
            }
        }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (debug_enabled) {
        NSLog(@"willDisplayCell indexPath.row: %ld _arrOffersCount: %lu",(long)indexPath.row, (unsigned long)[_arrOffers count]);
    }
    if ([_arrOffers count]) {
        if (indexPath.row == [_arrOffers count] - 15 ) {
            [self loadMore:nil];
        }
    }
}

-(IBAction)startRefresh:(id)sender {
    [[AppManager sharedInstance] loadOffersFromServerFor:self.category_id offset:[_arrOffers count]-20 WithSuccessBlock:^(BOOL response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_offersCollectionView reloadData];
            [_offersCollectionView layoutIfNeeded];
            [_refreshControl endRefreshing];

        });
    } andFailureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_offersCollectionView layoutIfNeeded];
            [_refreshControl endRefreshing];
            [self throughError:error];
        });
    }];
}

-(IBAction)loadMore:(id)sender {
    
    if (debug_enabled ) {
        NSLog(@"loadMore");
    }
    
    [[AppManager sharedInstance] loadOffersFromServerFor:self.category_id offset:[_arrOffers count] WithSuccessBlock:^(BOOL response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_offersCollectionView reloadData];
                [_offersCollectionView layoutIfNeeded];
//                [_offersCollectionView.loadControl endLoading];

            });
    
        } andFailureBlock:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_offersCollectionView layoutIfNeeded];
//                [_offersCollectionView.loadControl endLoading];
                [self throughError:error];
            });
        }];
}

@end
