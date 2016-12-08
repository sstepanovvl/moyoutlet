//
//  NewsCell.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 26.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *text;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;


@end
