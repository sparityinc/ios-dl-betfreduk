//
//  ZLAPIWrapper.m
//  WarHorse
//
//  Created by Jugs VN on 8/22/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLAPIWrapper.h"
#import <RestKit/RestKit.h>
#import "ZLRaceCard.h"
#import "ZLRaceDetails.h"
#import "ZLBetType.h"
#import "ZLAppDelegate.h"
#import "ZLRunner.h"
#import "ZLBetTransaction.h"
#import "ZLTrackResults.h"
#import "ZLBetResult.h"
#import "ZLFinisher.h"
#import "ZLOddsPool.h"
#import "ZLOddsPoolRunner.h"
#import "NSNotificationCenter+MainThread.h"
#import "ZLWagerUtility.h"
#import "ZLMyBets.h"
#import "ZLMyBetTrackDetails.h"
#import "ZLMyBetRaceDetails.h"
#import "SPDateEntry.h"
#import "SPCarryOver.h"
#import "SPPreLoginJsonData.h"
#import "SPPreLoginResponseContent.h"
#import "ZLLoadCardTracks.h"
#import "ZLBetResultRunner.h"
#import "SPConstant.h"
#import "WarHorseSingleton.h"


//#define APP_ENV_DEBUG 0 // Comment open live api
#ifdef APP_ENV_DEBUG
#define kAPIEndpointHost  @"http://wh.spodemo.com/"
#else
#define kAPIEndpointHost  @"http://devdl.spodemo.com:/"

#endif

#define kCaliforniaDemo @"http://g4.spodemo.com/"

//Staging Mywinners
#define kAPILocalEndPoint @"http://g4qc.spodemo.com/"

//Production Mywinners
#define kAPIMyWinnersEndPoint @"https://m.mywinners.com/"

#define kAPIDevEndpointHost  @"http://devdl.sparity.com:7070/"


#define kAPIBetfredUKDevHost @"http://bfddev.sparity.com:7070/"

#define kAPIBetfredUKStgHost @"http://bfdstg.spodemo.com/"


@interface ZLAPIWrapper()

@property(nonatomic, retain) NSURL *baseURL;

@property(nonatomic, retain) NSString *username;

@property(nonatomic, retain) NSString *password;

@property(nonatomic, retain) NSString *pin;

@end

@implementation ZLAPIWrapper

- (id)init
{
    self = [super init];
    if (self) {
        
        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
        //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
        self.baseURL = [NSURL URLWithString:kAPIBetfredUKDevHost];
        
        RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:self.baseURL];
        [RKObjectMapping addDefaultDateFormatterForString:@"yyyy-MM-dd'T'HH:mm:ssZ" inTimeZone:nil];
        
        RKObjectMapping *raceCardMapping = [RKObjectMapping mappingForClass:[ZLRaceCard class]];
        [raceCardMapping addAttributeMappingsFromDictionary:@{
                                                              @"currentRaceNumber": @"currentRaceNumber",
                                                              @"currentRaceStatus":@"currentRaceStatus",
                                                              @"eventCode":@"eventCode",
                                                              @"future":@"future",
                                                              @"hasResults":@"hasResults",
                                                              @"installationTypeID":@"installationTypeID",
                                                              @"meetNumber":@"meetNumber",
                                                              @"minutesToPost":@"minutesToPost",
                                                              @"name":@"name",
                                                              @"raceTime":@"raceTime",
                                                              @"number":@"cardId",
                                                              @"performanceDate":@"performanceDate",
                                                              @"performanceNumber":@"performanceNumber",
                                                              @"performanceTypeID":@"performanceTypeID",
                                                              @"distancePublishedValue":@"distance",
                                                              @"trackType":@"trackType",
                                                              @"purseUsa":@"purseUsa",
                                                              @"Claiming":@"claiming",
                                                              @"maximumClaimPrice":@"maximumClaimPrice",
                                                              @"minimumClaimPrice":@"minimumClaimPrice",
                                                              @"breedType":@"breedType",
                                                              @"isVideoAvailable":@"isVideoAvailable",
                                                              @"ticketName":@"ticketName",
                                                              @"favTrackCode":@"favTrackCode",
                                                              @"trackCountry":@"trackCountry",
                                                              @"spFavTrack":@"spFavTrack",
                                                              @"spFavDescription":@"spFavDescription",
                                                              @"spFavShortName":@"spFavShortName",
                                                              @"spFavName":@"spFavName",
                                                              @"kLegBetting":@"kLegBetting",
                                                              @"currentRace":@"currentRace"
                                                              
                                                              }];
        
        RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:raceCardMapping
                                                                                           pathPattern:kGetCards
                                                                                               keyPath:@"response-content"
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor];

        /*
        RKResponseDescriptor *responseDescriptor123 = [RKResponseDescriptor responseDescriptorWithMapping:raceCardMapping
                                                                                           pathPattern:kGetCards
                                                                                               keyPath:@"response-TF"
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];

        [objectManager addResponseDescriptor:responseDescriptor123];*/

        //
        
        
        RKObjectMapping *betTypeMapping = [RKObjectMapping mappingForClass:[ZLBetType class]];
        [betTypeMapping addAttributeMappingsFromDictionary:@{
                                                             @"allowFractionalBetAmt": @"allowFractionalBetAmt",
                                                             @"canHarryBoy":@"canHarryBoy",
                                                             @"longName":@"longName",
                                                             @"minBetAmt":@"minBetAmt",
                                                             @"maxBetAmt":@"maxBetAmt",
                                                             @"poolTypeID":@"poolTypeID",
                                                             @"requiresHalfUnitBetAmt":@"requiresHalfUnitBetAmt",
                                                             @"requiresMultOfMinBetAmt":@"requiresMultOfMinBetAmt",
                                                             @"specialMaxBetAmt":@"specialMaxBetAmt",
                                                             @"specialMaxNumCombos":@"specialMaxNumCombos",
                                                             @"specialMinBetAmt":@"specialMinBetAmt",
                                                             @"name":@"name",
                                                             @"numLegs" : @"numLegs",
                                                             @"specialMinNumCombos":@"specialMinNumCombos",
                                                             @"typeID":@"typeID",
                                                             @"boxTypeID":@"boxTypeID",
                                                             @"betAmounts":@"betAmounts",
                                                             @"raceTimeRange":@"raceTimeRange"
                                                             }];
        
        RKObjectMapping *raceDetailsMapping = [RKObjectMapping mappingForClass:[ZLRaceDetails class]];
        [raceDetailsMapping addAttributeMappingsFromDictionary:@{
                                                                 @"number": @"number",
                                                                 @"status":@"status",
                                                                 @"raceType":@"raceType",
                                                                 @"breedType":@"breedType",
                                                                 @"courseType":@"courseType",
                                                                 @"distanceId":@"distanceId",
                                                                 @"distanceUnit":@"distanceUnit",
                                                                 @"minutesToPost":@"minutesToPost",
                                                                 @"distancePublishedValue":@"distancePublishedValue",
                                                                 @"purseUsa":@"purseUsa",
                                                                 @"minimumClaimPrice":@"minimumClaimPrice",
                                                                 @"maximumClaimPrice":@"maximumClaimPrice",
                                                                 @"trackType":@"trackType",
                                                                 @"spFavShortName":@"spFavShortName",
                                                                 @"spFavName":@"spFavName",
                                                                 @"spFavDescription":@"spFavDescription",
                                                                 @"trackRaceNumber":@"trackRaceNumber",
                                                                 @"trackCountry":@"trackCountry",
                                                                 @"raceDate":@"raceDate",
                                                                 @"featureBets":@"featureBets" //VVH
                                                                 }];
        
       
        
        RKRelationshipMapping * betRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"bets" toKeyPath:@"betTypes" withMapping:betTypeMapping];
        [raceDetailsMapping addPropertyMapping:betRelationshipMapping];
        betRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKObjectMapping *runnersMapping = [RKObjectMapping mappingForClass:[ZLRunner class]];
        [runnersMapping addAttributeMappingsFromDictionary:@{
                                                             @"number": @"runnerNumber",
                                                             @"scratched": @"scratched",
                                                             @"winOdds": @"winOdds",
                                                             @"horseName" : @"title",
                                                             @"jockeyFullName" : @"jockeyName",
                                                             @"trainerFullName" : @"couchName",
                                                             @"mlodds":@"mlodds",
                                                             @"probablePay":@"probablePay",
                                                             @"runnerSilk":@"silkImageStr",
                                                             @"weightCarried":@"lbs"
                                                             }];
        
        RKRelationshipMapping * runnerRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"runners" toKeyPath:@"runners" withMapping:runnersMapping];
        [raceDetailsMapping addPropertyMapping:runnerRelationshipMapping];
        runnerRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
