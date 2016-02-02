//
//  SPSchedulesCell.m
//  WarHorse
//
//  Created by EnterPi on 22/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPSchedulesCell.h"
#import "SPSchedule.h"

@interface SPSchedulesCell ()


@end

@implementation SPSchedulesCell
@synthesize timeLabel;
@synthesize trackNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}
- (void)awakeFromNib
{
     //NSLog(@"%s",__func__);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateViewAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        self.contentView.backgroundColor = [UIColor colorWithRed:235.0/255.0f green:234.0/255.0f blue:234/255.0f alpha:1.0];
    }
    else
    {
        self.contentView.backgroundColor = [UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.timeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.timeLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f   blue:102.0/255.0f alpha:1.0]];
    //self.timeLabel.text = self.schedule.timeStr;
    
    [self.trackNameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.trackNameLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f   blue:30.0/255.0f alpha:1.0]];
    //self.trackNameLabel.text = self.schedule.trackNameStr;
    
    
}
@end
