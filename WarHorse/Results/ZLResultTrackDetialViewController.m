//
//  ZLResultTrackDetialViewController.m
//  WarHorse
//
//  Created by Sparity on 7/31/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLResultTrackDetialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLPdfViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ZLResultDetailCustomCell.h"
#import "ZLBetResult.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"



#define kcustomResultDetailCellIdentifierForSection0 @"customResultDetailCellIdentifierForSection0"
#define kcustomResultDetailCellIdentifierForSection1 @"customResultDetailCellIdentifierForSection1"
#define kcustomResultDetailCellIdentifierForSection2 @"customResultDetailCellIdentifierForSection2"
#define kcustomResultDetailCellIdentifierForSection3 @"customResultDetailCellIdentifierForSection3"

@interface ZLResultTrackDetialViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UINib *resultDetailCustomCellNib;
@property (nonatomic, retain) IBOutlet UITableView *raceDetailTableView;
@property (nonatomic, retain) IBOutlet ZLResultDetailCustomCell *resultDetailCustomCell;
@property (nonatomic,retain) NSMutableArray *betTypeArray;
@property (nonatomic,retain) NSMutableArray *wagerArray;
@property (nonatomic,retain) NSMutableArray *orderArray;
@property (nonatomic,retain) NSMutableArray *scratchesArray;
@property (nonatomic, strong) NSMutableArray *tableDataArray;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) NSMutableArray *ColorViews_array;
@property (nonatomic,retain) IBOutlet UIView *backgroundView;
@property (nonatomic,retain) IBOutlet UIButton *raceButton;
@property (nonatomic,retain) IBOutlet UIButton *resultButton;
@property (strong,nonatomic)  MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain)  UIView *trasparentView;
@property(nonatomic,retain) IBOutlet ZLCalendarScrollView * calendarScrollView;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIToolbar *pickerToolBar;

@property (nonatomic, retain) NSMutableArray * raceViews;
@property (assign) int currentPage;
@property (nonatomic,strong) NSString *repalyVideo;
@property (nonatomic,strong) NSString *raceDate;
@property (assign) BOOL isVideoFlag;

@property (strong, nonatomic) IBOutlet UIButton *playbtn;
@property (nonatomic, strong) UIButton *closeMediaPlayerButton;
@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic,strong) UILabel *noReplayVideo;
@property (nonatomic,strong) IBOutlet UILabel *selectDateLabel;
@property (nonatomic,strong) NSMutableArray *colorsArray;

-(IBAction)raceReplayClicked:(id)sender;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)showCalendar:(id)sender;
- (IBAction)resultsChartButtonClicked:(id)sender;

@end

@implementation ZLResultTrackDetialViewController

@synthesize track;
@synthesize meet;
@synthesize perf;
@synthesize trackCode;
@synthesize dateStr;
@synthesize trackCountryFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.track = nil;
        self.currentPage = 0;
        self.raceViews = [NSMutableArray array];
    }
    return self;
}

#pragma mark - View LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"dateStr %@",self.dateStr);
    
    self.screenName = @"Results Details";
    
    self.colorsArray = [[NSMutableArray alloc] initWithCapacity:0];

    
    [self.selectDateLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    self.selectDateLabel.text = dateStr;
    self.isVideoFlag = NO;
    
    self.noReplayVideo = [[UILabel alloc] initWithFrame:CGRectMake(60, 250, 260, 25)];
    
    [self.view addSubview:self.noReplayVideo];
    self.noReplayVideo.hidden = YES;
    
    
}