//        RKRelationshipMapping * featureBetsRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"featureBets" toKeyPath:@"featureBets" withMapping:runnersMapping];
//        [raceDetailsMapping addPropertyMapping:featureBetsRelationshipMapping];
//        featureBetsRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;

        
        RKObjectMapping *resultsMapping = [RKObjectMapping mappingForClass:[ZLTrackResults class]];
        [resultsMapping addAttributeMappingsFromDictionary:@{
                                                             @"track_name": @"trackName",
                                                             @"track_country": @"city",
                                                             @"track_location": @"state",
                                                             @"meet": @"meet",
                                                             @"perf": @"perf",
                                                             @"race": @"race",
                                                             @"raceNumber":@"raceNumber"
                                                             }];
        
        RKObjectMapping *betResultsMapping = [RKObjectMapping mappingForClass:[ZLBetResult class]];
        [betResultsMapping addAttributeMappingsFromDictionary:@{
                                                                @"Meet": @"meet",
                                                                @"Perf": @"perf",
                                                                @"Race": @"race",
                                                                @"Code": @"betCode",
                                                                @"Result_Order": @"resultOrder",
                                                                @"Xml.carry_over": @"carryOver"
                                                                }];
        
        RKRelationshipMapping * betResultRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"bets" toKeyPath:@"bets" withMapping:betResultsMapping];
        [resultsMapping addPropertyMapping:betResultRelationshipMapping];
        betResultRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKObjectMapping *betResultsRunnersMapping = [RKObjectMapping mappingForClass:[ZLBetResultRunner class]];
        [betResultsRunnersMapping addAttributeMappingsFromDictionary:@{
                                                                       @"number": @"combinations",
                                                                       @"amount": @"amount",
                                                                       @"winner": @"winner"
                                                                       }];
        
        RKRelationshipMapping * betResultRunnerRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"Xml.runner" toKeyPath:@"runners" withMapping:betResultsRunnersMapping];
        [betResultsMapping addPropertyMapping:betResultRunnerRelationshipMapping];
        betResultRunnerRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        
        RKObjectMapping *betFinisherMapping = [RKObjectMapping mappingForClass:[ZLFinisher class]];
        [betFinisherMapping addAttributeMappingsFromDictionary:@{
                                                                 @"position": @"position",
                                                                 @"runners": @"runnerPosition",
                                                                 @"WIN_payoff": @"winPayOff",
                                                                 @"PLC_payoff": @"plcPayOff",
                                                                 @"SHW_payoff": @"shwPayOff",
                                                                 @"horse_name": @"horseName",
                                                                 @"trainer_name": @"trainerName",
                                                                 @"jockey_name": @"jockeyName",
                                                                 @"owner_name": @"ownerName"
                                                                 }];
        
        RKRelationshipMapping * betFinisherRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"finishers" toKeyPath:@"finishers" withMapping:betFinisherMapping];
        [resultsMapping addPropertyMapping:betFinisherRelationshipMapping];
        betFinisherRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKObjectMapping *betScratchersMapping = [RKObjectMapping mappingForClass:[ZLFinisher class]];
        [betScratchersMapping addAttributeMappingsFromDictionary:@{
                                                                   @"runners": @"runnerPosition",
                                                                   @"horse_name": @"horseName",
                                                                   @"trainer_name": @"trainerName",
                                                                   @"jockey_name": @"jockeyName",
                                                                   @"owner_name": @"ownerName"
                                                                   }];
        
        RKRelationshipMapping * runnerScratcherRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"scratches" toKeyPath:@"scratches" withMapping:betScratchersMapping];
        [resultsMapping addPropertyMapping:runnerScratcherRelationshipMapping];
        runnerScratcherRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        
        RKObjectMapping *betOtherMapping = [RKObjectMapping mappingForClass:[ZLFinisher class]];
        [betOtherMapping addAttributeMappingsFromDictionary:@{
                                                                   @"Title": @"Title",
                                                                   @"Value": @"Value",
                                                                   
                                                                   }];
        
        RKRelationshipMapping *otherInformationRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"otherInformation" toKeyPath:@"otherInformation" withMapping:betOtherMapping];
        [resultsMapping addPropertyMapping:otherInformationRelationshipMapping];
        otherInformationRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;

        
        
        RKObjectMapping * oddsPoolMapping = [RKObjectMapping mappingForClass:[ZLOddsPool class]];
        [oddsPoolMapping addAttributeMappingsFromDictionary:@{
                                                              @"code": @"betType",
                                                              @"currency": @"currency",
                                                              @"total": @"total",
                                                              @"gross": @"gross",
                                                              @"net": @"net",
                                                              @"code": @"betType",
                                                              @"net-sales-addin": @"net_sales_addin",
                                                              @"net-pool-addin": @"net_pool_addin",
                                                              @"carry-in": @"carry_in",
                                                              @"total-gross": @"total_gross",
                                                              @"total-net":@"total_net"
                                                              }];
        
        RKObjectMapping * oddsPoolRunnerMapping = [RKObjectMapping mappingForClass:[ZLOddsPoolRunner class]];
        [oddsPoolRunnerMapping addAttributeMappingsFromDictionary:@{
                                                                    @"number": @"number",
                                                                    @"runner": @"runner",
                                                                    @"pp": @"pp",
                                                                    @"hi-pp": @"hi_pp",
                                                                    @"lo-pp": @"lo_pp",
                                                                    @"code": @"betType",
                                                                    @"odds": @"odds",
                                                                    @"total": @"total",
                                                                    @"currency": @"currency"
                                                                    }];
        
        RKRelationshipMapping * oddsPoolRunnerRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"runner" toKeyPath:@"oddsPoolRunners" withMapping:oddsPoolRunnerMapping];
        [oddsPoolMapping addPropertyMapping:oddsPoolRunnerRelationshipMapping];
        oddsPoolRunnerRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKRelationshipMapping * oddsPoolRunnerMultiLegRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"with" toKeyPath:@"withRunners" withMapping:oddsPoolRunnerMapping];
        [oddsPoolRunnerMapping addPropertyMapping:oddsPoolRunnerMultiLegRelationshipMapping];
        oddsPoolRunnerMultiLegRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKObjectMapping *myBetsTransactionMapping = [RKObjectMapping mappingForClass:[ZLBetTransaction class]];
        [myBetsTransactionMapping addAttributeMappingsFromDictionary:@{
                                                                       @"accountId": @"accountId",
                                                                       @"associationNo": @"associationNo",
                                                                       @"betAmount": @"betAmount",
                                                                       @"debit": @"debit",
                                                                       @"betType": @"betType",
                                                                       @"currentTime": @"currentTime",
                                                                       @"description": @"description",
                                                                       @"meet": @"meet",
                                                                       @"meetName": @"meetName",
                                                                       @"perf": @"perf",
                                                                       @"race": @"race",
                                                                       @"raceTime": @"raceTime",
                                                                       @"selection": @"selection",
                                                                       @"transactionType": @"transactionType",
                                                                       @"tsn": @"tsn",
                                                                       @"verificationNo": @"verificationNo",
                                                                       @"toteTimestamp": @"toteTimestamp",
                                                                       @"result": @"result",
                                                                       @"winningAmount":@"winningAmount"
                                                                       }];
        
        RKObjectMapping * myBetsMapping = [RKObjectMapping mappingForClass:[ZLMyBets class]];
        [myBetsMapping addAttributeMappingsFromDictionary:@{
                                                            @"number": @"number"
                                                            }];
        
        RKObjectMapping * myBetsTrackDetailsMapping = [RKObjectMapping mappingForClass:[ZLMyBetTrackDetails class]];
        [myBetsTrackDetailsMapping addAttributeMappingsFromDictionary:@{
                                                                        @"trackName": @"trackName",
                                                                        @"meet": @"meet",
                                                                        @"perf": @"perf"
                                                                        }];
        
        RKObjectMapping * myBetsRaceDetailsMapping = [RKObjectMapping mappingForClass:[ZLMyBetRaceDetails class]];
        [myBetsRaceDetailsMapping addAttributeMappingsFromDictionary:@{
                                                                       @"status": @"status",
                                                                       @"currentTime": @"currentTime",
                                                                       @"raceTime": @"raceTime",
                                                                       @"raceNumber": @"raceNumber",
                                                                       @"MTP": @"MTP"
                                                                       }];
        
        RKObjectMapping * loadCardTracksMapping = [RKObjectMapping mappingForClass:[ZLLoadCardTracks class]];
        [loadCardTracksMapping addAttributeMappingsFromDictionary:@{
                                                                    @"raceCardId": @"raceCardId",
                                                                    @"trackId": @"trackId",
                                                                    @"trackCountry": @"trackCountry",
                                                                    @"trackName": @"trackName",
                                                                    @"raceDate": @"raceDate",
                                                                    @"completeIndicator": @"completeIndicator",
                                                                    @"numberOfRaces": @"numberOfRaces",
                                                                    @"active": @"active",
                                                                    @"createdTs": @"createdTs",
                                                                    @"meetNumber": @"meet",
                                                                    @"performanceNumber": @"perf",
                                                                    @"trackCode":@"track_Code",
                                                                    @"breedType":@"breedType"
                                                                    }];
        
        
        
        RKRelationshipMapping * myBetsInPlayRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"inPlay" toKeyPath:@"inPlay" withMapping:myBetsTrackDetailsMapping];
        [myBetsMapping addPropertyMapping:myBetsInPlayRelationshipMapping];
        myBetsInPlayRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKRelationshipMapping * myBetsFinalRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"final" toKeyPath:@"final" withMapping:myBetsTrackDetailsMapping];
        [myBetsMapping addPropertyMapping:myBetsFinalRelationshipMapping];
        myBetsFinalRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKRelationshipMapping * myBetsRaceRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"raceArray" toKeyPath:@"raceArray" withMapping:myBetsRaceDetailsMapping];
        [myBetsTrackDetailsMapping addPropertyMapping:myBetsRaceRelationshipMapping];
        myBetsRaceRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKRelationshipMapping * myBetsTransactionRelationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"bets" toKeyPath:@"bets" withMapping:myBetsTransactionMapping];
        [myBetsRaceDetailsMapping addPropertyMapping:myBetsTransactionRelationshipMapping];
        myBetsTransactionRelationshipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKResponseDescriptor *responseDescriptor2 = [RKResponseDescriptor responseDescriptorWithMapping:raceDetailsMapping
                                                                                            pathPattern:getCardDetail
                                                                                                keyPath:@"response-content.cardDetail.races"
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor2];
        
        RKResponseDescriptor *responseDescriptor3 = [RKResponseDescriptor responseDescriptorWithMapping:myBetsTransactionMapping
                                                                                            pathPattern:mybetsinplay
                                                                                                keyPath:@"response-content"
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor3];
        
        RKResponseDescriptor *myBetsResponseDescriptor3 = [RKResponseDescriptor responseDescriptorWithMapping:myBetsMapping
                                                                                                  pathPattern:mybetsfinal
                                                                                                      keyPath:@"response-content"
                                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:myBetsResponseDescriptor3];
        
        RKResponseDescriptor *responseDescriptor4 = [RKResponseDescriptor responseDescriptorWithMapping:resultsMapping
                                                                                            pathPattern:getResultsWithDate
                                                                                                keyPath:@"response-content"
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor4];
        
        RKResponseDescriptor *responseDescriptor5 = [RKResponseDescriptor responseDescriptorWithMapping:resultsMapping
                                                                                            pathPattern:getResultsWithMeetAndPerf
                                                                                                keyPath:@"response-content"
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor5];
        
        RKResponseDescriptor *responseDescriptor6 = [RKResponseDescriptor responseDescriptorWithMapping:oddsPoolMapping
                                                                                            pathPattern:getQueryResult
                                                                                                keyPath:@"response-content.Xml.pool"
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor6];
        
        RKResponseDescriptor *responseDescriptor8 = [RKResponseDescriptor responseDescriptorWithMapping:loadCardTracksMapping
                                                                                            pathPattern:loadCardsArray
                                                                                                keyPath:@"response-content.raceCards"
                                                                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        [objectManager addResponseDescriptor:responseDescriptor8];
        
        
        
        //Pre-Login response mapping
        
        RKObjectMapping *preLoginResponseContentMapping = [RKObjectMapping mappingForClass:[SPPreLoginResponseContent class]];
        [preLoginResponseContentMapping addAttributeMappingsFromDictionary:@{@"Unique_Key": @"unique_Key",@"Json_Data_Id":@"json_Data_Id",@"Json_Schema_Id":@"json_Schema_Id"}];
        
        RKObjectMapping *preLoginJsonDataMapping = [RKObjectMapping mappingForClass:[SPPreLoginJsonData class]];
        [preLoginJsonDataMapping addAttributeMappingsFromDictionary:@{@"id": @"_id",@"logo":@"logo",@"name":@"name",@"title":@"title"}];
        
        RKObjectMapping *dateEntryMapping = [RKObjectMapping mappingForClass:[SPDateEntry class]];
        [dateEntryMapping addAttributeMappingsFromDictionary:@{@"Date": @"date"}];
        
        RKObjectMapping *spCarryOverMapping = [RKObjectMapping mappingForClass:[SPCarryOver class]];
        [spCarryOverMapping addAttributeMappingsFromDictionary:@{@"Trackname": @"trackname",
                                                                 @"PoolType": @"poolType",@"CarryOver":@"carryOver"}];
        
        RKRelationshipMapping *preLoginJsonDataRelationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"Json_Data" toKeyPath:@"json_Data" withMapping:preLoginJsonDataMapping];
        [preLoginResponseContentMapping addPropertyMapping:preLoginJsonDataRelationShipMapping];
        
        RKRelationshipMapping *preLoginDateEntryRelationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"DateEntries" toKeyPath:@"dateEntries" withMapping:dateEntryMapping];
        [preLoginJsonDataMapping addPropertyMapping:preLoginDateEntryRelationShipMapping];
        preLoginDateEntryRelationShipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        RKRelationshipMapping *spCarryOverRelationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"TrackList" toKeyPath:@"trackList" withMapping:spCarryOverMapping];
        [dateEntryMapping addPropertyMapping:spCarryOverRelationShipMapping];
        spCarryOverRelationShipMapping.assignmentPolicy = RKUnionAssignmentPolicy;
        
        
        RKResponseDescriptor *responseDescriptor7 = [RKResponseDescriptor responseDescriptorWithMapping:preLoginResponseContentMapping pathPattern:@"betfredcms/services/loadData" keyPath:@"response-content" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        [objectManager addResponseDescriptor:responseDescriptor7];
        
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"BetFred"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user-agent" value:[[WarHorseSingleton sharedInstance] iosVersionNo]];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"mobile-os" value:@"ios"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"ani" value:@"test"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"geofence" value:@"true"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"ip-address" value:@"test"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"context" value:@"test"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"app-open-timestamp" value:@"test"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client-version" value:@"test"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"unique-id" value:@"test"];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate, sdch"];//
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"device-token-id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"decvice_token"]];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
        
    }
    
    return  self;
}

