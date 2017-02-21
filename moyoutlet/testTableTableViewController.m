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


@end

@implementation testTableTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    for (UISwitch* sw in _cellSwitches) {
        sw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    _descriptionTextView.delegate = self;
    _titleTextField.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initFields];
}
-(void)initFields {
    OfferItem* editableItem = [AppManager sharedInstance].offerToEdit;
        if (editableItem.category_id) {
            NSDictionary* dic = [AppHelper searchInDictionaries:[AppManager sharedInstance].config.categories Value:editableItem.category_id forKey:@"id"];
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
    [AppManager sharedInstance].offerToEdit.itemDescription = _titleTextField.text;
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
    if (indexPath.section == 0 && indexPath.row == 1) {
        NSLog(@"section %ld",indexPath.section);
        NSLog(@"row %ld",indexPath.row);
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[_descriptionTextView font] forKey:NSFontAttributeName];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_descriptionTextView.text attributes:attrsDictionary];
        return [self textViewHeightForAttributedText:attrString andWidth:CGRectGetWidth(self.tableView.bounds)-31]+20;
    } else {
    return UITableViewAutomaticDimension;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HeaderView* headerCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    headerCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    headerCell.contentView.contentMode = UIViewContentModeCenter;
//    [headerCell.headerTitle setText:@"123"];
    [headerCell setNeedsLayout];
    [headerCell layoutIfNeeded];
    return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIImage *myImage = [UIImage imageNamed:@"backgroundImage"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
//    imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, );
//    return imageView;
//}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"setValue: %@ forUndefinedKey:%@",value,key);
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
            [cell.imageView setImage:[[AppManager sharedInstance].offerToEdit.arrImages objectAtIndex:0]];
            break;
        default:
            [cell.imageView setImage:[UIImage imageNamed:@"photoPlaceholder"]];
            break;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSString* tmp = [[AppManager sharedInstance].offerToEdit.photoUrls objectAtIndex:sourceIndexPath.item];
    
    [[AppManager sharedInstance].offerToEdit.photoUrls removeObjectAtIndex:sourceIndexPath.item];
    
    [[AppManager sharedInstance].offerToEdit.photoUrls insertObject:tmp atIndex:destinationIndexPath.item];
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    FusumaViewController* fsvc = [[FusumaViewController alloc]init];
    
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
