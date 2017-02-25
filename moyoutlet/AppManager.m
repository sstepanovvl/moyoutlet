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
        sharedInstance.config = [AppConfig new];
        sharedInstance.offers = [NSMutableDictionary dictionary];
        sharedInstance.savedSearch = [NSMutableArray array];
        sharedInstance.searchHistory = [NSMutableArray array];
        sharedInstance.selectedCategories = [NSMutableArray array];
        sharedInstance.selectedBrands = [NSMutableArray array];
        sharedInstance.selectedCities = [NSMutableArray array];
        sharedInstance.selectedWeight = [NSMutableArray array];
        sharedInstance.selectedConditions = [NSMutableArray array];
        sharedInstance.selectedWillSendIn = [NSMutableArray array];
        sharedInstance.offerToEdit = [[OfferItem alloc] init];
        sharedInstance.config.outletComissionMulitplier = 0.1f;
        // Do any other initialisation stuff here
    });

    return sharedInstance;
}

#pragma mark Get App Config

-(void) initConfiguration {
        
}

-(void)updateItems:(SearchType)searchType FromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure {
   
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

#pragma mark Get Categories

-(void) getCategoriesFromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure {

    [API requestWithMethod:@"getCategories" andData:@{@"request": @"Gimme that shit nigga"}
               withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   if (data) {
                       self.config.categories = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:nil];
                       success(YES);
                   } else {
                       success(NO);
                       failure(error);
                   }
               }];
}

#pragma mark Get AppConfig

-(void) getAppConfigFromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure {
    
    [API requestWithMethod:@"getAppConfig" andData:@{@"request": @"Gimme that shit nigga"}
               withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                   
                   if (data) {
                       NSArray* arr = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:kNilOptions
                                                                           error:nil];
                       NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                    ascending:YES];
                       NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
                       
                       self.config.weights = [arr valueForKey:@"weights"];
                       self.config.brands = [arr valueForKey:@"brands"];
                       [AppManager sharedInstance].config.brands = [[[AppManager sharedInstance].config.brands sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                       self.config.sizes = [arr valueForKey:@"sizes"];
                       self.config.cities = [arr valueForKey:@"cities"];
                       [AppManager sharedInstance].config.cities = [[[AppManager sharedInstance].config.cities sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
                       self.config.conditions = [arr valueForKey:@"conditions"];
                       self.config.willSendInFields = [arr valueForKey:@"willSendIn"];
                       
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
                       NSMutableArray* new_arr = [_offers valueForKey:[NSString stringWithFormat:@"%li",(long)categoryId]];
                       if (!new_arr) {
                           new_arr = [[NSMutableArray alloc] init];
                       }
                       for (NSDictionary* offer in [resp valueForKey:@"offers"]) {
                           OfferItem* item = [[OfferItem alloc] initWith:offer];
                           bool itemAlreadyThere = false;
                           for (OfferItem* itemInArray in new_arr) {
                               if ([itemInArray.objectId intValue] == [item.objectId intValue]) {
                                   itemAlreadyThere = true;
                                   NSLog(@"%@",offer);
                               }
                           }
                           if (!itemAlreadyThere) {
                               [new_arr addObject:item];
                           }
                       }

                       [_offers setValue:new_arr forKey:[NSString stringWithFormat:@"%li",(long)categoryId]];
                       success(YES);
                   }
               }];
}

-(void)loadOffersFromDBFor:(NSInteger)categoryId {


}

#pragma mark Create Offer
#warning delete method
-(void) uploadOfferToServer:(OfferItem*)offer withHandler:(void (^)(BOOL success))handlerBlock{
//    [API createOfferWithData: andImages:[[offer arrImages] allValues] withHandler:^(BOOL success) {
//        handlerBlock(success);
//    }];
    
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

-(BOOL)checkChildItemsInCategory:(NSNumber*)categoryId {
    for (NSDictionary* d in [AppManager sharedInstance].config.categories) {
        if ([d objectForKey:@"parent_id"] == categoryId) {
            return true;
        }
    }
    return false;
}

-(NSDictionary*)buildTreeForCategory:(NSInteger)category_id {
    
    return nil;
    
}

@end
