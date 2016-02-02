//
//  ZLAPIWrapper.h
//  WarHorse
//
//  Created by Jugs VN on 8/22/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZLWager.h"
#import "ZLBetTransaction.h"

@interface ZLAPIWrapper : NSObject<NSURLConnectionDelegate>

- (id) init;

//ADW registration
- (void)getIdologyWithParameters:(NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

- (void)saveAdwUserWithdetails:(NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

- (void)registerAdwUserWithDetails:(NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
- (void)registerOneDayUserWithDetails:(NSString *)user_pin success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

//New Api
- (void)isAccountValid:(NSDictionary *)emailStr success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
//New RegisterUser
- (void)registerUserWithdetails:(NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
- (void)registerForAnonymousUsers:(NSDictionary *)userDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;


- (void)resetAccountPassword:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//OneDay Pass/Anonymous user registration
- (void)saveAnonymousUser:(NSDictionary *) _userDetailsDict forUserType:(NSString *)user_type atLat:(NSString *)Latitude andLongitude:(NSString *)Longitude success:(void (^)(NSDictionary* _userInfo))success
                  failure:(void (^)(NSError *error))failure;
- (void)saveAnonymousUser2:(NSDictionary *) _userDetailsDict forUserType:(NSString *)user_type atLat:(NSString *)Latitude andLongitude:(NSString *)Longitude success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

//Paperless user registration
- (void)savePaperLessUser:(NSDictionary *) _userDetailsDict atLat:(NSString *)Latitude andLongitude:(NSString *)Longitude success:(void (^)(NSDictionary* _userInfo))success
                  failure:(void (^)(NSError *error))failure;


//ADW/Anonymous user login
-(void) authenticateUser:(NSString*) _user_id withPassword:(NSString*) _password
                     Pin:(NSString*) _pin
                     Lat:(NSString *)latitude andLon:(NSString *)longitude
                 success:(void (^)(NSDictionary* _userInfo))success
                 failure:(void (^)(NSError *error))failure;

//reset password
- (void)resetUserPasswordWithParameters: (NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

//Logout
- (void)logoutUserWithParameters: (NSDictionary *) _params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

//Wager
-(void) loadRaceCards:(BOOL) alert
            success:(void (^)(NSDictionary* _userInfo))success
            failure:(void (^)(NSError *error))failure;

-(void) loadTrackDetails:(NSDictionary *) _params alert:(BOOL) alert
                 success:(void (^)(NSDictionary* _userInfo))success
                 failure:(void (^)(NSError *error))failure;

-(void) refreshBalance:(BOOL) alert
               success:(void (^)(NSDictionary* _userInfo))success
               failure:(void (^)(NSError *error))failure;

-(void) validateBetAmountForWager:(ZLWager*) _wager
           success:(void (^)(NSDictionary* _userInfo))success
           failure:(void (^)(NSError *error))failure;

-(void) placeWager:(ZLWager*) _wager
           success:(void (^)(NSDictionary* _userInfo))success
           failure:(void (^)(NSError *error))failure;

-(void) cancelWager:(NSMutableDictionary*) transaction
            success:(void (^)(NSDictionary* _userInfo))success
            failure:(void (^)(NSError *error))failure;

-(void) getTracksResultsForDate:(NSDate*) date
                        success:(void (^)(NSDictionary* _userInfo))success
                        failure:(void (^)(NSError *error))failure;

-(void) getRaceResultsByMeet:(int) meet WithPerf:(int) perf dateStr:(NSString *)dateStr success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;


-(void) getRaceOddsByMeet:(int) meet WithPerf:(int) perf AndRace:(int) race
                  success:(void (^)(NSDictionary* _userInfo))success
                  failure:(void (^)(NSError *error))failure;

-(void) updateFavoriteTracks:(NSDictionary*) favoriteTrackDict
                     success:(void (^)(NSDictionary* _userInfo))success
                     failure:(void (^)(NSError *error))failure;

//-(void) getFavorites:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

//New Api
-(void)getFavorites:(NSDictionary*) favoriteTrackDic success:(void (^)(NSDictionary* _userInfo))success
            failure:(void (^)(NSError *error))failure;



//My Bets
-(void) loadMyBets:(NSDate *) _date
           success:(void (^)(NSDictionary* _userInfo))success
           failure:(void (^)(NSError *error))failure;

-(void) loadNewMyBets:(NSDate *) _date
              success:(void (^)(NSDictionary* _userInfo))success
              failure:(void (^)(NSError *error))failure;

//Changing myBets for MTP filtering
/*
- (void)loadMyBetsDataFromDate:(NSString *) _fromDateStr toDate:(NSString *) _toDateStr
                              success:(void (^)(NSDictionary* _userInfo))success
                              failure:(void (^)(NSError *error))failure;*/



- (void)loadMyBetsDataFromDate:(NSString *)_fromDateStr betsFlag:(NSString*)betsFlag toDate:(NSString *)_toDateStr success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;




//Wallet
- (void)getAcountActivityDetails:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

- (void)userQRCodeDetails:(NSDictionary *) _qrDetails
                  success:(void (^)(NSDictionary* _userInfo))success
                  failure:(void (^)(NSError *error))failure;

- (void) getCurrentBalanceForAccount:(NSDictionary *) _paymentDetails
                             success:(void (^)(NSDictionary* _userInfo))success
                             failure:(void (^)(NSError *error))failure;

- (void)amountDepositWithPaymentDetails:(NSDictionary *) paymentDetails
                                success:(void (^)(NSDictionary* _userInfo))success
                                failure:(void (^)(NSError *error))failure;

- (void)userAddFundsQRCodeDetails:(NSDictionary *) _qrDetails success:(void (^)(NSDictionary* _userInfo))success
                          failure:(void (^)(NSError *error))failure;
//getting all bet from user
- (void)getAllBetsForUser:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//live for wagering
- (void)liveVideoForWager:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//email register for eula
- (void)registerEmailandPhoneNo:(NSDictionary *)emailDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

- (void)withdrawalRequest:(NSDictionary *)emailDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//

//Live Video/ replays

- (void)getLiveVideoUrlForParameters:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
//RewardPointsSummary

- (void)getRewardPointsForUser:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

- (void)sendVerificationCodeForPassword:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

- (void)redeemRewardsServiceCall:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;


- (void)getPaymentServiceChargeInfo:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
- (void)preloginBanners:(NSDictionary *)params success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

- (void)getAppConfigurationForClientID:(NSString *)clientId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;

- (void)odpandCpluserQRCode:(NSDictionary *) _qrDetails success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
- (void)userDigitalVoucher:(NSDictionary *) _qrDetails success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

- (void)accountClosedValidationForOdp:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
- (void)activeAccountIdForODP:(NSString *)clientId success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
- (void)creditCardDepositUrl:(NSDictionary *)paymentDict success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure;
- (void)appRegistrationsConfig:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
- (void)validateExistingAccount:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
- (void)registerExistingUser:(NSDictionary *)userDetailsDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;
- (void)promoCodeValidation:(NSDictionary *)userPromoCodeDict success:(void (^)(NSDictionary* _userInfo))success failure:(void (^)(NSError *error))failure;

@end
