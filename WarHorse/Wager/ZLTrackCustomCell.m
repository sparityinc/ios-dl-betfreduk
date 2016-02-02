//
//  ZLWagerCustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLTrackCustomCell.h"

@implementation ZLTrackCustomCell
@synthesize raceTrack_Label=_raceTrack_Label;
@synthesize information_Label=_information_Label;
@synthesize raceNumber_Label=_raceNumber_Label;
@synthesize mtp_Label=_mtp_Label;
@synthesize mtp_TimeLabel;
@synthesize mtpNewLabel;
@synthesize rankLbl;
@synthesize countryFlagImg;
@synthesize videoButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        videoButton.hidden = YES;
          }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
