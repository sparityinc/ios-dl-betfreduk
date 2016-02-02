//
//  ZLViewController.m
//  OddsMatrix
//
//  Created by Sparity on 08/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLOddsBoardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "ZLOddsPool.h"
#import "ZLOddsPoolRunner.h"
#import "ZLAppData.h"
#import "ZLWager.h"
#import "WarHorseSingleton.h"
@interface ZLOddsBoardViewController ()

@property(nonatomic, strong) ZLOddsPool *oddsPool;
@property (nonatomic,strong) IBOutlet UIImageView *flagImage;
@property (nonatomic,weak) IBOutlet UILabel *trackName;
@property (nonatomic,weak) IBOutlet UILabel *raceNo;

@property (assign) BOOL isPlcValidHeader;
@property (assign) BOOL isPlcValid;


@end

@implementation ZLOddsBoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isPlcValidHeader = NO;
    self.isPlcValid = NO;
	// Do any additional setup after loading the view, typically from a nib.
    
//    NSLog(@"Track NAme %@ race no %@ Flag %@",[[WarHorseSingleton sharedInstance] selectTrackName],[[WarHorseSingleton sharedInstance] selectRaceNo],[[WarHorseSingleton sharedInstance] selectTrackCountry]);
    
    
    
    if ([[[WarHorseSingleton sharedInstance] selectTrackCountry] isEqualToString:@"UK"]){
        self.flagImage.image = [UIImage imageNamed:@"uk.png"];
    }else if ([[[WarHorseSingleton sharedInstance] selectTrackCountry] isEqualToString:@"US"]){
        self.flagImage.image = [UIImage imageNamed:@"us.png"];
        
    }
//    NSString *racNo = [NSString stringWithFormat:@"- Race-%@",[[WarHorseSingleton sharedInstance] selectRaceNo]];
    
//    self.raceNo.text = racNo;
    self.trackName.text = [NSString stringWithFormat:@"%@-%@",[[WarHorseSingleton sharedInstance] selectTrackName],[[WarHorseSingleton sharedInstance] selectRaceNo]];//[[WarHorseSingleton sharedInstance] selectTrackName];
    [self.raceNo setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.trackName setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.trackName setAdjustsFontSizeToFitWidth:YES];

