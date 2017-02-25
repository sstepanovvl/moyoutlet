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

@interface testTableTableViewController () <ARSPopoverDelegate>
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
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UIButton *createOfferButton;

@end

@implementation testTableTableViewController  

{
    M13ProgressHUD* HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItems];
    [self initHud];
    for (UISwitch* sw in _cellSwitches) {
        sw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    }
    
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
    if ([[[AppManager sharedInstance].offerToEdit.arrImages valueForKey:@"0"] isEqual:[NSNull null]]) {
        __weak testTableTableViewController* weaktvc = self;
        CameraViewController* camv = [[CameraViewController alloc] initWithCroppingEnabled:YES allowsLibraryAccess:YES
                                                                                completion:^(UIImage * _Nullable asd, PHAsset * _Nullable dsa) {
                                                                                    if (asd) {
                                                                                        [[AppManager sharedInstance].offerToEdit.arrImages setValue:asd forKey:@"0"];
                                                                                    }
                                                                                    [weaktvc dismissViewControllerAnimated:YES completion:nil];
                                                                                }];
        [self presentViewController:camv animated:NO completion:nil];
    }
    [self initFields];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


-(void)initHud {
    M13ProgressViewImage* imageHud = [[M13ProgressViewImage alloc]init];
    [imageHud setProgressImage:[UIImage imageNamed:@"outlet"]];
    [imageHud setProgressDirection:M13ProgressViewImageProgressDirectionBottomToTop];
    HUD = [[M13ProgressHUD alloc] initWithProgressView:imageHud];
//    HUD = [[M13ProgressHUD alloc] initWithProgressView:[[M13ProgressViewRing alloc] init]];
    HUD.progressViewSize = CGSizeMake(100.0, 100.0);
    CGPoint ss =CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    HUD.animationPoint = ss;
    HUD.primaryColor = [UIColor appRedColor];
    HUD.secondaryColor = [UIColor whiteColor];
    HUD.hudBackgroundColor = [UIColor whiteColor];
    HUD.statusColor = [UIColor appRedColor];
    HUD.statusFont = [UIFont fontWithName:@"OpenSans" size:12.0];
//    ((M13ProgressViewRing*)HUD.progressView).backgroundRingWidth = 0.5;
    HUD.maskType = M13ProgressHUDMaskTypeSolidColor;
    
    UIWindow *window = [UIApplication safeM13SharedApplication].delegate.window;
    
    [window addSubview:HUD];
    
//    [self.view addSubview:HUD];
    
}

-(void)initFields {
    [_editPhotoCollectionView reloadData];
    
    OfferItem* editableItem = [AppManager sharedInstance].offerToEdit;
    if (editableItem.name) {
                _titleTextField.textColor = [UIColor blackColor];
                _titleTextField.text = editableItem.name;
        }
    if (editableItem.itemDescription) {
        _descriptionTextView.textColor = [UIColor blackColor];
        _descriptionTextView.text = editableItem.itemDescription;
    }
    if (editableItem.category_id) {
            NSDictionary* dic = [AppHelper searchInDictionaries:(NSArray*)[AppManager sharedInstance].config.categories Value:editableItem.category_id forKey:@"id"];
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
            } else if ([editableItem.brand_id isEqualToNumber:@0]) {
                _brandLabel.textColor = [UIColor blackColor];
                _brandLabel.text = @"Без бренда";
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
    
    if (editableItem.price > 0) {
        [self calculateFeesAndPrices];
    }
    
    [_deliverySwitch setOn:editableItem.deliveryEnabled];
    [[_cellSwitches objectAtIndex:0] setOn:editableItem.deliveryWillSendByMyselfEnabled];
    [[_cellSwitches objectAtIndex:1] setOn:editableItem.deliverySamovivoznahEnabled];
    [[_cellSwitches objectAtIndex:2] setOn:editableItem.deliveryOfficeEnabled];
    [[_cellSwitches objectAtIndex:3] setOn:editableItem.deliveryCourierEnabled];
    
    if (editableItem.weight_id) {
        NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.weights Value:editableItem.weight_id forKey:@"id"] ;
        if (dic) {
            _weightLabel.textColor = [UIColor blackColor];
            _weightLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
        }
    }
}


