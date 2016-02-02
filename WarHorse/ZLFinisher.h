//
//  ZLFinisher.h
//  WarHorse
//
//  Created by Jugs VN on 9/25/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLFinisher : NSObject


@property (assign) int position;

@property (assign) int runnerPosition;

@property (nonatomic, retain) NSString * winPayOff;

@property (nonatomic, retain) NSString * plcPayOff;

@property (nonatomic, retain) NSString * shwPayOff;

@property (nonatomic, retain) NSString * horseName;

@property (nonatomic, retain) NSString * trainerName;

@property (nonatomic, retain) NSString * jockeyName;

@property (nonatomic, retain) NSString * ownerName;
@property (nonatomic, retain) NSString * Title;
@property (nonatomic, retain) NSString * Value;




@end
