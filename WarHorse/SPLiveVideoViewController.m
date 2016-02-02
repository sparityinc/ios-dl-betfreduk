//
//  SPLiveVideoViewController.m
//  WarHorse
//
//  Created by Ramya on 10/1/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPLiveVideoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SPLiveVideoTableCell.h"
#import "SPLiveVideo.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"

static NSString *const kCustomCellIdentifier = @"CustomCellIdentifier";
static NSString *const kCustomCellNib = @"SPLiveVideoTableCell";

@interface SPLiveVideoViewController ()

@property (strong, nonatomic) IBOutlet UIButton *playbtn;
@property (strong, nonatomic) IBOutlet UITableView *videosListTableView;
@property (nonatomic, strong) NSMutableArray *tracksArray;
@property (nonatomic, strong) SPLiveVideo *liveVideo;
@property (nonatomic, strong) NSMutableArray *videoObjArray;
@property (nonatomic, strong) UIButton *closeMediaPlayerButton;
@property (nonatomic, strong) UIView *transparentView;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic,strong) IBOutlet UILabel *nodataLabel;
@end

@implementation SPLiveVideoViewController
@synthesize moviePlayer;
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
    
    
    self.tracksArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.videoObjArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self prepareTopView];
    
    [self.videosListTableView registerNib:[UINib nibWithNibName:kCustomCellNib bundle:nil] forCellReuseIdentifier:kCustomCellIdentifier];
     self.videosListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.videosListTableView.hidden = YES;
    
    [self loadTracks];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    
    [self.nodataLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.nodataLabel setHidden:YES];
    
}

- (void)loadTracks
{
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Tracks..."];
    
    [apiWrapper loadRaceCards:YES success:^(NSDictionary* _userInfo){
        
        self.tracksArray = (NSMutableArray *)[ZLAppDelegate getAppData].raceCards;
        if ([self.tracksArray count]>0){
            self.videosListTableView.hidden = NO;

            [self.nodataLabel setHidden:YES];
        }else{
            self.videosListTableView.hidden = YES;
            [self.nodataLabel setHidden:NO];
        }
        
        //NSLog(@"tracksArray %@",self.tracksArray);
        
        
        [self sortByAlphabet];
        [self.videosListTableView reloadData];
        [[LeveyHUD sharedHUD] disappear];
        
    }failure:^(NSError *error){
        
        [[LeveyHUD sharedHUD] disappear];
        
    }];

}

- (void)sortByAlphabet
{    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES]; 
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,nil];
    
    self.tracksArray = (NSMutableArray *)[self.tracksArray sortedArrayUsingDescriptors:sortDescriptors];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareTopView
{
    
    [self.toggleButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleLabel setText:@"Live Videos"];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];

}

- (void)balanceUpdated:(NSNotification *)notification{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n %@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}

- (IBAction)amountButtonClicked:(id)sender
{
    CGRect rect = ((UIButton *)sender).frame;
    
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        
        rect.origin.x += 30;
        rect.size.width -= 30;
        [self.amountButton setFrame:rect];
        
    }
    else{
        [self.amountButton setTitle:[NSString stringWithFormat:@"Loading.."] forState:UIControlStateSelected];
        
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [[ZLAppDelegate getApiWrapper] refreshBalance:YES success:^(NSDictionary* _userInfo){
            [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
        }failure:^(NSError *error){
        }];
        [self.amountButton setSelected:YES];
        
        rect.origin.x -= 30;
        rect.size.width += 30;
        [self.amountButton setFrame:rect];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }
}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 17, 45, 45)];
    }
}


- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
    
}

