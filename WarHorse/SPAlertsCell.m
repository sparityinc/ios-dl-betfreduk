//
//  SPAlertsCell.m
//  WarHorse
//
//  Created by sekhar on 28/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPAlertsCell.h"

@implementation SPAlertsCell
@synthesize titleLabel;

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
