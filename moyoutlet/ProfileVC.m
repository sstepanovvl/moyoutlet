//
//  ProfileVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "ProfileVC.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileVC ()

@end

@implementation ProfileVC
NSString *kUserOfferLightCellID = @"OfferLightCollectionViewCell";

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        return self;
    } else {
        return nil; }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCustomNavigationItems];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];

    _userImage.layer.borderWidth = 2.0f;
    _userImage.layer.cornerRadius = 50.0f;
    _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImage.clipsToBounds = YES;
    
    [_offersCollectionView registerNib:[UINib nibWithNibName:@"OfferLightCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kUserOfferLightCellID];

//    NSLog(@"%lu",(unsigned long)_user.userID);

    if (_user) {
        _userName.text = [NSString stringWithFormat:@"%@ %@",_user.firstName, _user.lastName];
        _userDescriptionTextView.text = _user.descr;
        [MBProgressHUD showHUDAddedTo:_offersCollectionView animated:YES];

        [_userImage sd_setImageWithURL:[NSURL URLWithString:_user.photoUrl]
                      placeholderImage:[UIImage imageNamed:@"userImagePlaceholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [UIView transitionWithView:_userImage
                                                   duration:0.5f
                                                    options:UIViewAnimationOptionLayoutSubviews
                                                 animations:^{
                                                     _userImage.alpha = 1.0f;
                                                 } completion:^(BOOL finished) {
                                                 }];
                             }];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

            [[AppManager sharedInstance] getUserFromServer:_user.userID WithSuccessBlock:^(UserItem *user) {
                _user = user;
                dispatch_async(dispatch_get_main_queue(), ^{
                    _userName.text = [NSString stringWithFormat:@"%@ %@",_user.firstName, _user.lastName];
                    _userDescriptionTextView.text = _user.descr;
                    [_offersCollectionView reloadData];
                    [_offersCollectionView layoutIfNeeded];
                    [MBProgressHUD hideHUDForView:_offersCollectionView animated:YES];
                });
            } andFailureBlock:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:_offersCollectionView animated:YES];
                    [self throughError:error];
                });
            }];
        });
    } else {

        _user = [AppManager sharedInstance].authorizedUser;
        _userName.text = [NSString stringWithFormat:@"%@ %@",_user.firstName, _user.lastName];
        _userDescriptionTextView.text = _user.descr;

        [_userImage sd_setImageWithURL:[NSURL URLWithString:_user.photoUrl]
                      placeholderImage:[UIImage imageNamed:@"userImagePlaceholder"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [UIView transitionWithView:_userImage
                                                   duration:0.5f
                                                    options:UIViewAnimationOptionLayoutSubviews
                                                 animations:^{
                                                     _userImage.alpha = 1.0f;
                                                 } completion:^(BOOL finished) {
                                                 }];
                             }];


    }

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated  {
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initCustomNavigationItems {

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    UIButton* rightNotifyButton = [[UIButton alloc] init];
    UIImage *rightNotifyImage = [[UIImage imageNamed:@"navigationItemMore"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightNotifyButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightNotifyButton setImage:rightNotifyImage forState:UIControlStateNormal];
    [rightNotifyButton addTarget:self
                          action:@selector(alertButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightNotifyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNotifyButton];
    NSArray* rightBarItems = [[NSArray alloc] initWithObjects:rightNotifyBarButtonItem, nil];
    self.navigationItem.rightBarButtonItems = rightBarItems;


    if (!_user) {

        NSString* titleText = [AppManager sharedInstance].authorizedUser.firstName;
        UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
        CGSize requestedTitleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
        CGFloat titleWidth = MIN(100, requestedTitleSize.width);

        UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, requestedTitleSize.height)];
        navLabel.backgroundColor = [UIColor whiteColor];
        navLabel.textColor = [UIColor appRedColor];
        navLabel.font = titleFont;
        navLabel.textAlignment = NSTextAlignmentCenter;
        navLabel.text = titleText;
        self.navigationItem.titleView = navLabel;

        UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

        UIImage *image = [[UIImage imageNamed:@"leftMenuItemImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
        [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
        [leftBarButtonWithLogo addTarget:self.viewDeckController
                                  action:@selector(toggleLeftView)
                        forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
        NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
        
        self.navigationItem.leftBarButtonItems = leftBarItems;


    } else {

        NSString* titleText = _user.firstName;
        UIFont* titleFont = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
        CGSize requestedTitleSize = [titleText sizeWithAttributes:@{NSFontAttributeName: titleFont}];
        CGFloat titleWidth = MIN(100, requestedTitleSize.width);

        UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleWidth, requestedTitleSize.height)];
        navLabel.backgroundColor = [UIColor whiteColor];
        navLabel.textColor = [UIColor appRedColor];
        navLabel.font = titleFont;
        navLabel.textAlignment = NSTextAlignmentCenter;
        navLabel.text = titleText;
        self.navigationItem.titleView = navLabel;

        UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

        UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
        [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
        [leftBarButtonWithLogo addTarget:self
                                  action:@selector(backButtonPressed:)
                        forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
        NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];

        self.navigationItem.leftBarButtonItems = leftBarItems;

    }
}

#pragma mark - offersCollectionView Delegate & dataSource & lifeCycle

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {


    if (_user) {
        return [_user.offers count];
    } else  {
        return [[AppManager sharedInstance].authorizedUser.offers count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    OfferCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserOfferLightCellID
                                                                              forIndexPath:indexPath];

    if (_user) {
        cell.item = [_user.offers objectAtIndex:indexPath.row];

    } else {
        cell.item = [[AppManager sharedInstance].authorizedUser.offers objectAtIndex:indexPath.row];
    }

    cell.brandLabel.text = cell.item.brandName;
    cell.titleLabel.text = cell.item.name;

    cell.priceView.layer.cornerRadius = 4.0f;
    cell.priceView.layer.masksToBounds = YES;
    cell.priceView.backgroundColor = [UIColor appRedColor];

    cell.cellView.alpha = 0.0f;
    cell.priceLabel.text = [self printPriceWithCurrencySymbol: cell.item.price];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[cell.item.photoUrls objectAtIndex:0]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [UIView transitionWithView:cell.cellView
                                                   duration:0.5f
                                                    options:UIViewAnimationOptionLayoutSubviews
                                                 animations:^{
                                                     cell.cellView.alpha = 1.0f;
                                                 } completion:^(BOOL finished) {
                                                 }];
                             }];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    OfferCollectionViewCell* cell = (OfferCollectionViewCell*)[_offersCollectionView cellForItemAtIndexPath:indexPath];

    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    OfferVC* vc = [sb instantiateViewControllerWithIdentifier:@"OfferVC"];

//    vc.categoriesWithOffersvc = self.categoriesWithOffersvc;

    vc.offerItem = cell.item;

    [self.navigationController pushViewController:vc animated:YES];

}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    float  width = 145.0f;
    float  height = 200.0f;

    return CGSizeMake(width, height);
}

#pragma mark Navigation

- (IBAction)backButtonPressed:(id)sender {

    NSInteger controllerCount = [[self.navigationController viewControllers] count];

    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:controllerCount - 2]
                                          animated:YES];
}




@end
