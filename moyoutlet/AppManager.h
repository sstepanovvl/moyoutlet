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
#import "ConditionItem.h"
#import "WillSendInItem.h"


@interface AppManager : NSObject <NSURLSessionDelegate>
@property (assign,nonatomic) BOOL configured;
@property (assign,nonatomic) NSString* token;
@property (assign,nonatomic) BOOL newUser;
@property (assign,nonatomic) BOOL authorized;
@property (strong,nonatomic) AppConfig* config;
@property (strong,nonatomic) NSMutableDictionary* offers;
@property (strong,nonatomic) UserItem* authorizedUser;
@property (strong,nonatomic) NSMutableArray* savedSearch;
@property (strong,nonatomic) NSMutableArray* searchHistory;
@property (strong,nonatomic) NSMutableArray* selectedBrands;
@property (strong,nonatomic) NSMutableArray* selectedCategories;
@property (strong,nonatomic) NSMutableArray* selectedCities;
@property (strong,nonatomic) NSMutableArray* selectedWeight;
@property (strong,nonatomic) NSMutableArray* selectedSize;
@property (strong,nonatomic) NSMutableArray* selectedConditions;
@property (strong,nonatomic) NSMutableArray* selectedWillSendIn;
@property (strong,nonatomic) NSNumber* outletComissionMulitplier;
@property (strong,nonatomic) OfferItem* offerToEdit;

+ (instancetype)sharedInstance;

#pragma mark Get App Config

-(void) initConfiguration;
-(void)getAppConfigFromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure;

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

#pragma mark Get Categories

-(void) getCategoriesFromServerwithSuccessBlock:(void (^)(BOOL response))success andFailureBlock:(void (^)(NSError *error))failure;

-(NSArray*) getOffers;

-(void)loadOffersFromServerFor:(NSInteger)categoryId
                        offset:(NSInteger)offset
              WithSuccessBlock:(void (^)(BOOL response))success
               andFailureBlock:(void (^)(NSError *error))failure;
-(void)loadOffersFromDBFor:(NSInteger)categoryId;


#pragma mark Create Offer

-(void) createOfferWithData:(NSDictionary*)data andImages:(NSArray*)images;
-(void) saveOfferToDB;

#pragma mark Helpers

-(NSDictionary*)buildTreeForCategory:(NSInteger)category_id;
-(BOOL)checkChildItemsInCategory:(NSNumber*)categoryId;


@end
