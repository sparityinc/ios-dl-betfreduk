//
//  ZLCurrentBetCustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/11/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLCurrentBetCustomCell.h"

@implementation ZLCurrentBetCustomCell
@synthesize amountDollar_Label=_amountDollar_Label;
@synthesize betType_Label=_betType_Label;
@synthesize betDollar_Label=_betDollar_Label;

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

- (void)updateViewAtIndexPath:(NSIndexPath *)indexPath
{
    //[self.contentView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    //[self.accessoryView setBackgroundColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]];
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.backgroundView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.amountDollar_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.betDollar_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.betType_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    self.betType_Label.lineBreakMode = NSLineBreakByWordWrapping;
    self.betType_Label.numberOfLines = 10;
    
    self.cancelBetButton.tag = 20+indexPath.row;

}

- (IBAction)cancelbet:(id)sender
{
    
    [self.currentBetTypeDelegate cancelBetForSender:sender];
}

@end