- (void) initNavigationItems  {
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:17.0],
                              NSForegroundColorAttributeName :  [UIColor appRedColor]}];
    
    
    
    UIButton* rightNotifyButton = [[UIButton alloc] init];
    UIImage *rightNotifyImage = [[UIImage imageNamed:@"navigationItemMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightNotifyButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightNotifyButton setImage:rightNotifyImage forState:UIControlStateNormal];
    [rightNotifyButton addTarget:self
                          action:@selector(showLoadOfferOptions:)
                forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* showOptionsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNotifyButton];
    NSArray* rightBarItems = [[NSArray alloc] initWithObjects:showOptionsBarButtonItem, nil];
    self.navigationItem.rightBarButtonItems = rightBarItems;
    
    self.navigationItem.title = @"Создать объявление";
    
    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];
    
    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self action:@selector(showSaveOfferOptions:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate 
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString* text = textField.text;
    if (textField.tag == 1) {
        [AppManager sharedInstance].offerToEdit.name = text;
    } else if (textField.tag == 2) {
        _offerPriceLabel.text = [AppHelper numToStr:[NSNumber numberWithInt:[text intValue]]];
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    int underlineHeight = 0;
    int lastRow = [self.tableView numberOfRowsInSection:indexPath.section]-1;
    if (indexPath.section != 0 ) {
        if (indexPath.section == 1) {
            switch (indexPath.row) {
                case 0:
                    underlineHeight = 1;
                    break;
                default:
                    underlineHeight = 0;
                    break;
            }
        } else if (indexPath.section == 2 && indexPath.row != lastRow) {
            underlineHeight = 1;
        } else if (indexPath.section == 3 && indexPath.row != lastRow) {
            underlineHeight = 1;
        }
        
        UIView* underline = [[UIView alloc] initWithFrame:CGRectMake(25, cell.frame.size.height - 1, cell.frame.size.width-50, underlineHeight)];
        underline.backgroundColor = [UIColor appMidGrayColor];
        [cell addSubview:underline];
    }
    
    if (indexPath.section == 4 && indexPath.section == 5) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

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
        if (![[[AppManager sharedInstance].offerToEdit.arrImages valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqual:[NSNull null]]) {
            [cell.imView setImage:[[AppManager sharedInstance].offerToEdit.arrImages valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]];
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

    
    __weak testTableTableViewController* weaktvc = self;
    CameraViewController* camv = [[CameraViewController alloc] initWithCroppingEnabled:YES allowsLibraryAccess:YES
                                                                            completion:^(UIImage * _Nullable asd, PHAsset * _Nullable dsa) {
                                                                                NSDictionary* dic = [AppManager sharedInstance].offerToEdit.arrImages;
                                                                                [[AppManager sharedInstance].offerToEdit.arrImages setValue:asd forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                                                                                [weaktvc dismissViewControllerAnimated:YES completion:nil];
                                                                            }];
    [self presentViewController:camv animated:YES completion:nil];
}


#pragma mark - Other Stuff

-(BOOL)checkFieldsForValidValues {
    OfferItem* item = [AppManager sharedInstance].offerToEdit;
    
    NSString* message = @"";
    bool success = 1;
    if (!item.name.length) {
        message = [NSString stringWithFormat:@"%@\n%@",message,@"Введите название"];
        success = 0;
    }
    if (!item.itemDescription.length) {
        message = [NSString stringWithFormat:@"%@\n%@",message,@"Введите описание"];
        success = 0;
    }
    if (!item.category_id) {
        message = [NSString stringWithFormat:@"%@\n%@",message,@"Выберите категорию"];
        success = 0;
    }
    if (!item.brand_id) {
        message = [NSString stringWithFormat:@"%@\n%@",message,@"Выберите бренд"];
        success = 0;
    }
    if (!item.size_id) {
        message = [NSString stringWithFormat:@"%@\n%@",message,@"Выберите размер"];
        success = 0;
    }
    if (!item.condition_id) {
        message = [NSString stringWithFormat:@"%@\n%@",message, @"Укажите в каком состоянии ваша вещь"];
        success = 0;
    }
    if (!item.willSendIn_id) {
        message = [NSString stringWithFormat:@"%@\n%@",message, @"Укажите когда вы сможете отправить ваш товар"];
        success = 0;
    }
    if (!item.price){
        message = [NSString stringWithFormat:@"%@\n%@",message, @"Укажите цену в конце-то-концов"];
        success = 0;
    }
    
    for (id image in item.arrImages) {
        if ([image isEqual:[NSNull null]]) {
            message = [NSString stringWithFormat:@"%@\n%@",message, @"Необходимо добавить 4 фото"];
            success = 0;
        }
    }
    
    if (!success) {
        UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"Кажется вы что-то забыли" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        [errorAlert addAction:defaultAction];
        [self presentViewController:errorAlert animated:YES completion:^{
            NSLog(@"OOK");
        }];
        return false;
    } else {
        return true;
    }
}


-(void)calculateFeesAndPrices {
    float offerPrice = [AppManager sharedInstance].offerToEdit.price;
    
    [AppManager sharedInstance].offerToEdit.fee = offerPrice * [AppManager sharedInstance].config.outletComissionMulitplier;
    [AppManager sharedInstance].offerToEdit.clientIncome = [AppManager sharedInstance].offerToEdit.price - [AppManager sharedInstance].offerToEdit.fee;
    _outletFeeLabel.text = [NSString stringWithFormat:@"%@",[AppHelper numToStr:[NSNumber numberWithFloat:[AppManager sharedInstance].offerToEdit.fee]]];
    _totalForClientLabel.text = [NSString stringWithFormat:@"%@",[AppHelper numToStr:[NSNumber numberWithFloat:[AppManager sharedInstance].offerToEdit.clientIncome]]];
}

#pragma mark - ARSPopoverDelegate

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing *)view {
    NSLog(@"popoverPresentationController");
    // delegate for you to use.
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    // delegate for you to use.
    NSLog(@"popoverPresentationControllerDidDismissPopover");
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"popoverPresentationControllerShouldDismissPopover");
    // delegate for you to use.
    return YES;
}


#pragma mark IBActions

- (void)showLoadOfferOptions:(UIBarButtonItem*)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *loadOfferAction = [UIAlertAction actionWithTitle:@"Выбрать из сохраненных"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                OfferItem* offer = [OfferItem new];
                                                                offer.category_id = @1028;
                                                                offer.root_category_id = @1004;
                                                                offer.itemDescription = @"Здесь стандартное описание стандартными буквами раз два три четыре пять шесть семь восемь";
                                                                offer.name = @"Шаблонный товар который можно удалить";
                                                                offer.condition_id = @4;
                                                                offer.brand_id = @201;
                                                                offer.condition_id= @2;
                                                                offer.willSendIn_id = @7;
                                                                offer.senderCity_id = @259;
                                                                offer.deliveryEnabled = false;
                                                                offer.price = 65000;
                                                                offer.size_id = @12;
                                                                offer.weight_id = @17;
                                                                offer.arrImages = @{
                                                                                    @"0":[UIImage imageNamed:@"test"],
                                                                                    @"1":[UIImage imageNamed:@"test"],
                                                                                    @"2":[UIImage imageNamed:@"test"],
                                                                                    @"3":[UIImage imageNamed:@"test"]
                                                                                    };
                                                                                    
                                                                [AppManager sharedInstance].offerToEdit = offer;
                                                                [self viewWillAppear:YES];
                                                                [self initFields];
                                                                [self.tableView reloadData];
                                                                
                                                            }];
    
    UIAlertAction *otherOfferAction = [UIAlertAction actionWithTitle:@"Еще что-то"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *action) {

                                                              }];
    
    [alertController addAction:loadOfferAction];
    [alertController addAction:otherOfferAction];
    [alertController setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
    popPresenter.barButtonItem = sender;
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)showSaveOfferOptions:(UIBarButtonItem*)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *saveOfferAction = [UIAlertAction actionWithTitle:@"Редактировать позже"
                                                             style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                                          }];
    
    UIAlertAction *deleteOfferAction = [UIAlertAction actionWithTitle:@"Удалить"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction *action) {
                                                              [AppManager sharedInstance].offerToEdit = [OfferItem new];
                                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                                          }];
    
    [alertController addAction:saveOfferAction];
    [alertController addAction:deleteOfferAction];
    [alertController setModalPresentationStyle:UIModalPresentationPageSheet];
    
    UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
    popPresenter.barButtonItem = sender;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)createOfferButtonDidPressed:(id)sender {
    if ([self checkFieldsForValidValues]) {
        HUD.status = @"Публикуем объявление";
        [HUD show:YES];
        
        [API createOfferWithData:[[AppManager sharedInstance].offerToEdit dictionaryRepresentation]
                       andImages:[AppManager sharedInstance].offerToEdit.arrImages
                        progress:^(NSProgress *progress) {
                            [HUD setProgress:progress.fractionCompleted animated:YES];
        } withHandler:^(BOOL success) {
            if (success) {
                HUD.status = @"Всё готово!";
                [HUD performAction:M13ProgressViewActionSuccess animated:YES];
                [self performSelector:@selector(createdWithSuccess) withObject:nil afterDelay:2];
            } else {
                [HUD hide:YES];
                NSString* message = @"Что-то пошло не так, попробуйте еще раз или повторите позднее";
                UIAlertController* errorAlert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Плохо." style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          
                                                                      }];
                [errorAlert addAction:defaultAction];
                [self presentViewController:errorAlert animated:YES completion:^{
                }];
            }
        }];
    }
}

