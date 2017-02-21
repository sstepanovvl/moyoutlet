//
//  testTableTableViewController.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "testTableTableViewController.h"
#import "SelectVC.h"
#import "CreateOfferPhotoCell.h"
#import "PhotoCollectionViewCell.h"

@interface testTableTableViewController ()
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *cellSwitches;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *shippingWillSenByMyself;
@property (weak, nonatomic) IBOutlet UISwitch *smovivoz;
@property (weak, nonatomic) IBOutlet UISwitch *otdelenie;
@property (weak, nonatomic) IBOutlet UISwitch *courier;
@property (weak, nonatomic) IBOutlet UILabel *willSendinLabel;
@property (strong, nonatomic) IBOutlet PhotoCollectionView *editPhotoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *outletFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalForClientLabel;
@property (weak, nonatomic) IBOutlet UITextField *offerPriceLabel;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *deliveryFieldsToHide;
@property (strong, nonatomic) UISwitch* deliverySwitch;


@end

@implementation testTableTableViewController  

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UISwitch* sw in _cellSwitches) {
        sw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    }
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    _descriptionTextView.delegate = self;
    _titleTextField.delegate = self;
    UIGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [_editPhotoCollectionView addGestureRecognizer:longPressGesture];
    _editPhotoCollectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    _editPhotoCollectionView.clipsToBounds = NO;
    [_editPhotoCollectionView registerNib:[UINib nibWithNibName:@"CreateOfferPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"CreateOfferPhotoCell"];
    _editPhotoCollectionView.delegate = self;
    _offerPriceLabel.delegate = self;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if ([[[AppManager sharedInstance].offerToEdit.arrImages objectAtIndex:0] isEqual:[NSNull null]]) {
//        [self collectionView:_editPhotoCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
//    }
    [self initFields];
}
-(void)initFields {
    [_editPhotoCollectionView reloadData];
    
    OfferItem* editableItem = [AppManager sharedInstance].offerToEdit;
        if (editableItem.category_id) {
            NSDictionary* dic = [AppHelper searchInDictionaries:(NSArray*)[AppManager sharedInstance].config.categories Value:[editableItem.category_id stringValue] forKey:@"id"];
            if (dic) {
                _categoryLabel.textColor = [UIColor blackColor];
                _categoryLabel.text = [dic valueForKey:@"name"];
            }
        }
        if (editableItem.brand_id) {
            NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.brands Value:editableItem.brand_id forKey:@"id"];
            if (dic) {
                _brandLabel.textColor = [UIColor blackColor];
                _brandLabel.text = [dic valueForKey:@"name"];
            }
        }
        if (editableItem.condition_id) {
            NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.conditions Value:editableItem.condition_id forKey:@"id"] ;
            if (dic) {
                _conditionLabel.textColor = [UIColor blackColor];
                _conditionLabel.text = [dic valueForKey:@"name"];
            }
        }
        if (editableItem.senderCity_id) {
            NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.cities Value:editableItem.senderCity_id forKey:@"id"] ;
            if (dic) {
                _cityLabel.textColor = [UIColor blackColor];
                _cityLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
            }
        }
        if (editableItem.willSendIn_id) {
            NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.willSendInFields Value:editableItem.willSendIn_id forKey:@"id"] ;
            if (dic) {
                _willSendinLabel.textColor = [UIColor blackColor];
                _willSendinLabel.text = [dic valueForKey:@"name"];
            }
        }

    if (editableItem.size_id) {
        NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.sizes Value:editableItem.size_id forKey:@"id"] ;
        if (dic) {
            _sizeLabel.textColor = [UIColor blackColor];
            _sizeLabel.text = [NSString stringWithFormat:@"%@ (%@)",[dic valueForKey:@"name"],[dic valueForKey:@"description"]];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate 
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString* text = textField.text;
    if (textField.tag == 1) {
        [AppManager sharedInstance].offerToEdit.itemDescription = text;
    } else if (textField.tag == 2) {
        _offerPriceLabel.text = [self numToStr:[NSNumber numberWithInt:[text intValue]]];
        [AppManager sharedInstance].offerToEdit.price = [text integerValue];
        [self calculateFeesAndPrices];
    }
}


#pragma mark - TextView Delegate

