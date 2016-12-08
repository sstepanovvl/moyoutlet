//
//  NewsVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 16.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "NewsCell.h"
#import "NewsItemVC.h"

@interface NewsVC : baseVC <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