- (void)headersLoading
{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user-agent" value:[[WarHorseSingleton sharedInstance] iosVersionNo]];

    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"device-token-id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"decvice_token"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"]];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-lat" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-long" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"UserPin"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"AccountID"]];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplUserName"]];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplPassword"]];
    }
    
}

#pragma mark - Registration


- (void)isAccountValid:(NSDictionary *)paraDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    
    
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];

    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:validateAccount
                                                parameters:paraDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"AUTH Failed - %@", error);
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
    
}




- (void)getIdologyWithParameters:(NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getIdology
                                                parameters:_params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       NSLog(@"getIdology %@",responseObject);
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"AUTH Failed - %@", error);
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}
//New Register User

- (void)registerUserWithdetails:(NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure

{
    
    [self headersLoading];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[_params valueForKey:@"user_name"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[_params valueForKey:@"user_password"]];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetRegisterUser
                                                parameters:_params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"AUTH Failed - %@", error);
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}
- (void)saveAdwUserWithdetails:(NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[_params valueForKey:@"user_name"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[_params valueForKey:@"user_password"]];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:saveAdwUser
                                                parameters:_params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //NSLog(@"REsponse Object is %@", responseObject);
                                                       
                                                       if( [responseObject isKindOfClass:[NSDictionary class]]){ //[operation.response statusCode] == 201 &&
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           NSString* _status = [_dict objectForKey:@"response-status"];
                                                           
                                                           if( [_status isEqualToString:@"success"]){
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success([_dict valueForKey:@"response-content"]);
                                                               });
                                                               
                                                           }
                                                           else{
                                                               if (failure) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       NSError * error = [NSError errorWithDomain:@"Totepool" code:400 userInfo:_dict];
                                                                       failure(error);
                                                                   });
                                                               }
                                                           }
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"AUTH Failed - %@", error);
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}

- (void)registerAdwUserWithDetails:(NSDictionary *)_params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[_params valueForKey:@"user_name"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[_params valueForKey:@"user_password"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_type" value:@"ADW"];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:RegisterAdwUser
                                                parameters:_params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //NSLog(@"REsponse Object is %@", responseObject);
                                                       
                                                       if( [responseObject isKindOfClass:[NSDictionary class]]){ //[operation.response statusCode] == 201 &&
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           NSString* _status = [_dict objectForKey:@"response-status"];
                                                           
                                                           if( [_status isEqualToString:@"success"]){
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(_dict);
                                                               });
                                                               
                                                           }
                                                           else{
                                                               if (failure) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       failure(nil);
                                                                   });
                                                               }
                                                           }
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"AUTH Failed - %@", error);
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}

- (void)saveAnonymousUser:(NSDictionary *) _userDetailsDict forUserType:(NSString *)user_type atLat:(NSString *)Latitude andLongitude:(NSString *)Longitude success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    [self headersLoading];
    NSLog(@"_userDetailsDict %@",_userDetailsDict);
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetSaveAnonymousUser
                                                parameters:_userDetailsDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}
//RegisterOndayPass User


- (void)registerForAnonymousUsers:(NSDictionary *)userDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    
    NSLog(@"Header UserDict %@",userDict);
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:registerAnonymousUsers
                                                parameters:userDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *registerDict = responseObject;
                                                               if (success) {
                                                                   success(registerDict);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

- (void)registerOneDayUserWithDetails:(NSString *)user_pin success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure

{
    [self headersLoading];
    
    NSDictionary *userDict = @{@"user_pin":user_pin};
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
    
    //account_id
    
    
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"MyWinnersCT"];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:createOneDayPassAccount
                                                parameters:userDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
    
    
}
- (void)saveAnonymousUser2:(NSDictionary *) _userDetailsDict forUserType:(NSString *)user_type atLat:(NSString *)Latitude andLongitude:(NSString *)Longitude success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_type" value:user_type];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetRegisterUser
                                                parameters:_userDetailsDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               //                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}

- (void)savePaperLessUser:(NSDictionary *) _userDetailsDict atLat:(NSString *)Latitude andLongitude:(NSString *)Longitude success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    
    [self headersLoading];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetSaveAnonymousUser
                                                parameters:_userDetailsDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}