- (CGFloat)textViewHeightForAttributedText: (NSAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.tableView beginUpdates];
    NSLog(@"%@",textView.text);
    [self.tableView endUpdates];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [AppManager sharedInstance].offerToEdit.itemDescription = textView.text;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[_descriptionTextView font] forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_descriptionTextView.text attributes:attrsDictionary];
        return [self textViewHeightForAttributedText:attrString andWidth:CGRectGetWidth(self.tableView.bounds)-31]+20;
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        return 100.0f;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        return 350.0f;
    } else if (indexPath.section == 5 && indexPath.row == 2) {
        return 210.0f;
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView* headerCell = nil;
    
    if (section == 3) {
            headerCell = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
            if (!_deliverySwitch) {
                self.deliverySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(headerCell.frame.size.width-95,headerCell.frame.size.height-33, 35, 35)];
                [self.deliverySwitch setOn:_deliverySwitch.isEnabled];
            }
            self.deliverySwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
            [self.deliverySwitch addTarget:self action:@selector(deliverySwitchDidChanged:) forControlEvents:UIControlEventValueChanged];
            [headerCell.contentView addSubview:self.deliverySwitch];
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(headerCell.frame.size.width-52,headerCell.frame.size.height-35, 35, 35)];
            [button setImage:[UIImage imageNamed:@"questionIcon"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(questionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 2;
            [headerCell.contentView addSubview:button];
    } else if (section == 4 || section == 3) {
            headerCell = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 45)];
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(headerCell.frame.size.width-52,headerCell.frame.size.height-35, 35, 35)];
            [button setImage:[UIImage imageNamed:@"questionIcon"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(questionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 1;
            [headerCell.contentView addSubview:button];
    } else {
        headerCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    }
    
    headerCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    headerCell.contentView.contentMode = UIViewContentModeCenter;
    [headerCell setNeedsLayout];
    [headerCell layoutIfNeeded];
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else if (section == 5) {
        return 20;
    } else {
        return 45;
    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"setValue: %@ forUndefinedKey:%@",value,key);
}

#pragma mark - collectionView Layout &  Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (collectionView.tag) {
        case 0:
            return 4;
            break;
        default:
            return [[AppManager sharedInstance].offerToEdit.arrImages count];
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag) {
        PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
        return cell;

    } else {
        CreateOfferPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfferPhotoCell" forIndexPath:indexPath];
        [cell.imView setContentMode:UIViewContentModeScaleAspectFill];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        if (![[[AppManager sharedInstance].offerToEdit.arrImages objectAtIndex:indexPath.row] isEqual:[NSNull null]]) {
            [cell.imView setImage:[[AppManager sharedInstance].offerToEdit.arrImages objectAtIndex:indexPath.row]];
        } else {
            [cell.imView setImage:[UIImage imageNamed:@"photoPlaceholder"]];
        }
        return cell;

    }
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString* tmp = [[AppManager sharedInstance].offerToEdit.photoUrls objectAtIndex:sourceIndexPath.item];
    
    [[AppManager sharedInstance].offerToEdit.photoUrls removeObjectAtIndex:sourceIndexPath.item];
    
    [[AppManager sharedInstance].offerToEdit.photoUrls insertObject:tmp atIndex:destinationIndexPath.item];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {

    CameraViewController* cvc = [[CameraViewController alloc]init];
    cvc.arrayPosition = indexPath.row;

    [self presentViewController:cvc animated:YES completion:nil];
}


#pragma mark - Other Stuff

-(NSString*)numToStr:(NSNumber*)num {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:3];
    [formatter setGroupingSeparator:@"\u00a0"];
    NSString *string = [formatter stringFromNumber:num];
    return string;
}

-(void)calculateFeesAndPrices {
    float offerPrice = [AppManager sharedInstance].offerToEdit.price;
    
    [AppManager sharedInstance].offerToEdit.fee = offerPrice * [AppManager sharedInstance].config.outletComissionMulitplier;
    [AppManager sharedInstance].offerToEdit.clientIncome = [AppManager sharedInstance].offerToEdit.price - [AppManager sharedInstance].offerToEdit.fee;
    _outletFeeLabel.text = [NSString stringWithFormat:@"%@",[self numToStr:[NSNumber numberWithFloat:[AppManager sharedInstance].offerToEdit.fee]]];
    _totalForClientLabel.text = [NSString stringWithFormat:@"%@",[self numToStr:[NSNumber numberWithFloat:[AppManager sharedInstance].offerToEdit.clientIncome]]];
}

#pragma mark IBActions

-(IBAction)deliverySwitchDidChanged:(id)sender {
    self.hideSectionsWithHiddenRows = YES;
    [self cells:_deliveryFieldsToHide setHidden:!_deliverySwitch.on];
    [self reloadDataAnimated:YES];
}

-(IBAction)questionButtonPressed:(id)sender {
    NSLog(@"Question from offer price pressed");
}

-(IBAction)handleLongPressGesture:(UILongPressGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [_editPhotoCollectionView beginInteractiveMovementForItemAtIndexPath:[_editPhotoCollectionView indexPathForItemAtPoint:[gesture locationInView:_editPhotoCollectionView]]];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [_editPhotoCollectionView updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [_editPhotoCollectionView endInteractiveMovement];
    } else {
        [_editPhotoCollectionView cancelInteractiveMovement];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController* nvc = segue.destinationViewController;
    SelectVC* svc = nvc.topViewController;
    if ([segue.identifier isEqualToString:@"selectCategorySegue"]) {
        svc.searchType = CATEGORY;
        svc.parent_id = 0;
    } else if ([segue.identifier isEqualToString:@"selectBrandSegue"]) {
        svc.searchType = BRAND;
    } else if ([segue.identifier isEqualToString:@"selectCitySegue"]) {
        svc.searchType = CITIES;
    } else if ([segue.identifier isEqualToString:@"selectSizeSegue"]) {
        svc.searchType = SIZES;
    } else if ([segue.identifier isEqualToString:@"selectConditionSegue"]) {
        svc.searchType = CONDITIONS;
    } else if ([segue.identifier isEqualToString:@"selectWillSendInSegue"]) {
        svc.searchType = WILLSENDIN;
    } else if ([segue.identifier isEqualToString:@"selectWeightSegue"]) {
        svc.searchType = WEIGHTS;
    }
}


@end
