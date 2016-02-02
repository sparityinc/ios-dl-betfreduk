//
//  ZLPreLoginAPIWrapper.h
//  WarHorse
//
//  Created by PVnarasimham on 23/09/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLPreLoginAPIWrapper : NSObject <NSURLConnectionDelegate>

- (id) init;

- (void)loadCarryOverDataForParameterType:(NSDictionary *)params
                                  success:(void (^)(NSDictionary* _userInfo))success
                                  failure:(void (^)(NSError *error))failure;

- (void)loadPreLoginDataForParameterType:(NSDictionary *)params
                                 success:(void (^)(NSDictionary* _userInfo))success
                                 failure:(void (^)(NSError *error))failure;

//Load data for selected date

- (void)loadPreLoginDataForSelectedDate:(NSDictionary *)params
                                success:(void (^)(NSDictionary* _userInfo))success
                                failure:(void (^)(NSError *error))failure;

// Load SCR changes Data

- (void)loadSCRChangesDataForSelectedDate:(NSDictionary *)params
                                success:(void (^)(NSDictionary* _userInfo))success
                                failure:(void (^)(NSError *error))failure;

@end
