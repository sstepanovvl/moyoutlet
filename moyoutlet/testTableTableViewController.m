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




@interface testTableTableViewController () <ARSPopoverDelegate>
@property (strong, nonatomic)   IBOutletCollection(UISwitch) NSArray *cellSwitches;
@property (weak, nonatomic)     IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) 	IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) 	IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) 	IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) 	IBOutlet UILabel *brandLabel;
@property (weak, nonatomic)     IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic)     IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) 	IBOutlet UISwitch *shippingWillSenByMyself;
@property (weak, nonatomic) 	IBOutlet UISwitch *smovivoz;
@property (weak, nonatomic) 	IBOutlet UISwitch *otdelenie;
@property (weak, nonatomic)     IBOutlet UISwitch *courier;
@property (weak, nonatomic)     IBOutlet UILabel *willSendinLabel;



@property (strong, nonatomic) IBOutlet PhotoCollectionView *editPhotoCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *outletFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalForClientLabel;
@property (weak, nonatomic) IBOutlet UITextField *offerPriceLabel;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *deliveryFieldsToHide;
@property (strong, nonatomic) UISwitch* deliverySwitch;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UIButton *createOfferButton;

#pragma mark viewOfferMode Outlets
@property (weak, nonatomic) IBOutlet UICollectionView *viewPhotoCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *viewOfferNextButton;
@property (weak, nonatomic) IBOutlet UIButton *viewOfferPrevButton;
@property (weak, nonatomic) IBOutlet UICollectionView *relatedOffersCollectionView;


@property (strong, nonatomic) IBOutlet UIView* stickyFooter;
@property (strong,nonatomic)    NSArray* offerRelatedItems;

@end

@implementation testTableTableViewController
{
    M13ProgressHUD* HUD;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationItems];
    [self initHud];
    if (self.offerViewControllerMode == OfferViewControllerModeView) {
        [self initFooterWithPrice:@999999 andDeliveryText:@"Доставка не включена"];
        _offerRelatedItems = [[AppManager sharedInstance] getRelatedOffersForOffer:_offerItem];
        [_relatedOffersCollectionView registerNib:[UINib nibWithNibName:@"OfferLightCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"OfferLightCollectionViewCell"];
        
        _viewPhotoCollectionView.layer.cornerRadius = 5.0f;
        _viewPhotoCollectionView.layer.masksToBounds = YES;
        _viewPhotoCollectionView.clipsToBounds = YES;
        [_viewPhotoCollectionView registerNib:[UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"PhotoCollectionViewCell"];
        
        _offerPriceLabel.delegate = self;

    } else if (self.offerViewControllerMode == OfferViewControllerModeCreate) {
        [self initEditPhotoCollectionView];
        _descriptionTextView.delegate = self;
        _titleTextField.delegate = self;
        
        _offerPriceLabel.delegate = self;
    }
    
    self.tableView.delegate = self;
    
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initFields];
    
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideFooterWithPrice];
}

