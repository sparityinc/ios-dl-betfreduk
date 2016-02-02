//
//  ZLRaceDetails.m
//  WarHorse
//
//  Created by Jugs VN on 8/23/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLRaceDetails.h"
#import "ZLAppDelegate.h"
#import "ZLAppData.h"
#import "ZLRunner.h"

@implementation ZLRaceDetails

@synthesize number;

@synthesize status;

@synthesize raceType;

@synthesize breedType;

@synthesize courseType;

@synthesize distanceId;

@synthesize distanceUnit;

@synthesize distancePublishedValue;

@synthesize minimumClaimPrice;

@synthesize maximumClaimPrice;

@synthesize trackType;

@synthesize minutesToPost;

@synthesize extraBetTypes;

@synthesize betTypes;

@synthesize runners;
@synthesize trackRaceNumber;
@synthesize trackCountry;
@synthesize raceDate;
@synthesize featureBets;


@synthesize purseUsa;
@synthesize spFavDescription,spFavName,spFavShortName;
- (id)init
{
    self = [super init];
    if (self) {
        self.minutesToPost = 999;
        
        self.extraBetTypes = [NSMutableArray array ];//]arrayWithObjects:@"BB",@"EX",@"TR",@"SF",@"P3",@"P5", nil];
    }
    return self;
}

-(ZLBetType*) findBetTypeWithName:(NSString*) _bet_type_name{
    
    for( ZLBetType * _bet_type in betTypes){
        if( [_bet_type.typeID isEqualToString:_bet_type_name])
            return _bet_type;
    }
    return nil;
}

-(ZLRunner*) findRunnerWithNumber:(NSString*) _number{
    
    for( ZLRunner * _runner in runners){
        if( [_number isEqualToString:[NSString stringWithFormat:@"%d",_runner.runner_id]])
            return _runner;
    }
    return nil;
}
@end
