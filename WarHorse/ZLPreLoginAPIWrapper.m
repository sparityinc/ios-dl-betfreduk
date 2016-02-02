//
//  ZLPreLoginAPIWrapper.m
//  WarHorse
//
//  Created by PVnarasimham on 23/09/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLPreLoginAPIWrapper.h"
#import <Restkit/RestKit.h>
#import "SPDateEntry.h"
#import "SPCarryOver.h"
#import "ZLAppDelegate.h"
#import "SPPreLoginResponseContent.h"
#import "SPPreLoginJsonData.h"

@interface ZLPreLoginAPIWrapper ()

@property (nonatomic, retain) NSURL *preloginBaseURL;

@end


@implementation ZLPreLoginAPIWrapper

- (id)init
{
    self = [super init];
    if (self) {
        
        //RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
        //RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
                
    }
    
    return  self;
}

#pragma mark - pre-login API

- (void)loadCarryOverDataForParameterType:(NSDictionary *)params
                                 success:(void (^)(NSDictionary* _userInfo))success
                                 failure:(void (^)(NSError *error))failure
{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"BetFred"];

    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[RKObjectManager sharedManager] postObject:params path:@"betfredcms/services/loadData" parameters:params
                                        success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                                                    
                                            //NSLog(@"Mapping Result is %@", mappingResult);
                                            
                                            SPPreLoginResponseContent *responseContent = (SPPreLoginResponseContent *)[[mappingResult array] objectAtIndex:0];
                                            
                                            //NSLog(@"Response Content is %@",responseContent.json_Data);
                                            
                                            SPPreLoginJsonData *jsonData = (SPPreLoginJsonData *)responseContent.json_Data;
                                            
                                            if ([jsonData._id isEqualToString:@"CarryOver"]) {
                                                [ZLAppDelegate getAppData].carryOverDateEntries = jsonData.dateEntries;
                                            }
                                            
                                            NSDictionary* _userInfo = @{};
                                            if (success) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    success(_userInfo);
                                                });
                                            }
                                                
                                        }
                                        failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                            if (failure) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    failure(error);
                                                });
                                            }
                                        }];
    
}

- (void)loadPreLoginDataForParameterType:(NSDictionary *)params
                                 success:(void (^)(NSDictionary* _userInfo))success
                                 failure:(void (^)(NSError *error))failure
{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"BetFred"];

    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:@"betfredcms/services/loadData"
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           NSDictionary* _userInfo = @{@"Deposit_Status":_dict};
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

- (void)loadPreLoginDataForSelectedDate:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"BetFred"];

    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:@"betfredcms/services/loadData"
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           NSDictionary* _userInfo = @{@"Deposit_Status":_dict};
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

- (void)loadSCRChangesDataForSelectedDate:(NSDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure
{
    
    
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user-agent" value:@"test"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"mobile-os" value:@"ios"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"ani" value:@"test"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-lat" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"gps-long" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"geofence" value:@"true"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"ip-address" value:@"test"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"context" value:@"test"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"app-open-timestamp" value:@"test"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client-version" value:@"test"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"unique-id" value:@"test"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"Accept-Encoding" value:@"gzip, deflate, sdch"];//
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"user_mobile_number" value:@"34434343"];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"device-token-id" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"decvice_token"]];
    [[RKObjectManager sharedManager].HTTPClient setDefaultHeader:@"client_id" value:@"BetFred"];

    [[RKObjectManager sharedManager] setRequestSerializationMIMEType:RKMIMETypeJSON];
    [[[RKObjectManager sharedManager] HTTPClient] setParameterEncoding:AFJSONParameterEncoding];
    [[[RKObjectManager sharedManager] HTTPClient] postPath:@"betfred_warhorse/services/v1/getSCRChanges"
                                                parameters:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       if([operation.response statusCode] == 201 && [responseObject isKindOfClass:[NSDictionary class]]){
                                                           NSDictionary* _dict = (NSDictionary*)responseObject;
                                                           
                                                           NSDictionary* _userInfo = @{@"Deposit_Status":_dict};
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



@end
