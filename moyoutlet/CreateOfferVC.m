//
//  CreateOfferVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 12.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "CreateOfferVC.h"
#import "CreateOfferPhotoCell.h"
//#import "SelectBrandVC.h"
#import "SelectVC.h"
#import "SelectCategoryVC.h"

@interface CreateOfferVC ()
@property (strong, nonatomic) IBOutlet PhotoCollectionView *photoCollectionView;
@property (strong, nonatomic) IBOutlet UISwitch *deliverySwitch;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *deliverySectionHeightConstraint;
@property (strong, nonatomic) NSData* receiveData;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *deliverySection;

@property (strong, nonatomic) CreateOfferPhotoCell* selfcell ;
@property (strong, nonatomic) IBOutlet UIView *superView;
@property (strong, nonatomic) IBOutlet UIScrollView *superScrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *offerTitleField;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *offerDescriptionField;

@property (weak, nonatomic) IBOutlet UIView *detailsHeaderView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIView *brandView;
@property (weak, nonatomic) IBOutlet UIView *conditionView;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandNameLabel;
@property (weak, nonatomic) IBOutlet UIView *shippingFromView;
@property (weak, nonatomic) IBOutlet UILabel *shippingFromLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UILabel *comissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *willSendLabel;


@end

@implementation CreateOfferVC


-(instancetype) initFromStoryboardWithItem:(OfferItem*)item {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateOfferVC"];
    if (self) {
        if (!item) {
            self.item = [OfferItem new];
            self.createNewOffer = YES;
        } else {
            self.item = item;
            self.createNewOffer = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItems];
    
    UIGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [_photoCollectionView addGestureRecognizer:longPressGesture];
    _photoCollectionView.clipsToBounds = NO;
    _photoCollectionView.backgroundColor = [UIColor clearColor];
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"CreateOfferPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"CreateOfferPhotoCell"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    _priceTextField.delegate = self;
    _offerDescriptionField.placeholder = @"Несколько слов о вашей вещи добавьте сюда";
    _offerDescriptionField.placeholderColor = [UIColor appMidGrayColor];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initFields];
}

-(void)showImagePicker {
    FusumaViewController* fsvc = [FusumaViewController new];
    
    fsvc.delegate = self;
    fsvc.hasVideo = false;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.selfcell = (CreateOfferPhotoCell*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Сделать фото", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

            [self.navigationController pushViewController:fsvc animated:YES];
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Выбрать фото", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self.navigationController presentViewController:fsvc animated:YES completion:nil];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:NULL]];
    
    alert.popoverPresentationController.sourceView = [self.selfcell  superview];
    alert.popoverPresentationController.sourceRect = [self.selfcell  frame];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

-(void)initFields {
    if (!_createNewOffer) {
        if ([[AppManager sharedInstance].selectedCategories count]) {
            _categoryNameLabel.textColor = [UIColor blackColor];
            _categoryNameLabel.text = [[[AppManager sharedInstance].selectedCategories objectAtIndex:0] text];
        }
        if ([[AppManager sharedInstance].selectedBrands count]) {
            _brandNameLabel.textColor = [UIColor blackColor];
            _brandNameLabel.text = [[[AppManager sharedInstance].selectedBrands objectAtIndex:0] text];
        }
        if ([[AppManager sharedInstance].selectedConditions count]) {
            _conditionLabel.textColor = [UIColor blackColor];
            _conditionLabel.text = [[[AppManager sharedInstance].selectedConditions objectAtIndex:0] text];
        }
        if ([[AppManager sharedInstance].selectedCities count]) {
            _shippingFromLabel.textColor = [UIColor blackColor];
            _shippingFromLabel.text = [[[AppManager sharedInstance].selectedCities objectAtIndex:0] text];
        }
        if ([[AppManager sharedInstance].selectedWillSendIn count]) {
            _willSendLabel.textColor = [UIColor blackColor];
            _willSendLabel.text = [[[AppManager sharedInstance].selectedWillSendIn objectAtIndex:0] text];
        }
        
    }
}

-(void)initNavigationItems {
    [super initNavigationItems];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0],
                              NSForegroundColorAttributeName :  [UIColor appRedColor]}];

     self.navigationItem.title = @"Создать объявление";

    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)handleLongPressGesture:(UILongPressGestureRecognizer*)gesture {

    if (gesture.state == UIGestureRecognizerStateBegan) {
        [_photoCollectionView beginInteractiveMovementForItemAtIndexPath:[_photoCollectionView indexPathForItemAtPoint:[gesture locationInView:_photoCollectionView]]];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [_photoCollectionView updateInteractiveMovementTargetPosition:[gesture locationInView:gesture.view]];

    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [_photoCollectionView endInteractiveMovement];
    } else {
        [_photoCollectionView cancelInteractiveMovement];
    }
}

