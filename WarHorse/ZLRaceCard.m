//
//  ZLRaceCard.m
//  WarHorse
//
//  Created by Jugs VN on 8/22/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLRaceCard.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"

@implementation ZLRaceCard

@synthesize currentRaceNumber;

@synthesize currentRaceStatus;

@synthesize eventCode;

@synthesize future;

@synthesize hasResults;

@synthesize installationTypeID;

@synthesize meetNumber;

@synthesize minutesToPost;

@synthesize name;

@synthesize raceTime;

@synthesize cardId;

@synthesize performanceDate;

@synthesize performanceNumber;

@synthesize performanceTypeID;

@synthesize distance;

@synthesize trackType;

@synthesize claiming;

@synthesize purseUsa;

@synthesize cardDetails;

@synthesize minimumClaimPrice;

@synthesize maximumClaimPrice;

@synthesize breedType;

@synthesize isVideoAvailable;
@synthesize ticketName,favTrackCode,trackCountry,spFavTrack,spFavShortName,spFavDescription,spFavName;
@synthesize kLegBetting;
@synthesize currentRace;

- (id)init
{
    self = [super init];
    if (self) {
        NSString *title = [NSString stringWithFormat:@"%@$5000 - 25000",[[WarHorseSingleton sharedInstance] currencySymbel]];

        
        self.cardDetails = [NSArray array];
        self.trackType = @"All Weather Track";
        self.distance = @"6 Furlongs";
        self.claiming = title;
        self.minimumClaimPrice = @"0";
        self.maximumClaimPrice = @"0";
        self.favorite = NO;
    }
    return self;
}

-(ZLRaceDetails*) findRaceDeatilsByRaceId:(int) _race_id{

    for( ZLRaceDetails * _details in cardDetails){
        if( _details.number == _race_id)
            return _details;
    }
    return nil;
}

+(ZLRaceCard *) findRaceCardByMeetNumber:(int) _meet_number AndPerformanceNumber:(int) _perf_number{
    
    for( ZLRaceCard * _card in [ZLAppDelegate getAppData].raceCards){
        if( _card.meetNumber == _meet_number && _card.performanceNumber == _perf_number)
            return _card;
    }
    return nil;
}

+(ZLRaceCard *) findRaceCardById:(int) _card_id{
    
    for( ZLRaceCard * _card in [ZLAppDelegate getAppData].raceCards){
        if( _card.cardId == _card_id)
            return _card;
    }
    return nil;
}

+(ZLRaceCard *) findRaceCardByMeetNumber:(int) _meet_number{
    NSLog(@"[ZLAppDelegate getAppData].raceCards %@",[ZLAppDelegate getAppData].raceCards);
    
    for( ZLRaceCard * _card in [ZLAppDelegate getAppData].raceCards){
        if( _card.meetNumber == _meet_number)
            return _card;
    }
    return nil;
}
+(ZLRaceCard *) findRaceCardByFavTrackNumber:(int) _track_number{
    
    for( ZLRaceCard * _card in [ZLAppDelegate getAppData].raceCards){
        if( _card.favTrackCode == _track_number)
            return _card;
    }
    return nil;
}
@end
