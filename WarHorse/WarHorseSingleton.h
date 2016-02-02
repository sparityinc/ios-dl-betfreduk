//
//  WarHorseSingleton.h
//  WarHorse
//
//  Created by Sparity Dev on 06/11/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WarHorseSingleton : NSObject

+ (id)sharedInstance;

@property (strong, nonatomic) NSString *latitudeStr;
@property (strong, nonatomic) NSString *longitudeStr;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

@property (strong, nonatomic) NSString *stateString;
@property (strong, nonatomic) NSString *stateCodeString;

@property (strong , nonatomic) NSDictionary *paymentChargesDict;


@property (nonatomic, assign) BOOL isWithDrawalSuccess;

@property (strong,nonatomic) NSString *betType;
@property (strong,nonatomic) NSString *userType;

@property (strong,nonatomic) NSString *isAdwEnable;
@property (strong,nonatomic) NSString *isOntEnable;
@property (strong,nonatomic) NSString *isCplEnable;

@property (strong,nonatomic) NSString *isAdwFundingEnable;
@property (strong,nonatomic) NSString *isAdwSupervisorEnable;

@property (strong,nonatomic) NSString *isOntFundingEnable;
@property (strong,nonatomic) NSString *isOntSupervisorEnable;

@property (strong,nonatomic) NSString *isOdpPlayerIdEnable;


@property (strong,nonatomic) NSString *isCplFundingEnable;
@property (strong,nonatomic) NSString *isCplSupervisorEnable;

@property (nonatomic) NSInteger selectedIndexSegmentCntr;
@property (nonatomic) NSInteger noofSegmentToStart;

@property (nonatomic,strong) NSString *isRegisterFlag;
@property (nonatomic) NSInteger selectedIndexFromRegister;

@property (nonatomic,strong) NSString *notificationTrunOnStr;
@property (nonatomic, strong) NSDictionary *userDetailsDict;

@property (nonatomic,strong) NSDictionary *loginADWRequiredfieldsDic;
@property (nonatomic,strong) NSDictionary *loginODPRequiredfieldsDic;

@property (nonatomic,strong) NSDictionary *loginDVRequiredfieldsDic;

@property (nonatomic,strong) NSString *iosVersionNo;

@property (nonatomic, assign) BOOL isWithDrawEnable;
@property (nonatomic, assign) BOOL isRewordsEnable;
@property (nonatomic, assign) BOOL isVideoSteamingEnable;
@property (nonatomic, assign) BOOL isQRCodeEnable;

@property (nonatomic,strong) NSString *currencySymbel;

@property (nonatomic,strong) NSString *localCountry;

@property (nonatomic,strong) NSString *selectTrackCountry;
@property (nonatomic,strong) NSString *selectTrackName;

@property (nonatomic,strong) NSString *selectRaceNo;
@property (nonatomic, assign) BOOL isFavTF;

@property (nonatomic,strong) NSString *isTFShortName;
@property (nonatomic,strong) NSString *isSpFavName;
@property (nonatomic,strong) NSString *isSpFavDescription;

@property (assign) BOOL isWINByte;
@property (assign) BOOL isPLCByte;
@property (assign) BOOL isSHWByte;

@property (nonatomic,assign) NSInteger noColumsOddBoard;

@property (assign) BOOL kLegBetting;

- (BOOL)isInternetConnectionAvailable;

@end
