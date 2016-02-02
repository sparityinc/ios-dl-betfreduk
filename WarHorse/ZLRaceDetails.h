//
//  ZLRaceDetails.h
//  WarHorse
//
//  Created by Jugs VN on 8/23/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLBetType.h"
#import "ZLRunner.h"

@interface ZLRaceDetails : NSObject

@property(assign) int number;

@property(nonatomic, retain) NSString * status;

@property(nonatomic, retain) NSString * raceType;

@property(nonatomic, retain) NSString * breedType;

@property(nonatomic, retain) NSString * courseType;

@property(nonatomic, retain) NSString * distanceId;

@property(nonatomic, retain) NSString * distanceUnit;

@property(assign) int minutesToPost;

@property(nonatomic, retain) NSString * distancePublishedValue;

@property(assign) int minimumClaimPrice;

@property(assign) int maximumClaimPrice;

@property (nonatomic, retain) NSString * purseUsa;

@property(nonatomic, retain) NSString * trackType;

@property(nonatomic, retain) NSMutableArray * extraBetTypes;

@property(atomic, retain) NSMutableSet * betTypes;

@property(atomic, retain) NSMutableSet * runners;

@property(nonatomic, strong) NSString * spFavDescription;
@property(nonatomic, strong) NSString * spFavName;
@property(nonatomic, strong) NSString * spFavShortName;
@property (nonatomic,strong) NSString *trackRaceNumber;
@property (nonatomic,strong) NSString *trackCountry;

@property (nonatomic,strong) NSString *raceDate;
@property(nonatomic, retain) NSMutableSet *featureBets;


-(ZLBetType*) findBetTypeWithName:(NSString*) _bet_type_name;

-(ZLRunner*) findRunnerWithNumber:(NSString*) _number;



@end
