//
//  SPRewardsDetailViewController.m
//  WarHorse
//
//  Created by Enterpi on 23/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPRewardsDetailViewController.h"
#import "SPScrollableTrackTitleView.h"
#import "SPRewardDetailCustomCell.h"
#import "SPSCRChanges.h"
#import "SPRewards.h"
#import "ZLPreLoginAPIWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "SPConstant.h"



static NSString *const krewardDetailCustomCellIdentifier = @"rewardDetailCustomCellIdentifier";
static NSString *const krewardDetailCustomCellNib = @"SPRewardDetailCustomCell";

@interface SPRewardsDetailViewController () <UIScrollViewDelegate>

@property (strong) IBOutlet UITableView *rewardsDetailTableView;
@property (strong) IBOutlet UIImageView *headerImageView;
@property (strong) IBOutlet UIScrollView *trackContainerScrollView;
@property (strong) IBOutlet UIView *tableBackgroundView;

@property (strong) NSMutableArray *rewardsScrollViewDataObjectsArray;
@property (strong) NSMutableDictionary *rewardsTracksDataDictionary;
@property (strong) NSMutableArray *rewardsTracksObjectsArray;
@property (strong) NSMutableArray *filteredRewardsTracksObjectsArray;
@property (strong, nonatomic) NSMutableArray *rewardsObjectsArray;
@property (strong, nonatomic) NSMutableArray *colorsArray;

@property (strong) IBOutlet UISearchBar *searchBar;
@property (strong) IBOutlet UISegmentedControl *segmentedControl;
@property (strong) IBOutlet UIImageView  *segmentedControlBackgroundImage;
@property (strong) SPSCRChanges *rewards;
@property (strong) NSMutableDictionary *rewardsDataDic;
@property (strong, nonatomic) NSMutableArray *rewardsTracksArray;

@property (assign, nonatomic) int pageIndex;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) SPSCRChanges *scrChanges;
@property (strong, nonatomic) IBOutlet UIWebView *rewardswebView;
@property (strong, nonatomic) NSMutableArray *rewordsUrlArry;
@end

@implementation SPRewardsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View LifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.rewardswebView setOpaque:NO];
    // Do any additional setup after loading the view from its nib.
    [self serviceCall];
    self.rewardsTracksArray = [[NSMutableArray alloc] init];

    
    self.rewardsScrollViewDataObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.rewardsObjectsArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.pageIndex = 0;
    
    self.colorsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.tableBackgroundView.layer setBorderWidth:1.0];
    [self.tableBackgroundView.layer setBorderColor:[[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0] CGColor]];
    
    [self.rewardsDetailTableView.layer setBorderWidth:1.0];
    [self.rewardsDetailTableView.layer setBorderColor:[[UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0] CGColor]];
    [self.rewardsDetailTableView setBackgroundColor:[UIColor clearColor]];
    
    //adjust the label the the new height.
    UILabel *carryoverText = [[UILabel alloc]initWithFrame:CGRectMake(44, 34, 300, 19)];
    [carryoverText setBackgroundColor:[UIColor clearColor]];
    [carryoverText setText:@"Rewards Structure"];
    [carryoverText setFont:[UIFont fontWithName:@"Roboto-Light" size:16]];
    [carryoverText setTextColor:[UIColor whiteColor]];
    [self.headerImageView addSubview:carryoverText];
    [self.rewardsDetailTableView setSeparatorColor:[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0]];
    
    self.currentDate = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [self.dateFormatter setDateFormat:@"EEEE MMM dd, YYYY"];
    
    
    self.trackContainerScrollView.clipsToBounds = NO;
    
    [self.segmentedControl setFrame:CGRectMake(20, 7, 300, 44)];
    
    [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl setDividerImage:[UIImage imageNamed:@"dividerline"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setDividerImage:[UIImage imageNamed:@"dividerline"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setDividerImage:[UIImage imageNamed:@"dividerline"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self createScrollContainer];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.trackContainerScrollView addGestureRecognizer:singleTap];
    
    [self.rewardsDetailTableView registerNib:[UINib nibWithNibName:krewardDetailCustomCellNib bundle:nil] forCellReuseIdentifier:krewardDetailCustomCellIdentifier];
    
    
}
- (void)serviceCall
{
    
     ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
     NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
     @"queryParams":@{@"json_data_id":@"Rewards"}};
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Rewards..."];

     [apiWrapper preloginBanners:argumentsDic success:^(NSDictionary *_userInfo){
         
         
         if ([[_userInfo valueForKey:@"response-status"]isEqualToString:@"success"]){
             
             NSMutableArray *tempArray = [[NSMutableArray alloc] init];
             tempArray =[[[[_userInfo valueForKey:@"response-content"] objectAtIndex:0] valueForKey:@"Json_Data"] valueForKey:@"Rewards"];
             
             for (int i=0;i<[tempArray count];i++){
                 [self.rewardsTracksArray addObject:[[tempArray objectAtIndex:i] valueForKey:@"Description"]];
             }
             [self loadData];
             
             
             self.rewordsUrlArry = [[[[_userInfo valueForKey:@"response-content"] objectAtIndex:0] valueForKey:@"Json_Data"] valueForKey:@"Rewards"];
             NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,[[self.rewordsUrlArry objectAtIndex:0] valueForKey:@"fileurl"]];
             
             NSURL *instructionsURL = [NSURL URLWithString:urlStr];
             
             [self.rewardswebView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
         }
     
     
     
     }failure:^(NSError *error) {
     [[LeveyHUD sharedHUD] disappear];
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%ld", (long)error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
     
     }];
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView == self.trackContainerScrollView) {
        self.pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if ([self.rewordsUrlArry count]>1){
            [self scrollIndex:self.pageIndex];

        }
    
        
    }
    
}

