//
//  FavoritesVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "FavoritesVC.h"
#import "moyoutlet-swift.h"
@interface FavoritesVC ()

@end

@implementation FavoritesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItems];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
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
