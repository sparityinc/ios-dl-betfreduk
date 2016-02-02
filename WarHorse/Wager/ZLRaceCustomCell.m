//
//  ZLRaceCustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLRaceCustomCell.h"

@implementation ZLRaceCustomCell
@synthesize trackLabel=_trackLabel;
@synthesize furlongLabel=_furlongLabel;
@synthesize mtpLabel=_mtpLabel;
@synthesize amountLabel=_amountLabel;
@synthesize statusLabel=_statusLabel;


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
