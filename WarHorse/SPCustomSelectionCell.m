//
//  SPCustomSelectionCell.m
//  WarHorse
//
//  Created by Ramya on 8/22/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPCustomSelectionCell.h"
#import "SPSelections.h"

@interface SPCustomSelectionCell ()

@property (strong, nonatomic) IBOutlet UILabel *raceTrackTitle;
@property (strong, nonatomic) IBOutlet UILabel *racePlace;

@end

@implementation SPCustomSelectionCell

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

- (void) updateViewIndex:(NSIndexPath *)indexPath
{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2 == 0) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0]];
    }
    else{
        [self.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0f green:234.0/255.0f blue:234/255.0f alpha:1.0]];
        
    }
   
    [self.raceTrackTitle setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    [self.raceTrackTitle setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.raceTrackTitle.text = self.selections.raceTrackTitle;
    [self.raceTrackTitle setTextAlignment:NSTextAlignmentLeft];
    CGSize maximumparkTitleSize = CGSizeMake(299,9999);
    
    CGSize expectedparkTitleSize=  [self.raceTrackTitle.text boundingRectWithSize:maximumparkTitleSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.raceTrackTitle.font } context:nil].size;
    
    //CGSize expectedparkTitleSize = [self.raceTrackTitle.text sizeWithFont:self.raceTrackTitle.font constrainedToSize:maximumparkTitleSize lineBreakMode:self.raceTrackTitle.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect parkTitleNewFrame = self.raceTrackTitle.frame;
    parkTitleNewFrame.size.height = expectedparkTitleSize.height;
    self.raceTrackTitle.frame = parkTitleNewFrame;
    
    [self.racePlace setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.racePlace setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
    self.racePlace.text=self.selections.racePlace;
    CGSize maximumdateLbelSize = CGSizeMake(299,9999);
    
    CGSize expecteddateLbelSize=  [self.racePlace.text boundingRectWithSize:maximumdateLbelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.raceTrackTitle.font } context:nil].size;
    
    //CGSize expecteddateLbelSize = [self.racePlace.text sizeWithFont:self.racePlace.font constrainedToSize:maximumdateLbelSize lineBreakMode:self.racePlace.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect dateLbelNewFrame = self.racePlace.frame;
    dateLbelNewFrame.size.height = expecteddateLbelSize.height;
    self.racePlace.frame = dateLbelNewFrame;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
