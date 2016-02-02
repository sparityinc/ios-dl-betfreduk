//
//  ZLRaceCard.h
//  WarHorse
//
//  Created by Jugs VN on 8/22/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLRaceDetails.h"

@interface ZLRaceCard : NSObject

@property(assign) int meetNumber;

@property(assign) int performanceNumber;

@property(assign) int currentRaceNumber;

@property(nonatomic, retain) NSString * currentRaceStatus;

@property(nonatomic, retain) NSString * eventCode;

@property(assign) BOOL future;

@property(assign) BOOL hasResults;

@property(nonatomic, retain) NSString * installationTypeID;

@property(assign) int minutesToPost;

@property(nonatomic, retain) NSString * name;

@property (nonatomic, retain) NSString *raceTime;

@property(assign) int cardId;

@property(nonatomic, retain) NSString * performanceDate;

@property(nonatomic, retain) NSString * performanceTypeID;

@property(nonatomic, retain) NSString * distance;

@property(nonatomic, retain) NSString * trackType;

@property(nonatomic, retain) NSString * claiming;

@property(atomic, retain) NSArray * cardDetails;

@property (nonatomic, retain) NSString * minimumClaimPrice;

@property (nonatomic, retain) NSString * maximumClaimPrice;

@property (nonatomic, retain) NSString * purseUsa;

@property (assign) BOOL favorite;

@property (nonatomic, retain) NSString *breedType;


@property (nonatomic,strong) NSString *isVideoAvailable;
@property (nonatomic,strong) NSString *ticketName;
@property (nonatomic,strong) NSString *trackCountry;
@property (nonatomic,strong) NSString *spFavTrack;

@property (nonatomic,strong) NSString *spFavShortName;

@property (nonatomic,strong) NSString *spFavDescription;
@property (nonatomic,strong) NSString *spFavName;
@property (assign) BOOL kLegBetting;

@property (nonatomic,strong) NSString *currentRace;

@property(assign) int favTrackCode;




- (id)init;

-(ZLRaceDetails*) findRaceDeatilsByRaceId:(int) _race_id;

+(ZLRaceCard *) findRaceCardByMeetNumber:(int) _meet_number AndPerformanceNumber:(int) _perf_number;

+(ZLRaceCard *) findRaceCardById:(int) _card_id;

+(ZLRaceCard *) findRaceCardByMeetNumber:(int) _meet_number;
+(ZLRaceCard *) findRaceCardByFavTrackNumber:(int) _track_number;



@end
