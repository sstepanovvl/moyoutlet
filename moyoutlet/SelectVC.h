//
//  SelectVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 14.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "HeaderView.h"
#import "SearchCell.h"

@interface SelectVC : baseVC <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SearchCellDelegate>

@property SearchType searchType;
@property (assign,nonatomic) NSInteger parent_id;

@end