-(void) authenticateUser:(NSString*) _user_id withPassword:(NSString*) _pwd
                     Pin:(NSString*) _pn
                     Lat:(NSString *)latitude
                  andLon:(NSString *)longitude
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSError *))failure {
    
    
    self.username = _user_id;
    self.password = _pwd;
    //self.pin = _pn;
    
    [self headersLoading];
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplUserName"]];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplPassword"]];
    }
    if ([_pn isEqualToString:@"QRCodeScanner"]){
        
        if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
            [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"QRCodePin"]];

        }
        else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
            [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"QRCodePin"]];

        }

        
    }
    
    [[[RKObjectManager sharedManager] HTTPClient] getPath:Login
                                               parameters:nil
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                                      NSLog(@"REsponse Object is %@", responseObject);
                                                      
                                                      if( [responseObject isKindOfClass:[NSDictionary class]]){ //[operation.response statusCode] == 201 &&
                                                          NSDictionary* _dict = (NSDictionary*)responseObject;
                                                          
                                                          NSString* _status = [_dict objectForKey:@"response-status"];
                                                          
                                                          if( [_status isEqualToString:@"success"]){
                                                              
                                                              if (success) {
                                                                  
                                                                  [[NSUserDefaults standardUserDefaults]setObject:[[_dict objectForKey:@"response-content"] objectForKey:@"first_name"] forKey:@"firstname"];
                                                                  [[NSUserDefaults standardUserDefaults]setObject:[[_dict objectForKey:@"response-content"] objectForKey:@"last_name"] forKey:@"lastname"];
                                                                  
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      success(_dict);
                                                                      
                                                                      [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
                                                                      [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
                                                                      [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
                                                                      [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
                                                                      [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"device-token-id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"decvice_token"]];
                                                                      
                                                                      //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_type" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"user_type"]];
                                                                      
                                                                      
                                                                      //[self refreshBalance:NO success:nil failure:nil];
//                                                                      [self getFavorites:nil failure:nil];
                                                                      
                                                                  });
                                                              }
                                                              
                                                          }
                                                          else{
                                                              if (failure) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      failure(nil);
                                                                  });
                                                              }
                                                          }
                                                      }
                                                      else{
                                                          if (failure) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  failure(nil);
                                                              });
                                                          }
                                                      }
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      NSLog(@"AUTH Failed - %@", error);
                                                      if (failure) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              failure(error);
                                                          });
                                                      }
                                                  }];
}

- (void)resetUserPasswordWithParameters:(NSDictionary *)_params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetresetPassword parameters:_params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if( [responseObject isKindOfClass:[NSDictionary class]]){ //[operation.response statusCode] == 201 &&
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           //NSLog(@"refresh _dict %@",_dict);
                                                           
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(_dict);
                                                               });
                                                           }
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

- (void)logoutUserWithParameters:(NSDictionary *)_params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:logout parameters:_params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if( [responseObject isKindOfClass:[NSDictionary class]]){ //[operation.response statusCode] == 201 &&
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           //NSLog(@"refresh _dict %@",_dict);
                                                           
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(_dict);
                                                                   
                                                                   [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
                                                                   [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
                                                                   [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
                                                                   [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
                                                                   //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_type" value:@""];
                                                                   
                                                               });
                                                           }
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}


#pragma mark - Wager API

-(void) loadRaceCards:(BOOL) alert
              success:(void (^)(NSDictionary* _userInfo))success
              failure:(void (^)(NSError *error))failure{
    
    //static int mtp[] = {0,3,6,9,12,15,19,6,4,8,10};
    [self headersLoading];
    
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred" forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"]];
    
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    [objectManager getObjectsAtPath:kGetCards
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                NSLog(@"mappingResult %@",mappingResult);

                                NSMutableArray * favoriteTracks = [[ZLAppDelegate getAppData].dictFavorites objectForKey:@"Tracks"];
                                for(ZLRaceCard * raceCard in [mappingResult array]){
                                    
                                    
                                    if ([favoriteTracks containsObject:[NSNumber numberWithInt:raceCard.favTrackCode]]) {
                                        raceCard.favorite = YES;
                                    }
                                    
                                    //raceCard.minutesToPost = mtp[raceCard.cardId]; //Data generation - should be commented
                                    //if( raceCard.cardId == 5){
                                    //raceCard.currentRaceStatus = @"OFFICIAL";
                                    //}
                                    
                                    
                                    ZLRaceCard * oldRaceCard = [ZLRaceCard findRaceCardById:raceCard.cardId];
                                    if( oldRaceCard ){
                                        raceCard.cardDetails = oldRaceCard.cardDetails;
                                    }
                                }
                            
                                [ZLAppDelegate getAppData].raceCards = [mappingResult array];
//                                NSLog(@"[ZLAppDelegate getAppData].raceCards %@",[ZLAppDelegate getAppData].raceCards);
                                
                                NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"minutesToPost" ascending:YES];
                                NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"currentRaceStatus" ascending:YES];
                                NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor2, sortDescriptor,nil];
                                [ZLAppDelegate getAppData].raceCards = [[ZLAppDelegate getAppData].raceCards sortedArrayUsingDescriptors:sortDescriptors];
//                                NSLog(@"After shorting raceCards %@",[ZLAppDelegate getAppData].raceCards);

                                NSDictionary* _dict = @{@"results":[mappingResult array]};
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        success(_dict);
                                    });
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (failure) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if( alert ){
                                            [self showErrorMessageAndBailOut:error];
                                        }
                                        failure(error);
                                    });
                                }
                            }];
    
}

- (void)refreshBalance:(BOOL) alert
               success:(void (^)(NSDictionary* _userInfo))success
               failure:(void (^)(NSError *error))failure{
    [self headersLoading];
    
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    [[[RKObjectManager sharedManager] HTTPClient] getPath:AvailableBalance parameters:nil
                                                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                      //NSLog(@"responseObject %@",responseObject);
                                                      
                                                      if( [responseObject isKindOfClass:[NSDictionary class]]){ //[operation.response statusCode] == 201 &&
                                                          NSDictionary* _dict = (NSDictionary*)responseObject;
                                                          NSString * balanceAmount = [_dict objectForKey:@"response-content"];
                                                          [ZLAppDelegate getAppData].balanceAmount = [balanceAmount doubleValue] / 100.0;
                                                          [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:@"BalanceUpdated" object:self userInfo:nil];
                                                          if (success) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  success(_dict);
                                                              });
                                                          }
                                                      }
                                                      else{
                                                          if (failure) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  failure(nil);
                                                              });
                                                          }
                                                      }
                                                  }
                                                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                      if (failure) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              if( alert ){
                                                                  [self showErrorMessageAndBailOut:error];
                                                              }
                                                              failure(error);
                                                          });
                                                      }
                                                  }];
    
}


-(void) loadTrackDetails:(NSDictionary *) _params alert:(BOOL) alert
                 success:(void (^)(NSDictionary* _userInfo))success
                 failure:(void (^)(NSError *error))failure{
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    
    NSLog(@"_params %@",_params);
    //VVH
    [objectManager getObjectsAtPath:getCardDetail
                         parameters:_params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                ZLRaceCard * _race_card = [ZLRaceCard findRaceCardById:[[_params valueForKey:@"cardId"] intValue]];
                                if(_race_card){
                                    _race_card.cardDetails = [mappingResult array];
                                    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
                                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                    _race_card.cardDetails = [_race_card.cardDetails sortedArrayUsingDescriptors:sortDescriptors];
                                   
                                    for( ZLRaceDetails * raceDetails in _race_card.cardDetails){
                                        NSLog(@"raceDetails %@",raceDetails.spFavShortName);
                                        NSLog(@"raceDetails %@",raceDetails);

                                        for( ZLBetType * betType in raceDetails.betTypes){
                                            if( [betType.name isEqualToString:@"WIN" ] || [betType.name isEqualToString:@"PLC" ] || [betType.name isEqualToString:@"SHW" ] || [betType.name isEqualToString:@"EW" ] ||
                                               [betType.name isEqualToString:@"WS" ] || [betType.name isEqualToString:@"PS" ] || [betType.name isEqualToString:@"SHW" ] || [betType.name isEqualToString:@"WPS" ] || [betType.name isEqualToString:@"PKK" ]){
                                            }
                                            else if( [betType.name rangeOfString:@"W_"].location != NSNotFound){
                                                
                                            }
                                            else{
                                                [raceDetails.extraBetTypes addObject:betType.name];
                                            }
                                        }
                                        
                                        for(ZLRunner * runner in raceDetails.runners){
                                            runner.runner_id = [runner.runnerNumber intValue];
                                        }
                                        
                                        NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"runner_id" ascending:YES];
                                        NSSortDescriptor * sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"runnerNumber" ascending:YES];
                                        NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, sortDescriptor2,nil];
                                        raceDetails.runners = [NSMutableArray arrayWithArray:[raceDetails.runners sortedArrayUsingDescriptors:sortDescriptors]];
                                    }
                                    NSDictionary* _dict = @{@"results":[mappingResult array]};
                                    if (success) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            success(_dict);
                                        });
                                    }
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                if (failure) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        if( alert ){
                                            [self showErrorMessageAndBailOut:error];
                                        }
                                        failure(error);
                                    });
                                }
                            }];
    
}

