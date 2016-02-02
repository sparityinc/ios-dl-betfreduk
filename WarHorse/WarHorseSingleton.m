//
//  WarHorseSingleton.m
//  WarHorse
//
//  Created by Sparity Dev on 06/11/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "WarHorseSingleton.h"
#import "Reachability.h"

@implementation WarHorseSingleton

@synthesize stateString;
@synthesize stateCodeString;
//@synthesize emailString;
@synthesize paymentChargesDict;

@synthesize isWithDrawalSuccess;
@synthesize betType;
@synthesize userType;
//AppConfig 
@synthesize isAdwEnable;
@synthesize isOntEnable;
@synthesize isCplEnable;

@synthesize isAdwFundingEnable;
@synthesize isOntFundingEnable;
@synthesize isOdpPlayerIdEnable;

@synthesize isCplFundingEnable;

@synthesize isAdwSupervisorEnable;
@synthesize isOntSupervisorEnable;
@synthesize isCplSupervisorEnable;
@synthesize selectedIndexSegmentCntr;
@synthesize noofSegmentToStart,notificationTrunOnStr;
@synthesize userDetailsDict;
@synthesize loginODPRequiredfieldsDic,loginADWRequiredfieldsDic,loginDVRequiredfieldsDic;
@synthesize iosVersionNo;
@synthesize isWithDrawEnable,isRewordsEnable,isVideoSteamingEnable,isQRCodeEnable,currencySymbel,localCountry;
@synthesize selectTrackCountry,selectRaceNo,selectTrackName,isFavTF,isTFShortName,isSpFavName,isSpFavDescription;
@synthesize kLegBetting;
@synthesize isWINByte,isPLCByte,isSHWByte,noColumsOddBoard;

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isInternetConnectionAvailable
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection] ;
    NetworkStatus netWorkStatus = [reachability currentReachabilityStatus] ;
    if (netWorkStatus == ReachableViaWWAN || netWorkStatus == ReachableViaWiFi)
    {
        return YES;
    }
    else{
        return NO;
    }

    return NO;
}

@end
