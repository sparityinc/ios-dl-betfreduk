//
//  ZLAmountViewDelegate.h
//  AmountSelectionComponent
//
//  Created by Sparity on 17/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLAmountViewDelegate <NSObject>

- (NSUInteger) numberOfItems;
- (NSString *) titleForItem:(int) index;
- (void) selectedRowWithIndex:(int)index;
- (CGFloat) yValueToStart;

@end
