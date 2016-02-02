//
//  SPLiveVideoTableCell.m
//  WarHorse
//
//  Created by Ramya on 10/1/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPLiveVideoTableCell.h"

@implementation SPLiveVideoTableCell
@synthesize messageLabel;

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

- (void) updateViewAtIndexPath: (NSIndexPath *)indexPath
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2 == 0) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0f green:234.0/255.0f blue:234/255.0f alpha:1.0]];
    }
    else {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0]];
    }
    
    [self.messageLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.messageLabel setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    
    
    
}


@end
