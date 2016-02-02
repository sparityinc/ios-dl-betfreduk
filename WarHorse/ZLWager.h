//
//  ZLWager.h
//  WarHorse
//
//  Created by Jugs VN on 8/23/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLRaceCard.h"
#import "ZLRaceDetails.h"

@interface ZLWager : NSObject

@property(assign) int selectedRaceId;

@property(assign) int selectedRaceMeetNumber;

@property(assign) int selectedRacePerformanceNumber;

@property(assign) int selectedTrackId;

@property(assign) double amount;

@property(nonatomic, retain) NSString * selectedBetType;

@property(nonatomic, strong) NSString *raceTimeRange;
@property(nonatomic, strong) NSString *isBankarBetType;


@property(atomic, retain) ZLRaceCard * selectedTrack;

@property(atomic, retain) ZLRaceDetails * selectedRace;

@property(nonatomic, retain) NSMutableDictionary * selectedRunners;

@property(nonatomic, retain) NSString * tsnNumber;

-(double) calculateTotalBetAmount;

-(NSString*) getBetString;
@end
