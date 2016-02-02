//
//  ZLRunner.h
//  WarHorse
//
//  Created by Jugs VN on 8/28/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLRunner : NSObject

@property (assign) int runner_id;

@property(nonatomic, retain) NSString * runnerNumber;

@property (assign) BOOL scratched;

@property (nonatomic, retain) NSString * winOdds;
@property (nonatomic, retain) NSString * probablePay;

@property (nonatomic, retain) NSString * mlodds;

@property (nonatomic, retain) NSString * title;

@property (nonatomic, retain) NSString * jockeyName;

@property (nonatomic, retain) NSString * couchName;

@property (nonatomic, retain) NSString * lbs;

@property (nonatomic, retain) NSString * bb;

@property (nonatomic, retain) UIColor * textColor;

@property (nonatomic, retain) UIColor * backGroundColor;

@property (nonatomic,retain) NSString *silkImageStr;

@end
