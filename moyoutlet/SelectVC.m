//
//  SelectVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 14.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "SelectVC.h"


static NSString* kCellIdentifier = @"SearchCell";

@interface SelectVC ()
@property (weak, nonatomic) IBOutlet UITableView *resultTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeader;
@property (strong, nonatomic) NSMutableArray* itemsToDisplay;
@property (strong, nonatomic) NSOperation* currentOperation;
@property (strong, nonatomic) NSArray* sectionsArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeighConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBarHeightConstaraint;
@property (weak, nonatomic) IBOutlet UIImageView *tableViewHeaderImage;
@end


@implementation SelectVC

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_resultTable registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [_resultTable registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    _resultTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _resultTable.sectionIndexBackgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noItemRowSelected:)];
    
    [self.tableViewHeader addGestureRecognizer:tapGesture];

    self.itemsToDisplay = [NSMutableArray new];
    self.navigationController.navigationBar.hidden = YES;
    if (self.searchType == CATEGORY) {
        [self initNavigationItems];
        NSArray* ar = [AppManager sharedInstance].config.categories;
        ar = [[ar filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(parent_id == %@)",[[NSNumber numberWithInteger:_parent_id] stringValue]]] mutableCopy];
        
        if (_parent_id != 0) {
            [self.itemsToDisplay addObject:@{@"id":[NSNumber numberWithInteger:_parent_id],
                                             @"name":@"Все",
                                             @"parent_id":@"-1"}];
        }
        _headerViewHeighConstraint.constant = 0;
        _searchBarHeightConstaraint.constant = 0;
        self.tableViewHeaderImage.hidden = true;
        [self.itemsToDisplay addObjectsFromArray:ar];
        [self initNavigationItems];
    } else if (self.searchType == BRAND) {
        self.itemsToDisplay =[[AppManager sharedInstance].config brands];
        [self generateSectionsInBackgroundFromArray:self.itemsToDisplay withFilter:self.searchBar.text];
    } else if (self.searchType == SIZES) {
        self.itemsToDisplay =[[AppManager sharedInstance].config sizes];
        _headerViewHeighConstraint.constant = 0;
        _searchBarHeightConstaraint.constant = 0;
        self.tableViewHeaderImage.hidden = true;
        _resultTable.rowHeight = UITableViewAutomaticDimension;
        _resultTable.estimatedRowHeight = 44.0f;
    } else if (self.searchType == CITIES) {
        self.itemsToDisplay =[[AppManager sharedInstance].config cities];
        _headerViewHeighConstraint.constant = 0;
        _resultTable.rowHeight = UITableViewAutomaticDimension;
        _resultTable.estimatedRowHeight = 44.0f;
        self.tableViewHeaderImage.hidden = true;
        [self generateSectionsInBackgroundFromArray:self.itemsToDisplay withFilter:self.searchBar.text];
    } else if (self.searchType == CONDITIONS) {
        self.itemsToDisplay =[[AppManager sharedInstance].config conditions];
        _headerViewHeighConstraint.constant = 0;
        _searchBarHeightConstaraint.constant = 0;
        self.tableViewHeaderImage.hidden = true;
        _resultTable.rowHeight = UITableViewAutomaticDimension;
        _resultTable.estimatedRowHeight = 44.0f;
    } else if (self.searchType == WEIGHTS) {
        self.itemsToDisplay =[[AppManager sharedInstance].config weights];
        _headerViewHeighConstraint.constant = 0;
        _searchBarHeightConstaraint.constant = 0;
        self.tableViewHeaderImage.hidden = true;
        _resultTable.rowHeight = UITableViewAutomaticDimension;
        _resultTable.estimatedRowHeight = 44.0f;
    } else if (self.searchType == WILLSENDIN) {
        self.itemsToDisplay =[[AppManager sharedInstance].config willSendInFields];
        _headerViewHeighConstraint.constant = 0;
        _searchBarHeightConstaraint.constant = 0;
        self.tableViewHeaderImage.hidden = true;
    }
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    
    _searchBar.placeholder = @"Поиск в MoyOutlet";
    
    [[UISearchBar appearance] setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [self.view addSubview:_searchBar];
    
    self.definesPresentationContext = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) generateSectionsInBackgroundFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    
    if (debug_enabled) {
        NSLog(@"Filter string %@",filterString);
    }
    
    [self.currentOperation cancel];
    
    __weak SelectVC* weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray* sectionsArray = [weakSelf generateSectionsFromArray:array withFilter:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sectionsArray = sectionsArray;
            [weakSelf.resultTable reloadData];
            
            self.currentOperation = nil;
        });
    }];
    
    [self.currentOperation start];
}

