//
//  AKLegSelectionDelegate.h
//  LegSelection
//
//  Created by Sparity on 04/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AKLegSelectionDelegate <NSObject>
@optional
- (void) LegSelection:(id)LegSelection didSelect:(long int)selectedLeg;
- (void) moveRightToLegSelection:(id)LegSelection didSelect:(long int)selectedLeg;
- (void) moveLefttToLegSelection:(id)LegSelection didSelect:(long int)selectedLeg;

@required
- (NSUInteger) totalNumberOfLegs;
- (NSUInteger) numberOfLegsInPage;
@end
