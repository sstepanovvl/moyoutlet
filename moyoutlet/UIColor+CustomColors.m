//
//  UIColor + CustomColors.m
//  moyoutlet
//
//  Created by Stepan Stepanov on 10.05.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)appRedColor {

    static UIColor *appRedColor;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appRedColor = [UIColor colorWithRed:216.0 / 255.0
                                           green:67.0 / 255.0
                                            blue:56.0 / 255.0
                                           alpha:1.0];
    });

    return appRedColor;
}

+ (UIColor *)appMidGrayColor {

    static UIColor *appMidGrayColor;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appMidGrayColor = [UIColor colorWithRed:211.0 / 255.0
                                      green:211.0 / 255.0
                                       blue:211.0 / 255.0
                                      alpha:1.0];
    });

    return appMidGrayColor;
}

+ (UIColor *)appLightGrayColor {

    static UIColor *appLightGrayColor;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appLightGrayColor = [UIColor colorWithRed:218.0 / 255.0
                                          green:218.0 / 255.0
                                           blue:218.0 / 255.0
                                          alpha:1.0];
    });

    return appLightGrayColor;
}

+ (UIColor *)appDarkGrayColor {

    static UIColor *appDarkGrayColor;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDarkGrayColor = [UIColor colorWithRed:153.0 / 255.0
                                            green:153.0 / 255.0
                                             blue:153.0 / 255.0
                                            alpha:1.0];
    });

    return appDarkGrayColor;
}
@end