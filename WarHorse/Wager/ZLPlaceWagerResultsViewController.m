//
//  ZLConformationViewController.m
//  WarHorse
//
//  Created by Sparity on 13/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLPlaceWagerResultsViewController.h"
#import "ZLSelectedValues.h"
#import "ZLAppDelegate.h"
#import "ZLWager.h"
#import <QuartzCore/QuartzCore.h>
#import "WarHorseSingleton.h"
#import "ZLRaceCard.h"
#import "LeveyHUD.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZLPlaceWagerResultsViewController ()

@property (nonatomic, strong) UIButton *closeMediaPlayerButton;
@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPassword;
@property (nonatomic, strong) NSString *liveVideoUrlStr;
@property(strong,nonatomic)  MPMoviePlayerController *moviePlayer;

@end

@implementation ZLPlaceWagerResultsViewController

@synthesize delegate = _delegate;

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
    if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == NO)
    {
        [self.buttonVideo setHidden:YES];
        [self.buttonCurrentBets setFrame:CGRectMake(17, 327, 263, 49)];
    }
    else{
        [self.buttonVideo setHidden:NO];
        
    }

    
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.raceNumberLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:20]];
    [self.dateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.trackNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.leftPriseLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.betTypeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.runnersLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.amountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.numberOfBetsLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.totalAmountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.idLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.bottomDateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    [self.buttonRepeat.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.buttonNew.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.buttonBetSameRace.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.buttonGoToTrack.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.buttonVideo.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [self.buttonCurrentBets.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [self.totalLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];

    
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
                [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %@", _race_card.currentRace]];
                
                
            }else {
                [self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %d",[ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                
                
            }

        }
        self.raceNumberLabel.adjustsFontSizeToFitWidth = YES;
        
        
        //[self.raceNumberLabel setText:[NSString stringWithFormat:@"Race %d",[ZLAppDelegate getAppData].currentWager.selectedRaceId]];
        [self.leftPriseLabel setText:[NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].currentWager.amount]];
        
        if( [[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"E5N"]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:@"HI5"]){
            [self.betTypeLabel setText:@"PEN"];
        }
        else{
            [self.betTypeLabel setText:[ZLAppDelegate getAppData].currentWager.selectedBetType];
        }
        
                
        double total = [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount];
        int bets = total / [ZLAppDelegate getAppData].currentWager.amount;
        
        [self.runnersLabel setText:[[ZLAppDelegate getAppData].currentWager getBetString]];
        [self.amountLabel setText:[NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],total]];
        [self.totalAmountLabel setText:[NSString stringWithFormat:@"Total %@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],total]];
        [self.numberOfBetsLabel setText:[NSString stringWithFormat:@"%d Bet(s)",bets]];
        [self.idLabel setText:[ZLAppDelegate getAppData].currentWager.tsnNumber];
        [formatter setDateFormat:@"dd-MMM-yyyy hh:mm:ss"];
        [self.bottomDateLabel setText:[formatter stringFromDate:[NSDate date]]];
    }
    //[self liveVideoUrlCallFromServer];
    
    

}
//[[NSUserDefaults standardUserDefaults] objectForKey:@"event_code"];
- (void)liveVideoUrlCallFromServer
{
    //{"client_id":"BetLouisiana","user_id":"warhorse","user_password":"warhorse","videoType":"live","format":"stream"}
    
    //{"client_id":"Catskills","videoType":"live","format":"stream","track_code":"AQD"}
    ZLRaceCard *_race_card = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    
    
    NSString *trackCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"event_code"];
    NSString *meetNo =     [NSString stringWithFormat:@"%d",_race_card.meetNumber];
    //NSLog(@"meetNo %@",meetNo);
    
    NSDictionary *videoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"BetFred",@"client_id",@"live",@"videoType",@"stream",@"format",trackCode,@"track_code",meetNo,@"meet", nil];
    
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    [apiWrapper getLiveVideoUrlForParameters:videoDict success:^(NSDictionary* _responseDic) {
        [[LeveyHUD sharedHUD] disappear];
        
        NSString *urlStr = [_responseDic valueForKey:@"response-content"];
        if( urlStr.length > 0 && [urlStr hasPrefix:@"http"] ){
            NSURL *url = [NSURL URLWithString:urlStr];
            
            self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 430, 400)];
            
            [self.transparentView setBackgroundColor:[UIColor clearColor]];
            [self.transparentView setAlpha:0.6];
            [self.view addSubview:self.transparentView];
            
            self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            
            // Register to receive a notification when the movie has finished playing.
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.moviePlayer];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
            
            
            [self.transparentView addSubview:self.moviePlayer.view];
            [self.moviePlayer setFullscreen:YES animated:NO];
            [self.moviePlayer play];
            
            /*self.webview = [[UIWebView alloc] init];
             self.webview.frame = CGRectMake(self.backGroundView.frame.origin.x+15, self.backGroundView.frame.origin.y+15, self.backGroundView.frame.size.width-30, self.backGroundView.frame.size.height-30);
             UIColor *uicolor1 = [UIColor blackColor];
             CGColorRef color1 = [uicolor1 CGColor];
             [self.webview.layer setBorderWidth:1.0];
             [self.webview.layer setMasksToBounds:YES];
             [self.webview.layer setBorderColor:color1];
             
             [self.webview loadRequest:[NSURLRequest requestWithURL:url]];
             
             self.closeMediaPlayerButton = [UIButton buttonWithType:UIButtonTypeCustom];
             [self.closeMediaPlayerButton setImage:[UIImage imageNamed:@"crossmarkresults"] forState:UIControlStateNormal];
             [self.closeMediaPlayerButton addTarget:self action:@selector(removeMediaPlayerFromSuperView) forControlEvents:UIControlEventTouchUpInside];
             self.closeMediaPlayerButton.frame = CGRectMake(self.webview.frame.origin.x + self.webview.frame.size.width - 12,self.webview.frame.origin.y - 12, 24, 24);
             
             [self.backGroundView addSubview: self.webview];
             [self.backGroundView addSubview:self.closeMediaPlayerButton];
             */
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Live video is not available for the selected race!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSError* error) {
        [[LeveyHUD sharedHUD] disappear];
    }];
    

    
    
   
}