-(void) setup{
    
    // Do any additional setup after loading the view from its nib.
    self.betTypeArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.wagerArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.orderArray=[[NSMutableArray alloc]initWithCapacity:0];
    self.scratchesArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    UIColor *uicolor = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    CGColorRef color = [uicolor CGColor];
    [self.raceDetailTableView.layer setBorderWidth:1.0];
    [self.raceDetailTableView.layer setMasksToBounds:YES];
    [self.raceDetailTableView.layer setBorderColor:color];
    [self.raceDetailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    

    [self.trasparentView setBackgroundColor:[UIColor redColor]];
    [self.trasparentView setAlpha:0.8];
    
    UIColor *uicolor1 = [UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0];
    CGColorRef color1 = [uicolor1 CGColor];
    [self.trasparentView.layer setBorderWidth:1.0];
    //    [self.trasparentView.layer setMasksToBounds:YES];
    [self.trasparentView.layer setBorderColor:color1];
    [self.view addSubview:self.trasparentView];
    
    //[self.trasparentView setHidden:YES];
    
    if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES){
        [self.raceButton setHidden:NO];
        [self.raceButton setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
        [self.raceButton setTitle:@"RACE REPLAY" forState:UIControlStateNormal];
        [self.raceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.raceButton setTitleColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0] forState:UIControlStateSelected];
        [self.raceButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
        
        [self.raceButton.layer setBorderColor:[[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0] CGColor]];
        [self.raceButton.layer setBorderWidth:1.5];
    }
    else{
        [self.raceButton setHidden:YES];
    }

    
    [self.resultButton setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
    [self.resultButton setTitle:@"RESULTS CHART" forState:UIControlStateNormal];
    [self.resultButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.resultButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];

    self.calendarScrollView.selectedDate = self.resultDate;
    [self.calendarScrollView setUpSubView];
    
    self.scrollView.clipsToBounds = NO;
    self.scrollView.pagingEnabled = YES;
	self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    if( track.trackResults != nil && [track.trackResults count] > 0 ){
        [self setupRaceViews];
    }
    else{
        
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [ZLAppDelegate showLoadingView];
        
        [[ZLAppDelegate getApiWrapper] getRaceResultsByMeet:self.meet WithPerf:self.perf dateStr:self.dateStr
                                 success:^(NSDictionary* _userInfo){
                                     [self setupRaceViews];
                                     [ZLAppDelegate hideLoadingView];
                                 }failure:^(NSError *error){
                                     [ZLAppDelegate hideLoadingView];
                                 }];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    
    self.resultDetailCustomCellNib = [UINib nibWithNibName:@"ZLResultDetailCustomCell" bundle:nil];
    [self.raceDetailTableView registerNib:self.resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection0];
    [self.raceDetailTableView registerNib:self.resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection1];
    [self.raceDetailTableView registerNib:self.resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection2];
    [self.raceDetailTableView registerNib:self.resultDetailCustomCellNib forCellReuseIdentifier:kcustomResultDetailCellIdentifierForSection3];
    
    self.calendarScrollView.delegate = self;

}

-(void) setupRaceViews{
    
    CGFloat contentOffset = 0.0f;
    
    for( UIView * vw in self.raceViews){
        [vw removeFromSuperview];
    }
    [self.raceViews removeAllObjects];
    
    
    
    
    
    for (int i = 0; i <= [self.track.trackResults count]/9; i++) {
        
        [self.colorsArray addObject:[UIColor colorWithRed:255.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:0.0/255.0f green:153.0/255.0f blue:188.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:212.0/255.0f green:5.0/255.0f blue:63.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:117.0/255.0f green:114.0/255.0f blue:216.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:221.0/255.0f green:144.0/255.0f blue:34.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:160.0/255.0f green:17.0/255.0f blue:182/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:39.0/255.0f green:209.0/255.0f blue:26.0/255.0f alpha:1.0]];
        
        [self.colorsArray addObject:[UIColor colorWithRed:1.0/255.0f green:71.0/255.0f blue:185/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:229.0/255.0f green:30.0/255.0f blue:133.0/255.0f alpha:1.0]];    }
    
    
    for (int i=0;i<[self.track.trackResults count]; i++)
    {
        ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:i];
        
        CGRect imageViewFrame = CGRectMake(contentOffset, 0.0f,  self.scrollView.frame.size.width - 5,  self.scrollView.frame.size.height);
        
        UIView *view = [[UIView alloc] initWithFrame:imageViewFrame];
		view.backgroundColor = [self.colorsArray objectAtIndex:i];
        /*
        if ([resultsForTrack.trackCountry isEqualToString:@"UK"]){
            self.resultCustomCell.countryFlag.image = [UIImage imageNamed:@"uk.png"];
        }else if ([resultsForTrack.trackCountry isEqualToString:@"US"]){
            self.resultCustomCell.countryFlag.image = [UIImage imageNamed:@"us.png"];
            
        }
        
*/
        
        UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 15, 15)];
        if ([trackCountryFlag isEqualToString:@"UK"]){
            flagImageView.image = [UIImage imageNamed:@"uk.png"];
        }else if ([trackCountryFlag isEqualToString:@"US"]){
            flagImageView.image = [UIImage imageNamed:@"us.png"];
            
        }
        [view addSubview:flagImageView];

        UILabel *raceNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 10, 160, 18)];
        //imageView.center=raceNameLabel.center;
        [raceNameLabel setTextColor:[UIColor whiteColor]];
        [raceNameLabel setTextAlignment:NSTextAlignmentCenter];
        [raceNameLabel setBackgroundColor:[UIColor clearColor]];
        [raceNameLabel setText:self.track.trackName];
        [raceNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
        [view addSubview:raceNameLabel];
            
        UILabel *raceNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 29, _scrollView.frame.size.width - 5, 18)];
        [raceNumLabel setTextColor:[UIColor whiteColor]];
        [raceNumLabel setTextAlignment:NSTextAlignmentCenter];
        [raceNumLabel setBackgroundColor:[UIColor clearColor]];
        [raceNumLabel setText:[NSString stringWithFormat:@"Race - %@",trackResult.raceNumber]];
        [raceNumLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
        [view addSubview:raceNumLabel];
        
        
        
        if( [trackResult.winnersByPosition count] == 0){
            //[raceNumLabel setText:[NSString stringWithFormat:@"%d - No Race",trackResult.race]]; //ramya
        }
        
        contentOffset += view.frame.size.width + 5;
        
		[ self.scrollView addSubview:view];
        
        self.scrollView.contentSize = CGSizeMake(contentOffset,  self.scrollView.frame.size.height);
        [self.raceViews addObject:view];
	}
    [self.raceDetailTableView reloadData];
    [self repalayVideoUrl];
}