-(void) validateBetAmountForWager:(ZLWager*) wager
                          success:(void (^)(NSDictionary* _userInfo))success
                          failure:(void (^)(NSError *error))failure{
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    ZLRaceCard *raceCard = [ZLRaceCard findRaceCardByMeetNumber:wager.selectedRaceMeetNumber AndPerformanceNumber:wager.selectedRacePerformanceNumber];
    
    if( raceCard ){
        ZLRaceDetails * currentRace = [raceCard findRaceDeatilsByRaceId:wager.selectedRaceId];
        NSLog(@"racecard %@",currentRace.runners);

        ZLBetType* betType = [currentRace findBetTypeWithName:wager.selectedBetType];
        int numCombos = [ZLWagerUtility getNumCombos:wager];
        
        
        NSMutableDictionary * dictBetType = [NSMutableDictionary dictionaryWithDictionary:@{@"allowFractionalBetAmt":((betType.allowFractionalBetAmt) ? @"true":@"false"),@"boxTypeID":[ZLWagerUtility getBetTypeIdFromString:betType.boxTypeID],@"canHarryBoy":((betType.canHarryBoy) ? @"true":@"false"),@"longName":betType.longName,@"maxBetAmt":[NSString stringWithFormat:@"%d",betType.maxBetAmt],@"minBetAmt":[NSString stringWithFormat:@"%d",betType.minBetAmt],@"name":[ZLWagerUtility getBetTypeIdFromString:betType.name],@"numLegs":[NSString stringWithFormat:@"%d",betType.numLegs],@"poolTypeID":[ZLWagerUtility getBetTypeIdFromString:betType.poolTypeID],@"requiresHalfUnitBetAmt":((betType.requiresHalfUnitBetAmt) ? @"true":@"false"),@"requiresMultOfMinBetAmt":((betType.requiresMultOfMinBetAmt) ? @"true":@"false"),@"name":betType.name,@"specialMaxBetAmt":[NSString stringWithFormat:@"%d",betType.specialMaxBetAmt],@"specialMaxNumCombos":[NSString stringWithFormat:@"%d",betType.specialMaxNumCombos],@"specialMinBetAmt":[NSString stringWithFormat:@"%d",betType.specialMinBetAmt],@"specialMinNumCombos":[NSString stringWithFormat:@"%d",betType.specialMinNumCombos],@"typeID":[ZLWagerUtility getBetTypeIdFromString:betType.typeID]}];
        NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"cardNum":[NSString stringWithFormat:@"%d",raceCard.cardId],@"stake":[NSString stringWithFormat:@"%.0f",(wager.amount * 100.0)],@"cost":[NSString stringWithFormat:@"%.0f",(wager.amount * 100 * numCombos)], @"race":[NSString stringWithFormat:@"%d",currentRace.number],@"numOfCombos":[NSString stringWithFormat:@"%d",numCombos],@"betType":dictBetType}];
        
        [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
        [[[RKObjectManager sharedManager] HTTPClient] postPath:isBetAmtValid
                                                    parameters:jsonDict
                                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               NSDictionary* dict = (NSDictionary*)responseObject;
                                                               NSString *responseStatus = [responseObject valueForKey:@"response-status"];
                                                               //NSLog(@"responseStatus %@",responseStatus);
                                                               if ([responseStatus isEqualToString:@"success"]){
                                                                   BOOL validAmount = [[[dict objectForKey:@"response-content"] objectForKey:@"isBetAmtValid"] boolValue];
                                                                   if (validAmount) {
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           success(nil);
                                                                       });
                                                                   }
                                                               }
                                                               else{
                                                                   if (failure) {
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           failure(nil);
                                                                       });
                                                                   }
                                                               }
                                                           }
                                                           else{
                                                               
                                                               if (failure) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       failure(nil);
                                                                   });
                                                               }
                                                           }
                                                       }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [self showErrorMessageAndBailOut:error];
                                                                   failure(error);
                                                               });
                                                           }
                                                       }];
        
    }
    
}

-(void) placeWager:(ZLWager*) _wager
           success:(void (^)(NSDictionary* _userInfo))success
           failure:(void (^)(NSError *error))failure{
    
    [self headersLoading];
    NSString *userName;
    NSString *userPassword;
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        userPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    }
    else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplUserName"]];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplPassword"]];
        
        userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"CplUserName"];
        userPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"CplPassword"];
    }
    
    
    else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"AccountID"];
        userPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserPin"];
    }else{
        userName = @"test";
        userPassword = @"test";
        
    }
    NSLog(@"PlaceBet User %@ %@",userName,userPassword);
    
    
    
    
    
    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    if(_race_card){
        ZLRaceDetails * currentRace = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
        
        ZLBetType* _bet_type = [currentRace findBetTypeWithName:[ZLAppDelegate getAppData].currentWager.selectedBetType];
        NSString * selectedBetType = [ZLAppDelegate getAppData].currentWager.selectedBetType;
        int numCombos = [ZLWagerUtility getNumCombos:[ZLAppDelegate getAppData].currentWager];
        
        
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"user_id":userName,@"user_password":userPassword,@"meet":[NSString stringWithFormat:@"%d",_race_card.meetNumber],@"performance":[NSString stringWithFormat:@"%d",_race_card.performanceNumber],@"card_Num":[NSString stringWithFormat:@"%d",_race_card.cardId],@"race_Num":[NSString stringWithFormat:@"%d",currentRace.number],@"bet_Type":[ZLWagerUtility getBetTypeIdFromString:[ZLAppDelegate getAppData].currentWager.selectedBetType],@"num_legs":[NSString stringWithFormat:@"%d",_bet_type.numLegs],@"stake":[NSString stringWithFormat:@"%.0f",([ZLAppDelegate getAppData].currentWager.amount * 100.0)],@"bet_cost":[NSString stringWithFormat:@"%.0f",([ZLAppDelegate getAppData].currentWager.amount * 100.0 * numCombos)],@"serial_Num":@""}];
        
        NSLog(@"jsonDict %@",jsonDict);
        
        if([selectedBetType isEqualToString:@"DBL"]|| [selectedBetType isEqualToString:@"PK3"] || [selectedBetType isEqualToString:@"PK4"] || [selectedBetType isEqualToString:@"PK5"] || [selectedBetType isEqualToString:@"PK6"]|| [selectedBetType isEqualToString:@"PK7"] || [selectedBetType isEqualToString:@"PK8"] || [selectedBetType isEqualToString:@"PK9"] || [selectedBetType isEqualToString:@"P10"] || [selectedBetType isEqualToString:@"DD"]||[selectedBetType isEqualToString:@"QPT"]||[selectedBetType isEqualToString:@"PLP"]||[selectedBetType isEqualToString:@"JPT"]||[selectedBetType isEqualToString:@"SP7"]||[selectedBetType isEqualToString:@"SC6"]){
            
            NSMutableDictionary * runners= [ZLAppDelegate getAppData].currentWager.selectedRunners;
            NSMutableArray * _json_runners = [NSMutableArray array];
            for(int i = 0;i<[runners count];i++){
                ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId + i];
                NSMutableArray * _arr = [runners objectForKey:[NSString stringWithFormat:@"%d",i]];
                NSLog(@"_arr %@",_arr);
                NSMutableArray * _leg_runners = [NSMutableArray array];
                if(_arr != nil){
                    for(NSString * _runner_id in _arr){
                        NSLog(@"_runner_id %@",_runner_id);
                        
                        ZLRunner * _runner = [_race_details findRunnerWithNumber:_runner_id];
                        NSLog(@"Runner ID %d",_runner.runner_id);
                        
//                        if(_runner){
                            NSDictionary *dictRunners = @{@"jockey":@"",@"number":[NSString stringWithFormat:@"%d",_runner.runner_id],@"scratched":_runner.scratched ? @"true":@"false",@"winOdds":@""};
                            [_leg_runners addObject:dictRunners];
                        //}
                    }
                    [_json_runners addObject:_leg_runners];
                }
            }
            [jsonDict setValue:_json_runners forKey:@"runners"];
        }
        else if( [selectedBetType isEqualToString:@"EBX"] || [selectedBetType isEqualToString:@"TBX"] || [selectedBetType isEqualToString:@"SFX"]){
            [jsonDict setValue:@"1" forKey:@"num_legs"];
            ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
            if(_race_details){
                ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
                if(_race_details){
                    NSMutableDictionary * runners= [ZLAppDelegate getAppData].currentWager.selectedRunners;
                    NSMutableArray * _json_runners = [NSMutableArray array];
                    for(int i = 0;i<1;i++){
                        NSMutableArray * _arr = [runners objectForKey:[NSString stringWithFormat:@"%d",i]];
                        NSMutableArray * _leg_runners = [NSMutableArray array];
                        if(_arr != nil){
                            for(NSString * _runner_id in _arr){
                                ZLRunner * _runner = [_race_details findRunnerWithNumber:_runner_id];
                                if(_runner){
                                    NSDictionary *dictRunners = @{@"jockey":@"",@"number":[NSString stringWithFormat:@"%d",_runner.runner_id],@"scratched":_runner.scratched ? @"true":@"false",@"winOdds":@""};
                                    [_leg_runners addObject:dictRunners];
                                }
                            }
                            [_json_runners addObject:_leg_runners];
                        }
                    }
                    [jsonDict setValue:_json_runners forKey:@"runners"];
                }
            }
            
        }
        else{
            ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
            if(_race_details){
                ZLRaceDetails * _race_details = [_race_card findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
                if(_race_details){
                    NSMutableDictionary *runners= [ZLAppDelegate getAppData].currentWager.selectedRunners;
                    NSMutableArray * _json_runners = [NSMutableArray array];
                    for(int i = 0;i<[runners count];i++){
                        NSMutableArray * _arr = [runners objectForKey:[NSString stringWithFormat:@"%d",i]];
                        NSMutableArray * _leg_runners = [NSMutableArray array];
                        if(_arr != nil){
                            for(NSString * _runner_id in _arr){
                                ZLRunner * _runner = [_race_details findRunnerWithNumber:_runner_id];
                                if(_runner){
                                    NSDictionary *dictRunners = @{@"jockey":@"",@"number":[NSString stringWithFormat:@"%d",_runner.runner_id],@"scratched":_runner.scratched ? @"true":@"false",@"winOdds":@""};
                                    [_leg_runners addObject:dictRunners];
                                }
                            }
                            [_json_runners addObject:_leg_runners];
                        }
                    }
                    [jsonDict setValue:_json_runners forKey:@"runners"];
                }
            }
        }
//        NSLog(@"final dict %@",jsonDict);
        [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
        [[[RKObjectManager sharedManager] HTTPClient] postPath:placeBet
                                                    parameters:jsonDict
                                                       success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               NSDictionary* _dict = (NSDictionary*)responseObject;
                                                               // NSLog(@"Place Bet%@", _dict);
                                                               if( [[_dict objectForKey:@"response-status"] isEqualToString:@"success"] ){
                                                                   if (success) {
                                                                       [ZLAppDelegate getAppData].currentWager.tsnNumber = [[_dict objectForKey:@"response-content"] objectForKey:@"TSN"];
                                                                       NSDictionary* _userInfo = @{@"tsn-details":[_dict objectForKey:@"response-content"]};
                                                                       if (success) {
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               success(_userInfo);
                                                                           });
                                                                       }
                                                                       [self refreshBalance:NO success:nil failure:nil];
                                                                       
                                                                       
                                                                   }
                                                               }
                                                               else{
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       NSError *error = [NSError errorWithDomain:@"error" code:400 userInfo:_dict];
                                                                       failure(error);
                                                                   });
                                                               }
                                                           }
                                                           else{
                                                               
                                                               if (failure) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       failure(nil);
                                                                   });
                                                               }
                                                           }
                                                       }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(error);
                                                               });
                                                           }
                                                       }];
        
    }
    
    
}

