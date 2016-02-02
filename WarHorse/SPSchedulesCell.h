//
//  SPSchedulesCell.h
//  WarHorse
//
//  Created by EnterPi on 22/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPSchedule;

@interface SPSchedulesCell : UITableViewCell

@property (nonatomic, strong) SPSchedule *schedule;

- (void)updateViewAtIndexPath:(NSIndexPath *)indexPath;
@property(nonatomic,retain) IBOutlet UILabel *timeLabel;
@property(nonatomic,retain) IBOutlet UILabel *trackNameLabel;



@end