-(void) removeRaceViews{
    
    for( UIView * vw in self.raceViews){
        [vw removeFromSuperview];
    }
    [self.raceViews removeAllObjects];
    
}
-(void) dateDidChange{
    
    [self loadResultsForDate:self.calendarScrollView.selectedDate];
    self.noReplayVideo.hidden = YES;
    [self repalayVideoUrl];

}
- (void)repalayVideoUrl
{
    
    
    if( self.track && self.track.trackResults && [self.track.trackResults count] > 0){
        ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:self.currentPage];
        
        //NSLog(@"Race meet no %d",trackResult.meet);
        NSString *meetNo  = [NSString stringWithFormat:@"%d",trackResult.meet];
        
        NSDictionary *argumentsDic = @{@"client_id": @"BetFred",//   Betzotic
                                       @"videoType": @"replay",
                                       @"format": @"stream",
                                       @"track_code":trackCode,//trackCode
                                       @"race_number": [NSString stringWithFormat:@"%d",trackResult.race],
                                       @"video_date": dateStr,
                                       @"meet":meetNo
                                       };
        //NSLog(@"argumentsDic %@",argumentsDic);
        
        [[LeveyHUD sharedHUD] appearWithText:@"Loading Results..."];
        
        
        
        
        
        ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
        [apiWrapper getLiveVideoUrlForParameters:argumentsDic success:^(NSDictionary* _responseDic) {
            [[LeveyHUD sharedHUD] disappear];
            if ([[_responseDic valueForKey:@"response-status"] isEqualToString:@"success"] && ![[_responseDic valueForKey:@"response-message"] isEqualToString:@"The data requested is unavailable"]) // Hack - I couldn't find a way around this problem as the response-status is success and message is failure - Jugs
            {
                self.isVideoFlag = YES;
                self.repalyVideo = [_responseDic valueForKey:@"response-content"];
            }else{
                self.isVideoFlag = NO;
            }
            
        } failure:^(NSError* error) {
            [[LeveyHUD sharedHUD] disappear];
        }];
    }
    else{
        self.isVideoFlag = 0;
    }

}
-(void) loadResultsForDate:(NSDate*) date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    self.raceDate = [formatter stringFromDate:date];

    
    //NSMutableArray * tracks = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:date]];
    
    [self removeRaceViews];
    [self.raceDetailTableView reloadData];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [ZLAppDelegate showLoadingView];
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    [apiWrapper getTracksResultsForDate:date
                                success:^(NSDictionary* _userInfo){
                                    
                                    NSMutableArray * tracks = [[ZLAppDelegate getAppData].dictTrackResultsByDate objectForKey:[formatter stringFromDate:date]];
                                    if( tracks != nil){
                                        for(ZLLoadCardTracks * cardTrack in tracks){
                                            if( cardTrack.meet == self.meet){
                                                self.track = cardTrack;
                                                self.perf = cardTrack.perf;
                                                if( self.track.trackResults != nil && [self.track.trackResults count] > 0 ){
                                                    [self setupRaceViews];
                                                }
                                                else{
                                                    
                                                    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
                                                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                                        [alert show];
                                                        return;
                                                    }
                                                    
                                                    [ZLAppDelegate showLoadingView];
                                                    
                                                    [[ZLAppDelegate getApiWrapper] getRaceResultsByMeet:self.meet WithPerf:self.perf dateStr:self.dateStr
                                                                                                success:^(NSDictionary* _userInfo){
                                                                                                    [self setupRaceViews];
                                                                                                    [ZLAppDelegate hideLoadingView];
                                                                                                }failure:^(NSError *error){
                                                                                                    [ZLAppDelegate hideLoadingView];
                                                                                                }];
                                                }
                                                break;
                                            }
                                        }
                                    }
                                    [ZLAppDelegate hideLoadingView];
                                }failure:^(NSError *error){
                                    [ZLAppDelegate hideLoadingView];
                                }];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.scrollView.bounds.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page == [self.track.trackResults count]) {
        self.currentPage = page-1;
        return;
    }
    if( self.currentPage != page){
        
        self.currentPage = page;
        [self.raceDetailTableView reloadData];
        [self repalayVideoUrl];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private API

-(IBAction)raceReplayClicked:(id)sender
{
    
    if (self.isVideoFlag == YES){
        ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.isOrientation = YES;
        
        self.noReplayVideo.hidden = YES;
        //NSLog(@"Video Url %d",self.isVideoFlag);
        
        if (![self.raceButton isSelected] == YES)
        {
            //[self.trasparentView setHidden:NO];
            [self.raceButton setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
            
            self.trasparentView=[[UIView alloc] initWithFrame:CGRectMake(0, 42, self.raceDetailTableView.frame.size.width+10, self.raceDetailTableView.frame.size.height+55)];//[[UIView alloc]init];
            [self.trasparentView setBackgroundColor:[UIColor blackColor]];
            [self.trasparentView setAlpha:0.6];
            [self.view addSubview:self.trasparentView];
            
            
            [self.playbtn setImage:[UIImage imageNamed:@"video_selected.png"] forState:UIControlStateNormal] ;
            
            
            NSURL *url = [NSURL URLWithString:self.repalyVideo];
            
            
            self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
            
            // Register to receive a notification when the movie has finished playing.
            
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayexitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.moviePlayer];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:self.moviePlayer];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:self.moviePlayer];
            
            
            [self.trasparentView addSubview:self.moviePlayer.view];
            [self.moviePlayer setFullscreen:YES animated:NO];
            [self.moviePlayer play];
            
        }else
        {
            [self removeMediaPlayerFromSuperView];
        }
        
        
    }else{
        
        //NSLog(@"No Video Url %d",self.isVideoFlag);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Replay video is currently unavailable for this race" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
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
    [self.moviePlayer stop];

}



