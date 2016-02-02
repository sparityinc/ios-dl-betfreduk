//
//  ZLSideMenuDelegate.h
//  WarHorse
//
//  Created by Sparity on 08/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLSideMenuDelegate <NSObject>

@required
/** Method which is called when user went with single tap on calendar tile.
 *  @param view Tail on which user clicked.
 */
- (void) tapDetectingView:(id)view;
- (NSString *) selectedValuesForIndex:(NSUInteger)index;
- (UIImage *) imageForIndex:(NSUInteger)index;
- (NSString *) titleForIndex:(NSUInteger)index;
- (UIImage *) backgroundImage:(NSUInteger)index;
- (UIColor *) lineColor:(NSUInteger)index;
- (void)clearSelectedValuesWithIndex:(NSInteger)index;
- (UIView *) viewForSideTileIndex:(NSUInteger)index tile:(id)tile;
@end
