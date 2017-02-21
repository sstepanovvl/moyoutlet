//
//  CategoriesWithOffersVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 20.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "CategoriesWithOffersVC.h"
#import "OffersVC.h"
#import "OfferCollectionViewCell.h"
#import "OfferVC.h"
#import "CreateOfferVC.h"
#import "SearchVC.h"

@interface CategoriesWithOffersVC()

@property (assign, nonatomic) BOOL sellButtonInitialized;
@property (assign, nonatomic) bool sellButtonHidden;
@property (strong, nonatomic) IBOutlet UIImageView* sellButton;

@end

@implementation CategoriesWithOffersVC

-(void)viewDidLoad {

    if (debug_enabled) {
        NSLog(@"CategoriesWithOffersVC viewDidLoad");
    }
    
    [super viewDidLoad];

    [self initNavigationItems];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    
    if (![AppManager sharedInstance].config.categories) {
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
        [self initOffersVC];
    }
}




-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (debug_enabled) {
        NSLog(@"CategoriesWithOffersVC viewDidAppear");
    }
    [self showSellButton];

}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (debug_enabled) {
        NSLog(@"CategoriesWithOffersVC viewWillDisappear");
    }
}

#pragma mark - otherStuff

-(void)initOffersVC {

    NSMutableArray *controllerArray = [NSMutableArray array];

    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    for (NSDictionary* category in [AppManager sharedInstance].config.categories) {

        if ([[category valueForKey:@"parent_id"] isEqual:@"0"]) {

            OffersVC* ofVC0 = (OffersVC*)[mainStoryBoard instantiateViewControllerWithIdentifier:@"OffersVC"];
            ofVC0.title = [category valueForKey:@"name"];
            ofVC0.category_id = [[category valueForKey:@"id"] intValue];
            ofVC0.parent_id = [[category valueForKey:@"parent_id"] intValue];
            ofVC0.view.backgroundColor = [UIColor clearColor];
            ofVC0.categoriesWithOffersvc = self;
            ofVC0.offersCollectionView.showAndHideSellButtonDelegate = self;
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
    CGRect sellButtonRect = CGRectMake(0, 0, 0, 0);
    if (IS_IPHONE_4_OR_LESS) {
        sellButtonRect = CGRectMake(275.0f, 292.0f, 75, 75);
    } else if (IS_IPHONE_5) {
        sellButtonRect = CGRectMake(275.0f, 388.0f, 75, 75);
    } else if(IS_IPHONE_6) {
        sellButtonRect = CGRectMake(323.0f, 464.0f, 75, 75);
    } else if(IS_IPHONE_6P) {
        sellButtonRect = CGRectMake(356.0f, 517.0f, 75, 75);
    }

    _sellButton = [[UIImageView alloc] initWithFrame:sellButtonRect];
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
    [self showImagePicker];
    
}

#pragma mark Fusuma delegates 

- (void)fusumaImageSelected:(UIImage *)image {
    
    CreateOfferVC* cofvc = [[CreateOfferVC alloc] initFromStoryboardWithItem:nil];
    cofvc.item.arrImages = [[NSMutableArray alloc] initWithObjects:image, nil,nil,nil];

    [self.navigationController pushViewController:cofvc animated:YES];
}

#pragma mark get photos first

-(void)showImagePicker {
    FusumaViewController* fsvc = [FusumaViewController new];
    
    fsvc.delegate = self;
    fsvc.hasVideo = false;
    fsvc.fusumaCameraFirst = true;
    [self.navigationController presentViewController:fsvc animated:YES completion:nil];

}


@end