- (IBAction)backButtonClicked:(id)sender
{
    [self.scrollView removeFromSuperview];
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)resultsChartButtonClicked:(id)sender
{
    ZLPdfViewController *objPdfViewController = [[ZLPdfViewController alloc] init];
    [self.navigationController pushViewController:objPdfViewController animated:YES];
}

- (void)removeMediaPlayerFromSuperView;
{
    [self.moviePlayer stop];
    [self.raceButton setSelected:NO];
    [self.webview removeFromSuperview];
    [self.closeMediaPlayerButton removeFromSuperview];
    [self.trasparentView removeFromSuperview];
    
    //    self.closeMediaPlayerButton = nil;
    [self.raceButton setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /********** Using the default tracker **********/
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    /**********Manual screen recording**********/
    //  [tracker set:kGAIScreenName value:@"Stopwatch"];
    //  [tracker send:[[GAIDictionaryBuilder createAppView] build]];
    
    /**********Setting and Sending Data**********/
    //    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"appview", kGAIHitType, @"Stopwatch1", kGAIScreenName, nil];
    //    [tracker send:params];
    
    
    /* MapBuilder class simplifies the process of building hits */
    [tracker send:[[[GAIDictionaryBuilder createAppView] set:@"Reslut View" forKey:kGAIScreenName] build]];

    
    [self removeMediaPlayerFromSuperView];
}

#pragma mark - Gesture Recognizer Methods

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:self.scrollView];
    
    int currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    
    if (touchPoint.x > self.scrollView.contentOffset.x + self.scrollView.frame.size.width && touchPoint.x < self.scrollView.contentSize.width - self.scrollView.frame.size.width/2) {
        
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * (currentPage + 1);
        [self.scrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        
    }
    else if(self.scrollView.contentOffset.x >= self.scrollView.frame.size.width && touchPoint.x < self.scrollView.contentOffset.x)
    {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [self.scrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
    }
    
}

#pragma mark - DataSources

#pragma mark - TableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( self.track.trackResults == nil || [self.track.trackResults count] == 0){
        return 0;
    }
    if( section == 0){
        ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:self.currentPage];
        if( [trackResult.winnersByPosition count] > 0)
            return [trackResult.winnersByPosition count];
        else
            return 0;
    }
    else if( section == 1){
        ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:self.currentPage];
        return [trackResult.betsForRendering count];
    }
    else if( section == 2){
        ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:self.currentPage];
        return [trackResult.finishers count];
    }
    else  if( section == 3){
        ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:self.currentPage];
        NSLog(@"sub options = %@",trackResult.otherInformation);

        return [trackResult.otherInformation count];
        
        
    }
    return 0;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return @"Win, Place, Show Payoffs";
