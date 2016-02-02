//
//  ZLOddsPoolRunner.h
//  WarHorse
//
//  Created by Jugs VN on 10/1/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLOddsPoolRunner : NSObject

@property(assign) int number;

@property(assign) int runner;

@property(assign) double pp;

@property(assign) double hi_pp;

@property(assign) double lo_pp;

@property(nonatomic, strong) NSString * odds;

@property(assign) double total;

@property(nonatomic, strong) NSString * currency;

@property(nonatomic, strong) NSArray * withRunners;

@end
