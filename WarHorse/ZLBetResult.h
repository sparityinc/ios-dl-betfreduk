//
//  ZLBetResult.h
//  WarHorse
//
//  Created by Jugs VN on 9/25/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLBetResult : NSObject

@property (assign) int meet;

@property (assign) int perf;

@property (assign) int race;

@property (nonatomic, retain) NSString * betCode;

@property (assign) int resultOrder;

@property (nonatomic, retain) NSString * carryOver;

@property (nonatomic, retain) NSMutableArray * runners;

@end
