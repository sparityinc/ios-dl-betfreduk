//
//  ZLBetType.m
//  WarHorse
//
//  Created by Jugs VN on 8/24/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLBetType.h"

@implementation ZLBetType

@synthesize allowFractionalBetAmt;

@synthesize boxTypeID;

@synthesize canHarryBoy;

@synthesize longName;

@synthesize minBetAmt;

@synthesize maxBetAmt;

@synthesize name;

@synthesize numLegs;

@synthesize poolTypeID;

@synthesize requiresHalfUnitBetAmt;

@synthesize requiresMultOfMinBetAmt;

@synthesize specialMaxBetAmt;

@synthesize specialMaxNumCombos;

@synthesize specialMinBetAmt;

@synthesize specialMinNumCombos;

@synthesize typeID;

@synthesize betAmounts;
@synthesize raceTimeRange;
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


@end
