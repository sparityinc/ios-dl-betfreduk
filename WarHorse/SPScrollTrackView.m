//
//  SPScrollTrackView.m
//  WarHorse
//
//  Created by Ramya on 8/23/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPScrollTrackView.h"
#import "SPTrackDetails.h"
#import "SPSelections.h"

@interface SPScrollTrackView ()

@property (strong, nonatomic) IBOutlet UILabel *trackName;
@property (strong, nonatomic) IBOutlet UILabel *raceVenue;

@end

@implementation SPScrollTrackView

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
    [self setBackgroundColor:self.trackDetails.bgColor];
    [self.trackName setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    [self.trackName setTextColor:[UIColor whiteColor]];
    self.trackName.text = self.trackDetails.trackname;
    [self.trackName setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumTrackNameLabelSize = CGSizeMake(299,9999);
    CGSize expectedTrackNameLabelSize=  [self.trackName.text boundingRectWithSize:maximumTrackNameLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.trackName.font } context:nil].size;
    
//Deprecated sizeWithFont
//    CGSize expectedTrackNameLabelSize = [self.trackName.text sizeWithFont:self.trackName.font constrainedToSize:maximumTrackNameLabelSize lineBreakMode:self.trackName.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect trackNameLabelNewFrame = self.trackName.frame;
    trackNameLabelNewFrame.size.width = expectedTrackNameLabelSize.width;
    trackNameLabelNewFrame.origin.x = (self.frame.size.width - trackNameLabelNewFrame.size.width)/2;
    self.trackName.frame = trackNameLabelNewFrame;
    
    [self.raceVenue setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.raceVenue setTextColor:[UIColor whiteColor]];
    
    [self.raceVenue setText:self.trackDetails.date];
    //self.raceVenue.text=self.trackDetails.;
    [self.raceVenue setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumRaceDetailLabelSize = CGSizeMake(299,9999);
    CGSize expectedRaceDetailLabelSize = [self.raceVenue.text boundingRectWithSize: maximumRaceDetailLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.raceVenue.font } context:nil].size;
    
//Deprecated sizeWithFont
//    CGSize expectedRaceDetailLabelSize = [self.raceVenue.text sizeWithFont:self.raceVenue.font constrainedToSize:maximumRaceDetailLabelSize lineBreakMode:self.raceVenue.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect trackVenueLabelNewFrame = self.raceVenue.frame;
    trackVenueLabelNewFrame.size.width = expectedRaceDetailLabelSize.width;
    trackVenueLabelNewFrame.origin.x = (self.frame.size.width - trackVenueLabelNewFrame.size.width)/2;
    self.raceVenue.frame = trackVenueLabelNewFrame;
    
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
