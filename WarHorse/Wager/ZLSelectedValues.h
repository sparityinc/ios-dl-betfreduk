//
//  ZLSelectedValues.h
//  WarHorse
//
//  Created by Sparity on 11/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLSelectedValues : NSObject

@property (nonatomic, strong) NSString *selectedAmount;
@property (nonatomic, strong) NSString *selectedBetType;
@property (nonatomic, strong) NSString *selectedRace;
@property (nonatomic, strong) NSString *selectedTrack;
@property (nonatomic, strong) NSString *selectedMTP;
@property (nonatomic, retain) NSMutableArray *selectedRunnersArray;
@property (nonatomic, assign) BOOL isAmountCustomSelected;

+ (id) sharedInstance;

@end
