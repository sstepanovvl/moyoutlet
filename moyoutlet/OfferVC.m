//
//  OfferVC.m
//  AppManager
//
//  Created by Stepan Stepanov on 01.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "OfferVC.h"
#import "ProfileVC.h"

@interface OfferVC ()
@property (assign,nonatomic) NSUInteger currentPhotoIndex;
@property (assign, nonatomic) NSUInteger photosAmount;
@property (strong, nonatomic) IBOutlet UILabel *sellerFullName;
@property (strong, nonatomic) IBOutlet UILabel *sellerPoints;
@property (strong, nonatomic) IBOutlet UILabel *sellerSubscribers;
@property (strong, nonatomic) IBOutlet UIImageView *sellerImage;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *viewWithCategoryButtonsHeight;
@property (strong, nonatomic) IBOutlet UIView *viewWithCategoryButtons;

@end

@implementation OfferVC
@synthesize currentPhotoIndex = _currentPhotoIndex;
@synthesize photosAmount = _photosAmount;

float horizontal_size;


NSString *kOfferLightCellID = @"OfferLightCollectionViewCell";
NSString *kPhotoCellID = @"PhotoCell";


#pragma mark lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0],
                              NSForegroundColorAttributeName :  [UIColor appRedColor]}];

    UIButton* rightSearchButton = [[UIButton alloc] init];
    UIImage *rightSearchImage = [[UIImage imageNamed:@"rightMenuItemSearch"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightSearchButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightSearchButton setImage:rightSearchImage forState:UIControlStateNormal];
    [rightSearchButton addTarget:self
                          action:@selector(searchButtonPressed:)
                forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightSearchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightSearchButton];

    UIButton* rightNotifyButton = [[UIButton alloc] init];
    UIImage *rightNotifyImage = [[UIImage imageNamed:@"rightMenuItemShare"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightNotifyButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightNotifyButton setImage:rightNotifyImage forState:UIControlStateNormal];
    [rightNotifyButton addTarget:self
                          action:@selector(shareButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightNotifyBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightNotifyButton];
    NSArray* rightBarItems = [[NSArray alloc] initWithObjects:rightNotifyBarButtonItem,rightSearchBarButtonItem, nil];
    self.navigationItem.rightBarButtonItems = rightBarItems;

    self.navigationItem.title = _offerItem.name;

    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;

    [self initPhotoView];

    _descriptionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];

    _sizeView.backgroundColor = [UIColor whiteColor];

    _detailsHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    _detailsView.backgroundColor = [UIColor whiteColor];


    _footerBuyButton.layer.cornerRadius = 3.0f;
    _footerBuyButton.layer.masksToBounds = YES;

    _photoCollectionView.layer.cornerRadius = 5.0f;
    _photoCollectionView.layer.masksToBounds = YES;

    _sellerHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    _sellerDetailView.backgroundColor = [UIColor whiteColor];
    _sellerFullName.text = [NSString stringWithFormat:@"%@ %@",_offerItem.seller.firstName, _offerItem.seller.lastName];

    _sellerImage.layer.borderWidth = 2.0f;
    _sellerImage.layer.cornerRadius = 30.0f;
    _sellerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _sellerImage.clipsToBounds = YES;


    [_sellerImage sd_setImageWithURL:[NSURL URLWithString:_offerItem.seller.photoUrl]
                                                  placeholderImage:[UIImage imageNamed:@"userImagePlaceholder"]
                                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                             [UIView transitionWithView:_sellerImage
                                                                               duration:0.5f
                                                                                options:UIViewAnimationOptionLayoutSubviews
                                                                             animations:^{
                                                                                 _sellerImage.alpha = 1.0f;
                                                                             } completion:^(BOOL finished) {
                                                                             }];
                                                         }];





    _commentsHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];

    _footerPriceLabel.text = [self printPriceWithCurrencySymbol: _offerItem.price];

    _likeCountsButton.titleLabel.text = [NSString stringWithFormat:@"Понравилось: %@", _offerItem.likesCount];

    _offerSize.text = [NSString stringWithFormat:@"Размер: %@",_offerItem.size];
    _offerTitle.text = [NSString stringWithFormat:@"%@ %@",_offerItem.brandName,_offerItem.name];
    _offerTitle1.text = [NSString stringWithFormat:@"%@",_offerItem.itemDescription];
    _offerSize1.text = [NSString stringWithFormat:@"%@",_offerItem.size];

    _offerShipping.text = [NSString stringWithFormat:@"%@ from %@",_offerItem.shipping, _offerItem.senderCity];
    _offerCondition.text = [NSString stringWithFormat:@"%@",_offerItem.condition];
    _offerCreatonDate.text = [NSString stringWithFormat:@"%@",_offerItem.created];

    [_offersCollectionView registerNib:[UINib nibWithNibName:@"OfferLightCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kOfferLightCellID];
    [self initCategoryButtons];

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _viewWithCategoryButtonsHeight.constant = horizontal_size;
    [self updateViewConstraints];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithOfferItem:(OfferItem*)item {

    if (self = [super init]) {
        self.offerItem = item;
    }

    return self;
}


-(void)initCategoryButtons {
    int indexOfLeftmostButtonOnCurrentLine = 0;
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    float runningWidth = 0.0f;
    float maxWidth = _viewWithCategoryButtons.frame.size.width;
    float horizontalSpaceBetweenButtons = 10.0f;
    float verticalSpaceBetweenButtons = 10.0f;
    horizontal_size = 50.0f;


    for (int i=0; i<_offerItem.categories.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        int category_id = [[_offerItem.categories objectAtIndex:i] intValue];

        NSString* categoryTitle = [[NSString alloc] init];

        for (NSDictionary* category in [AppManager sharedInstance].categories) {
            if ([[category valueForKey:@"id"] intValue] == category_id) {
                categoryTitle = [category valueForKey:@"name"];
            }
        }

        [button setTitle:categoryTitle forState:UIControlStateNormal];

        UIFont* font = [UIFont fontWithName:@"OpenSans"
                                       size:13];


        NSDictionary * linkAttributes = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                          NSFontAttributeName: font,
                                          NSForegroundColorAttributeName: [UIColor blueColor]
                                          };

        button.tintColor = [UIColor blackColor];

        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:button.titleLabel.text
                                                                               attributes:linkAttributes];
        [button.titleLabel setAttributedText:attributedString];

        [button sizeToFit];

        [button  setImage:[UIImage imageNamed:@"arrow"] forState:(UIControlStateNormal)];


        button.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        button.translatesAutoresizingMaskIntoConstraints = NO;

        [_viewWithCategoryButtons addSubview:button];

        // check if first button or button would exceed maxWidth
        if ((i == 0) || (runningWidth + button.frame.size.width > maxWidth)) {
            // wrap around into next line
            runningWidth = button.frame.size.width;

            if (i== 0) {
                // first button (top left)
                // horizontal position: same as previous leftmost button (on line above)
                NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_viewWithCategoryButtons attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
                [_viewWithCategoryButtons addConstraint:horizontalConstraint];

                // vertical position:
                NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_viewWithCategoryButtons attribute:NSLayoutAttributeTop              multiplier:1.0f constant:verticalSpaceBetweenButtons];
                [_viewWithCategoryButtons addConstraint:verticalConstraint];


            } else {
                // put it in new line
                UIButton *previousLeftmostButton = [buttons objectAtIndex:indexOfLeftmostButtonOnCurrentLine];

                // horizontal position: same as previous leftmost button (on line above)
                NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
                [_viewWithCategoryButtons addConstraint:horizontalConstraint];

                // vertical position:
                NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousLeftmostButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:verticalSpaceBetweenButtons];
                [_viewWithCategoryButtons addConstraint:verticalConstraint];

                indexOfLeftmostButtonOnCurrentLine = i;
                horizontal_size += button.frame.size.height + verticalSpaceBetweenButtons;

            }
        } else {
            // put it right from previous buttom
            runningWidth += button.frame.size.width;

            UIButton *previousButton = [buttons objectAtIndex:(i-1)];


//            UIImageView* rightArrow = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"arrow"]];
//            rightArrow.backgroundColor = [UIColor redColor];
//
//            CGRect frame = rightArrow.frame;
//            frame.origin.x = previousButton.frame.size.width;
//            frame.origin.y = previousButton.frame.origin.y;
//            rightArrow.frame = frame;
//
//            [_viewWithCategoryButtons addSubview:rightArrow];

//            NSLayoutConstraint* leftToPreviousButton = [NSLayoutConstraint constraintWithItem:rightArrow attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:horizontalSpaceBetweenButtons];
//
//            [_viewWithCategoryButtons addConstraint:leftToPreviousButton];
//
//            NSLayoutConstraint* centerToPreviousButton = [NSLayoutConstraint constraintWithItem:rightArrow attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
//
//            [_viewWithCategoryButtons addConstraint:centerToPreviousButton];
//
//
//            NSLayoutConstraint *ImageVerticalConstraint = [NSLayoutConstraint constraintWithItem:rightArrow attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
//            [_viewWithCategoryButtons addConstraint:ImageVerticalConstraint];



            // horizontal position: right from previous button
            NSLayoutConstraint *horizontalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:horizontalSpaceBetweenButtons];
            [_viewWithCategoryButtons addConstraint:horizontalConstraint];

            // vertical position same as previous button
            NSLayoutConstraint *verticalConstraint = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f];
            [_viewWithCategoryButtons addConstraint:verticalConstraint];
        }
        
        [buttons addObject:button];
    }
}
#pragma mark IBActions