-(void)initEditPhotoCollectionView {
    UIGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [_editPhotoCollectionView addGestureRecognizer:longPressGesture];
    _editPhotoCollectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    _editPhotoCollectionView.clipsToBounds = NO;
    [_editPhotoCollectionView registerNib:[UINib nibWithNibName:@"CreateOfferPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"CreateOfferPhotoCell"];
    _editPhotoCollectionView.delegate = self;
}

-(void)initHud {
    M13ProgressViewImage* imageHud = [[M13ProgressViewImage alloc]init];
    [imageHud setProgressImage:[UIImage imageNamed:@"outlet"]];
    [imageHud setProgressDirection:M13ProgressViewImageProgressDirectionBottomToTop];
    HUD = [[M13ProgressHUD alloc] initWithProgressView:imageHud];
    HUD.progressViewSize = CGSizeMake(100.0, 100.0);
    CGPoint ss =CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    HUD.animationPoint = ss;
    HUD.primaryColor = [UIColor appRedColor];
    HUD.secondaryColor = [UIColor whiteColor];
    HUD.hudBackgroundColor = [UIColor whiteColor];
    HUD.statusColor = [UIColor appRedColor];
    HUD.statusFont = [UIFont fontWithName:@"OpenSans" size:12.0];
    HUD.maskType = M13ProgressHUDMaskTypeSolidColor;
    
    UIWindow *window = [UIApplication safeM13SharedApplication].delegate.window;
    
    [window addSubview:HUD];
}

-(void)initFields {
    
    OfferItem* editableItem = [AppManager sharedInstance].offerToEdit;

    if (_offerViewControllerMode != OfferViewControllerModeView ) {
        [self cell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]] setHidden:YES];
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
        [_editPhotoCollectionView reloadData];

        if (editableItem.price > 0) {
            [self calculateFeesAndPrices];
        }
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
            if ([editableItem.brand_id isEqualToNumber:@0]) {
                _brandLabel.textColor = [UIColor blackColor];
                _brandLabel.text = @"Без бренда";
            } else {
                NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.brands Value:editableItem.brand_id forKey:@"id"];
                if (dic) {
                    _brandLabel.textColor = [UIColor blackColor];
                    _brandLabel.text = [dic valueForKey:@"name"];
                }
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
   
        
    } else {
        [self cell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setHidden:YES];
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
    
    
    
    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];
    
    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    
    switch (_offerViewControllerMode) {
        case OfferViewControllerModeEdit:
            self.navigationItem.title = @"Редактирование объявления";
            [leftBarButtonWithLogo addTarget:self action:@selector(showSaveOfferOptions:) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            
        case OfferViewControllerModeView:
            self.navigationItem.title = _offerItem.name;
            [leftBarButtonWithLogo addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case OfferViewControllerModeCreate:
            self.navigationItem.title = @"Создание объявления";
            [leftBarButtonWithLogo addTarget:self action:@selector(showSaveOfferOptions:) forControlEvents:UIControlEventTouchUpInside];
            break;
        default:
            break;
    }
    
    
    
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;

}

- (void)initFooterWithPrice:(NSNumber*)price andDeliveryText:(NSString*)deliveryText {
    
    _stickyFooter = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-55, self.view.bounds.size.width, 55)];
    
    _stickyFooter.backgroundColor = [UIColor blackColor];
    
    UIButton* buyButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 135, 5 , 130, 45) ];
    buyButton.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"buyButtonImage"]];
    
    [buyButton addTarget:self action:@selector(buyButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
    [_stickyFooter addSubview:buyButton];
    
    UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 85, _stickyFooter.frame.size.height)];
    priceLabel.text = [NSString stringWithFormat:@"%@ ₽",price];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.textColor = [UIColor whiteColor];
    priceLabel.font = [UIFont fontWithName:@"Open-Sans bold" size:22];
    [_stickyFooter addSubview:priceLabel];
    
    UILabel* deliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceLabel.frame.size.width + 5, 0 ,self.view.bounds.size.width - buyButton.frame.size.width - priceLabel.frame.size.width - 15, _stickyFooter.frame.size.height)];
    deliveryLabel.text = [NSString stringWithFormat:@"%@",deliveryText];
    deliveryLabel.backgroundColor = [UIColor clearColor];
    deliveryLabel.textColor = [UIColor whiteColor];
    deliveryLabel.font = [UIFont fontWithName:@"Open-Sans" size:12];
    deliveryLabel.adjustsFontSizeToFitWidth = true;
    [_stickyFooter addSubview:deliveryLabel];

    [self.parentViewController.view addSubview:_stickyFooter];
    
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.3];
    [applicationLoadViewIn setType:kCATransitionFromBottom];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[_stickyFooter layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];

    
}

- (void)hideFooterWithPrice {
    [_stickyFooter removeFromSuperview];
}

