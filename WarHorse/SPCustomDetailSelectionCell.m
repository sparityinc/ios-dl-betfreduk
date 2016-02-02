//
//  SPCustomDetailSelectionCell.m
//  WarHorse
//
//  Created by Ramya on 8/22/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPCustomDetailSelectionCell.h"
#import "SPDetailSelection.h"
#import <stdlib.h>

@interface SPCustomDetailSelectionCell ()

@property (strong, nonatomic) IBOutlet UILabel *horseNameLabel1;
@property (strong, nonatomic) IBOutlet UILabel *horseNameLabel2;
@property (strong, nonatomic) IBOutlet UILabel *horseNameLabel3;
@property (strong, nonatomic) IBOutlet UILabel *raceLabel;
@property (strong, nonatomic) IBOutlet UILabel *horseNumberLabel1;
@property (strong, nonatomic) IBOutlet UILabel *horseNumberLabel2;
@property (strong, nonatomic) IBOutlet UILabel *horseNumberLabel3;
@property (strong, nonatomic) UILabel *positionLabel1;
@property (strong, nonatomic) UILabel *positionLabel2;
@property (strong, nonatomic) UILabel *positionLabel3;

@end

@implementation SPCustomDetailSelectionCell

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

- (void) updateViewIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0]];

    }
    else{
         [self.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0f green:234.0/255.0f blue:234/255.0f alpha:1.0]];
        
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.positionLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(83, 13, 300, 16)];
    [self.positionLabel1 setText:@"1"];
    [self.positionLabel1 setBackgroundColor:[UIColor clearColor]];
    [self.positionLabel1 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.positionLabel1 setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f   blue:4.0/255.0f alpha:1.0]];
    [self.contentView addSubview:self.positionLabel1];
    
    self.positionLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(83,36 , 300, 16)];
     [self.positionLabel2 setText:@"2"];
    [self.positionLabel2 setBackgroundColor:[UIColor clearColor]];
    [self.positionLabel2 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.positionLabel2 setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f   blue:4.0/255.0f alpha:1.0]];
      [self.contentView addSubview:self.positionLabel2];
    
    self.positionLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(83,61, 300, 16)];
     [self.positionLabel3 setText:@"3"];
    [self.positionLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.positionLabel3 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.positionLabel3 setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f   blue:4.0/255.0f alpha:1.0]];
    [self.contentView addSubview:self.positionLabel3];
    
    
    [self.horseNumberLabel1 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.horseNumberLabel1 setTextColor:[UIColor whiteColor ]];
    self.horseNumberLabel1.text = self.detailSelectons.horseNumber1;
    [self.horseNumberLabel1 setBackgroundColor:[UIColor colorWithRed:arc4random() % 100/255.0f green:50.0/255.0f blue:210.0/255.0f alpha:1.0]];
    [self.horseNumberLabel1 setTextAlignment:NSTextAlignmentCenter];
  
    
    [self.horseNumberLabel2 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.horseNumberLabel2 setTextColor:[UIColor whiteColor]];
    self.horseNumberLabel2.text = self.detailSelectons.horseNumber2;
   [self.horseNumberLabel2 setBackgroundColor:[UIColor colorWithRed:arc4random() % 160/255.0f green:10.0/255.0f blue:210.0/255.0f alpha:1.0]];
    [self.horseNumberLabel2 setTextAlignment:NSTextAlignmentCenter];
      
    [self.horseNumberLabel3 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.horseNumberLabel3 setTextColor:[UIColor whiteColor]];
    self.horseNumberLabel3.text = self.detailSelectons.horseNumber3;
    [self.horseNumberLabel3 setBackgroundColor:[UIColor colorWithRed:arc4random() % 120/255.0f green:160.0/255.0f blue:210.0/255.0f alpha:1.0]];
    [self.horseNumberLabel3 setTextAlignment:NSTextAlignmentCenter];
    
    [self.horseNameLabel1 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.horseNameLabel1 setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0]];
    self.horseNameLabel1.text = self.detailSelectons.horseName1;
    [self.horseNameLabel1 setTextAlignment:NSTextAlignmentLeft];
    CGSize maximumparkTitleSize = CGSizeMake(299,9999);

    CGSize expectedparkTitleSize=  [self.horseNameLabel1.text boundingRectWithSize: maximumparkTitleSize options: NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes: @{ NSFontAttributeName: self.horseNameLabel1.font } context: nil].size;
//Depredated sizeWithFont
//    CGSize expectedparkTitleSize = [self.horseNameLabel1.text sizeWithFont:self.horseNameLabel1.font constrainedToSize:maximumparkTitleSize lineBreakMode:self.horseNameLabel1.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect forcastnewframe1 = self.horseNameLabel1.frame;
    forcastnewframe1.size.height = expectedparkTitleSize.height;
    self.horseNameLabel1.frame = forcastnewframe1;
    
    [self.horseNameLabel2 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.horseNameLabel2 setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0]];
    self.horseNameLabel2.text=self.detailSelectons.horseName2;
    CGSize maximumdateLbelSize = CGSizeMake(299,9999);
    CGSize expecteddateLbelSize=  [self.horseNameLabel2.text boundingRectWithSize: maximumdateLbelSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.horseNameLabel2.font } context:nil].size;
//Depredated sizeWithFont
//    CGSize expecteddateLbelSize = [self.horseNameLabel2.text sizeWithFont:self.horseNameLabel2.font constrainedToSize:maximumdateLbelSize lineBreakMode:self.horseNameLabel2.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect forecastNewFrame2 = self.horseNameLabel2.frame;
    forecastNewFrame2.size.height = expecteddateLbelSize.height;
    self.horseNameLabel2.frame = forecastNewFrame2;
    
    [self.horseNameLabel3 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.horseNameLabel3 setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0f/255.0f alpha:1.0]];
    self.horseNameLabel3.text=self.detailSelectons.horseName3;
    CGSize maximumdateLbelSize1 = CGSizeMake(299,9999);
    CGSize expecteddateLbelSize1=  [self.horseNameLabel3.text boundingRectWithSize: maximumdateLbelSize1 options: NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: self.horseNameLabel3.font } context: nil].size;
//Depredated sizeWithFont
//    CGSize expecteddateLbelSize1 = [self.horseNameLabel3.text sizeWithFont:self.horseNameLabel3.font constrainedToSize:maximumdateLbelSize1 lineBreakMode:self.horseNameLabel3.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect forecastNewFrame3 = self.horseNameLabel3.frame;
    forecastNewFrame3.size.height = expecteddateLbelSize1.height;
    self.horseNameLabel3.frame = forecastNewFrame3;
    
    [self.raceLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.raceLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0]];
    self.raceLabel.text=[NSString stringWithFormat:@"Race %@", self.detailSelectons.race];
    CGSize maximumdateLbelSize2 = CGSizeMake(299,9999);
    CGSize expecteddateLbelSize2=  [self.raceLabel.text boundingRectWithSize: maximumdateLbelSize2 options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.raceLabel.font } context:nil].size;
//Depredated sizeWithFont
//    CGSize expecteddateLbelSize2 = [self.raceLabel.text sizeWithFont:self.raceLabel.font constrainedToSize:maximumdateLbelSize2 lineBreakMode:self.raceLabel.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect raceNewFrame = self.raceLabel.frame;
    raceNewFrame.size.height = expecteddateLbelSize2.height;
    self.raceLabel.frame = raceNewFrame;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
