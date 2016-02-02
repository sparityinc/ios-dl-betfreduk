//
//  ZLRaceViewController.m
//  WarHorse
//
//  Created by Sparity on 7/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLRaceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAmountViewController.h"
#import "ZLSelectedValues.h"
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "ZLRaceCard.h"
#import "ZLRaceDetails.h"
#import "ZLTrackResults.h"
#import "ZLRaceResultCustomCell.h"
#import "ZLFinisher.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "ZLBetType.h"

#define kcustomRaceCellIdentifier @"customRaceCellIdentifier"

@interface ZLRaceViewController ()

@property (strong, nonatomic) UINib *customRaceCellNib;

@property (strong, nonatomic) NSMutableArray *openResultsinTable;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong,nonatomic) NSString *raceNumber;
@property (strong,nonatomic) NSString *meetNoStr;

@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong) UIWebView *webview;

@end

@implementation ZLRaceViewController
@synthesize raceCustomCell=_raceCustomCell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.openResultsinTable = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    
    [self.selectRaceLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];

    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    NSDictionary *argumentsDic = @{@"date":[formatter stringFromDate:[NSDate date]],
                                   @"detailsFlag":@"true",
                                   @"cardId":[NSString stringWithFormat:@"%d",[ZLAppDelegate getAppData].currentWager.selectedTrackId]};

    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Races..."];
    
    [apiWrapper loadTrackDetails:argumentsDic alert:YES
                 success:^(NSDictionary* _userInfo) {
                     NSLog(@"_userInfo222222 %@",_userInfo);
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [[LeveyHUD sharedHUD] disappear];
                         [self.raceTableView reloadData];
                         
                         int i = 0;
                         ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
                         

                         
                         for( ZLRaceDetails * _race_details in _race_card.cardDetails){

                             NSString *eventCodeStr = [NSString stringWithFormat:@"%@", _race_card.eventCode];
                             [[NSUserDefaults standardUserDefaults] setValue:eventCodeStr forKey:@"event_code"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             
                             if(_race_details.number == _race_card.currentRaceNumber){
                                 if( i > 0)
                                     [self.raceTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                                 break;
                             }
                             i++;
                         }

                     });
                     
                 }failure:^(NSError *error){
                     [[LeveyHUD sharedHUD] disappear];
                 }];
    
    self.customRaceCellNib = [UINib nibWithNibName:@"ZLRaceCustomCell" bundle:nil];
    [self.raceTableView registerNib:self.customRaceCellNib forCellReuseIdentifier:kcustomRaceCellIdentifier];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
        
    //[self.raceTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

-(void) refreshRacesFromServer{

    [self.raceTableView reloadData];
    
}

-(void) closeResults:(id) sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.raceTableView];
    NSIndexPath *indexPath = [self.raceTableView indexPathForRowAtPoint:buttonPosition];
    if( [self.openResultsinTable containsObject:[NSNumber numberWithInt:indexPath.row]] ){
        dispatch_async(dispatch_get_main_queue(), ^{
            int idx = [self.openResultsinTable indexOfObject:[NSNumber numberWithInt:indexPath.row]];
            [self.openResultsinTable removeObjectAtIndex:idx];
            [self.raceTableView reloadData];
        });
        
    }
}