- (NSArray*) generateSectionsFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    
    NSMutableArray* sectionsArray = [NSMutableArray array];
    
    NSString* currentLetter = nil;
    
    for (NSDictionary* dict in array ) {
        NSString* string = nil;
        
        string = [dict objectForKey:@"name"];
        
        if ([filterString length] > 0 && [string rangeOfString:filterString options:NSCaseInsensitiveSearch].location == NSNotFound) {
            continue;
        }
        
        NSString* firstLetter = [string substringToIndex:1];
        
        HeaderView* section = nil;
        if (![[currentLetter uppercaseString] isEqualToString:[firstLetter uppercaseString]] ) {
            if (debug_enabled){
                NSLog(@"%@",[currentLetter uppercaseString]);
                NSLog(@"%@",[firstLetter uppercaseString]);
            }
            section = [[HeaderView alloc] init];
            section.name = firstLetter;
            section.childItems = [NSMutableArray array];
            currentLetter = firstLetter;
            [sectionsArray addObject:section];
        } else {
            section = [sectionsArray lastObject];
        }
        
        [section.childItems addObject:dict];
    }
    return sectionsArray;
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



-(void)initNavigationItems {
    [super initNavigationItems];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor appRedColor]}];
    
    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];
    
    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    
    self.navigationItem.leftBarButtonItems = leftBarItems;
    
    if (self.searchType == BRAND) {
        self.navigationItem.title = @"Бренд";
    } else if (self.searchType == CITIES) {
        self.navigationItem.title = @"Город";
    } else if (self.searchType == CONDITIONS) {
        self.navigationItem.title = @"Состояние";
    } else if (self.searchType == WILLSENDIN) {
        self.navigationItem.title = @"Сроки отправки";
    } else if (self.searchType == SIZES) {
        self.navigationItem.title = @"Размеры";
    } else if (self.searchType == WEIGHTS ) {
        self.navigationItem.title = @"Примерный вес";
    }
}


