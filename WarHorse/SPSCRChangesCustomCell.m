//
//  SPSCRChangesCustomCell.m
//  WarHorse
//
//  Created by Enterpi on 22/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPSCRChangesCustomCell.h"
#import "SPSCRChanges.h"

@interface SPSCRChangesCustomCell ()

@property (strong, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *trackVenueLabel;

@end

@implementation SPSCRChangesCustomCell

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
    
    [self.trackTitleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.trackTitleLabel setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.trackTitleLabel.text = self.scrChanges.trackname;
    [self.trackTitleLabel setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumTrackTitleLabelSize = CGSizeMake(299,9999);
    
    CGSize expectedTrackTitleLabelSize=  [self.trackTitleLabel.text boundingRectWithSize: maximumTrackTitleLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.trackTitleLabel.font } context: nil].size;
    
//Deprecated sizeWithFont
//    CGSize expectedTrackTitleLabelSize = [self.trackTitleLabel.text sizeWithFont:self.trackTitleLabel.font constrainedToSize:maximumTrackTitleLabelSize lineBreakMode:self.trackTitleLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect trackTitleLabelNewFrame = self.trackTitleLabel.frame;
    trackTitleLabelNewFrame.size.width = expectedTrackTitleLabelSize.width;
    self.trackTitleLabel.frame = trackTitleLabelNewFrame;
    
    [self.trackVenueLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.trackVenueLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0]];
    [self.trackVenueLabel setTextAlignment:NSTextAlignmentLeft];
    
    CGSize maximumTrackVenueLabelSize = CGSizeMake(299,9999);
    CGSize expectedTrackVenueSize = [self.trackVenueLabel.text boundingRectWithSize:maximumTrackVenueLabelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.trackVenueLabel.font } context:nil].size;
    
//Deprecated sizeWithFont
//    CGSize expectedTrackVenueSize = [self.trackVenueLabel.text sizeWithFont:self.trackVenueLabel.font constrainedToSize:maximumTrackVenueLabelSize lineBreakMode:self.trackVenueLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect trackVenueLabelNewFrame = self.trackVenueLabel.frame;
    trackVenueLabelNewFrame.size.width = expectedTrackVenueSize.width;
    self.trackVenueLabel.frame = trackVenueLabelNewFrame;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
