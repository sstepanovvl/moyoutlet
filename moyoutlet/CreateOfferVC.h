//
//  CreateOfferVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 12.08.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseVC.h"
#import "moyoutlet-swift.h"


@interface CreateOfferVC : baseVC <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, NSURLSessionDelegate, UITextFieldDelegate,UITextInputDelegate>

-(instancetype) initFromStoryboardWithItem:(OfferItem*)item;

@property (strong,nonatomic) OfferItem* item;
@property (assign,nonatomic) bool createNewOffer;

@end