#pragma mark Publish helpers

-(NSNumber*)getSelectedCategoryId {
    SearchItem* selectedCategory = nil;
    if ([[AppManager sharedInstance].selectedCategories count]) {
        selectedCategory = [[AppManager sharedInstance].selectedCategories lastObject];
        return [NSNumber numberWithInteger:selectedCategory.item_id];
    } else {
        return @-1;
    }
}
-(NSNumber*)getSelectedBrandId {
    SearchItem* selectedBrand = nil;
    if ([[AppManager sharedInstance].selectedBrands count]) {
        selectedBrand = [[AppManager sharedInstance].selectedBrands lastObject];
        return [NSNumber numberWithInteger:selectedBrand.item_id];
    } else {
        return @-1;
    }
}

-(NSNumber*)getSelectedConditionId {
    SearchItem* selectedCondition = nil;
    if ([[AppManager sharedInstance].selectedConditions count]) {
        selectedCondition = [[AppManager sharedInstance].selectedConditions lastObject];
        return [NSNumber numberWithInteger:selectedCondition.item_id];
    } else {
        return @-1;
    }
}

-(NSNumber*)getSelectedCityId {
    SearchItem* selectedCity = nil;
    if ([[AppManager sharedInstance].selectedCities count]) {
        selectedCity = [[AppManager sharedInstance].selectedCities lastObject];
        return [NSNumber numberWithInteger:selectedCity.item_id];
    } else {
        return @-1;
    }
}
-(NSNumber*)getSelectedWillSendIn {
    SearchItem* selectedWillSendItem = nil;
    if ([[AppManager sharedInstance].selectedWillSendIn count]) {
        selectedWillSendItem = [[AppManager sharedInstance].selectedWillSendIn lastObject];
        return [NSNumber numberWithInteger:selectedWillSendItem.item_id];
    } else {
        return @-1;
    }
}


-(NSNumber*)getPrice {
    return [NSNumber numberWithFloat:[_priceTextField.text floatValue]];
}


-(bool)checkFields {
    if ([[self getSelectedCategoryId] isEqual: @-1] ) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Выберите категорию и попробуйте снова";
        error.customHeader =@"Категория не выбрана";
        [self throughError:error];
        return false;
    } else if ([[self getSelectedBrandId] isEqual: @-1] ) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Выберите бренд и попробуйте снова";
        error.customHeader =@"Бренд не выбран";
        [self throughError:error];
        return false;
    } else if ([self.item.arrImages count] < 1) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Кажется вы забыли добавить фотографии";
        error.customHeader =@"нет фотографий";
        [self throughError:error];
        return false;
    } else if ([[self getSelectedWillSendIn] isEqual:@-1]) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Укажите когда вы сможете отправить вещь";
        error.customHeader =@"Отпрака в течение не указана";
        [self throughError:error];
        return false;
    } else if ([[self getSelectedConditionId] isEqual:@-1]) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Укажите в каком состоянии ваша вещь";
        error.customHeader =@"Состояние не выбрано";
        [self throughError:error];
        return false;
    } else if ([[self getSelectedConditionId] isEqual:@-1]) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Укажите в каком состоянии ваша вещь";
        error.customHeader =@"Состояние не выбрано";
        [self throughError:error];
        return false;
    } else if ([[self getSelectedCityId] isEqual:@-1]) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Укажите из какого города будет отправлена ваша вещь";
        error.customHeader =@"Город отправки не выбран";
        [self throughError:error];
        return false;
    } else if ([_offerTitleField.text length] < 5) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Добавьте название";
        error.customHeader =@"Название не добавлено";
        [self throughError:error];
        return false;
    } if ([_offerDescriptionField.text length] < 25) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Добавьте описание, хотябы 25 букв";
        error.customHeader =@"Описание не добавлено";
        [self throughError:error];
        return false;
    } else if ([_priceTextField.text floatValue] < 5) {
        baseError* error = [[baseError alloc] init];
        error.customError = @"Добавьте название";
        error.customHeader =@"Название не добавлено";
        [self throughError:error];
        return false;
    }
    return true;
}
#pragma mark IBAction

