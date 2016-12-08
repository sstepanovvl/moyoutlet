//
//  NotificationCell.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 26.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *daysAgoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *image;

@end
