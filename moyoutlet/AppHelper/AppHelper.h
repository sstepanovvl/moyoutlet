//
//  AppHelper.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 18.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import "baseManager.h"

@interface AppHelper : baseManager
+(NSDictionary*)searchInDictionaries:(NSArray*)array Value:(id)value forKey:(NSString*)key;
@end