- (IBAction)commentsButtonPressed:(id)sender {

    baseError* err = [[baseError alloc]init];
    err.customHeader= @"Комментарии";
    err.customError = @"Здесь появится экран с комментариями";
    [self throughError:err];

}

- (IBAction)likesButtonPressed:(id)sender {

    baseError* err = [[baseError alloc]init];
    err.customHeader= @"Понравилось";
    err.customError = @"+1 к лайкам";
    [self throughError:err];

}


- (IBAction)addToFavoriteButtonPressed:(id)sender {

    baseError* err = [[baseError alloc]init];
    err.customHeader= @"Избранное";
    err.customError = @"Товар попадает в \"Избранное\"";
    [self throughError:err];

}

- (IBAction)footerBuyButtonPressed:(id)sender {

    baseError* err = [[baseError alloc]init];
    err.customHeader= @"Купить";
    err.customError = @"Здесь появится экран с оформлением покупки";
    [self throughError:err];
    
}

- (IBAction)warrantyDetailsButtonPressed:(id)sender {

    baseError* err = [[baseError alloc]init];
    err.customHeader= @"Гарантии продовца";
    err.customError = @"Здесь появится экран с текстом гарантий продавца";
    [self throughError:err];

}

- (IBAction)sellerDetailButtonPressed:(id)sender {

    ProfileVC* pvc = [[ProfileVC alloc] initWithNibName:@"ProfileVC" bundle:nil];
//    NSLog(@"%lu",(unsigned long)_offerItem.seller.userID);

    pvc.user = _offerItem.seller;
    pvc.categoriesWithOffersvc = self.categoriesWithOffersvc;

    [self.navigationController pushViewController:pvc animated:YES];
    
}

