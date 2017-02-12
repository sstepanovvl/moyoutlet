//
//  OffersVC.h
//  moyoutlet
//
//  Created by Stepan Stepanov on 25.04.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"
#import "categoryItemButton.h"
#import <QuartzCore/QuartzCore.h>
#import "CategoriesWithOffersVC.h"
#import "moyoutlet-swift.h"

@interface OffersVC : baseVC <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet MOCollectionView *offersCollectionView;
@property (strong, nonatomic) CategoriesWithOffersVC* categoriesWithOffersvc;
@property (assign, nonatomic) NSInteger category_id;
@property (assign, nonatomic) NSInteger parent_id;

-(IBAction)loadMore:(id)sender;


@end
