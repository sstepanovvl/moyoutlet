//
//  UIWebView+Additional.m
//  moyOutlet
//
//  Created by Stepan Stepanov on 26.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "UIWebView+Additional.h"

@implementation UIWebView (Additional)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL superCanPerform = [super canPerformAction:action withSender:sender];
    if (superCanPerform) {

        SEL shareSelector = NSSelectorFromString(@"_share:");

        if (action == @selector(copy:) ||
            action == @selector(paste:)||
            action == shareSelector)
        {
            return false;
        }
    }
    return superCanPerform;
}

@end
