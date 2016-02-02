//
//  ZLResultDetailCustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/31/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLResultDetailCustomCell.h"
#import "ZLCustomUILabel.h"
#import "ZLFinisher.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLBetResultRunner.h"
#import "WarHorseSingleton.h"

@interface ZLResultDetailCustomCell ()
{
    UIView *nonRunnersView;
}

@property(nonatomic, strong)IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *detailLabel;
@property(nonatomic, strong) IBOutlet UILabel *numberLabel;
@property(nonatomic, strong) IBOutlet UILabel *accessoryLabel;
@property(nonatomic, strong) IBOutlet UIImageView *separatorLineImage;
@property (strong, nonatomic) NSArray * runnerColors;
@property (strong,nonatomic) NSArray *harneesColors;

@end

@implementation ZLResultDetailCustomCell
@synthesize trackResult;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.runnerColors = @[@{@"bg":[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],@"text":[UIColor blackColor]},//1
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor blackColor]},//2
                          @{@"bg":[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0],@"text":[UIColor whiteColor]},//3
                          @{@"bg":[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0],@"text":[UIColor blackColor]},//4
                          @{@"bg":[UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0],@"text":[UIColor whiteColor]},//5
                          @{@"bg":[UIColor blackColor],@"text":[UIColor whiteColor]},//6
                          @{@"bg":[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:0.0/255.0 alpha:1.0],@"text":[UIColor blackColor]},//7
                          @{@"bg":[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0],@"text":[UIColor blackColor]},//8
                          @{@"bg":[UIColor colorWithRed:51.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0],@"text":[UIColor blackColor]},//9
                          @{@"bg":[UIColor colorWithRed:153.0/255.0 green:0.0/255.0 blue:153.0/255.0 alpha:1.0],@"text":[UIColor whiteColor]},//10
                          @{@"bg":[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0],@"text":[UIColor colorWithRed:128.0/225.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0]},//11
                          @{@"bg":[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0],@"text":[UIColor blackColor]}, //12
                          @{@"bg":[UIColor colorWithRed:153.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0],@"text":[UIColor whiteColor]},//13
                          @{@"bg":[UIColor colorWithRed:153.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0],@"text":[UIColor colorWithRed:0.0/225.0 green:255/255.0 blue:0.0/255.0 alpha:1.0]}, //14
                          @{@"bg":[UIColor colorWithRed:240.0/255.0 green:230.0/255.0 blue:140.0/255.0 alpha:1.0],@"text":[UIColor blackColor]},//15
                          @{@"bg":[UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:1.0],@"text":[UIColor colorWithRed:255.0/225.0 green:215/255.0 blue:0.0/255.0 alpha:1.0]},//16
                          @{@"bg":[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:128.0/255.0 alpha:1.0],@"text":[UIColor whiteColor]}, //17
                          @{@"bg":[UIColor colorWithRed:51.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0],@"text":[UIColor blackColor]}, //18
                          @{@"bg":[UIColor colorWithRed:70.0/255.0 green:130.0/255.0 blue:180.0/255.0 alpha:1.0],@"text":[UIColor blackColor]}, //19
                          @{@"bg":[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:255.0/255.0 alpha:1.0],@"text":[UIColor blackColor]}, //20
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]},
                          @{@"bg":[UIColor whiteColor],@"text":[UIColor colorWithRed:128.0/255.0 green:0.0/252.0 blue:0.0/255.0 alpha:1.0]}
                          ];
    
    
    
    
}

