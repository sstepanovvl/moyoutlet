//
//  BaseTableViewController.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "BaseTableViewController.h"
#import <UIKit/UIKit.h>
#import "AppManager.h"
#import "IQKeyboardManager.h"
#import "IQDropDownTextField.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "IQUITextFieldView+Additions.h"
#import "UITextView+Placeholder.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backButtonPressed:(id)sender {
    NSInteger controllerCount = [[self.navigationController viewControllers] count];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:controllerCount -2]
                                          animated:YES];
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
