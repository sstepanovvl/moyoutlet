//
//  AppManager.h
//  AppManager
//
//  Created by Stepan Stepanov on 24.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"
#import "API.h"
#import "OfferItem.h"
#import "UserItem.h"
#import "SearchItem.h"


@interface AppManager : NSObject

@property (assign,nonatomic) BOOL configured;
@property (assign,nonatomic) NSString* token;
@property (assign,nonatomic) BOOL newUser;
@property (assign,nonatomic) BOOL authorized;
@property (strong,nonatomic) AppConfig* config;
@property (strong,nonatomic) NSMutableDictionary* offers;
@property (strong,nonatomic) NSDictionary* categories;
@property (strong,nonatomic) UserItem* authorizedUser;
@property (strong,nonatomic) NSMutableArray* savedSearch;
@property (strong,nonatomic) NSMutableArray* searchHistory;


+ (instancetype)sharedInstance;

#pragma mark Get App Config

-(void) initConfiguration;

#pragma mark Registration 

-(void) validatePhoneNumber:(NSInteger)phoneNumber;
-(NSDictionary*) registerWithParams:(NSDictionary*)params;

#pragma mark Authorization

-(void) authorizeWithPhoneNumber;

-(void) authorizeWithFacebook;
-(void) authorizeWithInstagram;
-(void) authorizeWithVkontakte;
-(void) authorizeWithTweeter;
-(void) authorizeWithOdnoklassniki;

#pragma mark Get User Config

-(void) loadUserConfigurationFromDB;
-(void) loadUserConfigurationFromServer;

#pragma mark - getUser

-(void)getUserFromServer:(NSUInteger)userID
        WithSuccessBlock:(void (^)(UserItem* user))success
         andFailureBlock:(void (^)(NSError *error))failure;

#pragma mark Get Offers

-(void)getCategoriesFromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure;
-(NSArray*) getOffers;
-(void)loadOffersFromServerFor:(NSInteger)categoryId
                        offset:(NSInteger)offset
              WithSuccessBlock:(void (^)(BOOL response))success
               andFailureBlock:(void (^)(NSError *error))failure;
-(void)loadOffersFromDBFor:(NSInteger)categoryId;


#pragma mark Create Offer

-(void) createOffer;
-(void) saveOfferToDB;

@end
