//
//  ZLMainTableCustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLMainTableCustomCell.h"

@implementation ZLMainTableCustomCell
@synthesize titleLabel=_titleLabel;
@synthesize iconImages=_iconImages;
@synthesize detailDisclosureImageView;

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
