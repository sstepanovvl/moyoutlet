//
//  SelectCategoryVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 28.12.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "SelectCategoryVC.h"

@interface SelectCategoryVC ()
@property (weak, nonatomic) IBOutlet UITableView *resultTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *tableViewHeader;
@property (strong, nonatomic) NSMutableArray* itemsToDisplay;
@property (strong, nonatomic) NSOperation* currentOperation;
@property (strong, nonatomic) NSArray* sectionsArray;
@property (weak, nonatomic) IBOutlet UIImageView *tableViewHeaderImage;

@end
static NSString* kCellIdentifier = @"SearchCell";

@implementation SelectCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.resultTable registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self.resultTable registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    self.resultTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.resultTable.sectionIndexBackgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noCategoryRowSelected:)];
    
    [self.tableViewHeader addGestureRecognizer:tapGesture];
    
    if ([[AppManager sharedInstance].selectedCategories count] > 0) {
        self.tableViewHeaderImage.hidden = true;
    }
    
    self.itemsToDisplay = [NSMutableArray new];
    
    [self initNavigationItems];
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    
    _searchBar.placeholder = @"Поиск в MoyOutlet";
    
    [[UISearchBar appearance] setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [self.view addSubview:_searchBar];
    
    self.definesPresentationContext = YES;
    
    [self initFirstItemsInResultTable];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) initFirstItemsInResultTable {
    
    NSMutableArray* ar = [[AppManager sharedInstance].categories mutableCopy];
    
    self.itemsToDisplay = [[ar filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(parent_id == %@)",[self.parent_id stringValue]]] mutableCopy];

    [self generateSectionsInBackgroundFromArray:self.itemsToDisplay withFilter:self.searchBar.text];
    
}

- (void) generateSectionsInBackgroundFromArray:(NSArray*) array withFilter:(NSString*) filterString {
    NSLog(@"Filter string %@",filterString);
    [self.currentOperation cancel];
    
    __weak SelectCategoryVC* weakSelf = self;
    
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
            if (debug_enabled) {
                NSLog(@"%@",[currentLetter uppercaseString]);
                NSLog(@"%@",[firstLetter uppercaseString]);
            }
            //        if ([currentLetter caseInsensitiveCompare:firstLetter] != NSOrderedSame ) {
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
    self.navigationItem.title = @"Категория";
}


#pragma mark UITableViewDelegate & UITableViewDataSource & noCategorySelector

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    
//    NSMutableArray* array = [NSMutableArray array];
//    
//    if ([self.sectionsArray count]) {
//        for (HeaderView* section in self.sectionsArray) {
//            [array addObject:section.name];
//        }
//        
//    }
//    
//    return array;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsToDisplay count];
}


//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    HeaderView* headerCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
//    headerCell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
//    
//    [headerCell.headerTitle setText:[[self.sectionsArray objectAtIndex:section] name]];
//    [headerCell setNeedsLayout];
//    [headerCell layoutIfNeeded];
//    return headerCell;
//}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//        return nil;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"Init Cell");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NSDictionary* dic = nil;
    dic = [self.itemsToDisplay objectAtIndex:indexPath.row];
    
    SearchItem* searchItem = [[SearchItem alloc] init];
    if ([dic respondsToSelector:@selector(objectForKey:)]) {
        searchItem.text  = [dic objectForKey:@"name"];
        searchItem.item_id = [[dic objectForKey:@"id"] integerValue];
        searchItem.parent_id = [[dic objectForKey:@"parent_id"] integerValue];
    } else {
        searchItem.text  = [dic valueForKey:@"name"];
        searchItem.item_id = [[dic valueForKey:@"item_id"] integerValue];
        searchItem.parent_id = [[dic valueForKey:@"parent_id"] integerValue];
    }
    
    cell.searchItem = searchItem;
    
    if (![[AppManager sharedInstance] checkChildItemsInCategory:cell.searchItem.item_id] || searchItem.item_id == 0 ) {
        cell.selectButtonConstraint.constant = 0.f;
        cell.selectButtonTrailingConstraint.constant = 0.f;
    } else {
        cell.selectButtonConstraint.constant = 14.f;
        cell.selectButtonTrailingConstraint.constant = 8.f;
    }
    
    for (SearchItem* selectedItem in [[AppManager sharedInstance]selectedCategories]) {
        if ([selectedItem.text isEqualToString:cell.searchItem.text] ) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    
    if (!cell.selected) {
        cell.selectedButton.hidden = NO;
        cell.selectedButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    } else {
        cell.selectedButton.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    }
    return cell;
}

#pragma SearcChellDelegate

-(IBAction)noCategoryRowSelected:(UITapGestureRecognizer*)gesture {
    if ([[[AppManager sharedInstance]selectedCategories]  count] > 0) {
        self.tableViewHeaderImage.hidden = false;
        for (NSIndexPath *indexPath in [self.resultTable indexPathsForSelectedRows]) {
            
            self.tableViewHeaderImage.transform = CGAffineTransformMakeScale(0.001,0.001);
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3
                                  delay:0
                                options:0
                             animations:^{
                                 self.tableViewHeaderImage.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                 self.tableViewHeaderImage.transform = CGAffineTransformMakeScale(1, 1);
                             } completion:^(BOOL finished) {
                                 [self tableView:self.resultTable didDeselectRowAtIndexPath:indexPath];
                                 [AppManager sharedInstance].selectedCategories = [NSMutableArray new];
                             }];
            });
            
        }
        if (debug_enabled){
            NSLog(@"No brand state changed");
        }
    }
}

-(void)deselectNoCategoryRow {
    
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

-(void)delegateForCell:(SearchCell *)cell showSubItems:(BOOL)showSubItems{
    
    NSIndexPath* indexPath = [self.resultTable indexPathForCell:cell];
    
    if (showSubItems) {
        SelectCategoryVC* svc = [[SelectCategoryVC alloc] init];
        svc.parent_id = [NSNumber numberWithInteger:cell.searchItem.item_id] ;
        [self.navigationController pushViewController:svc animated:YES];
    } else {
        if (cell.selected) {
            [self.resultTable deselectRowAtIndexPath:indexPath animated:NO];
        } else {
            [self.resultTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self deselectNoCategoryRow];
    
    [self.resultTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    // apply animation on the accessed view
    SearchCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = true;
    dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         cell.selectedButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         cell.selectedButton.transform = CGAffineTransformMakeScale(1, 1);
                     } completion:^(BOOL finished) {
                         [[AppManager sharedInstance].selectedCategories addObject:cell.searchItem];
                     }];
    });

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self.resultTable deselectRowAtIndexPath:indexPath animated:NO];
    dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         cell.selectedButton.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         cell.selectedButton.transform = CGAffineTransformMakeScale(0.001, 0.001);
                     } completion:^(BOOL finished) {
                         if ([[AppManager sharedInstance].selectedCategories count] == 1 && [[[AppManager sharedInstance].selectedCategories lastObject]isEqual:cell.searchItem]) {
                             [self performSelector:@selector(noCategoryRowSelected:) withObject:nil];
                         }
                         [[AppManager sharedInstance].selectedCategories removeObject:cell.searchItem];
                     }];
    });

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
    [self generateSectionsInBackgroundFromArray:[[AppManager sharedInstance].categories mutableCopy] withFilter:self.searchBar.text];
}

@end

