//
//  SPTusconConstants.h
//  WarHorse
//
//  Created by Veeru on 27/05/14.
//  Copyright (c) 2014 Northalley. All rights reserved.
//

#ifndef WarHorse_SPTusconConstants_h
#define WarHorse_SPTusconConstants_h




#define kDownLoadedBaseCMSUrl @"https://m.mywinners.com/mywinnerscms/file/"


#define kGetCards @"warhorse/services/getCards"
#define kgetCardDetail @"warhorse/services/getCardDetail"
#define kGetMyBets @"warhorse/services/v1/myBets"
#define myBets1 @"warhorse/services/v1/myBets1"
#define getResultsWithDate @"warhorse/services/v1/getResultsWithDate"

#define getResultsWithMeetAndPerf @"warhorse/services/v1/getResultsWithMeetAndPerf"
#define getQueryResult @"warhorse/services/getQueryResult"

#define loadCardsArray @"warhorse/services/loadCardsArray"

#define validateAccount @"warhorse/services/validateAccount"
#define getIdology @"warhorse/services/v1/getIdology"
#define kGetRegisterUser @"warhorse/services/registerUser"
#define saveAdwUser @"warhorse/services/v1/saveAdwUser"
#define RegisterAdwUser @"warhorse/services/v1/RegisterAdwUser"
#define kGetSaveAnonymousUser @"warhorse/services/v1/saveAnonymousUser"
#define createOneDayPassAccount @"warhorse/services/createOneDayPassAccount"
#define Login @"warhorse/services/Login"
#define kGetresetPassword @"warhorse/services/v1/resetPassword"
#define logout @"warhorse/services/v1/logout"

#define AvailableBalance @"warhorse/services/v1/AvailableBalance"
#define getCardDetail @"warhorse/services/getCardDetail"
#define isBetAmtValid @"warhorse/services/v1/isBetAmtValid"
#define placeBet @"warhorse/services/v1/placeBet"
#define CancelBet @"warhorse/services/v1/CancelBet"
#define loadCardsArray @"warhorse/services/loadCardsArray"

#define SaveUserPreferences @"warhorse/services/SaveUserPreferences"
#define UserPreferences @"%@warhorse/services/UserPreferences"
#define myBets2 @"warhorse/services/v1/myBets2"
#define encryptAndGenerateQR @"warhorse/services/v1/encryptAndGenerateQR"

#define getAccountBalance @"warhorse/services/v1/getAccountBalance"
#define Deposit @"warhorse/services/v1/Deposit"
#define getAccountActivityWithPagination @"warhorse/services/getAccountActivityWithPagination"
#define getRewardPointsSummary @"warhorse/services/getRewardPointsSummary"
#define getNumberOfInplayBets @"warhorse/services/v1/getNumberOfInplayBets"
#define loadStreamUrl @"warhorse/services/loadStreamUrl"
#define saveCustomerInfo @"warhorse/services/v1/saveCustomerInfo"
#define withdrawal @"warhorse/services/v1/withdrawal"
#define loadStreamUrl @"warhorse/services/loadStreamUrl"
#define kGetSendVerificationCodeForPassword @"warhorse/services/sendVerificationCodeForPassword"
#define kGetresetAccountPassword @"warhorse/services/resetAccountPassword"
#define redeemRewards @"warhorse/services/redeemRewards"
#define kGetPaymentServiceChargeInfo @"warhorse/services/v1/getPaymentServiceChargeInfo"

#define kAppConfig @"warhorse/services/ReadAPI?screenId=AppConfig"





/*
 
 #define kDownLoadedBaseCMSUrl @"https://m.mywinners.com/mywinnerscms/file/"
 
 
 //Mywinners APIs
 
 #define kGetCards @"mywinners/services/v3/getCards"
 
 #define kgetCardDetail @"mywinners/services/v3/getCardDetail"
 #define kGetMyBets @"mywinners/services/v1/myBets"
 #define myBets1 @"mywinners/services/v1/myBets1"
 #define getResultsWithDate @"mywinners/services/v1/getResultsWithDate"
 
 #define getResultsWithMeetAndPerf @"mywinners/services/v1/getResultsWithMeetAndPerf"
 #define getQueryResult @"mywinners/services/getQueryResult"
 
 #define loadCardsArray @"mywinners/services/v3/loadCardsArray"
 
 #define validateAccount @"mywinners/services/v3/validateAccount"
 #define getIdology @"mywinners/services/v1/getIdology"
 #define kGetRegisterUser @"mywinners/services/v3/registerUser"
 #define saveAdwUser @"mywinners/services/v1/saveAdwUser"
 #define RegisterAdwUser @"mywinners/services/v1/RegisterAdwUser"
 #define kGetSaveAnonymousUser @"mywinners/services/v1/saveAnonymousUser"
 #define createOneDayPassAccount @"mywinners/services/v3/createOneDayPassAccount"
 #define Login @"mywinners/services/Login"
 #define kGetresetPassword @"mywinners/services/v1/resetPassword"
 #define logout @"mywinners/services/logout"
 
 #define AvailableBalance @"mywinners/services/v1/AvailableBalance"
 #define getCardDetail @"mywinners/services/v3/getCardDetail"
 #define isBetAmtValid @"mywinners/services/v1/isBetAmtValid"
 #define placeBet @"mywinners/services/v3/placeBet"
 #define CancelBet @"mywinners/services/v3/CancelBet"
 #define loadCardsArray @"mywinners/services/v3/loadCardsArray"
 
 #define SaveUserPreferences @"mywinners/services/SaveUserPreferences"
 #define UserPreferences @"%@mywinners/services/UserPreferences"
 #define myBets2 @"mywinners/services/v1/myBets2"
 #define encryptAndGenerateQR @"mywinners/services/v1/encryptAndGenerateQR"
 
 #define getAccountBalance @"mywinners/services/v1/getAccountBalance"
 #define Deposit @"mywinners/services/v3/Deposit"
 #define getAccountActivityWithPagination @"mywinners/services/getAccountActivityWithPagination"
 #define getRewardPointsSummary @"mywinners/services/v3/getRewardPointsSummary"
 #define getNumberOfInplayBets @"mywinners/services/v1/getNumberOfInplayBets"
 #define loadStreamUrl @"mywinners/services/loadStreamUrl"
 #define saveCustomerInfo @"mywinners/services/v1/saveCustomerInfo"
 #define withdrawal @"mywinners/services/v1/withdrawal"
 #define loadStreamUrl @"mywinners/services/loadStreamUrl"
 #define kGetSendVerificationCodeForPassword @"mywinners/services/v3/sendVerificationCodeForPassword"
 #define kGetresetAccountPassword @"mywinners/services/v3/resetAccountPassword"
 #define redeemRewards @"mywinners/services/v3/redeemRewards"
 #define kGetPaymentServiceChargeInfo @"mywinners/services/v3/getPaymentServiceChargeInfo"
 
 #define kAppConfig @"mywinners/services/ReadAPI?screenId=AppConfig"
 
 
 */




#endif