- (IBAction)newWagerButtonClicked:(id)sender
{
    [[ZLAppDelegate getAppData] clearCurrentWager];
    [self.view removeFromSuperview];
    [self.delegate newWager];
}

- (IBAction)repeatWagerButtonClicked:(id)sender
{
    [self.view removeFromSuperview];
    [self.delegate repeatWager];
}
- (IBAction)currentBetsButtonClicked:(id)sender
{
    [[ZLAppDelegate getAppData] clearCurrentWager];
    [self.view removeFromSuperview];
    [self.delegate loadCurrentBets];
}


- (IBAction)betSameRaceButtonClicked:(id)sender
{
    [self.view removeFromSuperview];
    [self.delegate repeatWagerOnSameRace];
}
- (IBAction)goToTrackButtonClicked:(id)sender
{
    [self.view removeFromSuperview];
    [self.delegate gotoTracks];
}
- (IBAction)videoButtonClicked:(id)sender
{

    ZLRaceCard *raceCard = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    
    //NSLog(@"meet no %d",raceCard.meetNumber);
    
    NSString *meetNo = [NSString stringWithFormat: @"%d",raceCard.meetNumber];
    
    NSDictionary *videoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"BetFred",@"client_id",@"live",@"videoType",@"stream",@"format",raceCard.eventCode,@"track_code",[NSString stringWithFormat:@"%d",[ZLAppDelegate getAppData].currentWager.selectedRaceId],@"race_number",meetNo,@"meet", nil];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    [apiWrapper getLiveVideoUrlForParameters:videoDict success:^(NSDictionary* _responseDic) {
        [[LeveyHUD sharedHUD] disappear];
        
        
        
        
        
        
        
        
        NSString *urlStr = [_responseDic valueForKey:@"response-content"];
        if( urlStr.length > 0 && [urlStr hasPrefix:@"http"] ){
            NSURL *url = [NSURL URLWithString:urlStr];
            
            self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 430, 400)];
            
            [self.transparentView setBackgroundColor:[UIColor clearColor]];
            [self.transparentView setAlpha:0.6];
            //[self.view addSubview:self.transparentView];
            
            self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            
            // Register to receive a notification when the movie has finished playing.
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.moviePlayer];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
            
            
            [self.view addSubview:self.moviePlayer.view];
            [self.moviePlayer setFullscreen:YES animated:NO];
            [self.moviePlayer play];
            
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Live video is not available for the selected race!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSError* error) {
        [[LeveyHUD sharedHUD] disappear];
    }];
    
    
}

-(void)moviePlayBackDidFinish:(NSNotification*) notif
{
    MPMoviePlayerController *moviePlayer = [notif object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [self.moviePlayer stop];
    [moviePlayer.view removeFromSuperview];
    [self.transparentView removeFromSuperview];
    
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
    MPMoviePlayerController *moviePlayer = [notif object];
    
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:moviePlayer];
    [self.moviePlayer stop];
}
-(void)playerDidEnterFullscreen:(NSNotification*) notif
{
    MPMoviePlayerController *moviePlayer = [notif object];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidEnterFullscreenNotification
                                                  object:moviePlayer];
    
}

- (void)removeMediaPlayerFromSuperView;
{
    [self.webview removeFromSuperview];
    [self.closeMediaPlayerButton removeFromSuperview];
    [self.transparentView removeFromSuperview];
    //    self.closeMediaPlayerButton = nil;
    //    self.webview = nil;
}

-(void)viewDidUnload{
    self.raceNumberLabel=nil;
    self.dateLabel=nil;
    self.trackNameLabel=nil;
    self.leftPriseLabel=nil;
    self.betTypeLabel=nil;
    self.runnersLabel=nil;
    self.amountLabel=nil;
    self.numberOfBetsLabel=nil;
    self.amountLabel=nil;
    self.titleLabel=nil;
    self.buttonRepeat=nil;
    self.buttonNew=nil;
    self.totalAmountLabel=nil;
    
    
 }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
