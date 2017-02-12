//
//  MOCollectionView.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 12.02.17.
//  Copyright © 2017 Stepan Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MOCollectionViewDelegate <NSObject>
@required
-(void)MOCollectionViewWillDisplayCellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface MOCollectionView : UICollectionView

@property (nonatomic, strong) id willDisplayCellForItemAtIndexPathDelegate;

@end
