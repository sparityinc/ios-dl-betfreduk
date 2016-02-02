//
//  ZLBetType.h
//  WarHorse
//
//  Created by Jugs VN on 8/24/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLBetType : NSObject

@property(assign) BOOL allowFractionalBetAmt;

@property(assign) BOOL canHarryBoy;

@property(nonatomic, retain) NSString * boxTypeID;

@property(nonatomic, retain) NSString * longName;

@property(assign) int minBetAmt;

@property(assign) int maxBetAmt;

@property(nonatomic, retain) NSString * name;

@property(assign) int numLegs;

@property(nonatomic, retain) NSString * poolTypeID;

@property(assign) BOOL requiresHalfUnitBetAmt;

@property(assign) BOOL requiresMultOfMinBetAmt;

@property(assign) int specialMaxBetAmt;

@property(assign) int specialMaxNumCombos;

@property(assign) int specialMinBetAmt;

@property(assign) int specialMinNumCombos;

@property(nonatomic, retain) NSString * typeID;

@property(nonatomic, retain) NSMutableSet * betAmounts;
@property (nonatomic,retain) NSString *raceTimeRange;

/*- (void)addBetAmountsObject:(ZLBetType *)value;
- (void)removeBetAmountsObject:(ZLBetType *)value;

- (void)addBetAmounts:(NSSet *)values;
- (void)removeBetAmounts:(NSSet *)values;
*/
@end