-(void) openResults:(id) sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.raceTableView];
    NSIndexPath *indexPath = [self.raceTableView indexPathForRowAtPoint:buttonPosition];
    if( ![self.openResultsinTable containsObject:[NSNumber numberWithInt:indexPath.row]] ){
        ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
        ZLRaceDetails * raceDetails = [_race_card.cardDetails objectAtIndex:indexPath.row];
        if(!raceDetails)
            return;
        
        int meet = _race_card.meetNumber;
        int perf = _race_card.performanceNumber;
        int raceNumber = raceDetails.number;
        self.raceNumber = [NSString stringWithFormat:@"%d",raceDetails.number];
        self.meetNoStr =[NSString stringWithFormat:@"%d",_race_card.meetNumber];
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        
        ZLTrackResults * trackResult = [[ZLAppDelegate getAppData].dictResultsByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d",meet, perf, raceNumber]];
        
        if( trackResult == nil){
            
            ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
            
            if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            
            [ZLAppDelegate showLoadingView];
            
            [apiWrapper getRaceResultsByMeet:meet WithPerf:perf dateStr:raceDetails.raceDate
                                     success:^(NSDictionary* _userInfo){
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.openResultsinTable addObject:[NSNumber numberWithInt:indexPath.row]];
                                             [self.raceTableView reloadData];
                                             [ZLAppDelegate hideLoadingView];
                                         });
                                     }failure:^(NSError *error){
                                         [ZLAppDelegate hideLoadingView];
                                     }];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.openResultsinTable addObject:[NSNumber numberWithInt:indexPath.row]];
                [self.raceTableView reloadData];
            });
            
        }
        
    }
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    return [_race_card.cardDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //self.raceCustomCell  = (ZLRaceCustomCell *)[tableView dequeueReusableCellWithIdentifier:kcustomRaceCellIdentifier];
    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    ZLRaceDetails * _race_details = [_race_card.cardDetails objectAtIndex:indexPath.row];
    NSLog(@"featurebets====%@",_race_details.featureBets); //VVH
    
    
    self.raceCustomCell = (ZLRaceCustomCell*)[[[NSBundle mainBundle] loadNibNamed:@"ZLRaceCustomCell" owner:self options:nil] objectAtIndex:0];
    
    NSPredicate *valuePredicate=[NSPredicate predicateWithFormat:@"self.intValue == %d",indexPath.row];
    
    if ([[self.openResultsinTable filteredArrayUsingPredicate:valuePredicate] count]!=0) {

        self.raceCustomCell.backgroundImage.image = [UIImage imageNamed:@"bg_cross.png"];
        
        [self.raceCustomCell.raceNumberLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [self.raceCustomCell.trackLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
        [self.raceCustomCell.mtpLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [self.raceCustomCell.furlongLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
        [self.raceCustomCell.amountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
        
        [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor darkGrayColor]];
        [self.raceCustomCell.mtpLabel setTextColor:[UIColor whiteColor]];
        [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:02.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
        self.raceCustomCell.statusLabel.frame = CGRectMake(self.raceCustomCell.statusLabel.frame.origin.x,self.raceCustomCell.statusLabel.frame.origin.y,self.raceCustomCell.statusLabel.frame.size.width,327.0);
        self.raceCustomCell.mtpLabel.text = @"Final";
        
        if ([_race_card.trackCountry isEqualToString:@"UK"]){
            self.raceCustomCell.raceNumberLabel.text=[NSString stringWithFormat:@"Race %@",_race_details.trackRaceNumber];
            
            
        }else {
            self.raceCustomCell.raceNumberLabel.text=[NSString stringWithFormat:@"Race %d",_race_details.number];
            
        }
        
//        self.raceCustomCell.raceNumberLabel.text=[NSString stringWithFormat:@"Race %d",_race_details.number];
        
        self.raceCustomCell.furlongLabel.text = _race_details.distancePublishedValue;
        if( _race_details.purseUsa != nil || [_race_details.purseUsa length] > 0){
            self.raceCustomCell.amountLabel.text = [NSString stringWithFormat:@"Purse %@%@",[[WarHorseSingleton sharedInstance] currencySymbel],_race_details.purseUsa];
        }
        else{
            self.raceCustomCell.amountLabel.text = @"";
        }
        
        //NSLog(@"mtp is === %d",_race_details.minutesToPost);
        
        self.raceCustomCell.trackLabel.text = _race_details.trackType;
        
        ZLTrackResults * trackResult = [[ZLAppDelegate getAppData].dictResultsByMeetPerfRace objectForKey:[NSString stringWithFormat:@"%d_%d_%d",_race_card.meetNumber, _race_card.performanceNumber, _race_details.number]];
        if( trackResult != nil){
            ZLRaceResultCustomCell * raceResultCell = [[ZLRaceResultCustomCell alloc] initWithFrame:CGRectMake(0,77,self.raceTableView.bounds.size.width, 253)];
            raceResultCell.trackResult = trackResult;
            [raceResultCell setup];
            [self.raceCustomCell.contentView addSubview:raceResultCell];
        }
        
        UIView * vwContainer = [[UIView alloc] initWithFrame:CGRectMake(6.0,300.0,315.0,30)];
        vwContainer.backgroundColor  = [UIColor whiteColor];
        vwContainer.layer.borderColor = [UIColor colorWithRed:220.0/ 255.0 green:220.0/ 255.0 blue:220.0/ 255.0 alpha:1.0].CGColor;
        vwContainer.layer.borderWidth = 1.0;
        
        if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES)
        {
            UIButton *replayButton = [[UIButton alloc] initWithFrame:CGRectMake(5.0,5.0,220.0,20.0)];
            [replayButton setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
            [replayButton setTitle:@"RACE REPLAY" forState:UIControlStateNormal];
            [replayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [replayButton setTitleColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0] forState:UIControlStateSelected];
            [replayButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
            [replayButton.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0] CGColor]];
            [replayButton.layer setBorderWidth:1.5];
            [vwContainer addSubview:replayButton];
            
            [replayButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        /*
        UIButton * resultsButton = [[UIButton alloc] initWithFrame:CGRectMake(103.0,5.0,95.0,20.0)];
        [resultsButton setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
        [resultsButton setTitle:@"RESULTS CHART" forState:UIControlStateNormal];
        [resultsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resultsButton setTitleColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0] forState:UIControlStateSelected];
        [resultsButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:11]];
        [resultsButton.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0] CGColor]];
        [resultsButton.layer setBorderWidth:1.5];
        [vwContainer addSubview:resultsButton];
         */
        
        //UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(206.0,5.0,21.0,20.0)];
        UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(206.0,49.0,21.0,20.0)];
        [closeButton setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateNormal];
        [closeButton setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateHighlighted];
        [closeButton setImage:[UIImage imageNamed:@"minus.png"] forState:UIControlStateSelected];
        [closeButton addTarget:self action:@selector(closeResults:) forControlEvents:UIControlEventTouchUpInside];
        //[vwContainer addSubview:closeButton];
        [self.raceCustomCell addSubview:closeButton];

        [self.raceCustomCell.contentView addSubview:vwContainer];
        
        [self.raceCustomCell.contentView bringSubviewToFront:self.raceCustomCell.statusLabel];
        return self.raceCustomCell;
    }
    else{
        if ([_race_details.status isEqualToString:@"OFFICIAL"])
        {
            self.raceCustomCell.backgroundImage.image = [UIImage imageNamed:@"bg_cross.png"];
            [self.raceCustomCell.raceNumberLabel setTextColor:[UIColor blackColor]];
            [self.raceCustomCell.trackLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
            [self.raceCustomCell.furlongLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
            [self.raceCustomCell.amountLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
            
            UILabel *payOffLabel = [[UILabel alloc] init];
            [payOffLabel setFrame:CGRectMake(8, 45, 223, 28)];
            
            [payOffLabel setBackgroundColor:[UIColor whiteColor]];
            [payOffLabel setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0]];
            [payOffLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
            [payOffLabel setTextAlignment:NSTextAlignmentLeft];
            [payOffLabel setText:@"  Payoffs"];
            
            [self.raceCustomCell addSubview:payOffLabel];
            
            UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(206.0,49.0,21.0,20.0)];
            [closeButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            [closeButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateHighlighted];
            [closeButton setImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateSelected];
            [closeButton addTarget:self action:@selector(openResults:) forControlEvents:UIControlEventTouchUpInside];
            [self.raceCustomCell addSubview:closeButton];
            
        }
        else if([ZLAppDelegate getAppData].currentWager.selectedRaceId == _race_details.number)
        {
            self.raceCustomCell.backgroundImage.image = [UIImage imageNamed:@"bg_black.png"];
            self.raceCustomCell.raceNumberLabel.textColor = [UIColor whiteColor];
            self.raceCustomCell.trackLabel.textColor = [UIColor whiteColor];
            self.raceCustomCell.mtpLabel.textColor = [UIColor whiteColor];
            self.raceCustomCell.furlongLabel.textColor = [UIColor whiteColor];
            self.raceCustomCell.amountLabel.textColor = [UIColor whiteColor];
        }
        else{
            self.raceCustomCell.backgroundImage.image = [UIImage imageNamed:@"bg_white.png"];
            [self.raceCustomCell.raceNumberLabel setTextColor:[UIColor blackColor]];
            [self.raceCustomCell.trackLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
            [self.raceCustomCell.furlongLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
            [self.raceCustomCell.amountLabel setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
        }
        
        if (![_race_details.status isEqualToString:@"OFFICIAL"]){
            
            int i=12;
            int j=48;

            /*
            NSMutableArray *extraBetTypesArray = [[NSMutableArray alloc] initWithArray:_race_details.extraBetTypes];
            
            
            if ([extraBetTypesArray containsObject:@"EBX"]) {
                [extraBetTypesArray removeObject:@"EBX"];
            }
            if ([extraBetTypesArray containsObject:@"TBX"]) {
                [extraBetTypesArray removeObject:@"TBX"];
            }
            if ([extraBetTypesArray containsObject:@"SFX"]) {
                [extraBetTypesArray removeObject:@"SFX"];
            }
            if ([extraBetTypesArray containsObject:@"QBX"]) {
                [extraBetTypesArray removeObject:@"QBX"];
            }
            if ([extraBetTypesArray containsObject:@"TQX"]) {
                [extraBetTypesArray removeObject:@"TQX"];
            }
            if ([extraBetTypesArray containsObject:@"PEX"]) {
                [extraBetTypesArray removeObject:@"PEX"];
            }
            if ([extraBetTypesArray containsObject:@"EKK"]) {
                [extraBetTypesArray removeObject:@"EKK"];
            }
            if ([extraBetTypesArray containsObject:@"EKB"]) {
                [extraBetTypesArray removeObject:@"EKB"];
            }
            if ([extraBetTypesArray containsObject:@"TKK"]) {
                [extraBetTypesArray removeObject:@"TKK"];
            }
            if ([extraBetTypesArray containsObject:@"TKB"]) {
                [extraBetTypesArray removeObject:@"TKB"];
            }
            if ([extraBetTypesArray containsObject:@"SKK"]) {
                [extraBetTypesArray removeObject:@"SKK"];
            }
            if ([extraBetTypesArray containsObject:@"SKB"]) {
                [extraBetTypesArray removeObject:@"SKB"];
            }
            if ([extraBetTypesArray containsObject:@"SKB"]) {
                [extraBetTypesArray removeObject:@"SKB"];
            }
            if ([extraBetTypesArray containsObject:@"PKB"]) {
                [extraBetTypesArray removeObject:@"PKB"];
            }
            */
            NSArray *extraBetTypesArray = [_race_details.featureBets allObjects];
            NSLog(@"CHK-BETS-REST%@",_race_details.featureBets); //VVH

            int count = [extraBetTypesArray count];
            if( count > 4){
                count = 4;
            }
            for (NSUInteger k = 0; k < count; k++)
            {
                UILabel *betType_label=[[UILabel alloc] init];
                [betType_label setFrame:CGRectMake(i, j, 50, 20)];
                
                if([ZLAppDelegate getAppData].currentWager.selectedRaceId == _race_details.number)
                {
                    [betType_label setBackgroundColor:[UIColor colorWithRed:41.0/255.0f green:39.0/255.0f blue:43.0/255.0f alpha:1.0]];
                    [betType_label setTextColor:[UIColor colorWithRed:214.0/255.0f green:214.0/255.0f blue:214.0/255.0f alpha:1.0]];
                    betType_label.layer.borderColor = [UIColor colorWithRed:84.0/255.0f green:82.0/255.0f blue:85.0/255.0f alpha:1.0].CGColor;
                }
                else
                {
                    [betType_label setBackgroundColor:[UIColor whiteColor]];
                    [betType_label setTextColor:[UIColor colorWithRed:102.0/255.0f green:102.0/255.0f blue:102.0/255.0f alpha:1.0]];
                    betType_label.layer.borderColor = [UIColor colorWithRed:224.0/255.0f green:224.0/255.0f blue:224.0/255.0f alpha:1.0].CGColor;
                }
                
                [betType_label setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
                betType_label.layer.borderWidth = 1.0;
                [betType_label setTextAlignment:NSTextAlignmentCenter];
                NSLog(@"Test %@",[extraBetTypesArray objectAtIndex:k]);
                
                [betType_label setText:[extraBetTypesArray objectAtIndex:k]];
                [self.raceCustomCell addSubview:betType_label];
                i += 55;
                //i += 30;
            }
        }
        
        
        [self.raceCustomCell.raceNumberLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [self.raceCustomCell.trackLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
        [self.raceCustomCell.mtpLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [self.raceCustomCell.furlongLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
        [self.raceCustomCell.amountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];

        if ([_race_card.trackCountry isEqualToString:@"UK"]){
            self.raceCustomCell.raceNumberLabel.text=[NSString stringWithFormat:@"Race %@",_race_details.trackRaceNumber];

            
        }else {
            self.raceCustomCell.raceNumberLabel.text=[NSString stringWithFormat:@"Race %d",_race_details.number];
            
        }
//        self.raceCustomCell.raceNumberLabel.text=[NSString stringWithFormat:@"Race %d",_race_details.number];
        
        
        self.raceCustomCell.trackLabel.text = _race_details.trackType;
        
        if([_race_details.status isEqualToString:@"OFFICIAL"]){
            [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor darkGrayColor]];
            [self.raceCustomCell.mtpLabel setTextColor:[UIColor whiteColor]];
            self.raceCustomCell.mtpLabel.text = @"Final";
            [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]];
        }
        else{
            if( _race_card.currentRaceNumber == _race_details.number){
                if( [_race_details.status isEqualToString:@"BETTING_OFF"] ){
                    [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                    [self.raceCustomCell.mtpLabel setTextColor:[UIColor blackColor]];
                    [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                    self.raceCustomCell.mtpLabel.text = @"OFF";
                }
                else if(_race_details.minutesToPost <= 5){
                    [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                    [self.raceCustomCell.mtpLabel setTextColor:[UIColor whiteColor]];
                    [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                    self.raceCustomCell.mtpLabel.text = [NSString stringWithFormat:@"%d",_race_details.minutesToPost];
                }
                else if(_race_details.minutesToPost <= 20){
                    [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor colorWithRed:250.0/255 green:228.0/255 blue:48.0/255 alpha:1.0]];
                    [self.raceCustomCell.mtpLabel setTextColor:[UIColor blackColor]];
                    [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:250.0/255 green:228.0/255 blue:48.0/255 alpha:1.0]];
                    self.raceCustomCell.mtpLabel.text = [NSString stringWithFormat:@"%d",_race_details.minutesToPost];
                }
                else{
                    [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                    [self.raceCustomCell.mtpLabel setTextColor:[UIColor whiteColor]];
                    [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                    self.raceCustomCell.mtpLabel.text = [NSString stringWithFormat:@"%d",_race_details.minutesToPost];
                }
            }
            else if( [_race_details.status isEqualToString:@"OFFICIAL"] ){
                [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                [self.raceCustomCell.mtpLabel setTextColor:[UIColor blackColor]];
                [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                self.raceCustomCell.mtpLabel.text = @"FIN";
            }
            else{
                [self.raceCustomCell.mtpLabel setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                [self.raceCustomCell.mtpLabel setTextColor:[UIColor whiteColor]];
                [self.raceCustomCell.statusLabel setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                if( _race_details.minutesToPost < 0){
                    self.raceCustomCell.mtpLabel.text = @"-";
                }
                else{
                    self.raceCustomCell.mtpLabel.text = [NSString stringWithFormat:@"%d",_race_details.minutesToPost];
                }
            }
        }
        
        
        self.raceCustomCell.furlongLabel.text = _race_details.distancePublishedValue;
        if( _race_details.purseUsa != nil || [_race_details.purseUsa length] > 0){
            self.raceCustomCell.amountLabel.text = [NSString stringWithFormat:@"Purse %@%@",[[WarHorseSingleton sharedInstance] currencySymbel],_race_details.purseUsa];
        }
        else{
            self.raceCustomCell.amountLabel.text = @"";
        }
    }

    return self.raceCustomCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSPredicate *valuePredicate=[NSPredicate predicateWithFormat:@"self.intValue == %d",indexPath.row];
    
    if ([[self.openResultsinTable filteredArrayUsingPredicate:valuePredicate] count]!=0) {
        return 330;
    }
    
    return 77;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    ZLRaceDetails * raceDetails = [_race_card.cardDetails objectAtIndex:indexPath.row];
    
    
    if ([_race_card.trackCountry isEqualToString:@"UK"]){
        NSString *raceNo = [NSString stringWithFormat:@"Race %@",raceDetails.trackRaceNumber];

        [[WarHorseSingleton sharedInstance] setSelectRaceNo:raceNo];
        
        
    }else {
        NSString *raceNo = [NSString stringWithFormat:@"Race %d",raceDetails.number];
        
        [[WarHorseSingleton sharedInstance] setSelectRaceNo:raceNo];
        
    }
    
    

    if(!raceDetails)
        return;
    
    NSPredicate *valuePredicate=[NSPredicate predicateWithFormat:@"self.intValue == %d",indexPath.row];
    
    if ([[self.openResultsinTable filteredArrayUsingPredicate:valuePredicate] count]!=0) {
        return;
    }
    
    if( [raceDetails.status isEqualToString:@"BETTING_OFF"] ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Selected Race is unavailable for betting at this time. Please select a different race." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (![raceDetails.status isEqualToString:@"OFFICIAL"])
    {
        [ZLAppDelegate getAppData].currentWager.selectedRaceId = raceDetails.number;
        [ZLAppDelegate getAppData].currentWager.selectedRace = raceDetails;
        [tableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadWagerView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:WagerRace] forKey:@"currentLoadedIndex"]];
    }
    else{
        
        
    }
}


- (void)videoButtonAction:(id)sender
{
    
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormater stringFromDate:currentDate];

    
    NSDictionary *argumentsDic = @{@"client_id": @"BetFred",
                                   @"videoType": @"replay",
                                   @"format": @"stream",
                                   @"track_code":[[NSUserDefaults standardUserDefaults] valueForKey:@"event_code"],
                                   @"race_number":self.raceNumber,
                                   @"video_date": currentDateStr,
                                   @"meet":self.meetNoStr
                                   };
    
    
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getLiveVideoUrlForParameters:argumentsDic success:^(NSDictionary* _responseDic) {
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[_responseDic valueForKey:@"response-status"] isEqualToString:@"success"])
        {
            
            
            NSString *urlStr = [_responseDic valueForKey:@"response-content"];
            if( urlStr.length > 0 && [urlStr hasPrefix:@"http"] ){
                
                ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
                appDelegate.isOrientation = YES;
                
                self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 500)];
                
                [self.transparentView setBackgroundColor:[UIColor blackColor]];
                [self.transparentView setAlpha:0.6];
                [self.view addSubview:self.transparentView];
                
                
                
                
                
                NSURL *url = [NSURL URLWithString:urlStr];
                self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
                
                // Register to receive a notification when the movie has finished playing.
                
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:self.moviePlayer];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
                
                
                [self.transparentView addSubview:self.moviePlayer.view];
                [self.moviePlayer setFullscreen:YES animated:NO];
                [self.moviePlayer play];
                
                
                
                
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Live video is not available for the selected race!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            
            
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Sorry, video is not available now!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSError* error) {
        [[LeveyHUD sharedHUD] disappear];
    }];
    
    
    

}

-(void) viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRacesFromServer) name:@"ZLWagerRacesDidLoad" object:nil];
    
    [super viewDidAppear:animated];
    
}

-(void) viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property Overridden methods

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *temporaryDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        temporaryDateFormatter = [[NSDateFormatter alloc] init];
        [temporaryDateFormatter setDateFormat:@"YYYY/MM/dd"];
        
    });
    
    return temporaryDateFormatter;
}


-(void)moviePlayBackDidFinish:(NSNotification*) notif
{
    MPMoviePlayerController *aMoviePlayer = [notif object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:aMoviePlayer];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [self.moviePlayer stop];
    
    [self.transparentView removeFromSuperview];
    [self.moviePlayer.view removeFromSuperview];
    
    NSNumber* reason = [[notif userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"Playback Ended");
            [self performSelector:@selector(playBackEnded) withObject:nil afterDelay:1.0];
            
            break;
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"Playback Error");
            [self performSelector:@selector(corruptVideoAlertView) withObject:nil afterDelay:1.0];
            break;
        case MPMovieFinishReasonUserExited:
            NSLog(@"User Exited");
            break;
        default:
            break;
    }
}

- (void)corruptVideoAlertView
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information!" message:@"The video is currently unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (void)playBackEnded
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information!" message:@"The Video Playback is Ended" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void) moviePlayexitFullscreen:(NSNotification*) notif
{
    MPMoviePlayerController *aMoviePlayer = [notif object];
    
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:aMoviePlayer];
    [self.moviePlayer stop];
    
    [self.transparentView removeFromSuperview];
}
-(void)playerDidEnterFullscreen:(NSNotification*) notif
{
    MPMoviePlayerController *aMoviePlayer = [notif object];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidEnterFullscreenNotification
                                                  object:aMoviePlayer];
    [self.transparentView removeFromSuperview];
    
}



@end
