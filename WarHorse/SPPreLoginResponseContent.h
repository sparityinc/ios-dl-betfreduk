//
//  SPPreLoginResponseContent.h
//  WarHorse
//
//  Created by PVnarasimham on 04/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPPreLoginResponseContent : NSObject

@property (strong, nonatomic) NSString *unique_Key;
@property (strong, nonatomic) NSString *json_Data_Id;
@property (strong, nonatomic) NSString *json_Schema_Id;
@property (strong, nonatomic) NSDictionary *json_Data;

@end
