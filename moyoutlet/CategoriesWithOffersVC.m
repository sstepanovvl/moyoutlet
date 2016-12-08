//
//  CategoriesWithOffersVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 20.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "CategoriesWithOffersVC.h"
#import "OffersVC.h"
#import "moyoutlet-swift.h"
#import "OfferCollectionViewCell.h"
#import "OfferVC.h"
#import "CreateOfferVC.h"
#import "SearchVC.h"

@interface CategoriesWithOffersVC()

@property (assign, nonatomic) BOOL sellButtonInitialized;
@property (assign, nonatomic) bool sellButtonHidden;
@property (assign, nonatomic) bool offersCollectionViewIsScrolling;
@property (strong, nonatomic) IBOutlet UIImageView* sellButton;

@end

@implementation CategoriesWithOffersVC

-(void)viewDidLoad {

    NSLog(@"CategoriesWithOffersVC viewDidLoad");

    [super viewDidLoad];

    [self initNavigationItems];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    if (![AppManager sharedInstance].categories) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [[AppManager sharedInstance] getCategoriesFromServerwithSuccessBlock:^(BOOL response) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self viewDidLoad];
                    [self viewWillAppear:YES];
                    [self viewDidAppear:YES];
                });
            } andFailureBlock:^(NSError *error) {
                [self throughError:error];
            }];
        });
    } else {
        [self initControllers];
    }
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"CategoriesWithOffersVC viewDidAppear");

    [self showSellButton];

}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"CategoriesWithOffersVC viewWillDisappear");

}

#pragma mark - otherStuff

-(void)initControllers {

    NSMutableArray *controllerArray = [NSMutableArray array];

    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    for (NSDictionary* category in [AppManager sharedInstance].categories) {

        if ([[category valueForKey:@"parent_id"] isEqual:@"0"]) {

            OffersVC* ofVC0 = (OffersVC*)[mainStoryBoard instantiateViewControllerWithIdentifier:@"OffersVC"];
            ofVC0.title = [category valueForKey:@"name"];
            ofVC0.category_id = [[category valueForKey:@"id"] intValue];
            ofVC0.parent_id = [[category valueForKey:@"parent_id"] intValue];
            ofVC0.view.backgroundColor = [UIColor clearColor];
            ofVC0.categoriesWithOffersvc = self;
            ofVC0.offersCollectionView.delegate = self;
            ofVC0.offersCollectionView.loadControl = [[UILoadControl alloc] initWithTarget:ofVC0 action:@selector(loadMore:)];

            [controllerArray addObject:ofVC0];

        }
    }

    id elem = [controllerArray firstObject];
    [controllerArray removeObject:[controllerArray firstObject]];
    [controllerArray addObject:elem];
    PagingMenuController* pvc = [[PagingMenuController alloc] initWithViewControllers:controllerArray];

    [self addChildViewController:pvc];

    [self.view addSubview:pvc.view];

    [self initSellButtonOnFrame];

    _sellButtonInitialized = NO;
}

#pragma mark - sellButton stuff

-(void)initSellButtonOnFrame {

    _sellButton = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, self.view.frame.size.height - 180, 75, 75)];
    [_sellButton setImage:[UIImage imageNamed:@"sellMainButton"]];


    _sellButton.userInteractionEnabled = YES;

    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sellButtonPressed:)];
    tapGesture.numberOfTapsRequired = 1;

    [_sellButton addGestureRecognizer:tapGesture];

    _sellButton.layer.zPosition = 1;

    [self.view addSubview:_sellButton];

    UIImage* img = [UIImage imageNamed:@"sellMainButton"];

    _sellButton.image = [[UIImage alloc] initWithCGImage:img.CGImage scale:2.0 orientation:UIImageOrientationLeft];
    [self setAnchorPoint:CGPointMake(1.0f, 1.0f) forView:_sellButton];
    _sellButton.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)showSellButton {
    CGFloat angle = M_PI_2;
    [self setAnchorPoint:CGPointMake(1.5f, 0.0f) forView:self.sellButton];
    [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{
        _sellButton.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
    }];
}

- (void)hideSellButton {
    CGFloat angle = M_PI;
    [self setAnchorPoint:CGPointMake(1.5f, 0.0f) forView:_sellButton];
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _sellButton.transform = CGAffineTransformMakeRotation(angle);
    } completion:^(BOOL finished) {
    }];
}

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x, view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x, view.bounds.size.height * view.layer.anchorPoint.y);

    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);

    CGPoint position = view.layer.position;

    position.x -= oldPoint.x;
    position.x += newPoint.x;

    position.y -= oldPoint.y;
    position.y += newPoint.y;

    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}


-(void)sellButtonPressed:(id)sender {
    NSLog(@"%f,%f",self.view.bounds.size.height, self.view.bounds.size.width);
    NSLog(@"%f,%f",self.view.frame.size.height, self.view.frame.size.width);

    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CreateOfferVC* cofvc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CreateOfferVC"];
    [self.navigationController pushViewController:cofvc animated:YES];

}


#pragma mark ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)sender{


    [sender.loadControl update];

    if (!_offersCollectionViewIsScrolling) {

        NSLog(@"Scroll starts");

        _offersCollectionViewIsScrolling = YES;
        [self hideSellButton];
        _sellButtonHidden = TRUE;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    NSLog(@"scrollViewWillEndDragging");
}
// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"scrollViewDidEndDragging");
    if(_sellButtonHidden & _offersCollectionViewIsScrolling) {
        [self showSellButton];
        _sellButtonHidden = YES;
        _offersCollectionViewIsScrolling = NO;

    }

}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewWillBeginDecelerating");

}// called on finger up as we are moving

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scrollViewDidEndDecelerating");
    if(_sellButtonHidden) {
        [self showSellButton];
        _sellButtonHidden = YES;
        _offersCollectionViewIsScrolling = NO;

    }
}// called when scroll view grinds to a halt

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    OfferCollectionViewCell* cell = (OfferCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    OfferVC* vc = [sb instantiateViewControllerWithIdentifier:@"OfferVC"];

    vc.offerItem = cell.item;

    [self.navigationController pushViewController:vc animated:YES];
}

@end
