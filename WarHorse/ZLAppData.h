//
//  ZLAppData.h
//  WarHorse
//
//  Created by Jugs VN on 8/23/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLWager.h"

@interface ZLAppData : NSObject

@property(atomic, retain) NSArray * raceCards;

@property(atomic, retain) ZLWager * currentWager;

@property(atomic, retain) NSMutableArray * myBets;

@property(atomic, retain) NSMutableDictionary * dictMyBets;

@property(atomic, retain) NSMutableDictionary * dictTrackResultByMeetPerf; //Not used anymore

@property(atomic, retain) NSMutableDictionary * dictTrackResultsByDate;

@property(atomic, retain) NSMutableDictionary * dictResultsByMeetPerfRace;

@property (nonatomic, retain) NSArray *carryOverDateEntries;

@property(atomic, retain) NSMutableDictionary * dictOddsPoolByMeetPerfRace;

@property(atomic, retain) NSMutableDictionary * dictFavorites;

@property(assign) double balanceAmount;

- (id)init;

-(void) clearCurrentWager;
- (void) clearCurrentFavoriteTracks;

@end
