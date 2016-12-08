//
//  ViewDeckController.m
//  AppManager
//
//  Created by Stepan Stepanov on 03.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "ViewDeckController.h"
#import "OffersVC.h"
#import "MenuVC.h"
#import "NewsVC.h"
#import "FavoritesVC.h"
#import "moyoutlet-swift.h"



@interface ViewDeckController ()

@end

@implementation ViewDeckController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    MenuVC* mVC = (MenuVC*)[mainStoryBoard instantiateViewControllerWithIdentifier:@"MenuVC"];

    CategoriesWithOffersVC* rvc = [[CategoriesWithOffersVC alloc] init];

    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:rvc];

    self.centerController = nvc;

    self.leftController = mVC;

    
    [self setCenterhiddenInteractivity:IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose];
    
    NSNumber* leftSize = [[NSNumber alloc] init];
    if (IS_IPHONE_4_OR_LESS) {
        leftSize = [NSNumber numberWithInteger:90.0f];
    } else if (IS_IPHONE_5) {
        leftSize = [NSNumber numberWithInteger:90.0f];
    } else if (IS_IPHONE_6) {
        leftSize = [NSNumber numberWithInteger:110.0f];
    } else if (IS_IPHONE_6P) {
        leftSize = [NSNumber numberWithInteger:140.0f];
    }
    [self setLeftSize:[leftSize integerValue]];

    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Get the new view controller using [segue destinationViewController].

    // Pass the selected object to the new view controller.

}

*/
@end