//    }else if(section == 1) {
//        return @"Other wagers";
//    }else if (section == 2){
//        return @"Order of finish";
//    }else
//        return @"Scratches(Reason)";
    return @"";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(self.track.trackResults == nil || [self.track.trackResults count] == 0)
        return 0;
    
    if (indexPath.section == 0){
        self.resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection0 forIndexPath:indexPath];
    }
    else if (indexPath.section == 1){
        self.resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection1 forIndexPath:indexPath];
    }
    else if (indexPath.section == 2){
        self.resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection2 forIndexPath:indexPath];
    }
    else if (indexPath.section == 3) {
         self.resultDetailCustomCell  = [tableView dequeueReusableCellWithIdentifier:kcustomResultDetailCellIdentifierForSection3 forIndexPath:indexPath];
        
    }
    ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:self.currentPage];

    if( trackResult != nil){
        self.resultDetailCustomCell.trackResult = trackResult;
        self.resultDetailCustomCell.breedType = self.breedType;
        [self.resultDetailCustomCell updateViewAtIndexPath:indexPath];
    }

    return self.resultDetailCustomCell;
}


#pragma mark - Delegates

#pragma mark - TableView Delegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1) {
        return 39;
    }else if (indexPath.section==2){
        return 54;
    }else if (indexPath.section==3){
        
        if (indexPath.row == 2) {
           
             ZLTrackResults * trackResult = [self.track.trackResults objectAtIndex:self.currentPage];
            if ([trackResult.scratches count]>0) {
            return [trackResult.scratches count] * 24.0 + 20.0;
            }
        }
        return 24.0;
    }
    else
    {
        if (indexPath.row == 2) {
            return 44.5;
        }
        return 50.5;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 27.5;
            break;
        case 1:
            return 27.5;
            break;
        case 2:
            return 30.5;
            break;
        case 3:
            return 27;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        
        case 3:
            return 7;
            break;
            
        default:
            return 0;
            break;
    }
}

// custom view for footer. will be adjusted to default or specified footer height

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 274, 7)];
    return footerBackground;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView=[[UIView alloc]init];
    UIView *sectionHeaderViewBackgroundView = [[UIView alloc] init];
    UILabel *tempLabel=[[UILabel alloc]init];
    
    switch (section) {
        case 0:
            {
                [sectionHeaderView setFrame:CGRectMake(0,0,310,29)];
                [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
                [tempLabel setFrame:CGRectMake(6,7,298,20)];
            }
            break;
        case 1:
            {
                [sectionHeaderView setFrame:CGRectMake(0,0,310,29)];
                [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
                 [tempLabel setFrame:CGRectMake(6,7,298,20)];
            }
            break;
        case 2:
            {
                [sectionHeaderView setFrame:CGRectMake(0,0,310,29)];
                [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
                 [tempLabel setFrame:CGRectMake(6,7.5,298,20)];
            }
            break;
        case 3:
            {
                [sectionHeaderView setFrame:CGRectMake(0,0,310,29)];
                [sectionHeaderViewBackgroundView setFrame:CGRectMake(0, 0, 310, 27)];
                 [tempLabel setFrame:CGRectMake(6,7.5,298,20)];
            }
            break;
            
        default:
            break;
    }

    sectionHeaderView.backgroundColor=[UIColor clearColor];
    sectionHeaderViewBackgroundView.backgroundColor = [UIColor whiteColor];
    [sectionHeaderView addSubview:sectionHeaderViewBackgroundView];
    tempLabel.backgroundColor=[UIColor colorWithRed:217.0/255.0f green:217.0/255.0f blue:217.0/255.0f alpha:1.0];
    tempLabel.textAlignment=NSTextAlignmentCenter;
    
    [tempLabel setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [tempLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    
    if (section==0) {
        tempLabel.text=@"Results";
    }else if (section==1){
        tempLabel.text=@"";
    }else if (section==2){
        tempLabel.text=@"Order of finish";
        
    }else{
        tempLabel.text=@"Other Information";
        
    }
    [sectionHeaderView addSubview:tempLabel];
    
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

@end
