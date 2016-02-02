//
//  SPCustomFeatureRacesCell.m
//  WarHorse
//
//  Created by Ramya on 8/24/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPCustomFeatureRacesCell.h"
#import "SPfeatureRaces.h"

@interface SPCustomFeatureRacesCell ()

@property (strong, nonatomic) IBOutlet UILabel *trackName;
@property (strong, nonatomic) IBOutlet UILabel *grade;
@property (strong, nonatomic) IBOutlet UILabel *time;

@end

@implementation SPCustomFeatureRacesCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) updateViewIndex : (NSIndexPath *)indexPath;{
    
    if (indexPath.row % 2 == 0) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0f green:235.0/255.0f blue:235.0/255.0f alpha:1.0]];
    }
    else{
        [self.contentView setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0]];
        
    }
    
    [self.trackName setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.trackName setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.trackName.text = self.featureRaces.trackname;
    [self.trackName setTextAlignment:NSTextAlignmentLeft];
    CGSize maximumparkTitleSize = CGSizeMake(299,9999);
    
//    CGSize expectedparkTitleSize=  [self.trackName.text boundingRectWithSize: maximumparkTitleSize options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName:self.trackName.font} context:nil].size;
//Deprecated sizeWithFont
CGSize expectedparkTitleSize = [self.trackName.text sizeWithFont:self.trackName.font constrainedToSize:maximumparkTitleSize lineBreakMode:self.trackName.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect parkTitleNewFrame = self.trackName.frame;
    parkTitleNewFrame.size.height = expectedparkTitleSize.height;
    self.trackName.frame = parkTitleNewFrame;
    
    [self.grade setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.grade setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
    self.grade.text=self.featureRaces.description;
    CGSize maximumdateLbelSize = CGSizeMake(299,9999);
//    CGSize expecteddateLbelSize=  [self.grade.text boundingRectWithSize: maximumdateLbelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.grade.font } context:nil].size;
    
//Deprecated sizeWithFont
    CGSize expecteddateLbelSize = [self.grade.text sizeWithFont:self.grade.font constrainedToSize:maximumdateLbelSize lineBreakMode:self.grade.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect dateLbelNewFrame = self.grade.frame;
    dateLbelNewFrame.size.height = expecteddateLbelSize.height;
    self.grade.frame = dateLbelNewFrame;
    
    [self.time setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.time setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
    self.time.text = [NSString stringWithFormat:@"%@ - %@ - %@", self.featureRaces.poolTotal, self.featureRaces.horseAge, self.featureRaces.distancePublished];
    CGSize maximumdateLbelSize1 = CGSizeMake(299,9999);
    
//    CGSize expecteddateLbelSize1=  [self.grade.text boundingRectWithSize: maximumdateLbelSize1 options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName:self.grade.font } context:nil].size;
    
//Deprecated sizeWithFont
    CGSize expecteddateLbelSize1 = [self.grade.text sizeWithFont:self.grade.font constrainedToSize:maximumdateLbelSize1 lineBreakMode:self.grade.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect dateLbelNewFrame1 = self.time.frame;
    dateLbelNewFrame1.size.height = expecteddateLbelSize1.height;
    self.time.frame = dateLbelNewFrame1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
