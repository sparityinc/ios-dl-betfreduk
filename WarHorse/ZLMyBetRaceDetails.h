//
//  ZLMyBetRaceDetails.h
//  WarHorse
//
//  Created by Jugs VN on 10/8/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLBetTransaction.h"

@interface ZLMyBetRaceDetails : NSObject

@property(nonatomic, strong) NSString * status;

@property(nonatomic, strong) NSDate * currentTime;

@property(nonatomic, strong) NSDate * raceTime;

@property(assign) int raceNumber;

@property(assign) int MTP;

@property(nonatomic, strong) NSMutableArray * bets;

-(void) removeBetFromRaceDetails:(ZLBetTransaction*) transaction;

@end
