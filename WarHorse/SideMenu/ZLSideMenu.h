//
//  ZLSideMenu.h
//  WarHorse
//
//  Created by Sparity on 08/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSideMenuTile.h"



@interface ZLSideMenu : UIScrollView

@property (nonatomic, assign) NSUInteger numberOfItems;
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) NSMutableArray *tilesArray;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int whichViewLoaded;

- (void) nextViewLoaded;
- (void) reloadTilesWithIndex:(NSUInteger)index;
- (void) clearAllData;
- (void) selectTileWithTag:(int) tag;
- (void) reloadTiles;
@end
