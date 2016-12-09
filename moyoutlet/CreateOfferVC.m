//
//  CreateOfferVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 12.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "CreateOfferVC.h"
#import "CreateOfferPhotoCell.h"

@interface CreateOfferVC ()
@property (strong, nonatomic) IBOutlet PhotoCollectionView *photoCollectionView;
@property (strong, nonatomic) IBOutlet UISwitch *deliverySwitch;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *deliverySectionHeightConstraint;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *deliverySection;

@property (strong, nonatomic) CreateOfferPhotoCell* selfcell ;
@property (strong, nonatomic) IBOutlet UIView *superView;
@property (strong, nonatomic) IBOutlet UIScrollView *superScrollView;


@end

@implementation CreateOfferVC


-(instancetype) initFromStoryboard {
    self = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreateOfferVC"];
    if (self) {
        self.item = [OfferItem new];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    fsvc.hidesBottomBarWhenPushed = YES;
    
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

#pragma mark Fusuma delegate

- (void)fusumaImageSelected:(UIImage * _Nonnull)image {
    [self.selfcell.imageView setImage:image];
    if (debug_enabled ) {
        NSLog(@"fusumaImageSelected");
    }
    
}

- (void)fusumaDismissedWithImage:(UIImage * _Nonnull)image {
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
