//
//  ZLAppData.m
//  WarHorse
//
//  Created by Jugs VN on 8/23/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLAppData.h"

@implementation ZLAppData

@synthesize raceCards;

@synthesize currentWager;

@synthesize myBets;

@synthesize balanceAmount;

@synthesize dictTrackResultByMeetPerf;

@synthesize carryOverDateEntries;

@synthesize dictOddsPoolByMeetPerfRace;

@synthesize dictFavorites;

@synthesize dictMyBets;

- (id)init
{
    self = [super init];
    if (self) {
        self.raceCards = [NSArray array];
        self.currentWager = [[ZLWager alloc] init];
        self.myBets = [NSMutableArray array];
        self.dictTrackResultByMeetPerf = [NSMutableDictionary dictionary];
        self.dictTrackResultsByDate = [NSMutableDictionary dictionary];
        self.dictResultsByMeetPerfRace = [NSMutableDictionary dictionary];
        self.dictOddsPoolByMeetPerfRace = [NSMutableDictionary dictionary];
        self.dictFavorites = [NSMutableDictionary dictionary];
        self.dictMyBets = [NSMutableDictionary dictionary];
        [self.dictFavorites setValue:[NSMutableArray array] forKey:@"Tracks"];
        self.balanceAmount = 0.0;
        self.carryOverDateEntries = [NSArray array];
    }
    return self;
}

-(void) clearCurrentWager{
    
    self.currentWager = [[ZLWager alloc] init];
    

}
- (void)clearCurrentFavoriteTracks
{
    self.dictFavorites = [NSMutableDictionary dictionary];
    [self.dictFavorites setValue:[NSMutableArray array] forKey:@"Tracks"];
}
@end