- (void)buyButtonDidPressed {
    NSLog(@"buy button did pressed");
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

-(void)textViewDidBeginEditing:(UITextView *)textField {
    if ([textField.text isEqualToString:@"Подробно опишите Ваш товар, напр.:                             «б/у непродолжительное время, имеет несколько царапин, но выглядит как новый»"]) {
        textField.text = @"";
    }
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
    NSInteger lastRow = [self.tableView numberOfRowsInSection:indexPath.section]-1;
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
        if (_offerViewControllerMode == OfferViewControllerModeView) {
            return 325.0f;
        } else {
            return 100.0f;
        }
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        return 375.0f;
    } else if (indexPath.section == 5 && indexPath.row == 2) {
        return 210.0f;
    } else if (indexPath.section == 6) { //
        return 65.0f;
    } else if (indexPath.section == 8) {
        return 220.0f;
    } else if (indexPath.section == 9) {
        return 55.0f;
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
    
    if (section == 1) {
        headerCell = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 85)];
        UILabel* offerTitleLabel = [UILabel new];
        offerTitleLabel.text = _offerItem.name;
        offerTitleLabel.font = [UIFont appBoldFontWithSize:13];
        offerTitleLabel.backgroundColor = [UIColor clearColor];
        offerTitleLabel.textAlignment = NSTextAlignmentCenter;
        [headerCell addSubview:offerTitleLabel];
        
        
        UIButton* likesButton = [UIButton new];
        
        
        
        UIImageView* likeIcon = [[UIImageView alloc] init];
        likeIcon.image = [UIImage imageNamed:@"like_v2"];
        likeIcon.contentMode = UIViewContentModeCenter;
        likeIcon.translatesAutoresizingMaskIntoConstraints = NO;
        [headerCell addSubview:likeIcon];
        
        [headerCell addConstraints:@[[NSLayoutConstraint constraintWithItem:likeIcon
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:headerCell
                                                                  attribute:NSLayoutAttributeLeading
                                                                 multiplier:1.0
                                                                   constant:25.0],
                                     [NSLayoutConstraint constraintWithItem:likeIcon
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:headerCell
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:0.0],
                                     [NSLayoutConstraint constraintWithItem:likeIcon
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:17]]
         ];
        
        UILabel* likesCountLabel = [UILabel new];
        likesCountLabel.text = [NSString stringWithFormat: @"Понравилось: %@",_offerItem.likesCount];
        likesCountLabel.font = [UIFont appRegularFontWithSize:12.0f];
        likesCountLabel.textColor = [UIColor appDarkGrayColor];
        likesCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [headerCell addSubview:likesCountLabel];

        
        [headerCell addConstraints:@[[NSLayoutConstraint constraintWithItem:likesCountLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:likeIcon
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:10.0],
                                     [NSLayoutConstraint constraintWithItem:likesCountLabel
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:likeIcon
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:0.0],
                                     [NSLayoutConstraint constraintWithItem:likesCountLabel
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:25.0]]];
        
        UIImageView* commentIcon = [[UIImageView alloc] init];
        commentIcon.image = [UIImage imageNamed:@"comments_v2"];
        commentIcon.contentMode = UIViewContentModeCenter;
        commentIcon.translatesAutoresizingMaskIntoConstraints = NO;
        [headerCell addSubview:commentIcon];
        
        [headerCell addConstraints:@[[NSLayoutConstraint constraintWithItem:commentIcon
                                                                attribute:NSLayoutAttributeCenterX
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:headerCell
                                                                attribute:NSLayoutAttributeCenterX
                                                               multiplier:1.0f
                                                                 constant:0.0f],
         [NSLayoutConstraint constraintWithItem:commentIcon
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:50.0f],
         [NSLayoutConstraint constraintWithItem:commentIcon
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:nil
                                      attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0f
                                       constant:25.0f],
         [NSLayoutConstraint constraintWithItem:commentIcon
                                      attribute:NSLayoutAttributeCenterY
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:likeIcon
                                      attribute:NSLayoutAttributeCenterY
                                     multiplier:1.0f
                                       constant:0.0f]
         ]];
        
        UILabel* commentsCountLabel = [UILabel new];
        commentsCountLabel.text =  [NSString stringWithFormat: @"Комментарии: %@",_offerItem.commentsCount];
        commentsCountLabel.font = [UIFont appRegularFontWithSize:12.0f];
        commentsCountLabel.textColor = [UIColor appDarkGrayColor];
        commentsCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [headerCell addSubview:commentsCountLabel];
        
        
        [headerCell addConstraints:@[[NSLayoutConstraint constraintWithItem:commentsCountLabel
                                                                  attribute:NSLayoutAttributeLeading
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:commentIcon
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0
                                                                   constant:-5.0],
                                     [NSLayoutConstraint constraintWithItem:commentsCountLabel
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:likeIcon
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:0.0],
                                     [NSLayoutConstraint constraintWithItem:commentsCountLabel
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:25.0]]];
        
        UIImageView* flagIcon = [[UIImageView alloc] init];
        flagIcon.image = [UIImage imageNamed:@"flag"];
        flagIcon.contentMode = UIViewContentModeCenter;
        flagIcon.translatesAutoresizingMaskIntoConstraints = NO;
        [headerCell addSubview:flagIcon];
        
        [headerCell addConstraints:@[[NSLayoutConstraint constraintWithItem:flagIcon
                                                                  attribute:NSLayoutAttributeTrailing
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:headerCell
                                                                  attribute:NSLayoutAttributeTrailing
                                                                 multiplier:1.0f
                                                                   constant:-25.0f],
                                     [NSLayoutConstraint constraintWithItem:flagIcon
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:25.0f],
                                     [NSLayoutConstraint constraintWithItem:flagIcon
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0f
                                                                   constant:25.0f],
                                     [NSLayoutConstraint constraintWithItem:flagIcon
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:likeIcon
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0f
                                                                   constant:0.0f]
                                     ]];
        
    } else if (section == 3) {
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
    } else if (section == 7) {
            headerCell = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 65)];
            UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, headerCell.frame.size.width, headerCell.frame.size.height)];
            [button setImage:[UIImage imageNamed:@"commentButton"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(commentButtonDidPresed) forControlEvents:UIControlEventTouchUpInside];
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
        return 0.0001;
    } else if (section == 1 && _offerViewControllerMode == OfferViewControllerModeView)
    {
        return 85.0f;
    } else if (section == 5) {
        return 20.0f;
    } else if (section == 7) {
        return 65.0f;
    } else if (section == 9) {
        return 0.0f;
    } else {
        return 45.0f;
    }
}

