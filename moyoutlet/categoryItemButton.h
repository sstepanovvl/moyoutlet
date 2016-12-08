//
//  categoryItemButton.h
//  test
//
//  Created by Stepan Stepanov on 23.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface categoryItemButton : UIButton

@property NSString* title;
@property NSInteger category_id;
@property (nonatomic, strong) id delegate;
@end

@protocol categoryItemDelegate <NSObject>

@required

-(void)didSelectCategory:(categoryItemButton*)category;

@end




