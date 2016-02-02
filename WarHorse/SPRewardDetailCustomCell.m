//
//  SPRewardDetailCustomCell.m
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPRewardDetailCustomCell.h"
#import "SPRewards.h"

@interface SPRewardDetailCustomCell () 

@property (nonatomic, strong) IBOutlet UILabel *moneyWageredLabel;
@property (nonatomic, strong) IBOutlet UILabel *wpsLabel;
@property (nonatomic, strong) IBOutlet UILabel *toHorseLabel;
@property (nonatomic, strong) IBOutlet UILabel *exoticaLabel;
@property (nonatomic, strong) IBOutlet UIView *dividerView1, *dividerView2, *dividerView3;


@end

@implementation SPRewardDetailCustomCell

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

- (void) updateHeaderInsection: (NSInteger) section
{
    
    [self.contentView setBackgroundColor:[UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0]];
    [self.dividerView1 setBackgroundColor:[UIColor colorWithRed:165.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0]];
    [self.dividerView2 setBackgroundColor:[UIColor colorWithRed:165.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0]];
    [self.dividerView3 setBackgroundColor:[UIColor colorWithRed:165.0/255.0 green:165.0/255.0 blue:165.0/255.0 alpha:1.0]];
    
    [self.dividerView1 setFrame:CGRectMake(119, 0, 1, 24)];
    [self.dividerView2 setFrame:CGRectMake(171, 0, 1, 24)];
    [self.dividerView3 setFrame:CGRectMake(233, 0, 1, 24)];
    
    [self.moneyWageredLabel setFrame:CGRectMake(0, 1, 118, 22)];
    [self.moneyWageredLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.moneyWageredLabel setTextColor:[UIColor whiteColor]];
    self.moneyWageredLabel.text = @"MONEY WAGERED";
    [self.moneyWageredLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.wpsLabel setFrame:CGRectMake(120, 1, 52, 22)];
    [self.wpsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.wpsLabel setTextColor:[UIColor whiteColor]];
    self.wpsLabel.text = @"WPS";
    [self.wpsLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.toHorseLabel setFrame:CGRectMake(172, 1, 63, 22)];
    [self.toHorseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.toHorseLabel setTextColor:[UIColor whiteColor]];
    self.toHorseLabel.text = @"2 HORSE";
    [self.toHorseLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.exoticaLabel setFrame:CGRectMake(234, 1, 62, 22)];
    [self.exoticaLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.exoticaLabel setTextColor:[UIColor whiteColor]];
    self.exoticaLabel.text = @"EXOTICS";
    [self.exoticaLabel setTextAlignment:NSTextAlignmentCenter];
    
}


- (void) updateViewAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row % 2 != 0) {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:235.0/255.0f green:234.0/255.0f blue:234/255.0f alpha:1.0]];
    }
    else
    {
        [self.contentView setBackgroundColor:[UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0]];
    }
    
    [self.dividerView1 setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    [self.dividerView2 setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    [self.dividerView3 setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    
    [self.dividerView1 setFrame:CGRectMake(119, 0, 1, 33)];
    [self.dividerView2 setFrame:CGRectMake(171, 0, 1, 33)];
    [self.dividerView3 setFrame:CGRectMake(233, 0, 1, 33)];
    
    [self.moneyWageredLabel setFrame:CGRectMake(0, 6, 118, 22)];
    [self.wpsLabel setFrame:CGRectMake(120, 6, 51, 21)];
    [self.toHorseLabel setFrame:CGRectMake(172, 6, 60, 21)];
    [self.exoticaLabel setFrame:CGRectMake(234, 6, 62, 21)];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.moneyWageredLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [self.moneyWageredLabel setTextColor:[UIColor colorWithRed:4.0/255.0f green:4.0/255.0f blue:4.0f/255.0f alpha:1.0]];
    self.moneyWageredLabel.text = self.rewards.moneyWagered;
    [self.moneyWageredLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.wpsLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.wpsLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0]];
    self.wpsLabel.text = self.rewards.WPS;
    [self.wpsLabel setTextAlignment:NSTextAlignmentCenter];
        
    [self.toHorseLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.toHorseLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0]];
    self.toHorseLabel.text = self.rewards.toHorse;
    [self.toHorseLabel setTextAlignment:NSTextAlignmentCenter];
        
    [self.exoticaLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [self.exoticaLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0]];
    self.exoticaLabel.text = self.rewards.exostics;
    [self.exoticaLabel setTextAlignment:NSTextAlignmentCenter];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