- (void)updateViewAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"trackResult %@",self.breedType);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
    [self.accessoryLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
     [self.numberLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:18.0]];
    if (indexPath.section == 0 && [self.trackResult.winnersByPosition count] > 0 ) {
        
        int i = self.frame.size.width - 65.0;
        int j = 22;
        
        ZLFinisher * finisher = [self.trackResult.winnersByPosition objectAtIndex:indexPath.row];
        if( finisher){
                        
            UIView * vw = [self.contentView viewWithTag:1002];
            if( vw ){
                [vw removeFromSuperview];
            }
            
            if( finisher.shwPayOff != nil && finisher.shwPayOff.length > 0&& ![finisher.shwPayOff isEqualToString:@"-"] ){
                ZLCustomUILabel *betType_label=[[ZLCustomUILabel alloc] init];
                [betType_label setFrame:CGRectMake(i, j, 44, 20)];
                [betType_label setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
                [betType_label setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
                betType_label.tag = 1002;
                
                UIColor *uicolor = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0];
                CGColorRef color = [uicolor CGColor];
                [betType_label.layer setBorderWidth:1.0];
                [betType_label.layer setMasksToBounds:YES];
                [betType_label.layer setBorderColor:color];
                
                betType_label.layer.borderWidth = 1.0;
                [betType_label setTextAlignment:NSTextAlignmentRight];
                [betType_label drawTextInRect:betType_label.frame];
                double payOff = [finisher.shwPayOff doubleValue];
                if( payOff > 0.0)
                    [betType_label setText:[NSString stringWithFormat:@"%@%@",[[WarHorseSingleton sharedInstance] currencySymbel],finisher.shwPayOff]];
                [self.contentView addSubview:betType_label];
                i -= 49;
            }
            
            vw = [self.contentView viewWithTag:1001];
            if( vw ){
                [vw removeFromSuperview];
            }
            
            if( finisher.plcPayOff != nil && finisher.plcPayOff.length > 0 && ![finisher.plcPayOff isEqualToString:@"-"]){
                ZLCustomUILabel *betType_label=[[ZLCustomUILabel alloc] init];
                [betType_label setFrame:CGRectMake(i, j, 44, 20)];
                [betType_label setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
                [betType_label setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
                betType_label.tag = 1001;
                
                UIColor *uicolor = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0];
                CGColorRef color = [uicolor CGColor];
                [betType_label.layer setBorderWidth:1.0];
                [betType_label.layer setMasksToBounds:YES];
                [betType_label.layer setBorderColor:color];
                
                betType_label.layer.borderWidth = 1.0;
                [betType_label setTextAlignment:NSTextAlignmentRight];
                [betType_label drawTextInRect:betType_label.frame];
                double payOff = [finisher.plcPayOff doubleValue];
                if( payOff > 0.0)
                    [betType_label setText:[NSString stringWithFormat:@"%@%@",[[WarHorseSingleton sharedInstance] currencySymbel],finisher.plcPayOff]];
                [self.contentView addSubview:betType_label];
                i -= 49;
            }
            
            vw = [self.contentView viewWithTag:1000];
            if( vw ){
                [vw removeFromSuperview];
            }

            
            if( finisher.winPayOff != nil && finisher.winPayOff.length > 0 && ![finisher.winPayOff isEqualToString:@"-"]){
                ZLCustomUILabel *betType_label=[[ZLCustomUILabel alloc] init];
                [betType_label setFrame:CGRectMake(i, j, 44, 20)];
                [betType_label setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
                [betType_label setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
                betType_label.tag = 1000;
                
                UIColor *uicolor = [UIColor colorWithRed:209.0/255.0 green:209.0/255.0 blue:209.0/255.0 alpha:1.0];
                CGColorRef color = [uicolor CGColor];
                [betType_label.layer setBorderWidth:1.0];
                [betType_label.layer setMasksToBounds:YES];
                [betType_label.layer setBorderColor:color];
                
                betType_label.layer.borderWidth = 1.0;
                [betType_label setTextAlignment:NSTextAlignmentRight];
                [betType_label drawTextInRect:betType_label.frame];
                double payOff = [finisher.winPayOff doubleValue];
                if( payOff > 0.0)
                    [betType_label setText:[NSString stringWithFormat:@"%@%@",[[WarHorseSingleton sharedInstance] currencySymbel],finisher.winPayOff]];
                [self.contentView addSubview:betType_label];
                i -= 49;
            }
            
        }        

        if( finisher){
            
            [self.titleLabel setFrame:CGRectMake(49, 2, 255, 20)];
            [self addSubview:self.numberLabel];
            [self.numberLabel setFrame:CGRectMake(6, 7.5, 38, 34.5)];
            [self.separatorLineImage setFrame:CGRectMake(6, 49, 298, 1)];
            
            /*if( indexPath.row == 0){
                [self.numberLabel setBackgroundColor:[UIColor colorWithRed:245.0/255.0f green:235.0/255.0f blue:0.0/255.0f alpha:1.0]];
                [self.numberLabel setTextColor:[UIColor blackColor]];
            }
            else if( indexPath.row == 1){
                [self.numberLabel setBackgroundColor:[UIColor colorWithRed:69.0/255.0f green:244.0/255.0f blue:1.0/255.0f alpha:1.0]];
                [self.numberLabel setTextColor:[UIColor blackColor]];
            }
            else {
                [self.numberLabel setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:26.0/255.0f blue:139.0/255.0f alpha:1.0]];
                [self.numberLabel setTextColor:[UIColor whiteColor]];
            }*/
            //breedType TB
            
            if ([self.breedType isEqualToString:@"S"]){
                [self.numberLabel setTextColor:[UIColor blackColor]];

                [self harnessColors:[NSString stringWithFormat:@"%d", finisher.runnerPosition]];

            }else{
                //self.runnerColors
                
                [self.numberLabel setBackgroundColor:[self.runnerColors[finisher.runnerPosition-1] objectForKey:@"bg"]];
                
                
                NSString *positionNo = [NSString stringWithFormat:@"%d", finisher.runnerPosition];
                if ([positionNo isEqualToString:@"2"]){
                    [self.numberLabel setTextColor:[UIColor blackColor]];
                    
                }
                if ([positionNo isEqualToString:@"6"]){
                    [self.numberLabel setTextColor:[UIColor whiteColor]];

                }
                
            }
           

            self.numberLabel.text = [NSString stringWithFormat:@"%d",finisher.runnerPosition];
            self.numberLabel.textAlignment=NSTextAlignmentCenter;
            self.titleLabel.text = finisher.horseName;
            [self.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
            [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
            self.numberLabel.layer.borderColor = [UIColor blackColor].CGColor;
            self.numberLabel.layer.borderWidth = 1.0;
            self.numberLabel.hidden = NO;

            
        }
    }
    else if (indexPath.section == 1){
        ZLBetResultRunner * betResultRunner = [trackResult.betsForRendering objectAtIndex:indexPath.row];
        if(betResultRunner != nil){
            [self.titleLabel setFrame:CGRectMake(6, 4, 255, 15)];
            [self.detailLabel setFrame:CGRectMake(6, 18, 255, 15)];
            self.titleLabel.text = [NSString stringWithFormat:@"%@%@ %@", [[WarHorseSingleton sharedInstance] currencySymbel],@"2.00", betResultRunner.betCode]; //Fix needed
            [self.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
            [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
            self.detailLabel.text = betResultRunner.combinations;
            [self.detailLabel setTextColor:[UIColor colorWithRed:136.0/255.0f green:136.0/255.0f blue:136.0/255.0f alpha:1.0]];
            [self.detailLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
            [self.separatorLineImage setFrame:CGRectMake(6, 38, 298, 1)];
            if( self.frame.size.width > 240)
                [self.accessoryLabel setFrame:CGRectMake(self.frame.size.width - 100.0 , 4.5, 80, self.accessoryLabel.frame.size.height)];
            else{
                [self.accessoryLabel setFrame:CGRectMake(self.frame.size.width - 100.0 , 4.5, 80, self.accessoryLabel.frame.size.height)];
            }
            double payOff = [betResultRunner.amount doubleValue];
            if( payOff != 0.0)
                [self.accessoryLabel setText:[NSString stringWithFormat:@"%@%@",[[WarHorseSingleton sharedInstance] currencySymbel], betResultRunner.amount]];
            [self.accessoryLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
            [self.accessoryLabel setTextAlignment:NSTextAlignmentRight];
            
            self.numberLabel.hidden = YES;
        }
    }
    else if (indexPath.section == 2)
    {
        ZLFinisher * finisher = [self.trackResult.finishersByPosition objectAtIndex:indexPath.row];
        if( finisher != nil){
            [self.titleLabel setFrame:CGRectMake(48, 3, 200, 20)];
            [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
            [self.detailLabel setFrame:CGRectMake(48, 19, self.frame.size.width - 65.0, 30)];
            [self.detailLabel setTextColor:[UIColor colorWithRed:119.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0]];
            [self.detailLabel setNumberOfLines:2];
            [self.detailLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:11]];
            [self.separatorLineImage setFrame:CGRectMake(6, 53, 298, 1)];
            [self addSubview:self.numberLabel];
            [self.numberLabel setFrame:CGRectMake(6, 9.5,  38, 34.5)];
            
            
            
            
            if ([self.breedType isEqualToString:@"S"]){
                [self.numberLabel setTextColor:[UIColor blackColor]];
                [self harnessColors:[NSString stringWithFormat:@"%d", finisher.runnerPosition]];
                
            }else{
                [self.numberLabel setBackgroundColor:[self.runnerColors[finisher.runnerPosition-1] objectForKey:@"bg"]];
                NSString *positionNo = [NSString stringWithFormat:@"%d", finisher.runnerPosition];
                if ([positionNo isEqualToString:@"2"]){
                    [self.numberLabel setTextColor:[UIColor blackColor]];
                }
                if ([positionNo isEqualToString:@"6"]){
                    [self.numberLabel setTextColor:[UIColor whiteColor]];
                }
            }
            
            
            [self.numberLabel setText:[NSString stringWithFormat:@"%d", finisher.runnerPosition]];
            [self.numberLabel setTextAlignment:NSTextAlignmentCenter];
            self.numberLabel.layer.borderColor = [UIColor blackColor].CGColor;
            self.numberLabel.layer.borderWidth = 1.0;
            
            self.titleLabel.text = finisher.horseName;
            self.detailLabel.text = [NSString stringWithFormat:@"J:%@ | T:%@ \nO:%@",finisher.jockeyName, finisher.trainerName, finisher.ownerName];
        }
        
        
        
        self.numberLabel.hidden = NO;
    }
    else if (indexPath.section == 3){
        ZLFinisher * scratcher = [trackResult.otherInformation objectAtIndex:indexPath.row];
        
        if( scratcher ){
            self.numberLabel.hidden = NO;

            [self.numberLabel setFrame:CGRectMake(6, 2.5, 20, 20)];

            [self.titleLabel setFrame:CGRectMake(20, 2.5, 255, 20)];
            self.titleLabel.text = [NSString stringWithFormat:@"%@",scratcher.Title];//scratcher.horseName;
            [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
            
            self.numberLabel.text = [NSString stringWithFormat:@"%@",scratcher.Value];//scratcher.horseName;
            [self.numberLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];

            [self.separatorLineImage setFrame:CGRectMake(6, 24, 298, 1)];
        }
        if (indexPath.row == 2) {
            if ([trackResult.scratches count]>0) {
                int profileyaxis = 5;
                UIView * view;
                view = [self.contentView viewWithTag:3002];
                if( view ){
                    [view removeFromSuperview];
                }
                view = [[UIView alloc]initWithFrame:CGRectMake(0,17, self.frame.size.width, self.frame.size.height+30)];
                [view setTag:3002];
                for (int i = 0; i < trackResult.scratches.count; i++) {
                    ZLFinisher * scratcher = [trackResult.scratches objectAtIndex:i];
            
                    
                    UILabel *labelTitle = [[UILabel alloc] init];

                    [labelTitle setFrame:CGRectMake(35, profileyaxis+3, 100, 20)];
                    [labelTitle setBackgroundColor:[UIColor clearColor]];
                    labelTitle.textAlignment = NSTextAlignmentCenter;

                    labelTitle.text = [NSString stringWithFormat:@"%@",scratcher.horseName];
                    [labelTitle setFont:[UIFont fontWithName:@"Roboto-Medium" size:9]];

                    [view addSubview:labelTitle];
            
            
                     UILabel *labelNumber = [[UILabel alloc] initWithFrame:CGRectMake(15, profileyaxis+6, 15, 15)];
                     [labelNumber setBackgroundColor:[UIColor grayColor]];
                     labelNumber.text = [NSString stringWithFormat:@"%d",scratcher.runnerPosition];
                    labelNumber.textAlignment = NSTextAlignmentCenter;
                    [labelNumber setBackgroundColor:[self.runnerColors[scratcher.runnerPosition-1] objectForKey:@"bg"]];
                    [labelNumber setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
                    [view addSubview:labelNumber];
                    
                    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(15,profileyaxis+25,self.frame.size.width-15,1)];
                    [viewLine setBackgroundColor:[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0]];
                    [view addSubview:viewLine];

            
                    profileyaxis = profileyaxis+25+2;

            
                    
            }
                [self.contentView addSubview:view];
                view = [self.contentView viewWithTag:3002];
                if( view ){
                    NSLog(@"view added");
                }
        }
            else
            {
              UIView * view = [self.contentView viewWithTag:3002];
                if( view )
                {
                    [view removeFromSuperview];
                }

            }
            
     
     }
        
    }
    
    
}

- (void)harnessColors:(NSString *)hoursPosition
{
    
    if ([hoursPosition isEqualToString:@"1"]){
        
        [self.numberLabel setBackgroundColor:[UIColor redColor]];
        [self.numberLabel setTextColor:[UIColor blackColor]];

        
    }else if ([hoursPosition isEqualToString:@"2"]){
        [self.numberLabel setBackgroundColor:[UIColor blueColor]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];

        
    }else if ([hoursPosition isEqualToString:@"3"]){
        [self.numberLabel setBackgroundColor:[UIColor whiteColor]];
        [self.numberLabel setTextColor:[UIColor blackColor]];

        
    }else if ([hoursPosition isEqualToString:@"4"]){
        [self.numberLabel setBackgroundColor:[UIColor colorWithRed:0/255.0f green:128.0/255.0f blue:0/255.0f alpha:1.0]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];
        
    }else if ([hoursPosition isEqualToString:@"5"]){
        [self.numberLabel setBackgroundColor:[UIColor blackColor]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];


        
    }else if ([hoursPosition isEqualToString:@"6"]){
        [self.numberLabel setBackgroundColor:[UIColor yellowColor]];
        [self.numberLabel setTextColor:[UIColor blackColor]];

        
    }else if ([hoursPosition isEqualToString:@"7"]){
        [self.numberLabel setBackgroundColor:[UIColor colorWithRed:255/255.0f green:204.0/255.0f blue:204/255.0f alpha:1.0]];
        [self.numberLabel setTextColor:[UIColor blackColor]];
        
    }else if ([hoursPosition isEqualToString:@"8"]){
        [self.numberLabel setBackgroundColor:[UIColor grayColor]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];

        
    }else if ([hoursPosition isEqualToString:@"9"]){
        [self.numberLabel setBackgroundColor:[UIColor purpleColor]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];

        
    }else if ([hoursPosition isEqualToString:@"10"]){
        [self.numberLabel setBackgroundColor:[UIColor orangeColor]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];

        
    }else if ([hoursPosition isEqualToString:@"11"]){
        [self.numberLabel setBackgroundColor:[UIColor colorWithRed:173/255.0f green:216.0/255.0f blue:230/255.0f alpha:1.0]];
        [self.numberLabel setTextColor:[UIColor blackColor]];
        
    }else if ([hoursPosition isEqualToString:@"12"]){
        [self.numberLabel setBackgroundColor:[UIColor brownColor]];
        [self.numberLabel setTextColor:[UIColor blackColor]];

        
    }else {
        [self.numberLabel setBackgroundColor:[UIColor colorWithRed:128/255.0f green:0/255.0f blue:0/255.0f alpha:1.0]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];

        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
