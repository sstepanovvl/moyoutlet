//
//  menuVC.m
//  AppManager
//
//  Created by Stepan Stepanov on 03.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "MenuVC.h"
#import "OffersVC.h"
#import "NewsVC.h"
#import "MyOffersVC.h"
#import "MyPurchasesVC.h"
#import "SettingsVC.h"
#import "HelpVC.h"
#import "ProfileVC.h"
#import "FavoritesVC.h"

@interface MenuVC ()
@property NSArray* arrMenuNames;
@property NSArray* arrMenuImages;

@end

@implementation MenuVC

- (id) init
{
    self = [super init];
    if (!self) return nil;
    
    // Add this instance of TestClass as an observer of the TestNotification.
    // We tell the notification center to inform us of "TestNotification"
    // notifications using the receiveTestNotification: selector. By
    // specifying object:nil, we tell the notification center that we are not
    // interested in who posted the notification. If you provided an actual
    // object rather than nil, the notification center will only notify you
    // when the notification was posted by that particular object.
    
    
    return self;
}

- (void)receiveNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"userDidChanged"]) {
        [self initViewsForUser];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"userDidChanged"
                                               object:nil];


    _arrMenuNames = [NSArray arrayWithObjects:
                     @"Главная",
                     @"Новости Moyoutlet",
                     @"Избранное",
                     @"Мои объявления",
                     @"Мои покупки",
                     @"Настройки",
                     @"Помощь",
                     nil];

    _arrMenuImages = [NSArray arrayWithObjects:
                      [UIImage imageNamed:@"menuItemImageMain"],
                      [UIImage imageNamed:@"menuItemImageNews"],
                      [UIImage imageNamed:@"menuItemImageFavorites"],
                      [UIImage imageNamed:@"menuItemImageMyOffers"],
                      [UIImage imageNamed:@"menuItemImagePurchases"],
                      [UIImage imageNamed:@"menuItemImageSettings"],
                      [UIImage imageNamed:@"menuItemImageHelp"],
                      nil];

    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"menuBackground"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
        
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.scrollEnabled = YES;

    _image.layer.cornerRadius = 40.0f;
    _image.layer.borderWidth = 2.0f;
    _image.layer.borderColor = [[UIColor whiteColor] CGColor];
    _image.clipsToBounds = YES;




    _image.userInteractionEnabled = YES;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];

    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate  = self;
    [_image addGestureRecognizer:tapGesture];
    [self initViewsForUser];
    if (debug_enabled) {
        NSLog(@"MenuVC viewDidLoad");
    }

}


- (void)initViewsForUser {
    [_image sd_setImageWithURL:[NSURL URLWithString:[AppManager sharedInstance].authorizedUser.photoUrl]
              placeholderImage:[UIImage imageNamed:@"userImagePlaceholder"]
                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                         [UIView transitionWithView:_image
                                           duration:0.5f
                                            options:UIViewAnimationOptionLayoutSubviews
                                         animations:^{
                                             _image.alpha = 1.0f;
                                         } completion:^(BOOL finished) {
                                         }];
                     }];

    _name.text = [NSString stringWithFormat:@"%@ %@",[AppManager sharedInstance].authorizedUser.firstName, [AppManager sharedInstance].authorizedUser.lastName];
    if (debug_enabled ) {
        NSLog(@"MenuVC: initItemsWithUser");
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSLog(@"ViewWillAppear");
}

- (void) tapGesture: (id)sender {

    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {

        ProfileVC* pvc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];

        UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:pvc];

        controller.centerController = nvc;

        [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];

    }];

}



- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_arrMenuImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    LeftMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LeftMenuCell"];

    cell.menuTitle.text = [_arrMenuNames objectAtIndex:indexPath.row];
    cell.menuImage.image = [_arrMenuImages objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];

    UIView *highlightView = [[UIView alloc] init];

    highlightView.backgroundColor = [UIColor colorWithRed:218.0f/255.0f
                                                    green:218.0f/255.0f
                                                     blue:218.0f/255.0f
                                                    alpha:0.3];
    cell.selectedBackgroundView = highlightView;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {

        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

            CategoriesWithOffersVC* catVC = (CategoriesWithOffersVC*)[mainStoryBoard instantiateViewControllerWithIdentifier:@"CategoriesWithOffersVC"];

//            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:catVC];

            controller.centerController = catVC;

            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];

        }];

    }

    if (indexPath.row == 1) {

        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {

            NewsVC* newsVC = [[NewsVC alloc] initWithNibName:@"NewsVC" bundle:nil];

            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:newsVC];

            controller.centerController = nvc;

            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
            
        }];
        
    }

    if (indexPath.row == 2) {

        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            FavoritesVC* favoritesVC = [[FavoritesVC alloc] initWithNibName:@"FavoritesVC" bundle:nil];

            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:favoritesVC];

            controller.centerController = nvc;

            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
            
        }];
        
    }

    if (indexPath.row == 3) {

        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            MyOffersVC* myOffersVC = [[MyOffersVC alloc] initWithNibName:@"MyOffersVC" bundle:nil];

            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:myOffersVC];

            controller.centerController = nvc;

            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
            
        }];

    }

    if (indexPath.row == 4) {

        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            MyPurchasesVC* myPurchasesVC = [[MyPurchasesVC alloc] initWithNibName:@"MyPurchasesVC" bundle:nil];

            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:myPurchasesVC];

            controller.centerController = nvc;

            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
            
        }];
        
    }

    if (indexPath.row == 5) {

        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            SettingsVC* settingsVC = [[SettingsVC alloc] initWithNibName:@"SettingsVC" bundle:nil];

            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:settingsVC];

            controller.centerController = nvc;

            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
            
        }];
        
    }

    if (indexPath.row == 6) {

        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            HelpVC* helpVC = [[HelpVC alloc] initWithNibName:@"HelpVC" bundle:nil];

            UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:helpVC];

            controller.centerController = nvc;

            [NSThread sleepForTimeInterval:(300+arc4random()%700)/1000000.0];
            
        }];
        
    }

}


@end