- (IBAction)didSelectCategory:(id)sender {
    if(debug_enabled) {
        NSLog(@"Choose category");
    }
    _createNewOffer = false;
    
    SelectCategoryVC* srvc = [[SelectCategoryVC alloc] initWithNibName:@"SelectCategoryVC" bundle:nil];
    srvc.parent_id = @0;
    srvc.title = @"Категория";
    [self.navigationController showViewController:srvc sender:nil];
}

- (IBAction)didSelectBrand:(id)sender {
    if(debug_enabled) {
        NSLog(@"Choose brand");
    }
    _createNewOffer = false;
    SelectVC* srvc = [[SelectVC alloc] initWithNibName:@"SelectVC" bundle:nil];
    srvc.searchType = BRAND;
    [self.navigationController pushViewController:srvc animated:YES];
}

- (IBAction)didSelectCondition:(id)sender {
    _createNewOffer = false;
    if(debug_enabled) {
        NSLog(@"Choose condition");
    }
    SelectVC* srvc = [[SelectVC alloc] initWithNibName:@"SelectVC" bundle:nil];
    srvc.searchType = CONDITIONS;
    [self.navigationController pushViewController:srvc animated:YES];
}
- (IBAction)didSelectShippingFrom:(id)sender {
    _createNewOffer = false;
    if(debug_enabled) {
        NSLog(@"Choose condition");
    }
    SelectVC* srvc = [[SelectVC alloc] initWithNibName:@"SelectVC" bundle:nil];
    srvc.searchType = CITIES;
    [self.navigationController pushViewController:srvc animated:YES];
}

- (IBAction)didSelecectWillSendIn:(id)sender {
    _createNewOffer = false;
    if(debug_enabled) {
        NSLog(@"Choose condition");
    }
    SelectVC* srvc = [[SelectVC alloc] initWithNibName:@"SelectVC" bundle:nil];
    srvc.searchType = WILLSENDIN;
    [self.navigationController pushViewController:srvc animated:YES];
}



- (IBAction)publishButtonDidPress:(id)sender {
    if ([self checkFields]) {
        self.item.category_id = [self getSelectedCategoryId];
        self.item.name = _offerTitleField.text;
        self.item.brand_id = [self getSelectedBrandId];
        self.item.condition_id = [self getSelectedConditionId];
        self.item.itemDescription = _offerDescriptionField.text;
        self.item.willSendIn_id = [self getSelectedWillSendIn];
        self.item.senderCity_id = [self getSelectedCityId];
//        NSDictionary* data = @{
//                               @"category_id": [self getSelectedCategoryId],
//                               @"title" : _offerTitleField.text,
//                               @"description":_offerDescriptionField.text,
//                               @"brand":[self getSelectedBrandId],
//                               @"item_condition":[self getSelectedConditionId],
//                               @"shipping":@"",
//                               @"senderCity_id":[self getSelectedCityId],
//                               @"sellerId" : @0,
//                               @"price":[self getPrice],
//                               @"size":@"",
//                               @"willSendIn":_willSendInTextField.text
//                               };
//        
//        [[AppManager sharedInstance] createOfferWithData:data andImages:self.item.arrImages];
    }
}