//will pay
    NSString *title1 = @"Will Pay";//[NSString stringWithFormat:@"Will Pay (%@)",[[WarHorseSingleton sharedInstance] currencySymbel]];

    self.probablesLabel.text = title1;
    [self.probablesButton setTitle:title1 forState:UIControlStateNormal];

    self.oddsPoolButton.layer.borderWidth = 1;
    self.oddsPoolButton.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;
    
    self.probablesButton.layer.borderWidth = 1;
    self.probablesButton.layer.borderColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0].CGColor;
    
    self.oddsPoolButton.hidden = YES;
    self.probablesButton.hidden = YES;
    
    [self loadData];
    self.oddsPool = nil;
    
    [headerLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    
    
    
    [self.probablesLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];

    [self.probablesLabel.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.probablesLabel.layer setBorderWidth:1.5];
    
/*
    NSLog(@"odds board %@",[[WarHorseSingleton sharedInstance] betType]);
    if ([[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"SingleHorseType"]) {
        self.oddsPoolButton.hidden = YES;
        self.probablesButton.hidden = YES;
    }
    else {
        self.oddsPoolButton.hidden = NO;
        self.probablesButton.hidden = NO;
    }
    */
    //EBX QBX
    
    /*
     //multibetTypes
     [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"TRI"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"TBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"SFC"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"SFX"]
     
     
     //MultihorseType
     
     [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK3"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK4"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK5"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK6"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK7"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK8"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK9"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PK10"]||||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"OTT"]
     

     */
    //MultiHorseType
    
    if([[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"SingleHorseType"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]|| [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"TRI"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"TBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"TRB"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"SFC"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"SFX"]||[[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"MultiHorseType"]) {
        
        self.oddsPoolButton.hidden = YES;
        self.probablesButton.hidden = YES;
        
        
        self.probablesLabel.hidden = YES;
        
 
        
        
        if ([[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"SingleHorseType"]){
            [headerLabel setText:@"Odds Board"];
            self.probablesLabel.text = @"Odds Board";
            
        }else if ([[[WarHorseSingleton sharedInstance] betType] isEqualToString:@"MultiHorseType"]){
            
            
            if ([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"]){
                NSString *title = @"Will Pay";//[NSString stringWithFormat:@"Will Pay (%@)",[[WarHorseSingleton sharedInstance] currencySymbel]];

                [headerLabel setText:title];
                self.probablesLabel.text = title;
            }else{
                [headerLabel setText:@"Odds Board"];
                self.probablesLabel.text = @"Odds Board";
            }

        }else{
            if ([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||
                [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]||
                [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]){
                 NSString *title = @"Will Pay";//[NSString stringWithFormat:@"Will Pay (%@)",[[WarHorseSingleton sharedInstance] currencySymbel]];
                [headerLabel setText:title];
                self.probablesLabel.text = title;
                
            }else{
                [headerLabel setText:@"Odds Board"];
                self.probablesLabel.text = @"Odds Board";
            }
        }
        [self.probablesButton setSelected:YES];
        
        self.probablesButton.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;
        
        [self.probablesButton setBackgroundColor:[UIColor colorWithRed:35.0/255 green:108.0/255 blue:142.0/255 alpha:1.0]];
    }
    else {
        
        self.probablesLabel.hidden = YES;
        [headerLabel setText:@"Odds Board"];
        self.oddsPoolButton.hidden = YES;
        self.probablesButton.hidden = YES;

    }
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}

- (void)loadData
{

    self.runnersArray = [[NSMutableArray alloc] init];

    NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
    [dic1 setValue:@"1" forKey:@"horseNumber"];
    [dic1 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic1 setObject:[UIColor colorWithRed:255.0/256 green:0.0/256 blue:0.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic1];
    
    NSMutableDictionary *dic2=[NSMutableDictionary dictionary];
    [dic2 setValue:@"2" forKey:@"horseNumber"];
    [dic2 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic2 setObject:[UIColor colorWithRed:255.0/256 green:255.0/256 blue:255.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic2];
    
    NSMutableDictionary *dic3=[NSMutableDictionary dictionary];
    [dic3 setValue:@"3" forKey:@"horseNumber"];
    [dic3 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic3 setObject:[UIColor colorWithRed:0.0/256 green:3.0/256 blue:251.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic3];
    
    NSMutableDictionary *dic4=[NSMutableDictionary dictionary];
    [dic4 setValue:@"4" forKey:@"horseNumber"];
    [dic4 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic4 setObject:[UIColor colorWithRed:250.0/256 green:250.0/256 blue:37.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic4];
    
    NSMutableDictionary *dic5=[NSMutableDictionary dictionary];
    [dic5 setValue:@"5" forKey:@"horseNumber"];
    [dic5 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic5 setObject:[UIColor colorWithRed:9.0/256 green:253.0/256 blue:0.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic5];
    
    NSMutableDictionary *dic6=[NSMutableDictionary dictionary];
    [dic6 setValue:@"6" forKey:@"horseNumber"];
    [dic6 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic6 setObject:[UIColor colorWithRed:0.0/256 green:1.0/256 blue:0.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic6];
    
    NSMutableDictionary *dic7=[NSMutableDictionary dictionary];
    [dic7 setValue:@"7" forKey:@"horseNumber"];
    [dic7 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic7 setObject:[UIColor colorWithRed:251.0/256 green:135.0/256 blue:4.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic7];
    
    NSMutableDictionary *dic8=[NSMutableDictionary dictionary];
    [dic8 setValue:@"8" forKey:@"horseNumber"];
    [dic8 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic8 setObject:[UIColor colorWithRed:247.0/256 green:226.0/256 blue:192.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic8];
    
    NSMutableDictionary *dic9=[NSMutableDictionary dictionary];
    [dic9 setValue:@"9" forKey:@"horseNumber"];
    [dic9 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic9 setObject:[UIColor colorWithRed:0.0/256 green:135.0/256 blue:129.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic9];
    
    NSMutableDictionary *dic10=[NSMutableDictionary dictionary];
    [dic10 setValue:@"10" forKey:@"horseNumber"];
    [dic10 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic10 setObject:[UIColor colorWithRed:130.0/256 green:4.0/256 blue:137.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic10];
    
    NSMutableDictionary *dic11=[NSMutableDictionary dictionary];
    [dic11 setValue:@"11" forKey:@"horseNumber"];
    [dic11 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic11 setObject:[UIColor colorWithRed:255.0/256 green:0.0/256 blue:0.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic11];
    
    NSMutableDictionary *dic12=[NSMutableDictionary dictionary];
    [dic12 setValue:@"12" forKey:@"horseNumber"];
    [dic12 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic12 setObject:[UIColor colorWithRed:255.0/256 green:255.0/256 blue:255.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic12];
    
    NSMutableDictionary *dic13=[NSMutableDictionary dictionary];
    [dic13 setValue:@"13" forKey:@"horseNumber"];
    [dic13 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic13 setObject:[UIColor colorWithRed:0.0/256 green:3.0/256 blue:251.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic13];
    
    NSMutableDictionary *dic14=[NSMutableDictionary dictionary];
    [dic14 setValue:@"14" forKey:@"horseNumber"];
    [dic14 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic14 setObject:[UIColor colorWithRed:250.0/256 green:250.0/256 blue:37.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic14];
    
    NSMutableDictionary *dic15=[NSMutableDictionary dictionary];
    [dic15 setValue:@"15" forKey:@"horseNumber"];
    [dic15 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic15 setObject:[UIColor colorWithRed:9.0/256 green:253.0/256 blue:0.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic15];
    
    NSMutableDictionary *dic16=[NSMutableDictionary dictionary];
    [dic16 setValue:@"16" forKey:@"horseNumber"];
    [dic16 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic16 setObject:[UIColor colorWithRed:0.0/256 green:1.0/256 blue:0.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic16];
    
    NSMutableDictionary *dic17=[NSMutableDictionary dictionary];
    [dic17 setValue:@"17" forKey:@"horseNumber"];
    [dic17 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic17 setObject:[UIColor colorWithRed:251.0/256 green:135.0/256 blue:4.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic17];
    
    NSMutableDictionary *dic18=[NSMutableDictionary dictionary];
    [dic18 setValue:@"18" forKey:@"horseNumber"];
    [dic18 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic18 setObject:[UIColor colorWithRed:247.0/256 green:226.0/256 blue:192.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic18];
    
    NSMutableDictionary *dic19=[NSMutableDictionary dictionary];
    [dic19 setValue:@"19" forKey:@"horseNumber"];
    [dic19 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic19 setObject:[UIColor colorWithRed:0.0/256 green:135.0/256 blue:129.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic19];
    
    NSMutableDictionary *dic20=[NSMutableDictionary dictionary];
    [dic20 setValue:@"20" forKey:@"horseNumber"];
    [dic20 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic20 setObject:[UIColor colorWithRed:130.0/256 green:4.0/256 blue:137.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic20];
    
    NSMutableDictionary *dic21=[NSMutableDictionary dictionary];
    [dic21 setValue:@"21" forKey:@"horseNumber"];
    [dic21 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic21 setObject:[UIColor colorWithRed:255.0/256 green:0.0/256 blue:0.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic21];
    
    NSMutableDictionary *dic22=[NSMutableDictionary dictionary];
    [dic22 setValue:@"22" forKey:@"horseNumber"];
    [dic22 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic22 setObject:[UIColor colorWithRed:255.0/256 green:255.0/256 blue:255.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic22];
    
    NSMutableDictionary *dic23=[NSMutableDictionary dictionary];
    [dic23 setValue:@"23" forKey:@"horseNumber"];
    [dic23 setObject:[UIColor whiteColor] forKey:@"textColor"];
    [dic23 setObject:[UIColor colorWithRed:0.0/256 green:3.0/256 blue:251.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic23];
    
    NSMutableDictionary *dic24=[NSMutableDictionary dictionary];
    [dic24 setValue:@"24" forKey:@"horseNumber"];
    [dic24 setObject:[UIColor blackColor] forKey:@"textColor"];
    [dic24 setObject:[UIColor colorWithRed:250.0/256 green:250.0/256 blue:37.0/256 alpha:1.0] forKey:@"backgroundColor"];
    [self.runnersArray addObject:dic24];
    
    
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WIN"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PLC"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"SHW"]) {
        self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_WIN",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
    }
    else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"]) {
        self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_EX",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
    }
    else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"]) {
        self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_DD",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
    }
    else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]) {
        self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_QU",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
    }
    
    else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]) {
        self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_QU",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
    }
    
   // if(self.oddsPool == nil) {
        
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [ZLAppDelegate showLoadingView];
        
        [apiWrapper getRaceOddsByMeet:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber WithPerf:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber AndRace:[ZLAppDelegate getAppData].currentWager.selectedRaceId
                             success:^(NSDictionary* _userInfo) {
                                 
                                 if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"]) {
                                     self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_EX",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                                 }
                                 else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"]) {
                                     self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_DD",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                                 }
                                 else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]) {
                                     self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_QU",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                                 }
                                 else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]) {
                                     self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_QU",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                                 }
//                                 else if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WPS"] ){
//
//                                 }
                                 else {
                                     self.oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_WIN",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                                 }
                                 
                                 if( self.oddsPool != nil){
                                     [self setupPoolTables];
                                 }
                                 [ZLAppDelegate hideLoadingView];
                             }failure:^(NSError *error){
                                 [ZLAppDelegate hideLoadingView];
                             }];
   // }
    //else {
      //  [self setupPoolTables];
   // }
    
    
}

-(void) setupPoolTables
{
    //NSLog(@"exa bet type %@",[ZLAppDelegate getAppData].currentWager.selectedBetType);

    if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]) {
        self.lblOtherBetTypesPoolTotal.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        self.lblOtherBetTypesPoolTotal.text = [NSString stringWithFormat:@"Pool Total : %@%.0f",[[WarHorseSingleton sharedInstance] currencySymbel],self.oddsPool.total];
        [self.flippingView setFrame:CGRectMake(self.flippingView.frame.origin.x,75,self.flippingView.frame.size.width, self.flippingView.frame.size.height+6)];

    }
//    else if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WPS"]){
//        
//    }
    else {
        [self.flippingView setFrame:CGRectMake(self.flippingView.frame.origin.x,75,self.flippingView.frame.size.width, self.flippingView.frame.size.height+6)];
        self.lblOtherBetTypesPoolTotal.hidden = YES;
        self.lblWinPoolTotal.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
        self.lblShwPoolTotal.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
         self.lblPlcPoolTotal.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
        
        self.lblWinPoolTotal.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        self.lblPlcPoolTotal.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        self.lblShwPoolTotal.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        self.lblPoolGrandTotal.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        
        ZLOddsPool * winOddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_WIN",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
        ZLOddsPool * plcOddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_PLC",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
        ZLOddsPool * shwOddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_SHW",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
        
        if(winOddsPool != nil && plcOddsPool != nil && shwOddsPool != nil){
            
            self.lblPlcPoolTotal.text = [NSString stringWithFormat:@"\n%@%.0f\n\n\n",[[WarHorseSingleton sharedInstance] currencySymbel],plcOddsPool.total];
            self.lblWinPoolTotal.text = [NSString stringWithFormat:@"\n%@%.0f\n\n\n",[[WarHorseSingleton sharedInstance] currencySymbel],winOddsPool.total];
            self.lblPlcPoolTotal.text = [NSString stringWithFormat:@"\n%@%.0f\n\n\n",[[WarHorseSingleton sharedInstance] currencySymbel],plcOddsPool.total];

            self.lblShwPoolTotal.text = [NSString stringWithFormat:@"\n%@%.0f\n\n\n",[[WarHorseSingleton sharedInstance] currencySymbel],shwOddsPool.total];
            self.lblPoolGrandTotal.text = [NSString stringWithFormat:@"\n%@%.0f\n\n\n",[[WarHorseSingleton sharedInstance] currencySymbel],(winOddsPool.total + plcOddsPool.total + shwOddsPool.total)];
            [self.poolTotal setText:@"Pool Total:"];

            /*
            if ([[WarHorseSingleton sharedInstance] isWINByte] == YES){

            }else if ([[WarHorseSingleton sharedInstance] isPLCByte] == YES){
//                self.isPlcValid = YES;

                
            }else if([[WarHorseSingleton sharedInstance] isSHWByte] == YES){

            }*/
        }
        
        if (shwOddsPool.total == 0) {
            [self.lblShwPoolTotal setHidden:YES];
        }
         if (winOddsPool.total == 0)
        {
            [self.lblWinPoolTotal setHidden:YES];
        }
        if (plcOddsPool.total == 0){
            [self.lblPlcPoolTotal setHidden:YES];
        }
    }
    
    self.oddsPoolArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.runnersArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < self.runnersArray.count; j++) {
            NSString *title = [NSString stringWithFormat:@"%d",arc4random()%1000];
            [array addObject:title];
        }
        [self.oddsPoolArray addObject:array];
    }
    
    self.probablesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.runnersArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < self.runnersArray.count; j++) {
            NSString *title = [NSString stringWithFormat:@"%@%d",[[WarHorseSingleton sharedInstance] currencySymbel],arc4random()%1000];
            [array addObject:title];
        }
        [self.probablesArray addObject:array];
        
        self.probablesmatrix = [[ZLMatrixView alloc] initWithFrame:self.flippingView.bounds delegate:self tag:222];
        self.probablesmatrix.autoresizesSubviews = YES;
        self.probablesmatrix.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
        //self.probablesmatrix.hidden = YES;
        [self.flippingView addSubview:self.probablesmatrix];
        
        if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]) {
            
            //NSLog(@"probablesmatrix sub views = %@", [self.flippingView subviews]);
            
            [self.view bringSubviewToFront:self.flippingView];

        }
        else {
            self.oddsmatrix = [[ZLMatrixView alloc] initWithFrame:self.flippingView.bounds delegate:self tag:111];
            self.oddsmatrix.autoresizesSubviews = YES;
            
            self.oddsmatrix.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth);
            [self.flippingView addSubview:self.oddsmatrix];
            [self.view bringSubviewToFront:self.flippingView];

        }

        
    }
    
}

- (IBAction)closeButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)oddsPoolButtonClicked:(id)sender
{
    self.probablesmatrix.hidden = NO;

    if (![self.oddsPoolButton isSelected])
    {
        [self.oddsPoolButton setSelected:YES];
        [self.probablesButton setSelected:NO];
        
        self.oddsPoolButton.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;
        self.probablesButton.layer.borderColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0].CGColor;
        
        [self.oddsPoolButton setBackgroundColor:[UIColor colorWithRed:35.0/255 green:108.0/255 blue:142.0/255 alpha:1.0]];
        [self.probablesButton setBackgroundColor:[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0]];
        
        [self flipViews];
    }
    else{
    }

}
- (IBAction)probablesButtonClicked:(id)sender
{
    self.probablesmatrix.hidden = NO;

    if (![self.probablesButton isSelected])
    {
        [self.oddsPoolButton setSelected:NO];
        [self.probablesButton setSelected:YES];
        
        self.oddsPoolButton.layer.borderColor = [UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0].CGColor;
        self.probablesButton.layer.borderColor = [UIColor colorWithRed:2.0/255 green:55.0/255 blue:84.0/255 alpha:1.0].CGColor;
        
        [self.probablesButton setBackgroundColor:[UIColor colorWithRed:35.0/255 green:108.0/255 blue:142.0/255 alpha:1.0]];
        [self.oddsPoolButton setBackgroundColor:[UIColor colorWithRed:224.0/255 green:224.0/255 blue:224.0/255 alpha:1.0]];
        
        [self flipViews];
    }
    else{
        
    }

}


-(void)flipViews
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.flippingView cache:YES];
    
    if ([self.oddsmatrix superview])
    {
        [self.oddsmatrix removeFromSuperview];
        [self.flippingView addSubview:self.probablesmatrix];
        [self.flippingView sendSubviewToBack:self.oddsmatrix];
    }
    else
    {
        [self.probablesmatrix removeFromSuperview];
        [self.flippingView addSubview:self.oddsmatrix];
        [self.flippingView sendSubviewToBack:self.probablesmatrix];
    }
    
    [UIView commitAnimations];
}

-(CGFloat) widthForCellInMatrixView:(id)matrixView
{
    if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]){
        return 42;
    }
    else if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"]){
        return  42;
    }
    else{
        return 60;//48
    }
    return 42;
}

-(CGFloat) heightForCellInMatrixView:(id)matrixView
{
    return 36;
}
-(NSUInteger) numberOfRowsInMatrixView:(id)matrixView
{
    if( self.oddsPool == nil){
        return 0;
    }
    if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]){
        //NSLog(@"numberOfRowsInMatrix count %d",[self.oddsPool.oddsPoolRunners count]);
        return [self.oddsPool.oddsPoolRunners count];
    }
//    else if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WPS"]){
//        return 0;
//    }
    else{
        return [self.oddsPool.oddsPoolRunners count];
    }
//    if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WIN"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"PLC"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"SHW"]){
//        return [self.oddsPool.oddsPoolRunners count];
//    }
    return 0;
}
-(NSUInteger) numberOfColumnsInMatrixView:(id)matrixView
{
    if(self.oddsPool == nil) {
        return 0;
    }
    
    if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]) {

        ZLOddsPoolRunner * runnerOdds = [self.oddsPool.oddsPoolRunners objectAtIndex:0];
        return [runnerOdds.withRunners count];
    }
