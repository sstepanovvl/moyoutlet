//
//  SelectBrandVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 27.12.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "SearchCell.h"
#import "baseVC.h"

@interface SelectBrandVC : baseVC <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SearchCellDelegate>


@property SearchType searchType;
@property (assign,nonatomic) NSNumber* parent_id;

@end