-(void)initPhotoView {

    _currentPhotoIndex = 0;

    _photosAmount = [_offerItem.photoUrls count];

}

-(IBAction)nextPhoto:(id)sender {

    if (_currentPhotoIndex + 1 < _photosAmount) {
        _currentPhotoIndex++;
        NSIndexPath* nextPhoto = [NSIndexPath indexPathForItem:_currentPhotoIndex inSection:0];
        [_photoCollectionView scrollToItemAtIndexPath:nextPhoto atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }

}

-(IBAction)previousPhoto:(id)sender {

    if (_currentPhotoIndex) {
        _currentPhotoIndex--;
        NSIndexPath* nextPhoto = [NSIndexPath indexPathForItem:_currentPhotoIndex inSection:0];
        [_photoCollectionView scrollToItemAtIndexPath:nextPhoto atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}



#pragma mark - offersCollectionView Delegate & dataSource & lifeCycle

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView.tag == 1) {
        return 5;
    } else  {

        return [[_offerItem photoUrls] count];

    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    if (collectionView.tag == 1) {

        OfferCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kOfferLightCellID
                                                                                  forIndexPath:indexPath];

        cell.item = self.offerItem;

        cell.brandLabel.text = cell.item.brandName;
        cell.titleLabel.text = cell.item.name;

        cell.priceView.layer.cornerRadius = 4.0f;
        cell.priceView.layer.masksToBounds = YES;
        cell.priceView.backgroundColor = [UIColor appRedColor];

        cell.cellView.layer.borderColor = [[UIColor appLightGrayColor] CGColor];
        cell.cellView.layer.borderWidth = 0.5f;
        cell.cellView.layer.masksToBounds = YES;

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

    } else {

        PhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCellID
                                                                                  forIndexPath:indexPath];

        CGRect frame = cell.frame;
        frame.size.width = collectionView.frame.size.width;
        frame.size.height = collectionView.frame.size.height;
        cell.photoImageView.alpha = 0.0f;

        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[_offerItem.photoUrls objectAtIndex:indexPath.row]]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     [UIView transitionWithView:cell.photoImageView
                                                       duration:0.5f
                                                        options:UIViewAnimationOptionLayoutSubviews
                                                     animations:^{
                                                         cell.photoImageView.alpha = 1.0f;
                                                     } completion:^(BOOL finished) {
                                                     }];
                                 }];

//        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:[_offerItem.photoUrls  objectAtIndex:indexPath.row]]
//                               placeholderImage:placeHolderImage];

        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


    if (collectionView.tag == 1)  {

        OfferCollectionViewCell* cell = (OfferCollectionViewCell*)[self.offersCollectionView cellForItemAtIndexPath:indexPath];

        UIStoryboard* sb = self.storyboard;

        OfferVC* vc = [sb instantiateViewControllerWithIdentifier:@"OfferVC"];

        vc.categoriesWithOffersvc = self.categoriesWithOffersvc;

        vc.offerItem = cell.item;

        [self.navigationController pushViewController:vc animated:YES];

    } else  {

        PhotoCollectionViewCell* photoCell = (PhotoCollectionViewCell*)[_photoCollectionView cellForItemAtIndexPath:indexPath];

        [EXPhotoViewer showImageFrom:photoCell.photoImageView];

    }
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    float width = 0;
    float height = 0;

    if (collectionView.tag == 0) {

        width = collectionView.bounds.size.width;

        height = collectionView.bounds.size.height;

    } else if (collectionView.tag == 1) {

        width = 145.0f;
        height = 200.0f;

    }

    return CGSizeMake(width, height);

}




#pragma mark Navigation

//- (IBAction)backButtonPressed:(id)sender {
//
//    NSInteger controllerCount = [[self.navigationController viewControllers] count];
//    NSArray* ar  = [self.navigationController viewControllers];
//    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:controllerCount - 2]
//                                          animated:YES];
//
//}

@end