-(void) cancelWager:(NSMutableDictionary*) transaction
            success:(void (^)(NSDictionary* _userInfo))success
            failure:(void (^)(NSError *error))failure{
    
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"TSN":[transaction valueForKey:@"tsn"]}];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:CancelBet
                                                parameters:jsonDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if( [responseObject isKindOfClass:[NSDictionary class]]){ //[operation.response statusCode] == 201 &&
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           //NSLog(@"_dict %@",_dict);
                                                           NSString* status = [_dict objectForKey:@"response-status"];
                                                           
                                                           if( [status isEqualToString:@"success"]){
                                                               if (success) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       success(_dict);
                                                                   });
                                                               }
                                                               [self refreshBalance:NO success:nil failure:nil];
                                                           }
                                                           else{
                                                               if (failure) {
                                                                   NSError * error = [[NSError alloc] initWithDomain:@"DigitalLink" code:NSURLErrorBadServerResponse userInfo:@{@"response":_dict}];
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       failure(error);
                                                                   });
                                                               }
                                                           }
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

-(void) getTracksResultsForDate:(NSDate*) date
                        success:(void (^)(NSDictionary* _userInfo))success
                        failure:(void (^)(NSError *error))failure{
    
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"date":[formatter stringFromDate:date],@"detailsFlag":@"false"}];
        [self headersLoading];
        
        //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
        //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
        
        [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
        [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
        //NSLog(@"loadaray %@",jsonDict);
        [[RKObjectManager sharedManager] postObject:jsonDict path:loadCardsArray parameters:jsonDict
                                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                {
                                                    
                                                    NSArray * results = [mappingResult array];
                                                    NSLog(@"Results is %@", results);
                                                    NSMutableArray * resultsByTrack = nil;
                                                    if( !resultsByTrack ){
                                                        resultsByTrack = [NSMutableArray array];
                                                        [[ZLAppDelegate getAppData].dictTrackResultsByDate setValue:resultsByTrack forKey:[formatter stringFromDate:date]];
                                                    }
                                                    for( ZLLoadCardTracks * trackResult in [mappingResult array]){
                                                        
                                                        if (trackResult.meet == 0 || trackResult.perf == 0 ){
                                                            //NSLog(@"meet is zero === %d pref %d",trackResult.meet,trackResult.perf);
                                                            
                                                        }else{
                                                            [resultsByTrack addObject:trackResult];
                                                            
                                                        }
                                                        
                                                        [[ZLAppDelegate getAppData].dictTrackResultsByDate setValue:trackResult forKey:[NSString stringWithFormat:@"%d_%d",trackResult.meet, trackResult.perf]];
                                                        
                                                        
                                                    }
                                                    
                                                    NSDictionary* _userInfo = @{};
                                                    if (success) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            success(_userInfo);
                                                        });
                                                    }
                                                    
                                                }
                                            }
                                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                if (failure) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        [self showErrorMessageAndBailOut:error];
                                                        failure(error);
                                                    });
                                                }
                                            }];
        
    }
    @catch (id ex) {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(nil);
            });
        }
    }
    @finally {
        if (failure) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(nil);
            });
        }
    }
    
}

-(void) getRaceResultsByMeet:(int) meet WithPerf:(int) perf dateStr:(NSString *)dateStr success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure{
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"meet":[NSString stringWithFormat:@"%d",meet],@"perf":[NSString stringWithFormat:@"%d",perf],@"date":dateStr}];
    
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
    
    [errorMapping addPropertyMapping: [RKAttributeMapping attributeMappingFromKeyPath:@"error" toKeyPath:@"errorMessage"]];
    RKResponseDescriptor *errorResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)];
    [[RKObjectManager sharedManager] addResponseDescriptor:errorResponseDescriptor];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[RKObjectManager sharedManager] postObject:jsonDict path:getResultsWithMeetAndPerf parameters:jsonDict
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            {
                                                
                                                NSArray * results = [mappingResult array];
                                                if(results == nil || [results count] == 0){
                                                    if (failure) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            failure(nil);
                                                        });
                                                    }
                                                    return;
                                                }
                                                ZLLoadCardTracks * track = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[NSString stringWithFormat:@"%d_%d",meet, perf]];
                                                if( track && [track.trackResults count] > 0){
                                                    track = nil; //to avoid duplicates
                                                }
                                                for( ZLTrackResults * trackResult in [mappingResult array]){
                                                    
                                                    for( ZLFinisher * finisher in trackResult.finishers){
                                                        [trackResult.finishersByPosition addObject:finisher];
                                                        if( ( (finisher.winPayOff != nil && finisher.winPayOff.length > 0 ) || (finisher.shwPayOff != nil && finisher.shwPayOff.length > 0 ) || (finisher.plcPayOff != nil && finisher.plcPayOff.length > 0 )  ) ){
                                                            [trackResult.winnersByPosition addObject:finisher];
                                                        }
                                                    }
                                                    
                                                    trackResult.numberofBetRunners = 0;
                                                    trackResult.betsForRendering = [NSMutableArray array];
                                                    for( ZLBetResult * betResult in trackResult.bets ){
                                                        for(ZLBetResultRunner * runner in betResult.runners){
                                                            trackResult.numberofBetRunners++;
                                                            runner.betCode = betResult.betCode;
                                                            [trackResult.betsForRendering addObject:runner];
                                                        }
                                                    }
                                                    
                                                    NSSortDescriptor * sortBetTypeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"betCode" ascending:YES];
                                                    NSArray *sortBetTypeDescriptors = [NSArray arrayWithObject:sortBetTypeDescriptor];
                                                    trackResult.betsForRendering = [NSMutableArray arrayWithArray:[trackResult.betsForRendering sortedArrayUsingDescriptors:sortBetTypeDescriptors]];
                                                    
                                                    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:YES];
                                                    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                    trackResult.winnersByPosition = [NSMutableArray arrayWithArray:[trackResult.winnersByPosition sortedArrayUsingDescriptors:sortDescriptors]];
                                                    trackResult.finishersByPosition = [NSMutableArray arrayWithArray:[trackResult.finishersByPosition sortedArrayUsingDescriptors:sortDescriptors]];
                                                    [[ZLAppDelegate getAppData].dictResultsByMeetPerfRace setValue:trackResult forKey:[NSString stringWithFormat:@"%d_%d_%d",trackResult.meet, trackResult.perf, trackResult.race]];
                                                    if( track ){
                                                        [track.trackResults addObject:trackResult];
                                                    }
                                                }
                                                
                                                NSDictionary* _userInfo = @{};
                                                if (success) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        success(_userInfo);
                                                    });
                                                }
                                                
                                            }
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            if (failure) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self showErrorMessageAndBailOut:error];
                                                    failure(error);
                                                });
                                            }
                                        }];
    
}