//    else if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WPS"]){
//        return 0;
//    }
    else{
        return [[WarHorseSingleton sharedInstance] noColumsOddBoard];
    }
    
    return 0;
}

- (NSString *) matrixView:(id)matrixView titleForRow:(NSInteger)row forColumn:(NSInteger)column
{
    
    if (((ZLMatrixView *)matrixView).tag == 111) {
        
        if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]) {
            ZLOddsPoolRunner * runnerOdds = [self.oddsPool.oddsPoolRunners objectAtIndex:row];
            if( runnerOdds != nil){
                if (column == [runnerOdds.withRunners count]) {
                    return @"-";
                }
                ZLOddsPoolRunner * withRunnerOdds = [runnerOdds.withRunners objectAtIndex:column];
                if( withRunnerOdds != nil) {
                    if( [withRunnerOdds.odds isEqualToString:@"-"]) {
                        return @"";
                    }
                    return [NSString stringWithFormat:@"%.2f",withRunnerOdds.pp];                }
            }
        }
//        else if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WPS"]){
//            
//        }
        else {
            ZLOddsPool *oddsPool = nil;
            if(column == 0 ){ //WIN ODDS
                oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_WIN",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
            }else if(column == 1 ){
                if ([[WarHorseSingleton sharedInstance] isWINByte] == YES){
                    oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_WIN",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];

                }else if ([[WarHorseSingleton sharedInstance] isPLCByte] == YES){
                    self.isPlcValid = YES;
                    oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_PLC",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];

                    
                }else if([[WarHorseSingleton sharedInstance] isSHWByte] == YES){
                    oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_SHW",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];

                }
                

            }
            else if(column == 2 ){ //PLC POOL
                if ([[WarHorseSingleton sharedInstance] isPLCByte] == YES && self.isPlcValid != YES){
                    oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_PLC",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                    
                    
                }
           else if([[WarHorseSingleton sharedInstance] isSHWByte] == YES){
                    oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_SHW",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                    
                }            }
            else if(column == 3 ){ //SHW POOL
                oddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_SHW",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
            }
            else if(column == 4 ){ //TOTAL POOL
                ZLOddsPool * winOddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_WIN",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                ZLOddsPool * plcOddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_PLC",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                ZLOddsPool * shwOddsPool = [[ZLAppDelegate getAppData].dictOddsPoolByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d_SHW",[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber, [ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber, [ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                if(winOddsPool != nil && plcOddsPool != nil && shwOddsPool != nil){
                    ZLOddsPoolRunner * winRunnerOdds = [winOddsPool.oddsPoolRunners objectAtIndex:row];
                    ZLOddsPoolRunner * plcRunnerOdds = [plcOddsPool.oddsPoolRunners objectAtIndex:row];
                    ZLOddsPoolRunner * shwRunnerOdds = [shwOddsPool.oddsPoolRunners objectAtIndex:row];
                    double total = (winRunnerOdds.total + plcRunnerOdds.total + shwRunnerOdds.total);
                    if( total == 0.0){
                        return @"";
                    }
                    return [NSString stringWithFormat:@"%.0f",total];
                }
            }
            
            if( oddsPool != nil) {
                ZLOddsPoolRunner * runnerOdds = [oddsPool.oddsPoolRunners objectAtIndex:row];
                if( runnerOdds != nil){
                    if( column == 0){
                        
                        if( [runnerOdds.odds isEqualToString:@"-"]){
                            return @"";
                        }
                    return [NSString stringWithFormat:@"%.2f",runnerOdds.pp];
                    }
                    else{
                        if( runnerOdds.total == 0.0){
                            return @"";
                        }

                        return [NSString stringWithFormat:@"%.0f",runnerOdds.total];
                    }
                }
            }
        }
        
    }
    else{
        if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]){
            ZLOddsPoolRunner * runnerOdds = [self.oddsPool.oddsPoolRunners objectAtIndex:row];
            if( runnerOdds != nil){
                //NSLog(@"count %d",[runnerOdds.withRunners count]);
                if (column == [runnerOdds.withRunners count]) {
                    return @"-";
                }
                //NSLog(@"runnerOdds.withRunners %@ index %@",runnerOdds.withRunners,[runnerOdds.withRunners objectAtIndex:column]);
                if ([runnerOdds.withRunners count]>column){
                    ZLOddsPoolRunner * withRunnerOdds = [runnerOdds.withRunners objectAtIndex:column];
                    
                    if( withRunnerOdds != nil){
                        if( [withRunnerOdds.odds isEqualToString:@"-"]){
                            return @"";
                        }
                        return [NSString stringWithFormat:@"%.0f",withRunnerOdds.pp];
                    }
                }
            }
        }
    }
    
    return @"";
}