#pragma mark UITableViewDelegate & UITableViewDataSource & noBrandSelector

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray* array = [NSMutableArray array];
    
    if ([self.sectionsArray count] > 1) {
        for (HeaderView* section in self.sectionsArray) {
            [array addObject:section.name];
        }
        return array;
    } else {
        return nil;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_searchType == CATEGORY || _searchType == CONDITIONS || _searchType == WILLSENDIN || _searchType == SIZES || _searchType == WEIGHTS) {
        return 1;
    } else {
        return [self.sectionsArray count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_searchType == CATEGORY || _searchType == CONDITIONS || _searchType == WILLSENDIN || _searchType == SIZES || _searchType == WEIGHTS ) {
        if (![_itemsToDisplay count]) {
            return 0;
        } else {
            return [_itemsToDisplay count];
        }
    } else {
        return [[[self.sectionsArray objectAtIndex:section] childItems] count];
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HeaderView* headerCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    headerCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    
    [headerCell.headerTitle setText:[[self.sectionsArray objectAtIndex:section] name]];
    [headerCell setNeedsLayout];
    [headerCell layoutIfNeeded];
    return headerCell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchType == CATEGORY) {
        return nil;
    } else {
        return [NSString stringWithFormat:@" "];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        NSLog(@"Init Cell");
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selectButtonConstraint.constant = 0.f;
    cell.selectButtonTrailingConstraint.constant = 0.f;

    SearchItem* searchItem = [[SearchItem alloc] init];
    NSDictionary* item = nil;
    
    if (self.searchType == CATEGORY) {
        item = [self.itemsToDisplay objectAtIndex:indexPath.row];
        searchItem.item_id = [item objectForKey:@"id"];
        searchItem.text = [item objectForKey:@"name"];
        searchItem.parent_id = [item valueForKey:@"parent_id"];
        
        if ([item objectForKey:@"description"] != nil) {
            searchItem.itemDescription = [item objectForKey:@"description"];
            cell.descriptionLabel.hidden = false;
        }
        
        if ([[AppManager sharedInstance] checkChildItemsInCategory:[item objectForKey:@"id"]] && [searchItem.item_id intValue]){
            searchItem.hasChild = YES;
//            cell.delegate = self;
        }
        
        cell.searchItem = searchItem;
        
        if ([AppManager sharedInstance].offerToEdit.category_id == cell.searchItem.item_id) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selected = YES;
        }
    } else if (self.searchType == BRAND) {
        item = [[[self.sectionsArray objectAtIndex:indexPath.section] childItems] objectAtIndex:indexPath.row];
        searchItem.item_id = [item objectForKey:@"id"];
        searchItem.text = [item objectForKey:@"name"];
        if ([item objectForKey:@"description"] != nil) {
            searchItem.itemDescription = [item objectForKey:@"description"];
            cell.descriptionLabel.hidden = false;
        }
        cell.searchItem = searchItem;
        if ([AppManager sharedInstance].offerToEdit.brand_id == cell.searchItem.item_id) {
                [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selected = YES;
        }
    } else if (self.searchType == CITIES) {
        item = [[[self.sectionsArray objectAtIndex:indexPath.section] childItems] objectAtIndex:indexPath.row];
        searchItem.item_id = [item objectForKey:@"id"];
        searchItem.text = [item objectForKey:@"name"];
        if ([item objectForKey:@"description"] != nil) {
            searchItem.itemDescription = [item objectForKey:@"description"];
            cell.descriptionLabel.hidden = false;
        }
        cell.searchItem = searchItem;
        if ([AppManager sharedInstance].offerToEdit.senderCity_id == cell.searchItem.item_id) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selected = YES;
        }
    } else if (self.searchType == WEIGHTS) {
        item = [self.itemsToDisplay objectAtIndex:indexPath.row];
        searchItem.item_id = [item objectForKey:@"id"];
        searchItem.text = [item objectForKey:@"name"];
        if ([item objectForKey:@"description"] != nil) {
            searchItem.itemDescription = [item objectForKey:@"description"];
            cell.descriptionLabel.hidden = false;
        }
        cell.searchItem = searchItem;
        if ([AppManager sharedInstance].offerToEdit.weight_id == cell.searchItem.item_id) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selected = YES;
        }
    } else if (self.searchType == SIZES) {
        item = [self.itemsToDisplay objectAtIndex:indexPath.row];
        searchItem.item_id = [item objectForKey:@"id"];
        searchItem.text = [item objectForKey:@"name"];
        if ([item objectForKey:@"description"] != nil) {
            searchItem.itemDescription = [item objectForKey:@"description"];
            cell.descriptionLabel.hidden = false;
        }
        cell.searchItem = searchItem;
        if ([AppManager sharedInstance].offerToEdit.size_id == cell.searchItem.item_id) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selected = YES;
        }
    } else if (self.searchType == CONDITIONS) {
        item = [self.itemsToDisplay objectAtIndex:indexPath.row];
        searchItem.item_id = [item objectForKey:@"id"];
        searchItem.text = [item objectForKey:@"name"];
        if ([item objectForKey:@"description"] != nil) {
            searchItem.itemDescription = [item objectForKey:@"description"];
            cell.descriptionLabel.hidden = false;
        }
        cell.searchItem = searchItem;
        if ([AppManager sharedInstance].offerToEdit.condition_id == cell.searchItem.item_id) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selected = YES;
        }
        cell.descriptionLabel.hidden = NO;
    } else if (self.searchType == WILLSENDIN) {
        item = [self.itemsToDisplay objectAtIndex:indexPath.row];
        searchItem.item_id = [item objectForKey:@"id"];
        searchItem.text = [item objectForKey:@"name"];
        if ([item objectForKey:@"description"] != nil) {
            searchItem.itemDescription = [item objectForKey:@"description"];
            cell.descriptionLabel.hidden = false;
        }
        cell.searchItem = searchItem;
        if ([AppManager sharedInstance].offerToEdit.willSendIn_id == cell.searchItem.item_id) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.selected = YES;
        }
        
        cell.descriptionLabel.hidden = NO;
    }
    
    cell.selectedButton.hidden = NO;
    
    if (!cell.selected) {
        cell.selectedButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } else {
        cell.selectedButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    }
    
    return cell;
}

