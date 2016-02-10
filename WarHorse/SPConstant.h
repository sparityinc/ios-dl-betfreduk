//
//  SPConstant.h
//  mywinners
//
//  Created by EnterPi on 10/09/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#ifndef WarHorse_SPConstant_h
#define WarHorse_SPConstant_h


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define Aleart_Title @"Totepool"
#define Aleart_Title_New @"Totepool"
// http://bfddev.sparity.com:7070/betfred_warhorse/services/Logi

#define QRCode_Text @"WithDrawl:\n    To withdraw funds or cash voucher.\nTerminal:\n     Access your One Day Pass on terminal."

#define TextviewMes_One @"On Hold will be deposited to your wagering when it clears the banking network. Additional requests will be deposited when they clear the banking network."
#define TextviewMes_Two @"Click here to learn how to have your immediate deposit limit increased."
#define TextviewMes_Third @"Note: Nassau OTB charges a "
#define TextviewMes_Four @"transaction fee for each ACH transaction."

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


// DevDl API's

//#define kDownLoadedBaseCMSUrl @"http://g4qc.spodemo.com/mywinnerscms/file/"
//#define kDownLoadedBaseCMSUrl @"https://m.mywinners.com/mywinnerscms/file/"


#define kDownLoadedBaseCMSUrl @"http://bfddev.sparity.com:7070/betfredcms/file/"
//#define kDownLoadedBaseCMSUrl @"http://bfdstg.spodemo.com/betfredcms/file/"



#define getResultsWithDate @"betfred_warhorse/services/v1/getResultsWithDate"



//Register APIs

#define createOneDayPassAccount @"betfred_warhorse/services/v3/createOneDayPassAccount"
#define kGetSendVerificationCodeForPassword @"betfred_warhorse/services/v3/sendVerificationCodeForPassword"
#define kGetresetAccountPassword @"betfred_warhorse/services/v3/resetAccountPassword"
#define kGetresetPassword @"betfred_warhorse/services/v1/resetPassword"

#define registerAnonymousUsers @"betfred_warhorse/services/v3/registerAnonymousUsers"

//New Registation API's

//#define validateAccount @"mywinners/services/v4/validateAccount"

//#define getIdology @"mywinners/services/v2/getIdology"

//#define kGetRegisterUser @"mywinners/services/v4/registerUser"

//New Registation API's

#define validateAccount @"betfred_warhorse/services/v5/validateAccount"

#define getIdology @"betfred_warhorse/services/v3/getIdology"

#define kGetRegisterUser @"betfred_warhorse/services/v5/registerUser"
// Final Registation Promo code validation

#define kPromoCodeValidation @"betfred_warhorse/services/v3/validatePromocode"


//Registration AppConfig

#define kGetRegistrationConfig @"betfred_warhorse/services/v3/getRegistrationConfig"

// ADW - NO

#define kGetValidateExistingAccount @"betfred_warhorse/services/v3/validateExistingAccount"
#define kGetRegisterExistingUser @"betfred_warhorse/services/v4/registerExistingUser"

//Old Registation API's
/*
 #define validateAccount @"mywinners/services/v3/validateAccount"
 
 #define getIdology @"mywinners/services/v1/getIdology"
 
 #define kGetRegisterUser @"mywinners/services/v3/registerUser"
 */



#define digitalVoucherRegister @"betfred_warhorse/services/v3/createTempAccount"

//LOGIN, LOGOUT API
#define Login @"betfred_warhorse/services/Login"
#define logout @"betfred_warhorse/services/v1/logout"
#define getActiveAccountIdForDevice @"betfred_warhorse/services/v3/getActiveAccountIdForDevice"


#define isAccountClosedForDevice  @"betfred_warhorse/services/v3/isAccountClosedForDevice"


//Dash Board API
#define getNumberOfInplayBets @"betfred_warhorse/services/v1/getNumberOfInplayBets"
//#define UserPreferences @"%@mywinners/services/UserPreferences"
#define UserPreferences @"betfred_warhorse/services/GetUserPreferences"


//#define SaveUserPreferences @"mywinners/services/SaveUserPreferences"
#define SaveUserPreferences @"betfred_warhorse/services/v1/saveUserPreferencesIng4"



//Wager
#define kGetCards @"betfred_warhorse/services/v3/getCards"
#define getCardDetail @"betfred_warhorse/services/v3/getCardDetail"
#define isBetAmtValid @"betfred_warhorse/services/v1/isBetAmtValid"
#define placeBet @"betfred_warhorse/services/v3/placeBet"

//MyBets
#define myBets2 @"betfred_warhorse/services/v1/myBets2"
#define mybetsfinal @"betfred_warhorse/services/v1/myBetsFinal"
#define mybetsinplay @"betfred_warhorse/services/v1/myBetsInplay"


#define mybetsfinal @"betfred_warhorse/services/v1/myBetsFinal"

#define mybetsinplay @"betfred_warhorse/services/v1/myBetsInplay"


//#define myBets2 @"mywinners/services/v1/myBets3"

#define CancelBet @"betfred_warhorse/services/v3/CancelBet"

//Wallet
#define kGetPaymentServiceChargeInfo @"betfred_warhorse/services/v3/getPaymentServiceChargeInfo"
#define getAccountActivityWithPagination @"betfred_warhorse/services/getAccountActivityWithPagination"
#define Deposit @"betfred_warhorse/services/v3/Deposit"
#define withdrawal @"betfred_warhorse/services/v1/withdrawal"
#define encryptAndGenerateQR @"betfred_warhorse/services/v1/encryptAndGenerateQR"
#define redeemRewards @"betfred_warhorse/services/v3/redeemRewards"
#define getOntAndCplQRcode @"betfred_warhorse/services/v1/encryptAndGenerateQRForTransaction"



//RESULT API
#define loadCardsArray @"betfred_warhorse/services/v3/loadCardsArray"
//Old API Results Details
//#define getResultsWithMeetAndPerf @"betfred_warhorse/services/v1/getResultsWithMeetAndPerf"
//New API for Resulits Details
#define getResultsWithMeetAndPerf @"betfred_warhorse/services/v1/getResultsWithMeetAndPerfFromG4"
//ODDS BOARD
#define getQueryResult @"betfred_warhorse/services/getQueryResult"

#define getAccountBalance @"betfred_warhorse/services/v1/getAccountBalance"
#define AvailableBalance @"betfred_warhorse/services/v1/AvailableBalance"
#define getRewardsSummary @"betfred_warhorse/services/v1/getRewardsSummary"

//Live Video
#define loadStreamUrl @"betfred_warhorse/services/loadStreamUrl"

//APP Config API
#define kAppConfig @"betfred_warhorse/services/v1/ReadAPI?screenId=BetFred"

#define saveAdwUser @"betfred_warhorse/services/v1/saveAdwUser"
#define RegisterAdwUser @"betfred_warhorse/services/v1/RegisterAdwUser"
#define kGetSaveAnonymousUser @"betfred_warhorse/services/v1/saveAnonymousUser"

#define getRewardPointsSummary @"betfred_warhorse/services/getRewardPointsSummary"
#define saveCustomerInfo @"betfred_warhorse/services/v1/saveCustomerInfo"

#define getCreditCardDepositUrl @"betfred_warhorse/services/v3/getCreditCardDepositUrl"



#endif