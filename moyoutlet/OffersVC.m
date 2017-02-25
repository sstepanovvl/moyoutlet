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




NSString *kCellID = @"OfferCollectionViewCell";

#define kCellsPerRow 2

@interface OffersVC ()
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray* categoryButtons;
@property (strong, nonatomic) NSMutableArray* arrOffers;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;
@property (assign, nonatomic) bool sellButtonHidden;
@property (assign, nonatomic) bool offersCollectionViewIsScrolling;


@end

@implementation OffersVC

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
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
    
//    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_offersCollectionView.collectionViewLayout;
//
//    CGFloat availableWidthForCells = CGRectGetWidth(self.view.bounds) - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * (kCellsPerRow - 1);
//
//    CGFloat cellWidth = availableWidthForCells / kCellsPerRow;
//    
//    CGSize itemSize = CGSizeZero;
//    if (IS_IPHONE_6P) {
//        itemSize = CGSizeMake(cellWidth, 230.0f);
//    } else if (IS_IPHONE_6) {
//        itemSize = CGSizeMake(cellWidth, 210.0f);
//    } else {
//        itemSize = CGSizeMake(cellWidth, 180.0f);
//
//    }
//
//    flowLayout.itemSize = itemSize;

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
//            cell.brandLabel.text = [[AppHelper searchInDictionaries:[AppManager sharedInstance].config.brands Value:cell.item.brand_id forKey:@"id"] objectForKey:@"name"];
            cell.brandLabel.text = @"";
            cell.titleLabel.text = cell.item.name;
            cell.likesCount.text = [cell.item.likesCount stringValue];
//            cell.priceLabel.text = [NSString stringWithFormat:@"%.f ₽",cell.item.price];
                NSNumber* price = [NSNumber numberWithFloat:cell.item.price];
            cell.priceLabel.text = [NSString stringWithFormat:@"%@ руб.",[AppHelper numToStr:price]];
            cell.priceView.layer.cornerRadius = 4.0f;
            cell.priceView.layer.masksToBounds = YES;
            cell.priceView.backgroundColor = [UIColor appRedColor];
            cell.cellView.layer.borderColor = [[UIColor appLightGrayColor] CGColor];
            cell.cellView.layer.borderWidth = 0.5f;
            cell.cellView.layer.masksToBounds = YES;
            
            cell.imageView.backgroundColor = [UIColor whiteColor];
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

#pragma mark ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    [sender.loadControl update];
    
    if (!_offersCollectionViewIsScrolling) {
        if (debug_enabled){
            NSLog(@"Scroll starts");
        }
        _offersCollectionViewIsScrolling = YES;
        [_offersCollectionView.showAndHideSellButtonDelegate hideSellButton];
        _sellButtonHidden = TRUE;
    }
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (debug_enabled) {
        NSLog(@"scrollViewDidEndDragging");
    }
    if(_sellButtonHidden & _offersCollectionViewIsScrolling) {
        [_offersCollectionView.showAndHideSellButtonDelegate showSellButton];
        _sellButtonHidden = YES;
        _offersCollectionViewIsScrolling = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (debug_enabled) {
        NSLog(@"scrollViewDidEndDecelerating");
    }
    if(_sellButtonHidden) {
        [_offersCollectionView.showAndHideSellButtonDelegate showSellButton];
        _sellButtonHidden = YES;
        _offersCollectionViewIsScrolling = NO;
    }
}// called when scroll view grinds to a halt

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [UIView animateWithDuration:1.0f
                          delay:0
         usingSpringWithDamping:0.75
          initialSpringVelocity:10
                        options:0
                     animations:^{
                         OfferCollectionViewCell* cell = (OfferCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
                         
                         UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                         
                         OfferVC* vc = [sb instantiateViewControllerWithIdentifier:@"OfferVC"];
                         
                         vc.offerItem = cell.item;
                         
                         [self.navigationController pushViewController:vc animated:YES];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}


-(IBAction)startRefresh:(id)sender {
    [[AppManager sharedInstance] loadOffersFromServerFor:self.category_id offset:0 WithSuccessBlock:^(BOOL response) {
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