-(void) getRaceOddsByMeet:(int) meet WithPerf:(int) perf AndRace:(int) race
                  success:(void (^)(NSDictionary* _userInfo))success
                  failure:(void (^)(NSError *error))failure{
    
    [self headersLoading];
    
    NSMutableDictionary * jsonQueryParams = [NSMutableDictionary dictionaryWithDictionary:@{@"meet":[NSString stringWithFormat:@"%d",meet],@"perf":[NSString stringWithFormat:@"%d",perf],@"race":[NSString stringWithFormat:@"%d",race]}];
    NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"queryName":@"odds",@"queryParams":jsonQueryParams}];
    

    
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[RKObjectManager sharedManager] postObject:jsonDict path:getQueryResult parameters:jsonDict
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            {
                                                
                                                NSArray * results = [mappingResult array];
                                                for( ZLOddsPool * pool in results){
                                                    NSLog(@"pool %@",pool);
//                                                    NSLog(@"Veeru %@",[NSString stringWithFormat:@"%d_%d_%d_%@",meet, perf, race, pool.betType]);
                                                    [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace setValue:pool forKey:[NSString stringWithFormat:@"%d_%d_%d_%@",meet, perf, race, pool.betType]];
                                                }
//                                                NSLog(@"%@", results);
//                                                NSLog(@"Veeru %@",[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace);
                                                
                                                NSDictionary* _userInfo = @{};
                                                if (success) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        success(_userInfo);
                                                    });
                                                }
                                                
                                            }
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            if (failure) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self showErrorMessageAndBailOut:error];
                                                    failure(error);
                                                });
                                            }
                                        }];
    
}

-(void) updateFavoriteTracks:(NSDictionary*) favoriteTrackDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure{
    
    //NSMutableDictionary * jsonQueryParams = [NSMutableDictionary dictionaryWithDictionary:@{@"favorite_tracks":favoriteTracks,@"favorite_runners":@""}];
    
    

    
    [self headersLoading];
    
    /*
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[RKObjectManager sharedManager] postObject:favoriteTrackDict path:SaveUserPreferences parameters:favoriteTrackDict
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            {
                                                NSDictionary* userInfo = @{};
                                                if (success) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        success(userInfo);
                                                    });
                                                }
                                            }
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            if (failure) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self showErrorMessageAndBailOut:error];
                                                    failure(error);
                                                });
                                            }
                                        }];*/
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:SaveUserPreferences parameters:favoriteTrackDict
                                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                        {
                                                            NSDictionary* userInfo = @{};
                                                            if (success) {
                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                    success(userInfo);
                                                                });
                                                            }
                                                        }
                                                    }
                                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                        if (failure) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [self showErrorMessageAndBailOut:error];
                                                                failure(error);
                                                            });
                                                        }
                                                    }];
    
}

-(void)getFavorites:(NSDictionary*) favoriteTrackDic success:(void (^)(NSDictionary* _userInfo))success
            failure:(void (^)(NSError *error))failure{
    [self headersLoading];
    
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:UserPreferences
                                                parameters:nil
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       {
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               
                                                               NSDictionary* dict = (NSDictionary*)responseObject;
                                                               NSLog(@"dict %@",dict);
                                                               [ZLAppDelegate getAppData].dictFavorites = nil ;
                                                               [[ZLAppDelegate getAppData] clearCurrentFavoriteTracks];
                                                               
                                                               NSMutableArray *favoriteTracks = [[ZLAppDelegate getAppData].dictFavorites objectForKey:@"Tracks"];
                                                               
                                                               NSString* favoriteTrackIds = [[dict objectForKey:@"response-content"] objectForKey:@"Favorite_Tracks"];
                                                               if( favoriteTrackIds != nil && favoriteTrackIds.length > 0){
                                                                   NSArray * tracks = [favoriteTrackIds componentsSeparatedByString:@","];
                                                                   tracks = [[NSSet setWithArray:tracks] allObjects];
                                                                   if( [tracks count] > 0 ){
                                                                       for( NSString * trackId in tracks){
                                                                           [favoriteTracks addObject:[NSNumber numberWithInt:[trackId intValue]]];
                                                                           ZLRaceCard * raceCard = [ZLRaceCard findRaceCardByMeetNumber:[trackId intValue]];
                                                                           if( raceCard != nil){
                                                                               raceCard.favorite = YES;
                                                                           }
                                                                       }
                                                                       
                                                                   }
                                                               }
                                                               NSDictionary* userInfo = @{};
                                                               if (success) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       success(userInfo);
                                                                   });
                                                               }
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                       failure(nil);
                                                                   });
                                                               }
                                                           }
                                                           
                                                     
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

#pragma mark - My Bets API
/*
-(void) loadNewMyBets:(NSDate *) _date
              success:(void (^)(NSDictionary* _userInfo))success
              failure:(void (^)(NSError *error))failure{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"fromDate":[formatter stringFromDate:_date],@"toDate":[formatter stringFromDate:_date]}]; //
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[RKObjectManager sharedManager] postObject:jsonDict path:myBets1 parameters:jsonDict
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            {
                                                
                                                NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"MTP" ascending:YES];
                                                NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
                                                NSArray *sortedArray = [[mappingResult array] sortedArrayUsingDescriptors:sortDescriptors];
                                                
                                                
                                                for( ZLMyBets * myBets in sortedArray){
                                                    [[ZLAppDelegate getAppData].dictMyBets setValue:myBets forKey:[formatter stringFromDate:_date]]; //There will be only one object
                                                }
                                                
                                                NSDictionary* _userInfo = @{};
                                                if (success) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        success(_userInfo);
                                                    });
                                                }
                                                
                                            }
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            if (failure) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self showErrorMessageAndBailOut:error];
                                                    failure(error);
                                                });
                                            }
                                        }];
}
*/
-(void) loadMyBets:(NSDate *) _date
           success:(void (^)(NSDictionary* _userInfo))success
           failure:(void (^)(NSError *error))failure{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"fromDate":[formatter stringFromDate:_date],@"toDate":[formatter stringFromDate:_date]}]; //
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[RKObjectManager sharedManager] postObject:jsonDict path:kGetCards parameters:jsonDict
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                            {
                                                NSMutableArray * tempTransaction = [NSMutableArray array];
                                                for( ZLBetTransaction * _transaction in [mappingResult array]){
                                                    if( _transaction.meet != 0 ){
                                                        [tempTransaction addObject:_transaction];
                                                    }
                                                }
                                                NSMutableDictionary * myBets = [NSMutableDictionary dictionary];
                                                
                                                for( ZLBetTransaction * _transaction in tempTransaction){
                                                    NSString * betId = [NSString stringWithFormat:@"%d_%d_%d",_transaction.meet, _transaction.perf, _transaction.race];
                                                    NSMutableArray * raceBets = [myBets objectForKey:betId];
                                                    if( raceBets == nil){
                                                        raceBets = [NSMutableArray array];
                                                        [myBets setObject:raceBets forKey:betId];
                                                    }
                                                    [raceBets addObject:_transaction];
                                                }
                                                
                                                NSArray * myBetsArray = [myBets allValues];
                                                NSMutableArray * mySortedBets = [NSMutableArray arrayWithArray:[myBetsArray sortedArrayUsingComparator:^NSComparisonResult(NSMutableArray * a, NSMutableArray * b){
                                                    
                                                    NSDate * aLatestDate = nil;
                                                    NSDate * bLatestDate = nil;
                                                    for( ZLBetTransaction * _transaction in a){
                                                        if( aLatestDate == nil){
                                                            aLatestDate = _transaction.toteTimestamp;
                                                        }
                                                        else if ( [aLatestDate compare:_transaction.toteTimestamp] == NSOrderedAscending ){
                                                            aLatestDate = _transaction.toteTimestamp;
                                                        }
                                                    }
                                                    
                                                    for( ZLBetTransaction * _transaction in b){
                                                        if( bLatestDate == nil){
                                                            bLatestDate = _transaction.toteTimestamp;
                                                        }
                                                        else if ( [bLatestDate compare:_transaction.toteTimestamp] == NSOrderedAscending ){
                                                            bLatestDate = _transaction.toteTimestamp;
                                                        }
                                                    }
                                                    
                                                    return [bLatestDate compare:aLatestDate];
                                                }]];
                                                
                                                [ZLAppDelegate getAppData].myBets = mySortedBets;
                                                
                                                
                                                NSDictionary* _userInfo = @{};
                                                if (success) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        success(_userInfo);
                                                    });
                                                }
                                                
                                            }
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            if (failure) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self showErrorMessageAndBailOut:error];
                                                    failure(error);
                                                });
                                            }
                                        }];
}

- (void)loadMyBetsDataFromDate:(NSString *)_fromDateStr betsFlag:(NSString*)betsFlag toDate:(NSString *)_toDateStr success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    
    
    NSMutableDictionary * jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"fromDate":_fromDateStr ,@"toDate":_toDateStr}];
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    //inPlay
    NSString *mybetsAPI;
    if ([betsFlag isEqualToString:@"inPlay"]){
        mybetsAPI = mybetsinplay;
        
    }else{
        mybetsAPI = mybetsfinal;

    }
//    NSLog(@"jsonDict %@",jsonDict);
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:mybetsAPI
                                                parameters:jsonDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           NSDictionary* _userInfo = @{@"Deposit_Status":_dict};
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success([_userInfo valueForKey:@"Deposit_Status"]);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure)
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           }); {
                                                           }
                                                   }];
    
}


#pragma mark - Wallet API
/*
 @ QRCode Image generation
 @ _qrDetails is user details
 @ _userInfo is server send to dictionary
 */

