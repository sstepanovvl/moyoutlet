//
//  SearchResultVC.h
//  moyOutlet
//
//  Created by Stepan Stepanov on 29.07.16.
//  Copyright © 2016 Stepan Stepanov. All rights reserved.
//

#import "baseVC.h"

@interface SearchResultVC : baseVC <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (strong,nonatomic) NSString* searchString;
@property (strong, nonatomic) NSMutableArray* searchResults;
@property (strong, nonatomic) SearchItem* searchItem;
@property (strong, nonatomic) UISearchBar *searchBar;

@end
