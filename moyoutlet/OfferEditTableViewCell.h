//
//  OfferEditTableViewCell.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 15.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferEditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *requieredLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowLabel;

@end
