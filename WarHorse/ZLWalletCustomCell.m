//
//  ZLWalletCustomCell.m
//  WarHorse
//
//  Created by Sparity on 8/7/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLWalletCustomCell.h"

@implementation ZLWalletCustomCell
@synthesize dateLabel=_dateLabel;
@synthesize cashLabel=_cashLabel;
@synthesize titleLable=_titleLable;
@synthesize detailLabel=_detailLabel;
@synthesize amountLable=_amountLable;
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