- (NSString *) matrixView:(id)matrixView headerForColumn:(NSInteger)column
{
    if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EXA"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"DBL"] || [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QNL"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"EBX"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"QBX"]){
        if (((ZLMatrixView *)matrixView).tag == 111){
            return [NSString stringWithFormat:@"%d",((ZLOddsPoolRunner*)[self.oddsPool.oddsPoolRunners objectAtIndex:column]).number];
        }
        else{
            return [NSString stringWithFormat:@"%d",((ZLOddsPoolRunner*)[((ZLOddsPoolRunner*)[self.oddsPool.oddsPoolRunners objectAtIndex:0]).withRunners objectAtIndex:column]).runner];
            
            //return [NSString stringWithFormat:@"%d",((ZLOddsPoolRunner*)[self.oddsPool.oddsPoolRunners objectAtIndex:column]).number];
        }
    }
    //    else if([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"WPS"]){
    //
    //    }
    else{
       // NSString *currency =[NSString stringWithFormat:@"(%@)",[[WarHorseSingleton sharedInstance] currencySymbel]];

        if(column == 0){
            return @"WILL\nPAY";
        }
        else if(column == 1){
            if ([[WarHorseSingleton sharedInstance] isWINByte] == YES){
                
                return @"WIN\nPOOL";//[NSString stringWithFormat:@"WIN\nPOOL%@",currency];//@"WIN\nPOOL";
            }else if ([[WarHorseSingleton sharedInstance] isPLCByte] == YES){
                self.isPlcValidHeader = YES;
                return @"PLACE\nPOOL";//[NSString stringWithFormat:@"PLACE\nPOOL%@",currency];//@"PLACE\nPOOL";
            }else if ([[WarHorseSingleton sharedInstance] isSHWByte] == YES){
                
                return @"SHOW\nPOOL";//[NSString stringWithFormat:@"SHOW\nPOOL%@",currency];//@"SHOW\nPOOL";
            }
        }
        
        else if(column == 2){
            if ([[WarHorseSingleton sharedInstance] isPLCByte] == YES && self.isPlcValidHeader != YES){
                return @"PLACE\nPOOL";//[NSString stringWithFormat:@"PLACE\nPOOL%@",currency];//@"PLACE\nPOOL";
                
            }else if ([[WarHorseSingleton sharedInstance] isSHWByte] == YES){
                
                return @"SHOW\nPOOL";//[NSString stringWithFormat:@"SHOW\nPOOL%@",currency];//@"SHOW\nPOOL";
            }
        }
        else if(column == 3){
            if ([[WarHorseSingleton sharedInstance] isSHWByte] == YES){
                return @"SHOW\nPOOL";//[NSString stringWithFormat:@"SHOW\nPOOL%@",currency];//@"SHOW\nPOOL";
                
            }
        }
        else if(column == 4){
            return @"TOTAL";
        }
    }
    return @"";
}
- (NSString *) matrixView:(id)matrixView headerForRow:(NSInteger)row
{
//    NSString *tempStr = [NSString stringWithFormat:@"%d",((ZLOddsPoolRunner*)[self.oddsPool.oddsPoolRunners objectAtIndex:row]).number];
//    NSLog(@"tempStr %@",tempStr);
    return [NSString stringWithFormat:@"%d",((ZLOddsPoolRunner*)[self.oddsPool.oddsPoolRunners objectAtIndex:row]).number];
}

- (UIColor *) backgroundColorCellIndex:(NSUInteger)index
{
    NSMutableDictionary *dic = [self.runnersArray objectAtIndex:index];
    return [dic objectForKey:@"backgroundColor"];
}
- (UIColor *) textColorCellIndex:(NSUInteger)index
{
    NSMutableDictionary *dic = [self.runnersArray objectAtIndex:index];
//    NSLog(@"Dic %@",dic);
    
    return [dic objectForKey:@"textColor"];
}

-(void) tapedCellWithRow:(NSUInteger) row andWIthColumn:(NSUInteger)column
{
    NSLog(@"row = %ld , column = %ld",(unsigned long)row,(unsigned long)column);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