- (void)userQRCodeDetails:(NSDictionary *) _qrDetails success:(void (^)(NSDictionary* _userInfo))success
                  failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:encryptAndGenerateQR
                                                parameters:_qrDetails
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           NSDictionary* _userInfo = @{@"User_QRCode":_dict};
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(_userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
    
}


- (void)userAddFundsQRCodeDetails:(NSDictionary *) _qrDetails success:(void (^)(NSDictionary* _userInfo))success
                          failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:encryptAndGenerateQR
                                                parameters:_qrDetails
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           NSDictionary* _userInfo = @{@"User_QRCode":_dict};
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(_userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}




- (void)getCurrentBalanceForAccount:(NSDictionary *) _paymentDetails success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    
    [self headersLoading];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getAccountBalance
                                                parameters:nil
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //NSLog(@"response balance %@",responseObject);
                                                       
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(_dict);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"error %@",error);
                                                       if (failure)
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           }); {
                                                           }
                                                   }];
    
    
}

- (void)amountDepositWithPaymentDetails:(NSDictionary *) _paymentDetails
                                success:(void (^)(NSDictionary* _userInfo))success
                                failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    NSLog(@"Headers UserName %@",[[WarHorseSingleton sharedInstance] userType]);
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplUserName"]];
        [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"CplPassword"]];
    }
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    
    NSDictionary *jsonDict = @{@"request":@{@"version":@"1.0",
                                            @"type":[_paymentDetails valueForKey:@"type"],
                                            @"customer":@{@"town":@"",
                                                          @"name":@{@"middle":@"",
                                                                    @"prefix":@"",
                                                                    @"last":[_paymentDetails valueForKey:@"last"],
                                                                    @"first":[_paymentDetails valueForKey:@"first"]
                                                                    },
                                                          @"telephone":[_paymentDetails valueForKey:@"telephone"],
                                                          @"street":@"",
                                                          @"postcode":@"",
                                                          @"premise":@"",
                                                          @"province":@"",
                                                          @"country":@""
                                                          },
                                            @"payment":@{@"type":[_paymentDetails valueForKey:@"paymenttype"],
                                                         @"accountnumber":[_paymentDetails valueForKey:@"accountnumber"],
                                                         @"routingnumber":[_paymentDetails valueForKey:@"routingnumber"],
                                                         @"expirydate":[_paymentDetails valueForKey:@"expirydate"],
                                                         @"securitycode":[_paymentDetails valueForKey:@"securitycode"],
                                                         @"amount":[_paymentDetails valueForKey:@"amount"]
                                                         } ,
                                            @"province":@""
                                            }
                               };
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:Deposit
                                                parameters:jsonDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           
                                                           //NSLog(@"responseObject %@",responseObject);
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           NSDictionary* _userInfo = _dict;
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(_userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure)
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           }); {
                                                           }
                                                   }];
    
}


// User Account Activity details API
- (void)getAcountActivityDetails:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-lat" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-long" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getAccountActivityWithPagination
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
}
- (void)getRewardPointsForUser:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getRewardPointsSummary
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

// getting all bet from user.
- (void)getAllBetsForUser:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getNumberOfInplayBets
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       
                                                       //NSLog(@"Response Object os All Bets is ---- %@", responseObject);
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}
#pragma mark ---
#pragma live Video Api

- (void)liveVideoForWager:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    [self headersLoading];
    
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:loadStreamUrl
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
}

- (void)showErrorMessageAndBailOut:(NSError*) error{
    
    if( error && error.userInfo ){
        NSString * message = [error.userInfo objectForKey:@"response-message"];
        //NSLog(@"message %@",message);
        if( message ){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

- (void)getAppConfigurationForClientID:(NSString *)clientId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-lat" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-long" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    


    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kAppConfig
                                                parameters:nil
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *appConfigDict = responseObject;
                                                               if (success) {
                                                                   success(appConfigDict);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
}

#pragma mark
#pragma Email and Phone Register

- (void)registerEmailandPhoneNo:(NSDictionary *)emailDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]];
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"password"]];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:saveCustomerInfo
                                                parameters:emailDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}
#pragma mark
#pragma Withdrawal API

- (void)withdrawalRequest:(NSDictionary *)emailDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-lat" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-long" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:withdrawal
                                                parameters:emailDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //NSLog(@"responseObject %@",responseObject);
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
}

- (void)getLiveVideoUrlForParameters:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    //NSLog(@"video 111 is %@",params);
    [self headersLoading];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-lat" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-long" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:loadStreamUrl
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //NSLog(@"Video responseObject %@",responseObject);
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

//VerificationCodeForPassword
- (void)sendVerificationCodeForPassword:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    [self headersLoading];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetSendVerificationCodeForPassword
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       //NSLog(@"Video responseObject %@",responseObject);
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       NSLog(@"AUTH Failed - %@", error);
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}
//resetAccountPassword
- (void)resetAccountPassword:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    
    [self headersLoading];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetresetAccountPassword
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

// RedeemPoint Server call

- (void)redeemRewardsServiceCall:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    
    [self headersLoading];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:redeemRewards
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       NSLog(@"RewordsPoints %@",responseObject);
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}




- (void)getPaymentServiceChargeInfo:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetPaymentServiceChargeInfo
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       
                                                       //NSLog(@"Response Object os PaymentCharge is ---- %@", responseObject);
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [self showErrorMessageAndBailOut:error];
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

- (void)preloginBanners:(NSDictionary *)params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    //[[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"MyWinnersCT"];
    [self headersLoading];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-lat" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-long" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:@"betfredcms/services/loadData"
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                           NSDictionary *userInfo = responseObject;
                                                           if (success) {
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   success(userInfo);
                                                               });
                                                           }
                                                           
                                                       }
                                                       else{
                                                           NSLog(@"failure1111 %@",failure);
                                                           if (failure) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   failure(nil);
                                                               });
                                                           }
                                                       }
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
}

//Oneday pass and Voucher for QRCode Image

- (void)odpandCpluserQRCode:(NSDictionary *) _qrDetails success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure{
    
    [self headersLoading];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getOntAndCplQRcode
                                                parameters:_qrDetails
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *qrCodeDict = responseObject;
                                                               if (success) {
                                                                   success(qrCodeDict);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
    
}

// DigitalVoucher Register

- (void)userDigitalVoucher:(NSDictionary *)dvDeatails success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure{
    
    [self headersLoading];
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"BetFred-ODP"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:digitalVoucherRegister
                                                parameters:dvDeatails
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *qrCodeDict = responseObject;
                                                               if (success) {
                                                                   success(qrCodeDict);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
    
}

- (void)accountClosedValidationForOdp:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];

    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:isAccountClosedForDevice
                                                parameters:userDetailsDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *accountDetails = responseObject;
                                                               if (success) {
                                                                   success(accountDetails);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}
//getActiveAccountIdForDevice
- (void)activeAccountIdForODP:(NSString *)clientId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"BetFred-ODP"];
    [self userCredintianalClear];

    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getActiveAccountIdForDevice
                                                parameters:nil
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *appConfigDict = responseObject;
                                                               if (success) {
                                                                   success(appConfigDict);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
}



//getCreditCardDepositUrl
- (void)creditCardDepositUrl:(NSDictionary *)paymentDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [self headersLoading];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@""];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    
    [[[RKObjectManager sharedManager] HTTPClient] postPath:getCreditCardDepositUrl
                                                parameters:paymentDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *secureTrading = responseObject;
                                                               if (success) {
                                                                   success(secureTrading);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
}

//kGetRegistrationConfig
- (void)appRegistrationsConfig:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    [self userCredintianalClear];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetRegistrationConfig
                                                parameters:userDetailsDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *accountDetails = responseObject;
                                                               if (success) {
                                                                   success(accountDetails);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}

// ADW - YES Option
- (void)validateExistingAccount:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    [self userCredintianalClear];

    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetValidateExistingAccount
                                                parameters:userDetailsDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *accountDetails = responseObject;
                                                               if (success) {
                                                                   success(accountDetails);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}

- (void)registerExistingUser:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    [self userCredintianalClear];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kGetRegisterExistingUser
                                                parameters:userDetailsDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *accountDetails = responseObject;
                                                               if (success) {
                                                                   success(accountDetails);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}



- (void)promoCodeValidation:(NSDictionary *)userPromoCodeDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure
{
    [self headersLoading];
    [self userCredintianalClear];
    
    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:kPromoCodeValidation
                                                parameters:userPromoCodeDict
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       void(^completionBlock)() = ^{
                                                           
                                                           if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                               //NSString *succesMes = [responseObject valueForKey:@"response-status"];
                                                               NSDictionary *accountDetails = responseObject;
                                                               if (success) {
                                                                   success(accountDetails);
                                                               }
                                                               
                                                           }
                                                           else{
                                                               NSLog(@"failure1111 %@",failure);
                                                               if (failure) {
                                                                   failure(nil);
                                                               }
                                                           }
                                                           
                                                       };
                                                       
                                                       if([NSThread isMainThread]){
                                                           completionBlock();
                                                       }
                                                       else{
                                                           dispatch_sync(dispatch_get_main_queue(), completionBlock);
                                                       }
                                                       
                                                       
                                                   }
                                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                       if (failure) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               failure(error);
                                                           });
                                                       }
                                                   }];
    
    
}





- (void)userCredintianalClear
{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_pin" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_password" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_id" value:@""];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"account_id" value:@""];
}


////kGetValidateExistingAccount
//kGetRegisterExistingUser




@end
