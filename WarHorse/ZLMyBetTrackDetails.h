//
//  ZLMyBetTrackDetails.h
//  WarHorse
//
//  Created by Jugs VN on 10/8/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLMyBetTrackDetails : NSObject

@property(nonatomic, strong) NSString * trackName;

@property(assign) int meet;

@property(assign) int perf;

@property(nonatomic, strong) NSMutableArray * raceArray;

@end
