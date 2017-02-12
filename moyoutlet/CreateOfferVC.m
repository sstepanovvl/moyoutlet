//
//  CreateOfferVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 12.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "CreateOfferVC.h"
#import "CreateOfferPhotoCell.h"
#import "SelectBrandVC.h"

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
@property (weak, nonatomic) IBOutlet UILabel *conditionNameLabel;
@property (weak, nonatomic) IBOutlet UIView *shippingFromView;
@property (weak, nonatomic) IBOutlet UILabel *shippingFromLabel;


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
    [self initFields];
    [self initNavigationItems];

    _photoCollectionView.clipsToBounds = NO;
    
    _photoCollectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    [_photoCollectionView registerNib:[UINib nibWithNibName:@"CreateOfferPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"CreateOfferPhotoCell"];

    UIGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [_photoCollectionView addGestureRecognizer:longPressGesture];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        _categoryNameLabel.textColor = [UIColor blackColor];
        _brandNameLabel.textColor = [UIColor blackColor];
        _conditionNameLabel.textColor = [UIColor blackColor];
        _shippingFromLabel.textColor = [UIColor blackColor];
        _categoryNameLabel.text = _item.name;
        _brandNameLabel.text = _item.brandName;
        _conditionNameLabel.text = _item.condition;
        _shippingFromLabel.text = _item.shipping;
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

-(id)getSelectedCategoryId {
#warning добавить модель категории
    return @0;
}
#pragma mark IBAction

- (IBAction)didSelectCategory:(id)sender {
    if(debug_enabled) {
        NSLog(@"Choose category");
    }
}
- (IBAction)didSelectBrand:(id)sender {
    if(debug_enabled) {
        NSLog(@"Choose brand");
    }
    SelectBrandVC* srvc = [[SelectBrandVC alloc] initWithNibName:@"SelectBrandVC" bundle:nil];
    [self.navigationController presentViewController:srvc animated:YES completion:^{
        NSLog(@"Brand selected");
    }];
    
}
- (IBAction)didSelectCondition:(id)sender {
    if(debug_enabled) {
        NSLog(@"Choose condition");
    }
}
- (IBAction)didSelectShippingFrom:(id)sender {
    if(debug_enabled) {
        NSLog(@"Choose condition");
    }
}





- (IBAction)publishButtonDidPress:(id)sender {
    NSDictionary* data = @{
                           @"category_id": [self getSelectedCategoryId],
                           @"title" : @"Тестовый оффер",
                           @"description":@"",
                           @"brand":@"",
                           @"item_condition":@"",
                           @"shipping":@"",
                           @"senderCity":@"",
                           @"sellerId" : @0,
                           @"price":@"",
                           @"size":@"",
                           @"super_category_id":@"",
                           @"categories":@""
                           };
    
    [[AppManager sharedInstance] createOfferWithData:data andImages:self.item.arrImages];
}

#pragma mark - TableView Delegate & DataSource

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - collectionView Layout &  Delegate & DataSource


//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    float width = 0;
//    float height = 0;
//
//    width = 75.0f;
//    height = 75.0f;
//
//    return CGSizeMake(width, height);
//    
//}

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

/*
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Сделать фото", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.navigationController presentViewController:fsvc animated:YES completion:^{}];
        }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Выбрать фото", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        [self.navigationController presentViewController:fsvc animated:YES completion:nil];

    }]];

    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Отмена", nil) style:UIAlertActionStyleCancel handler:NULL]];

    alert.popoverPresentationController.sourceView = [self.selfcell  superview];
    alert.popoverPresentationController.sourceRect = [self.selfcell  frame];
    
    [self presentViewController:alert animated:YES completion:NULL];
 */
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
