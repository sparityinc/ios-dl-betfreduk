//
//  ZLConformationViewController.m
//  WarHorse
//
//  Created by Sparity on 06/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLConformationViewController.h"
#import "ZLSelectedValues.h"
#import "ZLAppDelegate.h"
#import "ZLWager.h"
#import <QuartzCore/QuartzCore.h>
#import "SPConstant.h"
#import "LeveyHUD.h"
#import "WarHorseSingleton.h"


@interface ZLConformationViewController ()

@property (nonatomic ,strong) IBOutlet UIView *confirmationView;
@end

@implementation ZLConformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IS_IPHONE5){
        //self.addCardBtn.frame = CGRectMake(self.addCardBtn.frame.origin.x, 480, self.addCardBtn.frame.size.width, self.addCardBtn.frame.size.height);
        self.confirmationView.frame = CGRectMake(self.confirmationView.frame.origin.x, 150,self.confirmationView.frame.size.width , self.confirmationView.frame.size.height);
    }
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
    self.raceNumberLabel.adjustsFontSizeToFitWidth = YES;
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.raceNumberLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:21]];
    [self.dateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.trackNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.leftPriseLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.betTypeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.runnersLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.amountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.numberOfBetsLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.totalAmountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.buttonConfirm.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.buttonCancel.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.totalLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.bottomDateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    if(_race_card){

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd-MMM-yy"];

        [self.dateLabel setText:[formatter stringFromDate:[NSDate date]]];
        [self.trackNameLabel setText:_race_card.ticketName];
        
        
        
        if ([[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"MultiHorseType"]){
            
            NSString *betTypeRange = [ZLAppDelegate getAppData].currentWager.raceTimeRange;
            //[raceLabel setText:betTypeRange];
            
            if(betTypeRange == nil || [betTypeRange length] <= 0){
                if ([_race_card.trackCountry isEqualToString:@"UK"]){
                    //[self.wagerCustomCell.raceNumber_Label setText:[NSString stringWithFormat:@"Race\n%@", _race_card.currentRace]];
                    [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %@", _race_card.currentRace]];
                    
                    
                }else {
                    [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %d",[ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                    
                    
                }
            }else {
                [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %@", betTypeRange]];

                
            }

            
            
        }else{
            if ([_race_card.trackCountry isEqualToString:@"UK"]){
                //[self.wagerCustomCell.raceNumber_Label setText:[NSString stringWithFormat:@"Race\n%@", _race_card.currentRace]];
                [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %@", _race_card.currentRace]];
                
                
            }else {
                [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %d",[ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                
                
            }
        }
        
        self.raceNumberLabel.adjustsFontSizeToFitWidth = YES;


        
        
       // [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %d",[ZLAppDelegate getAppData].currentWager.selectedRaceId]];
        
        NSString *amountValue =[NSString stringWithFormat:@"%.0f", [ZLAppDelegate getAppData].currentWager.amount];
        float amountInt = [amountValue floatValue];
        if (1<=amountInt){
            [self.leftPriseLabel setText:[NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].currentWager.amount]];
            
        }else{
            int amount  =  [ZLAppDelegate getAppData].currentWager.amount*100;
            NSLog(@"cost %d",amount);
            [self.leftPriseLabel setText:[NSString stringWithFormat:@"%d%@", amount,@"p"]];
            
        }
        

        
        if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"E5N"]){
            [self.betTypeLabel setText:@"PEN"];
        }
        else{
            [self.betTypeLabel setText:[ZLAppDelegate getAppData].currentWager.selectedBetType];
        }
        
        
        double total = [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount];
        int bets = total / [ZLAppDelegate getAppData].currentWager.amount;
        
        [self.runnersLabel setText:[[ZLAppDelegate getAppData].currentWager getBetString]];
        
        
        
        NSString *totalAmount =[NSString stringWithFormat:@"%.0f", total];
        float totalAmountInt = [totalAmount floatValue];
        if (1<=totalAmountInt){
            [self.amountLabel setText:[NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],total]];
            [self.totalAmountLabel setText:[NSString stringWithFormat:@"Total %@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],total]];

            
        }else{
            int amount  =  total*100;
            NSLog(@"cost %d",amount);
            [self.amountLabel setText:[NSString stringWithFormat:@"%d%@", amount,@"p"]];
            [self.totalAmountLabel setText:[NSString stringWithFormat:@"%d%@", amount,@"p"]];

            
        }

        
        
        [self.numberOfBetsLabel setText:[NSString stringWithFormat:@"%d Bet(s)", bets]];
        
        [formatter setDateFormat:@"dd-MMM-yyyy hh:mm:ss"];
        [self.bottomDateLabel setText:[formatter stringFromDate:[NSDate date]]];
        
        [[LeveyHUD sharedHUD] disappear];
    }

}

- (IBAction)conformButtonClicked:(id)sender
{
    //[self.view removeFromSuperview];
    [self.delegate confirmWager:self];
}
- ( IBAction)cancelButtonClicked:(id)sender
{
    [self.delegate cancelWager:self];
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