- (void)scrollIndex:(int)index
{
    switch (index) {
        case 0:
        {
            [[LeveyHUD sharedHUD] appearWithText:@"Loading Rewards..."];

            NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,[[self.rewordsUrlArry objectAtIndex:0] valueForKey:@"fileurl"]];
            
            NSURL *instructionsURL = [NSURL URLWithString:urlStr];

            [self.rewardswebView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
            
        }
            
            break;
        case 1:
        {
            
            [[LeveyHUD sharedHUD] appearWithText:@"Loading Rewards..."];

            NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,[[self.rewordsUrlArry objectAtIndex:1] valueForKey:@"fileurl"]];
            
            NSURL *instructionsURL = [NSURL URLWithString:urlStr];
            

            [self.rewardswebView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
            
        }
            
            break;
        case 2:
        {
            [[LeveyHUD sharedHUD] appearWithText:@"Loading Rewards..."];

            NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,[[self.rewordsUrlArry objectAtIndex:2] valueForKey:@"fileurl"]];
            
            NSURL *instructionsURL = [NSURL URLWithString:urlStr];
            

            [self.rewardswebView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
            
        }
            
            break;
        case 3:
        {
            [[LeveyHUD sharedHUD] appearWithText:@"Loading Rewards..."];

            NSString *urlStr =[NSString stringWithFormat:@"%@%@",kDownLoadedBaseCMSUrl,[[self.rewordsUrlArry objectAtIndex:3] valueForKey:@"fileurl"]];
            
            NSURL *instructionsURL = [NSURL URLWithString:urlStr];
            [self.rewardswebView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
            
        }
            
            break;
        default:
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[LeveyHUD sharedHUD] disappear];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[LeveyHUD sharedHUD] disappear];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[LeveyHUD sharedHUD] disappear];
}


