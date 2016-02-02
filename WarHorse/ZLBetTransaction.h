//
//  ZLBetTransaction.h
//  WarHorse
//
//  Created by Jugs VN on 9/6/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLBetTransaction : NSObject

@property(nonatomic, retain) NSString * accountId;

@property(assign) int associationNo;

@property(assign) double betAmount;

@property(assign) double debit;

@property(nonatomic, retain) NSString * betType;

@property(nonatomic, retain) NSDate * currentTime;

@property(nonatomic, retain) NSString * description;

@property(assign) int meet;

@property(nonatomic, retain) NSString * meetName;

@property(assign) int perf;

@property(assign) int race;

@property(nonatomic, retain) NSDate * raceTime;

@property(nonatomic, retain) NSString * selection;

@property(nonatomic, retain) NSString * transactionType;

@property(nonatomic, retain) NSString * tsn;

@property(nonatomic, retain) NSString * verificationNo;

@property(assign) BOOL inPlay;

@property(assign) int minutesToStart;

@property(nonatomic, strong) NSDate * toteTimestamp;

@property(nonatomic, strong) NSString * result;

@property(assign) double winningAmount;

@end
