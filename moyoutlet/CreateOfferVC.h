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
@import Fusuma;

@interface CreateOfferVC : baseVC <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, FusumaDelegate, NSURLSessionDelegate>

-(instancetype) initFromStoryboard;

@property (strong,nonatomic) OfferItem* item;

@end