#pragma mark - textField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        float itemPrice = [textField.text floatValue];
        float comission = itemPrice * [[AppManager sharedInstance].outletComissionMulitplier floatValue];
        float totalValue = itemPrice - comission;
        _comissionLabel.text = [NSString stringWithFormat:@"%l.f ₽",comission];
        _totalLabel.text = [NSString stringWithFormat:@"%l.f ₽", totalValue];
    }
}
#pragma mark - TableView Delegate & DataSource

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - collectionView Layout &  Delegate & DataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CreateOfferPhotoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CreateOfferPhotoCell" forIndexPath:indexPath];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    switch (indexPath.row) {
        case 0:
            [cell.imageView setImage:[self.item.arrImages objectAtIndex:0]];
            break;
        default:
            [cell.imageView setImage:[UIImage imageNamed:@"photoPlaceholder"]];
            break;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {

    NSString* tmp = [_item.photoUrls objectAtIndex:sourceIndexPath.item];

    [_item.photoUrls removeObjectAtIndex:sourceIndexPath.item];

    [_item.photoUrls insertObject:tmp atIndex:destinationIndexPath.item];

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {

    FusumaViewController* fsvc = [FusumaViewController new];
    
    fsvc.delegate = self;
    fsvc.hasVideo = false;
    
    self.selfcell = (CreateOfferPhotoCell*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];

    [self.navigationController presentViewController:fsvc animated:YES completion:^{}];
}

#pragma mark Fusuma delegate

- (void)fusumaImageSelected:(UIImage * _Nonnull)image {
    if (debug_enabled ) {
        NSLog(@"fusumaImageSelected");
    }
}

- (void)fusumaDismissedWithImage:(UIImage * _Nonnull)image {
    [self.selfcell.imageView setImage:image];
    NSInteger row =[[_photoCollectionView indexPathForCell:self.selfcell] row];
#warning Отследи какого хуя тут пустой массив! НЕ ПОЗОРЬСЯ
    
    if ([self.item.arrImages count] < 4) {
        while ([self.item.arrImages count] < 4) {
            [_item.arrImages addObject:[NSNull null]];
        }
    }
    [self.item.arrImages insertObject:image atIndex: row];
    if (debug_enabled) {
    NSLog(@"fusumaDismissedWithImage");
    }
}

- (void)fusumaVideoCompletedWithFileURL:(NSURL * _Nonnull)fileURL {
    if (debug_enabled) {
        NSLog(@"fusumaVideoCompletedWithFileURL");
    }
}


- (void)fusumaCameraRollUnauthorized {
    if (debug_enabled) {
        NSLog(@"fusumaCameraRollUnauthorized");
    }
}

- (void)fusumaClosed {
    if (debug_enabled) {
        NSLog(@"fusumaClosed");
    }
    
}

#pragma mark NSUrlsession Delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSLog(@"Sent %lld, Total sent %lld, Not Sent %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    _receiveData = [NSMutableData data];
//    [_receiveData setLength:0];
//    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"NSURLSession Starts to Receive Data");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    [_receiveData appendData:data];
    NSLog(@"NSURLSession Receive Data");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"URL Session Complete: %@", task.response.description);
    
    if(error != nil) {
        NSLog(@"Error %@",[error userInfo]);
    } else {
        NSLog(@"Uploading is Succesfull");
        
        NSString *result = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", result);
    }
}




#pragma mark Alert Stuff

- (void)showImportActionSheet:(id)sender
{

}
- (IBAction)deliverySwitchDidChanged:(UISwitch*)sender {

    [self.view layoutIfNeeded];
    
    for (NSLayoutConstraint* cons in _deliverySectionHeightConstraint) {
        cons.constant = sender.isOn ? 0 : 42;
    }

    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    for (UIView* section in _deliverySection) {
        section.hidden = sender.isOn ? YES : NO;
    }
}




@end