#pragma SearcChellDelegate

-(IBAction)noItemRowSelected:(UITapGestureRecognizer*)gesture {
    if (debug_enabled) {
        NSLog(@"noItemRowSelected now its %lu and %lu items in selectedItems",[[_resultTable indexPathsForSelectedRows] count],[[AppManager sharedInstance].selectedBrands count]);

    }
    for (NSIndexPath *indexPath in [self.resultTable indexPathsForSelectedRows]) {
        SearchCell* cell = [_resultTable cellForRowAtIndexPath:indexPath];
        [_resultTable deselectRowAtIndexPath:indexPath animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:0
                             animations:^{
                                 cell.selectedButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 cell.selectedButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
                             } completion:^(BOOL finished) {
                             }];
        });
    }
    
    [[AppManager sharedInstance].selectedBrands removeAllObjects];
    SearchItem* noBrandItem = [[SearchItem alloc] init];
    noBrandItem.text = @"Без бренда";
    noBrandItem.item_id = 0;
    noBrandItem.parent_id = 0;
    [[AppManager sharedInstance].selectedBrands addObject:noBrandItem];
    if (debug_enabled) {
        NSLog(@"noItemRowSelected now its %lu and %lu items in selectedItems",[[_resultTable indexPathsForSelectedRows] count],[[AppManager sharedInstance].selectedBrands count]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                              delay:0
                            options:0
                         animations:^{
                             self.tableViewHeaderImage.hidden = false;
                             self.tableViewHeaderImage.transform = CGAffineTransformMakeScale(1.5, 1.5);
                             self.tableViewHeaderImage.transform = CGAffineTransformMakeScale(1, 1);
                         } completion:^(BOOL finished) {
                             
                         }];
    });
}

-(void)deselectNoBrandRow {
    if (self.tableViewHeaderImage.hidden == NO ){
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:0
                             animations:^{
                                 self.tableViewHeaderImage.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 self.tableViewHeaderImage.transform = CGAffineTransformMakeScale(0.001, 0.001);
                             } completion:^(BOOL finished) {
                                 self.tableViewHeaderImage.hidden = YES;
                             }];
        });
    }
}

