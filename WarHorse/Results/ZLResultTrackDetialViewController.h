//
//  ZLResultTrackDetialViewController.h
//  WarHorse
//
//  Created by Sparity on 7/31/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCalendarScrollView.h"
#import "ZLLoadCardTracks.h"
#import "GAITrackedViewController.h"

@interface ZLResultTrackDetialViewController : GAITrackedViewController <ZLCalendarScrollViewDelegate, UIScrollViewDelegate>


@property(nonatomic, retain) ZLLoadCardTracks * track;

@property(nonatomic, retain) NSDate * resultDate;

@property(assign) int meet;

@property(assign) int perf;

@property (nonatomic,strong) NSString *trackCode;

@property (nonatomic,strong) NSString *dateStr;

@property (nonatomic,strong) NSString *breedType;

@property (nonatomic,strong) NSString *trackCountryFlag;

-(void) setup;

@end