- (void)playVideoBtAction:(id)sender
{
    [self playVideo:[sender tag]];
}
- (void)playVideo:(int)selectedRow
{
    
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    ZLRaceCard * _race_card = [self.tracksArray objectAtIndex:selectedRow];
    
    
    NSDictionary *argumentsDic = @{@"client_id": @"BetFred",
                                   @"videoType": @"live",
                                   @"format": @"stream",
                                   @"track_code": [NSString stringWithFormat:@"%@",_race_card.eventCode],
                                   @"race_number": [NSString stringWithFormat:@"%d",_race_card.currentRaceNumber],
                                   @"meet":[NSString stringWithFormat:@"%d",_race_card.meetNumber]
                                   };
    //NSLog(@"Video Dict %@",argumentsDic);

    [[LeveyHUD sharedHUD] appearWithText:@"Loading Video..."];
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getLiveVideoUrlForParameters:argumentsDic success:^(NSDictionary* _responseDic) {
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[_responseDic valueForKey:@"response-status"] isEqualToString:@"success"]) {
            
            NSString *urlStr = [_responseDic valueForKey:@"response-content"];
            if( urlStr.length > 0 && [urlStr hasPrefix:@"http"] ) {
                
                appDelegate.isOrientation = YES;

                
                self.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 46, self.videosListTableView.frame.size.width, self.videosListTableView.frame.size.height)];
                
                [self.transparentView setBackgroundColor:[UIColor blackColor]];
                [self.transparentView setAlpha:0.6];
                [self.view addSubview:self.transparentView];
                
                [self.playbtn setImage:[UIImage imageNamed:@"video_selected.png"] forState:UIControlStateNormal] ;
                
                NSURL *url = [NSURL URLWithString:urlStr];
                self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
                
                //self.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;

                
                // Register to receive a notification when the movie has finished playing.
                
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                           object:self.moviePlayer];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
                
                
                
                
                [self.transparentView addSubview:self.moviePlayer.view];
                [self.moviePlayer setFullscreen:YES animated:NO];
                [self.moviePlayer play];
                
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"The data requested is unavailable" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            
            
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Sorry, video is not available now!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }

    } failure:^(NSError* error) {
        [[LeveyHUD sharedHUD] disappear];        
    }];
    

}

- (void)moviePlayBackDidFinish:(NSNotification*) notif
{
    MPMoviePlayerController *aMoviePlayer = [notif object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:aMoviePlayer];
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.isOrientation = NO;
    [self.moviePlayer stop];
    

    [self.transparentView removeFromSuperview];
    [moviePlayer.view removeFromSuperview];
    
    NSNumber* reason = [[notif userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            //NSLog(@"Playback Ended");
            
            [self performSelector:@selector(playBackEnded) withObject:nil afterDelay:1.0];

            break;
        case MPMovieFinishReasonPlaybackError:
            //NSLog(@"Playback Error");
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


- (void)removeMediaPlayerFromSuperView;
{
    [self.moviePlayer stop];
    [self.webview removeFromSuperview];
    [self.closeMediaPlayerButton removeFromSuperview];
    [self.transparentView removeFromSuperview];
}

- (void)viewDidUnload {
    [self setPlaybtn:nil];
    [super viewDidUnload];
}

#pragma mark -TableView Dalagate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [self.tracksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPLiveVideoTableCell *customCell = [tableView dequeueReusableCellWithIdentifier:kCustomCellIdentifier forIndexPath:indexPath];

    [customCell.playVideoBtn setTag:indexPath.row];
    [customCell.playVideoBtn addTarget:self action:@selector(playVideoBtAction:) forControlEvents:UIControlEventTouchUpInside];
    ZLRaceCard * _race_card = [self.tracksArray objectAtIndex:indexPath.row];
    customCell.messageLabel.text = _race_card.ticketName;
    [customCell.messageLabel setTextAlignment:NSTextAlignmentLeft];
    
    
    if ([_race_card.isVideoAvailable boolValue]) {
        customCell.playVideoBtn.hidden = NO;

    }
    else {
        customCell.playVideoBtn.hidden = YES;

    }
    
    [customCell updateViewAtIndexPath: indexPath];
    
    return customCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    ZLRaceCard * _race_card = [self.tracksArray objectAtIndex:indexPath.row];

    if ([_race_card.isVideoAvailable boolValue]) {
        [self playVideo:indexPath.row];
    }

}

#pragma mark - Private API

- (IBAction)goToHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}

- (IBAction)goToMyBets:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardMyBets]forKey:@"viewNumber"]];
}

@end
