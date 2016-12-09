//
//  AppManager.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

+ (instancetype)sharedInstance
{
    static AppManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AppManager alloc] init];
//        [sharedInstance getCategoriesFromServer];
        sharedInstance.offers = [NSMutableDictionary dictionary];
        sharedInstance.savedSearch = [NSMutableArray array];
        sharedInstance.searchHistory = [NSMutableArray array];

        // Do any other initialisation stuff here
    });

    return sharedInstance;
}

#pragma mark Get App Config

-(void) initConfiguration {
        
}

-(void) loadConfigurationFromDB {


}

-(void) checkFroConfigUpdatesFromServer {

    

}

-(void) loadConfigurationFromServer {


}

#pragma mark Registration

-(void) validatePhoneNumber:(NSInteger)phoneNumber {


}

-(NSDictionary*) registerWithParams:(NSDictionary*)params {

//    NSDictionary* dic = [API requestWithMethod:@"registerNewUserWithPhoneNumber" andData:params];

    return nil;
}

#pragma mark Authorization

-(void) authorizeWithPhoneNumber {

}

-(void) authorizeWithFacebook {

}

-(void) authorizeWithInstagram {

}

-(void) authorizeWithVkontakte {

}

-(void) authorizeWithTweeter {

}

-(void) authorizeWithOdnoklassniki {

}

#pragma mark Get User Config

-(void) loadUserConfigurationFromDB {

}

-(void) loadUserConfigurationFromServer {

}

#pragma mark Get Offers
-(void) getCategoriesFromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure {

    [API requestWithMethod:@"getCategories" andData:@{@"testData": @123}
               withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

                   if (data) {
                       self.categories = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:nil];
                       success(YES);
                   } else {
                       success(NO);
                       failure(error);
                   }
               }];
}


-(NSArray*) getOffers {
    return nil;
}


-(void)loadOffersFromServerFor:(NSInteger)categoryId offset:(NSInteger)offset WithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure{

    NSMutableArray* arr = [NSMutableArray array];

    [API requestWithMethod:@"getOffers"
                   andData:@{@"category_id" : [NSNumber numberWithInteger:categoryId],
                             @"offset":[NSNumber numberWithInteger:offset]
                             }
               withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   NSError* err;
                   NSDictionary* resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                   if (!resp) {
                       success(NO);
                       failure(err);
                       NSLog(@"Request error: %@",err.localizedDescription);
                   } else {
                       if (debug_enabled) {
                            NSLog(@"%@",resp);
                       }

                       for (NSDictionary* offer in [resp valueForKey:@"offers"]) {
                           OfferItem* item = [[OfferItem alloc] initWith:offer];
                           NSLog(@"%@",offer);
                           [arr addObject:item];
                       }

                       NSMutableArray* new_arr = [_offers valueForKey:[NSString stringWithFormat:@"%li",(long)categoryId]];
                       if (!new_arr) {
                           new_arr = [[NSMutableArray alloc] init];
                       }

                       [new_arr addObjectsFromArray:arr];

                       [_offers setValue:new_arr forKey:[NSString stringWithFormat:@"%li",(long)categoryId]];

                       success(YES);
                   }
               }];
}

-(void)loadOffersFromDBFor:(NSInteger)categoryId {


}

#pragma mark Create Offer

-(void) createOffer {


}

-(void) saveOfferToDB {


}

#pragma mark - getUser

-(void)getUserFromServer:(NSUInteger)userID
        WithSuccessBlock:(void (^)(UserItem* user))success
         andFailureBlock:(void (^)(NSError *error))failure {

    [API requestWithMethod:@"getUser"
                   andData:@{@"id":[NSNumber numberWithUnsignedInteger:userID]}
               withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   NSError* err;
                   NSDictionary* resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                   if (!resp) {
                       success(nil);
                       failure(err);
                    if (debug_enabled) {
                           NSLog(@"Request error: %@",err.localizedDescription);
                       }
                   } else {
                       if (debug_enabled){
                           NSLog(@"%@",[resp valueForKey:@"user"]);
                       }
                       NSDictionary* user_dic = [resp valueForKey:@"user"];
                       UserItem* user_item = [[UserItem alloc] initWith:user_dic];
                       success(user_item);
                   }
               }];
}
-(void)setAuthorizedUser:(UserItem *)authorizedUser {
    _authorizedUser = authorizedUser;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"userDidChanged"
     object:self];
}
@end