//-(void)delegateForCell:(SearchCell *)cell showSubItems:(BOOL)showSubItems {
//    NSIndexPath* indexPath = [self.resultTable indexPathForCell:cell];
//    if (cell.selected) {
//        [self.resultTable deselectRowAtIndexPath:indexPath animated:NO];
//    }
////    SelectVC* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectVC"];
////    vc.searchType = CATEGORY;
////    vc.parent_id = [cell.searchItem.item_id integerValue];
////    [self.navigationController pushViewController:vc animated:YES];
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                              delay:0
                            options:0
                         animations:^{
                             if (self.searchType != CATEGORY || cell.searchItem.hasChild != 1) {
                                 cell.selectedButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 cell.selectedButton.transform = CGAffineTransformMakeScale(1, 1);
                             }
                         } completion:^(BOOL finished) {
                             if (self.searchType == CATEGORY) {
                                 if (cell.searchItem.hasChild) {
                                     SelectVC* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectVC"];
                                     vc.searchType = CATEGORY;
                                     vc.parent_id = [cell.searchItem.item_id integerValue];
                                     [self.navigationController pushViewController:vc animated:YES];
                                     return;
                                 } else {
                                     [AppManager sharedInstance].offerToEdit.category_id = cell.searchItem.item_id;
                                 }
                             } else if (self.searchType == BRAND) {
                                 [AppManager sharedInstance].offerToEdit.brand_id = cell.searchItem.item_id;
                                 [self deselectNoBrandRow];
                             } else if (self.searchType == CITIES) {
                                 [AppManager sharedInstance].offerToEdit.senderCity_id = cell.searchItem.item_id;
                             } else if (self.searchType == CONDITIONS) {
                                 [AppManager sharedInstance].offerToEdit.condition_id = cell.searchItem.item_id;
                             } else if (self.searchType == WILLSENDIN) {
                                 [AppManager sharedInstance].offerToEdit.willSendIn_id = cell.searchItem.item_id;
                             } else if (self.searchType == SIZES) {
                                 [AppManager sharedInstance].offerToEdit.size_id = cell.searchItem.item_id;
                             } else if (self.searchType == WEIGHTS) {
                                 [AppManager sharedInstance].offerToEdit.weight_id = cell.searchItem.item_id;
                             }
                             [self updateOkButton];
                             [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                 
                             }];
                         }];
    });
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (debug_enabled) {
        NSLog(@"didDeSelectRowAtIndexPath now its %lu ",[[_resultTable indexPathsForSelectedRows] count]);
    }
    
    SearchCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.searchType == BRAND) {
        [[AppManager sharedInstance].selectedBrands removeObject:cell.searchItem];
    } else if (self.searchType == CITIES) {
        [[AppManager sharedInstance].selectedCities removeObject:cell.searchItem];
    } else if (self.searchType == CONDITIONS) {
        [[AppManager sharedInstance].selectedConditions removeObject:cell.searchItem];
    } else if (self.searchType == WILLSENDIN) {
        [[AppManager sharedInstance].selectedWillSendIn removeObject:cell.searchItem];
    } else if (self.searchType == SIZES) {
        [[AppManager sharedInstance].selectedSize removeObject:cell.searchItem];
    } else if (self.searchType == WEIGHTS) {
        [[AppManager sharedInstance].selectedWeight removeObject:cell.searchItem];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3
                              delay:0
                            options:0
                         animations:^{
                             cell.selectedButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                             cell.selectedButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         } completion:^(BOOL finished) {
                             
                         }];
    });
    
    if (self.searchType == BRAND) {
        [[AppManager sharedInstance].selectedBrands removeAllObjects];
    } else if (self.searchType == CITIES) {
        [[AppManager sharedInstance].selectedCities removeAllObjects];
    } else if (self.searchType == CONDITIONS) {
        [[AppManager sharedInstance].selectedConditions removeAllObjects];
    } else if (self.searchType == WILLSENDIN) {
        [[AppManager sharedInstance].selectedWillSendIn removeAllObjects];
    } else if (self.searchType == SIZES) {
        [[AppManager sharedInstance].selectedSize removeAllObjects];
    } else if (self.searchType == WEIGHTS) {
        [[AppManager sharedInstance].selectedWeight removeAllObjects];
    }
    
    for (NSIndexPath *indexPath in [self.resultTable indexPathsForSelectedRows]) {
        SearchCell* cell = [_resultTable cellForRowAtIndexPath:indexPath];
        [_resultTable deselectRowAtIndexPath:indexPath animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                                  delay:0
                                options:0
                             animations:^{
                                 cell.selectedButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 cell.selectedButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
                             } completion:^(BOOL finished) {
                             }];
        });
    }
    
    if (debug_enabled) {
        NSLog(@"didDeSelectRowAtIndexPath now its %lu ",[[_resultTable indexPathsForSelectedRows] count]);
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [_searchBar setShowsCancelButton:YES animated:YES];
    
    UIView *view = [_searchBar.subviews objectAtIndex:0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton *)subView;
            [cancelButton setTitleColor:[UIColor appRedColor] forState:UIControlStateNormal];
            [cancelButton setTitleColor:[UIColor appRedColor] forState:UIControlStateHighlighted];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.searchType == BRAND) {
        [self generateSectionsInBackgroundFromArray:[AppManager sharedInstance].config.brands withFilter:self.searchBar.text];
    } else if (self.searchType == CITIES) {
        [self generateSectionsInBackgroundFromArray:[AppManager sharedInstance].config.cities withFilter:self.searchBar.text];
    }
}

#pragma mark Other Stuff

-(void)updateOkButton {
    
}

-(void)finishBrandSelection {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
