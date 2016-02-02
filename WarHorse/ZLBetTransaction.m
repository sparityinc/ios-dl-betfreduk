//
//  ZLBetTransaction.m
//  WarHorse
//
//  Created by Jugs VN on 9/6/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLBetTransaction.h"

@implementation ZLBetTransaction

@synthesize accountId;

@synthesize associationNo;

@synthesize betAmount;

@synthesize betType;

@synthesize currentTime;

@synthesize description;

@synthesize meet;

@synthesize meetName;

@synthesize perf;

@synthesize race;

@synthesize raceTime;

@synthesize selection;

@synthesize transactionType;

@synthesize tsn;

@synthesize verificationNo;

@synthesize debit;

@synthesize toteTimestamp;

@synthesize result;

@synthesize winningAmount;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}
@end