#pragma mark - TableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_offerViewControllerMode == OfferViewControllerModeEdit || _offerViewControllerMode == OfferViewControllerModeCreate )
        {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([cell.reuseIdentifier  isEqual: @"CreateModeCategoryCell"]) {
                [self performSegueWithIdentifier:@"selectCategorySegue" sender:nil];
            }
            if ([cell.reuseIdentifier  isEqual: @"CreateModesizeCell"]) {
                [self performSegueWithIdentifier:@"selectSizeSegue" sender:nil];
            }
            if ([cell.reuseIdentifier  isEqual: @"CreateModeBrandCell"]) {
                [self performSegueWithIdentifier:@"selectBrandSegue" sender:nil];
            }
            if ([cell.reuseIdentifier  isEqual: @"CreateModeConditionCell"]) {
                [self performSegueWithIdentifier:@"selectConditionSegue" sender:nil];
            }
            if ([cell.reuseIdentifier  isEqual: @"CreateModeSenderCityCell"]) {
                [self performSegueWithIdentifier:@"selectCitySegue" sender:nil];
            }
            if ([cell.reuseIdentifier  isEqual: @"CreateModeWeightCell"]) {
                [self performSegueWithIdentifier:@"selectWeightCell" sender:nil];
            }
            if ([cell.reuseIdentifier  isEqual: @"CreateModeWillSendInCell"]) {
                [self performSegueWithIdentifier:@"selectWillSendInSegue" sender:nil];
            }
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
    NSLog(@"indexPath.row = %ld, CollectionView.tag =  %ld",(long)section,(long)collectionView.tag);

    if (_offerViewControllerMode == OfferViewControllerModeView) {
        switch (collectionView.tag) {
            case 0:
                return 0;
                break;
            case 1:
                return [_offerItem.photoUrls count];
                break;
            case 2:
                return [_offerRelatedItems count];
                break;
            default:
                return 0;
                break;
        }
    } else if (_offerViewControllerMode == OfferViewControllerModeEdit) {
            switch (collectionView.tag) {
                case 0:
                    return 4;
                    break;
                case 1:
                    return 0;
                    break;
                case 2:
                    return 0;
                    break;
                default:
                    return 0;
                    break;
            }
    } else {
        switch (collectionView.tag) {
            case 0:
                return 4;
                break;
            case 1:
                return 0;
                break;
            case 2:
                return 0;
                break;
            default:
                return 0;
                break;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView.tag == 0) {
        CreateOfferPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfferPhotoCell" forIndexPath:indexPath];
        [cell.imView setContentMode:UIViewContentModeScaleAspectFill];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        if (![[[AppManager sharedInstance].offerToEdit.arrImages valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]] isEqual:[NSNull null]]) {
            [cell.imView setImage:[[AppManager sharedInstance].offerToEdit.arrImages valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]];
        } else {
            [cell.imView setImage:[UIImage imageNamed:@"photoPlaceholder"]];
        }
        return cell;
    } else if (collectionView.tag == 1){
        
        PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCollectionViewCell" forIndexPath:indexPath];
        
        CGSize photoSize = cell.frame.size;
        
        CGFloat nativeSCale = [[UIScreen mainScreen]scale];
        
        NSString* urlString = [NSString stringWithFormat:@"%@&size=%.fx%.f",[_offerItem.photoUrls objectAtIndex:indexPath.row],photoSize.width*nativeSCale,photoSize.height*nativeSCale];
        
        NSURL * url = [NSURL URLWithString:urlString];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                        options:SDWebImageRetryFailed
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           NSLog(@"%ld",receivedSize-expectedSize);
                                                       }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          UIImage* imageToSet = [UIImage imageWithCGImage:[image CGImage]
                                                                                                    scale:[UIScreen mainScreen].scale
                                                                                              orientation:UIImageOrientationUp];
                                                          if (cell.offerImage != nil) {
                                                          [cell.offerImage setImage:imageToSet];
                                                          } else {
                                                              NSLog(@"offerImage == nil");
                                                          }
                                                          
                                                      }];
        
        return cell;
    } else {
        
        OfferLightCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OfferLightCollectionViewCell" forIndexPath:indexPath];
        
        OfferItem* offerItem = [_offerRelatedItems objectAtIndex:indexPath.row];
        
        cell.offerItem = offerItem;
        [cell configure];
        
        CGSize photoSize = cell.frame.size;
        
        CGFloat nativeSCale = [[UIScreen mainScreen]scale];
        
        NSString* urlString = [NSString stringWithFormat:@"%@&size=%.fx%.f",[offerItem.photoUrls objectAtIndex:0],photoSize.width*nativeSCale,photoSize.height*nativeSCale];
        
        NSURL * url = [NSURL URLWithString:urlString];
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:url
                                                        options:SDWebImageRetryFailed
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           NSLog(@"%ld",expectedSize - receivedSize);
                                                       }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          UIImage* imageToSet = [UIImage imageWithCGImage:[image CGImage]
                                                                                                    scale:[UIScreen mainScreen].scale
                                                                                              orientation:UIImageOrientationUp];
                                                          
                                                          [cell.offerImage setImage:imageToSet];
                                                      }];
        
        return cell;
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString* tmp = [[AppManager sharedInstance].offerToEdit.photoUrls objectAtIndex:sourceIndexPath.item];
    
    [[AppManager sharedInstance].offerToEdit.photoUrls removeObjectAtIndex:sourceIndexPath.item];
    
    [[AppManager sharedInstance].offerToEdit.photoUrls insertObject:tmp atIndex:destinationIndexPath.item];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    if (collectionView.tag == 0) {
        __weak testTableTableViewController* weaktvc = self;
        CameraViewController* camv = [[CameraViewController alloc] initWithCroppingEnabled:YES allowsLibraryAccess:YES
                                                                                completion:^(UIImage * _Nullable asd, PHAsset * _Nullable dsa) {
                                                                                    [[AppManager sharedInstance].offerToEdit.arrImages setValue:asd forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
                                                                                    [weaktvc dismissViewControllerAnimated:YES completion:nil];
                                                                                }];
        [self presentViewController:camv animated:YES completion:nil];
    }
}


#pragma mark - Other Stuff

-(void)createDummyOffer {
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
}



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

- (IBAction)didPressViewOfferNextButton:(id)sender {
}

- (IBAction)didPressViewOfferPrevButton:(id)sender {
}

- (void)showLoadOfferOptions:(UIBarButtonItem*)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *loadOfferAction = [UIAlertAction actionWithTitle:@"Выбрать из сохраненных"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                                                                [self createDummyOffer];
                                                                [self viewWillAppear:YES];
                                                                [self initFields];
                                                                [self calculateFeesAndPrices];
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

-(void)commentButtonDidPresed {
    NSLog(@"comment button did pressed");
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
