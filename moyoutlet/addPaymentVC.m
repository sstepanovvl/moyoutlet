//
//  addPaymentVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 25.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "addPaymentVC.h"

@interface addPaymentVC ()
@property (weak, nonatomic) IBOutlet UIButton *savePaymentButton;
@property (weak, nonatomic) IBOutlet UITextField *validTillField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *accountIdField;

@end

@implementation addPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItems];
    
    _savePaymentButton.layer.borderWidth = 0.0f;
    _savePaymentButton.layer.cornerRadius = 3.0f;
    _savePaymentButton.layer.borderColor = [UIColor clearColor].CGColor;
    _savePaymentButton.clipsToBounds = YES;
    self.tableView.tableHeaderView   = nil;
    self.tableView.tableFooterView = nil;
    // Do any additional setup after loading the view.
}

- (void) initNavigationItems  {
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:17.0],
                              NSForegroundColorAttributeName :  [UIColor appRedColor]
                              }];
    
    self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Добавить карту";
    
    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];
    
    UIImage *image = [[UIImage imageNamed:@"closeImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;
}

-(IBAction)dismissViewController:(id)sender {
    NSArray* controllers = [self.navigationController viewControllers];
    [self.navigationController popToViewController:[controllers objectAtIndex:[controllers indexOfObject:self]-1] animated:YES];
    
}
- (IBAction)didPressSaveCardButton:(id)sender {
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:nil message:@"Карта успешно добавлена" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self dismissViewController:nil];
                                                          }];
    [errorAlert addAction:defaultAction];
    [self presentViewController:errorAlert animated:YES completion:^{
        
    }];
}

- (IBAction)didPressScanCardButton:(id)sender {
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:nil message:@"Здесь будет экран скана карты" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [errorAlert addAction:defaultAction];
    [self presentViewController:errorAlert animated:YES completion:^{
        NSLog(@"OOK");
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
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
