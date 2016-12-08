//
//  baseVC.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "createOfferVC.h"
#import "PopupWithNotificationsVC.h"
#import "NotificationCell.h"
#import "NewsItemVC.h"
#import "SearchVC.h"

@interface baseVC ()

@property (strong,nonatomic) PopupWithNotificationsVC* pwnvc;
@property (strong,nonatomic) ARSPopover* popoverController;
@end

@implementation UINavigationBar (CustomNavigationBar)

- (void)layoutSubviews
{
    [self setFrame:CGRectMake(0, 0, self.frame.size.width, 64)];
}

@end

@implementation baseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;


//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
//
//    view.backgroundColor = [UIColor redColor];
//
//    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:view];



    // Do any additional setup after loading the view.
}

-(void)initNavigationItems {

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];

    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    UIButton* rightSearchButton = [[UIButton alloc] init];
    UIImage *rightSearchImage = [[UIImage imageNamed:@"rightMenuItemSearch"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightSearchButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightSearchButton setImage:rightSearchImage forState:UIControlStateNormal];
    [rightSearchButton addTarget:self
                          action:@selector(searchButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    _rightSearchButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightSearchButton];

    UIButton* rightBellButton = [[UIButton alloc] init];
    UIImage *rightBellImage = [[UIImage imageNamed:@"rightMenuItemBell"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightBellButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightBellButton setImage:rightBellImage forState:UIControlStateNormal];
    [rightBellButton addTarget:self
                        action:@selector(notifyButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    _rightBellButton = [[UIBarButtonItem alloc] initWithCustomView:rightBellButton];

    UIButton* rightNotifyButton = [[UIButton alloc] init];
    UIImage *rightNotifyImage = [[UIImage imageNamed:@"rightMenuItemCheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightNotifyButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightNotifyButton setImage:rightNotifyImage forState:UIControlStateNormal];
    [rightNotifyButton addTarget:self
                          action:@selector(alertButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    _rightNotifyButton = [[UIBarButtonItem alloc] initWithCustomView:rightNotifyButton];
    NSArray* rightBarItems = [[NSArray alloc] initWithObjects:_rightNotifyButton,_rightBellButton,_rightSearchButtonItem, nil];
    self.navigationItem.rightBarButtonItems = rightBarItems;


    UIBarButtonItem* LOGO = [[UIBarButtonItem alloc] initWithTitle:@"moyoutlet"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self.viewDeckController
                                                            action:@selector(toggleLeftView)];

    [LOGO setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                  [UIFont fontWithName:@"OpenSans-Bold" size:20.0], NSFontAttributeName,
                                  [UIColor appRedColor], NSForegroundColorAttributeName,
                                  @(10),NSKernAttributeName,
                                  nil] forState:UIControlStateNormal];
    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

    UIImage *image = [[UIImage imageNamed:@"leftMenuItemImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but,LOGO, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;

    [self.navigationItem.rightBarButtonItems objectAtIndex:1 ].badgeValue = @"3";

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)notifyButtonPressed {


    _popoverController = [ARSPopover new];
    _popoverController.sourceView = _rightBellButton.customView;
    _popoverController.sourceRect = CGRectMake(CGRectGetMidX(_rightSearchButtonItem.customView.bounds), CGRectGetMaxY(_rightSearchButtonItem.customView.bounds), 0, 0);
    _popoverController.contentSize = CGSizeMake(400, 600);
    _popoverController.arrowDirection = UIPopoverArrowDirectionUp;
    [self presentViewController:_popoverController animated:YES completion:^{
        [_popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {

            CGFloat originX = 0;
            CGFloat originY = 0;
            CGFloat width = popoverPresentedSize.width;
            CGFloat height = popoverPresentedSize.height - popoverArrowHeight;

            CGRect frame = CGRectMake(originX, originY, width, height);
            _pwnvc = [[PopupWithNotificationsVC alloc] init];
            _pwnvc.view.frame = frame;
            _pwnvc.mainTableView.delegate = self;
            _pwnvc.mainTableView.dataSource = self;
            [popover.view addSubview:_pwnvc.view];
        }];
    }];
}

-(void)alertButtonPressed {

    baseError* err = [[baseError alloc]init];
    err.customHeader= @"Новое событие";
    err.customError = @"Вызов экрана событий";
    [self throughError:err];

}


-(IBAction)searchButtonPressed:(id)sender {
    SearchVC* vc = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];

    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark <ARSPopoverDelegate>

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    // delegate for you to use.
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // delegate for you to use.
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // delegate for you to use.
    return YES;
}


-(void)shareButtonPressed{
    baseError* err = [[baseError alloc]init];
    err.customHeader= @"Поделиться";
    err.customError = @"Вызов экрана \"поделиться\"";
    [self throughError:err];

}

-(IBAction)backButtonPressed:(id)sender {
    NSInteger controllerCount = [[self.navigationController viewControllers] count];
    NSArray* ar = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:controllerCount -2]
                                          animated:YES];
}

-(void)throughError:(baseError*)error {

    NSString* header = [NSString string];
    NSString* body = [NSString string];

    if (![error.customError isEqualToString:@""]) {
        header = error.customHeader;
        body = error.customError;
    } else {

        header = error.localizedFailureReason;
        body = error.localizedDescription;

    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:header message:body preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Oкейси" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];

    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(void)showHud {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)hideHud {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}
- (NSString *)printPriceWithCurrencySymbol:(CGFloat)price {

    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];

    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setCurrencyCode:@"RUB"];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ru"]];

    NSString * productPrice = [numberFormatter stringFromNumber:[NSNumber numberWithInt:price]];
    productPrice = [productPrice stringByReplacingOccurrencesOfString:@",00" withString:@""];
    return productPrice;
    
}




#pragma mark - tableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 15;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NotificationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NotificationCell alloc] init];
    }

    cell.mainTextLabel.text = @"Новое сообщение от Аутлета: Дарим бонусы за просмотр объявлений!";
    cell.daysAgoLabel.text = @"10 дней назад";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsItemVC* nivc = [[NewsItemVC alloc] initWithNibName:@"NewsItemVC" bundle:nil];

    [_popoverController  dismissViewControllerAnimated:NO completion:^{
        [self.navigationController pushViewController:nivc animated:YES];
    }];
}


@end
