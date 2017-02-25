//
//  OfferCheckout.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 25.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "OfferCheckoutVC.h"
#import "addPaymentVC.h"

@interface OfferCheckoutVC ()
@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) IBOutlet UILabel *offerPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *shippingVariantLabel;
@property (weak, nonatomic) IBOutlet UILabel *willShipinLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentMethodLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentMethodButtonWidthConstraint;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UIImageView *guarantyImage;
@property (weak, nonatomic) IBOutlet UILabel *guarantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerNameLabel;

@end

@implementation OfferCheckoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItems];
    [self initFields];
    _offerImage.layer.borderWidth = 0.0f;
    _offerImage.layer.cornerRadius = 3.0f;
    _offerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _offerImage.clipsToBounds = YES;
    self.tableView.tableHeaderView   = nil;
    self.tableView.tableFooterView = nil;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)checkoutButtonDidPressed:(id)sender {
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:nil message:@"Здесь будет экран оплаты" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self dismissViewController:nil];
                                                          }];
    [errorAlert addAction:defaultAction];
    [self presentViewController:errorAlert animated:YES completion:^{
        NSLog(@"OOK");
    }];
}

- (IBAction)shippingQuestionDidPressed:(id)sender {
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:nil message:@"Здесь будут ответы на вопросы про доставку" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [errorAlert addAction:defaultAction];
    [self presentViewController:errorAlert animated:YES completion:^{
        NSLog(@"OOK");
    }];
}

- (IBAction)questionAboutGuarantyDidPressed:(id)sender {
    UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:nil message:@"Здесь будут ответы на вопросы про безопасность проведения платежей" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [errorAlert addAction:defaultAction];
    [self presentViewController:errorAlert animated:YES completion:^{
        NSLog(@"OOK");
    }];
}

- (void)initFields {
    if (_offerItem) {
        [_offerImage sd_setImageWithURL:[NSURL URLWithString:[[_offerItem photoUrls]objectAtIndex:0]]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     _offerImage.contentMode = UIViewContentModeScaleAspectFill;
                                 }];
        
        _offerNameLabel.text = _offerItem.name;
        _offerPriceLabel.text = [NSString stringWithFormat:@"%@ ₽",[AppHelper numToStr:[NSNumber numberWithFloat:_offerItem.price]]];
        _shippingCostLabel.text = [NSString stringWithFormat:@"%@ ₽",[AppHelper numToStr:[NSNumber numberWithFloat:350.0f]]];
        _willShipinLabel.text = [[AppHelper searchInDictionaries:[AppManager sharedInstance].config.willSendInFields Value:_offerItem.willSendIn_id forKey:@"id"] valueForKey:@"name"];
        float total = _offerItem.price + 350.0f;
        _totalPriceLabel.text = [NSString stringWithFormat:@"%@ ₽",[AppHelper numToStr:[NSNumber numberWithFloat:total]]];
    }
}

- (void) initNavigationItems  {
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:17.0],
                              NSForegroundColorAttributeName :  [UIColor appRedColor]
                              }];
    
    self.navigationItem.titleView.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Оформление покупки";
    
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
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - TableView DataSource & Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 &&indexPath.row == 0) {
        addPaymentVC* apvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"addPaymentVC"];
        [self.navigationController pushViewController:apvc animated:YES];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    int underlineHeight = 0;
    if (indexPath.section == 0 ) {
            switch (indexPath.row) {
                case 3:
                    underlineHeight = 0;
                    break;
                default:
                    underlineHeight = 1;
                    break;
            }
        if (indexPath.section == 1) {
            underlineHeight = 0;
        }
        
        UIView* underline = [[UIView alloc] initWithFrame:CGRectMake(25, cell.frame.size.height - 1, cell.frame.size.width-50, underlineHeight)];
        underline.backgroundColor = [UIColor appMidGrayColor];
        [cell addSubview:underline];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView* headerCell = (HeaderView*)[tableView headerViewForSection:section];
    if  (headerCell == nil) {
        headerCell = [[HeaderView alloc]init];
    }
    headerCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    headerCell.contentView.contentMode = UIViewContentModeCenter;
    [headerCell setNeedsLayout];
    [headerCell layoutIfNeeded];
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSLog(@"%ld",(long)section);
    if (section == 0) {
        return 0;
    } else if (section == 1) {
        return 20;
    } else {
        return 45;
    }
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
