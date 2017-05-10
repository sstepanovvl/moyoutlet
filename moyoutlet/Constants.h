//
//  Constants.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 05.12.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#endif /* Constants_h */

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

static const BOOL debug_enabled = NO;
static const NSString* apiServer = @"http://moyoutlet.ru/api/";
static const NSString* XDEBUG_SESSION_START = @"18089";
static const NSString* imageServerUrl = @"http://moyoutlet.ru/api/image";
static const float kJpegCompressionRate = 0.7;

typedef enum searchTypes
{
    BRAND,
    CATEGORY,
    CITIES,
    CONDITIONS,
    WILLSENDIN,
    SIZES,
    WEIGHTS
} SearchType;

typedef enum OfferViewControllerModes
{
    OfferViewControllerModeCreate,
    OfferViewControllerModeEdit,
    OfferViewControllerModeView
    
} OfferViewControllerMode;
