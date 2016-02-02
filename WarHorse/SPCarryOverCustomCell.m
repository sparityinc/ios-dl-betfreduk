//
//  SPCarryOverCustomCell.m
//  WarHorse
//
//  Created by Ramya on 8/20/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPCarryOverCustomCell.h"
#import "SPCarryOver.h"

@interface SPCarryOverCustomCell ()

@property (strong, nonatomic) IBOutlet UILabel *parkTitle;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLbel;

@end

@implementation SPCarryOverCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
    }
    return self;
}

- (void) awakeFromNib
{
  
}

#pragma mark - Private API

- (void) updateViewAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row % 2 == 0) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0f green:234.0/255.0f blue:234/255.0f alpha:1.0]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0]];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.parkTitle setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    [self.parkTitle setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.parkTitle.text = self.carryOver.trackname;
    [self.parkTitle setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumparkTitleSize = CGSizeMake(299,9999);
    CGSize expectedparkTitleSize=  [self.parkTitle.text boundingRectWithSize: maximumparkTitleSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName:self.parkTitle.font } context: nil].size;
//Deprecated sizeWithFont
//    CGSize expectedparkTitleSize = [self.parkTitle.text sizeWithFont:self.parkTitle.font constrainedToSize:maximumparkTitleSize lineBreakMode:self.parkTitle.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect parkTitleNewFrame = self.parkTitle.frame;
    parkTitleNewFrame.size.width = expectedparkTitleSize.width;
    self.parkTitle.frame = parkTitleNewFrame;
    
    [self.priceLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:17]];
    [self.priceLabel setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.priceLabel.text=self.carryOver.carryOver;
    [self.priceLabel setTextAlignment:NSTextAlignmentRight];

    CGSize maximumpriceLabelSize = CGSizeMake(100,30);
    CGSize expectedpriceLabelSize = [self.priceLabel.text boundingRectWithSize:maximumpriceLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.priceLabel.font } context:nil].size;
//Deprecated sizeWithFont
//    CGSize expectedpriceLabelSize = [self.priceLabel.text sizeWithFont:self.priceLabel.font constrainedToSize:maximumpriceLabelSize lineBreakMode:self.priceLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect priceLabelNewFrame = self.priceLabel.frame;
    priceLabelNewFrame.size.width = expectedpriceLabelSize.width;
    priceLabelNewFrame.origin.x = self.frame.size.width - priceLabelNewFrame.size.width - 9;
    self.priceLabel.frame = priceLabelNewFrame;
    
    [self.dateLbel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.dateLbel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
    
    self.dateLbel.text=self.carryOver.poolType;
    
    CGSize maximumdateLbelSize = CGSizeMake(299,9999);
    CGSize expecteddateLbelSize = [self.dateLbel.text boundingRectWithSize: maximumdateLbelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.dateLbel.font } context:nil].size;
    
//Deprecated sizeWithFont
//    CGSize expecteddateLbelSize = [self.dateLbel.text sizeWithFont:self.dateLbel.font constrainedToSize:maximumdateLbelSize lineBreakMode:self.dateLbel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect dateLbelNewFrame = self.dateLbel.frame;
    dateLbelNewFrame.size.width = expecteddateLbelSize.width;
    self.dateLbel.frame = dateLbelNewFrame;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