- (void)loadData
{
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
        
    
    for (int i = 0; i < [self.rewardsTracksArray count]; i++) {
        [self.colorsArray addObject:[UIColor colorWithRed:255.0/255.0f green:90.0/255.0f blue:0.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:0.0/255.0f green:153.0/255.0f blue:188.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:212.0/255.0f green:5.0/255.0f blue:63.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:117.0/255.0f green:114.0/255.0f blue:216.0/255.0f alpha:1.0]];
        [self.colorsArray addObject:[UIColor colorWithRed:221.0/255.0f green:144.0/255.0f blue:34.0/255.0f alpha:1.0]];
        
    }
    for (int i = 0; i < [self.rewardsTracksArray count]; i++) {
        
        self.scrChanges = [[SPSCRChanges alloc] init];
        self.scrChanges.trackname = [self.rewardsTracksArray objectAtIndex:i];
        self.scrChanges.viewBgColor = [self.colorsArray objectAtIndex:i];
        [self.rewardsScrollViewDataObjectsArray addObject:self.scrChanges];

    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self createScrollContainer];
        
    });
    
}



#pragma mark - Private API

- (void)createScrollContainer
{
    CGFloat x = 5.0f;
    
    for (int i = 0; i < [self.rewardsScrollViewDataObjectsArray count]; i++) {
        
        CGRect scrollableTrackTitleViewFrame = CGRectMake(x, 0, 220, self.trackContainerScrollView.frame.size.height);
        
        NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"SPScrollableTrackTitleView" owner:self options:nil];
        
        SPScrollableTrackTitleView *scrollableTrackTitleView = nil;
        for (id xibObject in xibArray) {
            //Loop through array, check for the object we're interested in.
            if ([xibObject isKindOfClass:[SPScrollableTrackTitleView class]]) {
                //Use casting to cast (id) to (MyCustomView *)
                scrollableTrackTitleView = (SPScrollableTrackTitleView *)xibObject;
            }
        }
        
        scrollableTrackTitleView.frame = scrollableTrackTitleViewFrame;
        [scrollableTrackTitleView setIsSCRChanges:YES];
        [scrollableTrackTitleView setScrChanges:[self.rewardsScrollViewDataObjectsArray objectAtIndex:i]];
        [scrollableTrackTitleView updateView];
        
        [self.trackContainerScrollView addSubview:scrollableTrackTitleView];
        
        x = x + self.trackContainerScrollView.frame.size.width;
        
    }
    
    [self.trackContainerScrollView setContentSize:CGSizeMake(x, self.trackContainerScrollView.frame.size.height)];
}

- (IBAction)backToHome:(id)sender
{
    [self.trackContainerScrollView removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backToRewards:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shuffle
{
    NSUInteger count = [self.rewardsTracksObjectsArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (arc4random() % nElements) + i;
        [self.rewardsTracksObjectsArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    [self.rewardsDetailTableView reloadData];
}

- (void)keyboardWillShow {
    for( UIView *subview in self.view.subviews ) {
        if( [subview isKindOfClass:[UIControl class]] ) {
            UIControl *v = (UIControl*)subview;
            if (v.alpha < 1) {
                v.hidden = YES;
            }
        }
    }
}


#pragma mark - Gesture Recognizer Methods

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    CGPoint touchPoint=[gesture locationInView:self.trackContainerScrollView];
    
    int currentPage = self.trackContainerScrollView.contentOffset.x / self.trackContainerScrollView.frame.size.width;
    
    if (touchPoint.x > self.trackContainerScrollView.contentOffset.x + self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentSize.width - self.trackContainerScrollView.frame.size.width/2) {
        
        self.pageIndex = currentPage + 1;
        [self scrollIndex:self.pageIndex];
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage + 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        [self.rewardsDetailTableView setContentOffset:CGPointMake(0, 0)];
        
    }
    else if(self.trackContainerScrollView.contentOffset.x >= self.trackContainerScrollView.frame.size.width && touchPoint.x < self.trackContainerScrollView.contentOffset.x)
    {
        
        self.pageIndex = currentPage - 1;
        [self scrollIndex:self.pageIndex];
        
        CGRect frame = self.trackContainerScrollView.frame;
        frame.origin.x = frame.size.width * (currentPage - 1);
        [self.trackContainerScrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
        [self.rewardsDetailTableView setContentOffset:CGPointMake(0, 0)];
    }
    
}




@end
