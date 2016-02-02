//
//  SPScrollableWeeklyView.m
//  WarHorse
//
//  Created by EnterPi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPScrollableWeeklyView.h"
#import "SPSchedule.h"

@interface SPScrollableWeeklyView ()

@property (strong, nonatomic) IBOutlet UILabel *dayScheduleNameLabel;

@end

@implementation SPScrollableWeeklyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateView
{

    [self setBackgroundColor:self.schedule.viewBgColor];
    [self.dayScheduleNameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15.0]];
    [self.dayScheduleNameLabel setText:self.schedule.timeStr];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
