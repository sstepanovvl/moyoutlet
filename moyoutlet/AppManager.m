//
//  AppManager.m
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "AppManager.h"
@interface AppManager ()
@end


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
        sharedInstance.selectedCategories = [NSMutableArray array];
        sharedInstance.selectedBrands = [NSMutableArray array];
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

#pragma mark Get Brands

-(void)getBrandsFromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure {
    [API requestWithMethod:@"getBrands" andData:@{@"Give me the matherfuckin brands": @"Gimmy that shit niger"}
               withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   
                   if (data) {
                       self.brands = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:nil];
                       success(YES);
                   } else {
                       success(NO);
                       failure(error);
                   }
               }];
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

-(void) createOfferWithData:(NSDictionary*)data andImages:(NSArray*)images {
    
    [API createOfferWithData:data andImages:images];
    
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

/*
#pragma mark NSUrlsession Delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSLog(@"Sent %lld, Total sent %lld, Not Sent %lld", bytesSent, totalBytesSent, totalBytesExpectedToSend);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    _receiveData = [NSMutableData data];
    [_receiveData setLength:0];
    completionHandler(NSURLSessionResponseAllow);
    NSLog(@"NSURLSession Starts to Receive Data");
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [_receiveData appendData:data];
    NSLog(@"NSURLSession Receive Data");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSLog(@"URL Session Complete: %@", task.response.description);
    
    if(error != nil) {
        NSLog(@"Error %@",[error userInfo]);
    } else {
        NSLog(@"Uploading is Succesfull");
        
        NSString *result = [[NSString alloc] initWithData:_receiveData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", result);
    }
}
 */
#pragma mark Helpers

-(BOOL)checkChildItemsInCategory:(NSInteger)categoryId {
    for (NSDictionary* d in [[AppManager sharedInstance].categories mutableCopy]) {
        if ([[d objectForKey:@"parent_id"] integerValue] == categoryId) {
            return true;
        }
    }
    return false;
}

-(NSDictionary*)buildTreeForCategory:(NSInteger)category_id {
    
    return nil;
    
}

@end
