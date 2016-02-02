//
//  SPScrollView.m
//  WarHorse
//
//  Created by Ramya on 8/25/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPScrollView.h"
#import "SPDate.h"

@interface SPScrollView ()

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SPScrollView

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
    
    [self setBackgroundColor:self.date.bgColor];
    [self.dateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.dateLabel setTextColor:[UIColor whiteColor]];
    self.dateLabel.text = self.date.dateWiseDetails;    
    [self.dateLabel setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumTrackNameLabelSize = CGSizeMake(299,9999);
    CGSize expectedTrackNameLabelSize = [self.dateLabel.text boundingRectWithSize:maximumTrackNameLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.dateLabel.font } context:nil].size;

//Deprecated sizeWithFont
//    CGSize expectedTrackNameLabelSize = [self.dateLabel.text sizeWithFont:self.dateLabel.font constrainedToSize:maximumTrackNameLabelSize lineBreakMode:self.dateLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect trackNameLabelNewFrame = self.dateLabel.frame;
    trackNameLabelNewFrame.size.width = expectedTrackNameLabelSize.width;
    trackNameLabelNewFrame.origin.x = (self.frame.size.width - trackNameLabelNewFrame.size.width)/2;
    self.dateLabel.frame = trackNameLabelNewFrame;
    
       
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
