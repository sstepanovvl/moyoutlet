//
//  PopupSearchVC.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 27.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "SearchVC.h"
#import "SearchCell.h"
#import "HeaderView.h"
#import "SearchOffersResultVC.h"

@interface SearchVC ()

@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray* searchResult;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initNavigationItems];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImage"]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.sectionHeaderHeight = 60.0f;
    
    [self initSearchType];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initSearchType {
    _searchBar = [[SearchBar alloc] initWithFrame:CGRectZero];
    [_searchBar sizeToFit];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"Поиск в MoyOutlet";
    [[UISearchBar appearance] setImage:nil forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [_tableView registerNib:[UINib nibWithNibName:@"HeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    [_tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:@"SearchCell"];
    

    self.navigationItem.titleView = _searchBar;
    // It is usually good to set the presentation context.
    self.definesPresentationContext = YES;

}

-(void)initNavigationItems {

    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];

    UIButton* leftBarButtonWithLogo = [[UIButton alloc] init];

    UIImage *image = [[UIImage imageNamed:@"leftMenuBackButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [leftBarButtonWithLogo setFrame:CGRectMake(0, 0, 35, 35)];
    [leftBarButtonWithLogo setImage:image forState:UIControlStateNormal];
    [leftBarButtonWithLogo addTarget:self action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* but = [[UIBarButtonItem alloc] initWithCustomView:leftBarButtonWithLogo];
    NSArray* leftBarItems = [[NSArray alloc] initWithObjects:but, nil];
    self.navigationItem.leftBarButtonItems = leftBarItems;
    self.navigationItem.titleView = _searchBar;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
}

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return [[AppManager sharedInstance].savedSearch count];
            break;
        case 2:
            return [[AppManager sharedInstance].searchHistory count];
        default:
            return 0;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    HeaderView* headerCell = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];

    if (section == 1) {
        [headerCell.headerTitle setText:@"СОХРАНЕННЫЕ РЕЗУЛЬТАТЫ"];
    }
    if (section == 2) {
        [headerCell.headerTitle setText:@"ИСТОРИЯ ПОИСКА"];
    }
    [headerCell setNeedsLayout];
    [headerCell layoutIfNeeded];

    return headerCell;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {

    SearchCell* cell  =  [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];

    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.cellTitle.text = @"Категория";
                    return cell;
                    break;
                case 1:
                    cell.cellTitle.text = @"Бренд";
                    return cell;
                    break;
                default:
                    cell.cellTitle.text = @"Empty";
                    return cell;
                    break;
            }
            break;
        case 1:
            cell.searchItem = [[AppManager sharedInstance].savedSearch objectAtIndex:indexPath.row];
            return cell;
            break;
        case 2:
            cell.searchItem = [[AppManager sharedInstance].searchHistory objectAtIndex:indexPath.row];
            return cell;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            SelectCategoryVC* srvc = [[SelectCategoryVC alloc] initWithNibName:@"SelectCategoryVC" bundle:nil];
            srvc.parent_id = @0;
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [self.navigationController pushViewController:srvc animated:YES];
            
        }  else {
            SelectBrandVC* srvc = [[SelectBrandVC alloc] initWithNibName:@"SelectBrandVC" bundle:nil];
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            [self.navigationController pushViewController:srvc animated:YES];
        }
        
    } else {
        
        SearchOffersResultVC* srvc = [[SearchOffersResultVC alloc] initWithNibName:@"SearchResultVC" bundle:nil];
        
        SearchCell* cell = (SearchCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        srvc.searchItem = cell.searchItem;

        srvc.searchString = srvc.searchItem.text;
        
        srvc.searchResults = _searchResult;
        
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        [self.navigationController pushViewController:srvc animated:YES];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"textDidChange %@", searchText);
    
    //self.sectionsArray = [self generateSectionsFromArray:self.namesArray withFilter:searchText];
    //[self.tableView reloadData];
    
    //    [self generateSectionsInBackgroundFromArray:self.itemsToDisplay withFilter:self.searchBar.text];
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    SearchOffersResultVC* srvc = [[SearchOffersResultVC alloc] initWithNibName:@"SearchResultVC" bundle:nil];
    srvc.searchString = searchBar.text;
    srvc.searchResults = _searchResult;
    [self.navigationController pushViewController:srvc animated:YES];
}

- (void)setImage:(UIImage *)iconImage forSearchBarIcon:(UISearchBarIcon)icon state:(UIControlState)state {

    NSLog(@"setImage");

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
