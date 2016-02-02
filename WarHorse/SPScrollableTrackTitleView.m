//
//  SPScrollableTrackTitleView.m
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPScrollableTrackTitleView.h"
#import "SPSCRChangesDetailViewController.h"
#import "SPSCRChanges.h"

@interface SPScrollableTrackTitleView ()

@property (strong, nonatomic) IBOutlet UILabel *trackNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *raceDetailLabel;

@end

@implementation SPScrollableTrackTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Private API

- (void)updateView
{
    [self setBackgroundColor:self.scrChanges.viewBgColor];
    [self.trackNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
//    [self.trackNameLabel setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.trackNameLabel.text = self.scrChanges.trackname;
    [self.trackNameLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.raceDetailLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    if (self.isSCRChanges == YES) {
        
        [self.trackNameLabel setFrame:CGRectMake(0, 13, 220, 21)];
    }
    else
    {
        self.raceDetailLabel.text=self.scrChanges.date;

    }
    
    [self.raceDetailLabel setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumRaceDetailLabelSize = CGSizeMake(299,9999);
    CGSize expectedRaceDetailLabelSize=  [self.raceDetailLabel.text boundingRectWithSize: maximumRaceDetailLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName:self.raceDetailLabel.font } context: nil].size;
//Deprecated sizeWithFont
//    CGSize expectedRaceDetailLabelSize = [self.raceDetailLabel.text sizeWithFont:self.raceDetailLabel.font constrainedToSize:maximumRaceDetailLabelSize lineBreakMode:self.raceDetailLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect trackVenueLabelNewFrame = self.raceDetailLabel.frame;
    trackVenueLabelNewFrame.size.width = expectedRaceDetailLabelSize.width;
    trackVenueLabelNewFrame.origin.x = (self.frame.size.width - trackVenueLabelNewFrame.size.width)/2;
    self.raceDetailLabel.frame = trackVenueLabelNewFrame;
    
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
