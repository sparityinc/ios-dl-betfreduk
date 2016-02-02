//
//  ZLOddsPool.h
//  WarHorse
//
//  Created by Jugs VN on 10/1/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLOddsPool : NSObject

@property(nonatomic, strong) NSString * betType;

@property(nonatomic, strong) NSString * currency;

@property(assign) double total;

@property(assign) double gross;

@property(assign) double net;

@property(assign) double net_sales_addin;

@property(assign) double net_pool_addin;

@property(assign) double carry_in;

@property(assign) double total_gross;

@property(assign) double total_net;

@property(nonatomic, strong) NSArray * oddsPoolRunners;
@end
