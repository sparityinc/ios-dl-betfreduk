//
//  SPTodaysTrackCell.m
//  WarHorse
//
//  Created by Sparity on 22/01/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import "SPTodaysTrackCell.h"

@implementation SPTodaysTrackCell

@synthesize raceTrack_Label=_raceTrack_Label;
@synthesize information_Label=_information_Label;
@synthesize raceNumber_Label=_raceNumber_Label;
@synthesize mtp_Label=_mtp_Label;
@synthesize mtp_TimeLabel;
@synthesize mtpNewLabel;
@synthesize rankLbl;
@synthesize videoButton,countryFlagImg;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
