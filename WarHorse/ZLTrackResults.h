//
//  ZLTrackResults.h
//  WarHorse
//
//  Created by Jugs VN on 9/25/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLTrackResults : NSObject

@property (nonatomic, retain) NSString * trackName;

@property (nonatomic, retain) NSString * city;

@property (nonatomic, retain) NSString * state;

@property (assign) int meet;

@property (assign) int perf;

@property (assign) int race;
@property (nonatomic,strong) NSString *raceNumber;


@property (assign) int numberofBetRunners;

@property (nonatomic, retain) NSMutableArray * betsForRendering;

@property (nonatomic, retain) NSMutableArray * bets;

@property (nonatomic, retain) NSMutableArray * finishers;

@property (nonatomic, retain) NSMutableArray * finishersByPosition;

@property (nonatomic, retain) NSMutableArray * winnersByPosition;

@property (nonatomic, retain) NSMutableArray * scratches;

@property (nonatomic, retain) NSMutableArray * otherInformation;


@end
