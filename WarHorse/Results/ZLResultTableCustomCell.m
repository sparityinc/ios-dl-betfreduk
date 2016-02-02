//
//  ZLResultTableCustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/31/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLResultTableCustomCell.h"

@implementation ZLResultTableCustomCell
@synthesize trackName_Label=_trackName_Label;
@synthesize address_Label=_address_Label;
@synthesize countryFlag;
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
