//
//  ZLTrackResults.m
//  WarHorse
//
//  Created by Jugs VN on 9/25/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLTrackResults.h"

@implementation ZLTrackResults

@synthesize trackName;

@synthesize city;

@synthesize state;

@synthesize meet;

@synthesize perf;

@synthesize race;
@synthesize raceNumber;
@synthesize numberofBetRunners;

@synthesize bets;

@synthesize finishers;

@synthesize finishersByPosition;

@synthesize scratches;
@synthesize otherInformation;


- (id)init
{
    self = [super init];
    if (self) {
        self.finishersByPosition = [NSMutableArray array];
        self.winnersByPosition = [NSMutableArray array];
        self.betsForRendering = [NSMutableArray array];
    }
    return self;
}


@end
