//
//  SelectCategoryVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 28.12.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "SearchCell.h"
#import "HeaderView.h"

@interface SelectCategoryVC : baseVC <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SearchCellDelegate>

@property (assign,nonatomic) NSNumber* parent_id;


@end
