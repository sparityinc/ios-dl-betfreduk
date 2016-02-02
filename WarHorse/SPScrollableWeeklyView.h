//
//  SPScrollableWeeklyView.h
//  WarHorse
//
//  Created by EnterPi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPSchedule;

@interface SPScrollableWeeklyView : UIView

@property (strong, nonatomic) SPSchedule *schedule;

- (void)updateView;

@end
