//
//  UIFont+UIFont_appFonts.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 10.05.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "UIFont+UIFont_appFonts.h"

@implementation UIFont (UIFont_appFonts)
+(UIFont*)appRegularFontWithSize:(float)size {
    return [UIFont fontWithName:@"OpenSans" size:size];
}
+(UIFont*)appBoldFontWithSize:(float)size {
    return [UIFont fontWithName:@"OpenSans-bold" size:size];
}
+(UIFont*)appLightFontWithSize:(float)size {
    return [UIFont fontWithName:@"OpenSans-light" size:size];
}

@end