-(void)createdWithSuccess {
    [AppManager sharedInstance].offerToEdit = [OfferItem new];
    [HUD hide:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)deliveryOptionSwitchDidChanged:(id)sender {
    UISwitch* senderSwitch = (UISwitch*)sender;
    
    [AppManager sharedInstance].offerToEdit.deliveryWillSendByMyselfEnabled = [NSNumber numberWithBool:senderSwitch.on];
    [AppManager sharedInstance].offerToEdit.deliverySamovivoznahEnabled = [NSNumber numberWithBool:senderSwitch.on];
    [AppManager sharedInstance].offerToEdit.deliveryOfficeEnabled = [NSNumber numberWithBool:senderSwitch.on];
    [AppManager sharedInstance].offerToEdit.deliveryCourierEnabled = [NSNumber numberWithBool:senderSwitch.on];
}

-(IBAction)deliverySwitchDidChanged:(id)sender {
    self.insertTableViewRowAnimation = UITableViewRowAnimationLeft;
    self.deleteTableViewRowAnimation = UITableViewRowAnimationRight;
    self.reloadTableViewRowAnimation = UITableViewRowAnimationNone;
    self.hideSectionsWithHiddenRows = NO;
    self.animateSectionHeaders = NO;
    [self cells:_deliveryFieldsToHide setHidden:!_deliverySwitch.on];
    [self reloadDataAnimated:NO];
    [AppManager sharedInstance].offerToEdit.deliveryEnabled = [NSNumber numberWithBool:_deliverySwitch.on];
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

#pragma mark - Navigation Controller stuff

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
