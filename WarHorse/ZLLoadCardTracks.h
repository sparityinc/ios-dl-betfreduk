//
//  ZLLoadCardTracks.h
//  WarHorse
//
//  Created by Jugs VN on 10/23/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLLoadCardTracks : NSObject

@property (assign) int raceCardId;

@property (nonatomic, retain) NSString * trackId;

@property (nonatomic,retain) NSString *track_Code;

@property (nonatomic, retain) NSString * trackCountry;
//@property (nonatomic, retain) NSString * ticketName;


@property (nonatomic, retain) NSString * trackName;

@property (nonatomic, retain) NSDate * raceDate;

@property (nonatomic, retain) NSString * completeIndicator;

@property (assign) int numberOfRaces;

@property (nonatomic, retain) NSString * active;

@property (nonatomic, retain) NSString * createdTs;

@property (assign) int meet;

@property (assign) int perf;

@property (nonatomic, retain) NSMutableArray * trackResults;

@property (nonatomic,retain) NSString *raceDateStr;

@property (nonatomic,retain) NSString *breedType;
@end
