//
//  ZLMainGridViewController.m
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLMainGridViewController.h"
#import "ZLMainTileCell.h"
#import "ZLWagerViewController.h"
#import "ZLLeftSideMenuViewController.h"
#import "RevealController.h"
#import "ZLCurrentBetTypeViewController.h"
#import "ZLWalletViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLResultsViewController.h"
#import "ZLQRCodeViewController.h"
#import "SPQRCodeTypesViewController.h"
#import "ZLAppDelegate.h"
#import "SPLiveVideoViewController.h"
#import "SPAlertsViewController.h"
#import "LeveyHUD.h"
#import "SPRedeemViewController.h"
#import "SPSCRChangesDetailViewController.h"
#import "SPGetStartedViewController.h"
#import "WarHorseSingleton.h"


#define NO_OF_ROWS 2
#define NO_OF_COLOMS 2
#define NOPAGES 3


@interface ZLMainGridViewController () <UIAlertViewDelegate>
{
    
    NSOperationQueue *queue;
}
- (void)alertViewController;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;
@property (strong, nonatomic) NSString *allBetsString;
@property (strong, nonatomic) NSMutableArray *alertArray;
//@property (strong, nonatomic) NSString *alertCountStr;
@property (strong,nonatomic) NSMutableArray *postloginBannersArray;
@property (strong, nonatomic) IBOutlet UIImageView *staticBannerImgView;

@end

@implementation ZLMainGridViewController
@synthesize mainGridCollectionView=_mainGridCollectionView;
@synthesize numberArray=_numberArray;
@synthesize mainScrollView=_mainScrollView;
@synthesize mainTableView=_mainTableView;
@synthesize mainTableCustomCell=_mainTableCustomCell;
@synthesize tableArray=_tableArray;
@synthesize pageControl=_pageControl;
@synthesize imageScrollView=_imageScrollView;
@synthesize imagesArray=_imagesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadView:)
                                                     name:@"LoadView"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.mainScrollView setContentSize:CGSizeMake(320, 560)];
    _numberArray=[[NSMutableArray alloc]init];
    
    [self.mainGridCollectionView registerClass:[ZLMainTileCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    
    self.staticBannerImgView.image =[UIImage imageNamed:@"post_loginnew6.jpg"] ;
    
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.userPassword = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    
    //ZLAppDelegate * appDelegate = (ZLAppDelegate*)[UIApplication sharedApplication].delegate;
    //if( !appDelegate.balanceRefreshTimer )
    //  appDelegate.balanceRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 * 60 target:self selector:@selector(refreshBalance) userInfo:nil repeats:YES];
    [self getBannersService];
    
    [self loadData];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
    [self refreshBalance];
    [self getAllBetsForUser];
    //[self performSelector:@selector(paymentServiceCharge) withObject:nil afterDelay:1.0];
    [self paymentServiceCharge];
    //[self loadData];
    
    
    
    [super viewWillAppear:YES];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

- (void)getBannersService
{
    
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"queryParams":@{@"json_data_id":@"PostLoginBanners"}};
    //    [[LeveyHUD sharedHUD] appearWithText:@"Loading Banners..."];
    
    [apiWrapper preloginBanners:argumentsDic success:^(NSDictionary *_userInfo){
        
        if ([[_userInfo valueForKey:@"response-status"]isEqualToString:@"success"]){
            self.postloginBannersArray = [[[[_userInfo valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"Json_Data"] valueForKey:@"Banners"];
            //NSLog(@"postloginBannersArray %@",self.postloginBannersArray);
            
            for (int i = 0; i < [self.postloginBannersArray count] ; i++) {
                
                
                //get a dispatch queue
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //this will start the image loading in bg
                dispatch_async(concurrentQueue, ^{
                    
                    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.postloginBannersArray valueForKey:@"URL"] objectAtIndex:i]]];
                    
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
                    
                    //this will set the image when loading is finished
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [self.imageScrollView setContentSize:CGSizeMake([self.postloginBannersArray count] * self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height)];
                        [self.imageScrollView setPagingEnabled:YES];
                        [self.imageScrollView setShowsHorizontalScrollIndicator:NO];
                        [self.imageScrollView setDelegate:self];
                        self.staticBannerImgView.hidden = YES;
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.imageScrollView.frame.size.width, 0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height)];
                        imageView.image = [UIImage imageWithData:imageData];
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        [self.imageScrollView addSubview:imageView];
                        
                        
                        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.imageScrollView.frame.origin.y + self.imageScrollView.frame.size.height - 24, self.imageScrollView.frame.size.width, 36)];
                        
                        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
                        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:31.0/256 green:111.0/256 blue:137.0/256 alpha:1.0];
                        //                        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:31.0/256 green:111.0/256 blue:137.0/256 alpha:1.0];
                        self.pageControl.numberOfPages = self.postloginBannersArray.count;
                        self.pageControl.currentPage = 0;
                        [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
                        [self.pageView addSubview:self.pageControl];
                        
                        
                        
                    });
                });
                
                
                
            }
            
        }
        
    }failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error Code:%ld", (long)error.code] message:[NSString stringWithFormat:@"%@",error.localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }];
    
}


- (void)refreshBalance
{
    
    [[ZLAppDelegate getApiWrapper] refreshBalance:NO success:^(NSDictionary* _userInfo){
        
    }failure:^(NSError *error){
    }];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if ([self.imageTimer isValid]) {
        [self.imageTimer invalidate];
        self.imageTimer = nil;
    }
}

- (void) viewDidUnload
{
    // If you don't remove yourself as an observer, the Notification Center
    // will continue to try and send notification objects to the deallocated
    // object.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.mainScrollView=nil;
    self.mainGridCollectionView=nil;
    self.mainTableView=nil;
    self.pageView=nil;
    self.pageControl=nil;
    self.imageScrollView=nil;
    self.imagesArray=nil;
    self.numberArray=nil;
    self.mainTableCustomCell=nil;
    self.tableArray=nil;
    self.viewController=nil;
    
}

- (void)paymentServiceCharge
{
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper getPaymentServiceChargeInfo:nil success:^(NSDictionary *paymentDict){
        if ([[paymentDict valueForKey:@"response-status"] isEqualToString:@"success"]){
            
            [[WarHorseSingleton sharedInstance] setPaymentChargesDict:paymentDict];
            int achEnable =  [[[[paymentDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"achEnabled"] intValue];
            int creditCardEnable =  [[[[paymentDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardEnabled"] intValue];
            [[NSUserDefaults standardUserDefaults] setBool:achEnable forKey:@"achEnableKey"];
            [[NSUserDefaults standardUserDefaults] setBool:creditCardEnable forKey:@"cardEnabledKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"achEnableKey"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cardEnabledKey"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }failure:^(NSError *error){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"achEnableKey"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"cardEnabledKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
}

- (void)getAllBetsForUser
{
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    //    [ZLAppDelegate showLoadingView];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Dashboard..."];
    NSDictionary *userDetails = [NSDictionary dictionaryWithObjectsAndKeys:self.userName,@"user_id",self.userPassword,@"user_password", nil];
    
    
    [apiWrapper getAllBetsForUser:userDetails success:^(NSDictionary *allBetsDict) {
        [ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[allBetsDict valueForKey:@"response-status"] isEqualToString:@"success"]){
                self.allBetsString = [allBetsDict valueForKey:@"response-content"];
                [self.mainGridCollectionView reloadData];
            }else
            {
                [[LeveyHUD sharedHUD] disappear];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        });
        
    }failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"The server could not process your request at this time, please try later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        
    }];
    
    
}

- (void)loadView:(NSNotification *) notification
{
    [self.navigationController popToViewController:self animated:NO];
    NSNumber *viewNumber = [notification.userInfo objectForKey:@"viewNumber"];
    [self pushToView:[viewNumber integerValue]];
    viewNumber=nil;
}

- (void) pushToView:(DashBoard)viewNumber
{
    switch (viewNumber)
    {
        case DashBoardHome:
            
            break;
        case DashBoardWager:
            
            [self loadWagerView];
            
            break;
        case DashBoardAlerts:
            //[self alertViewController];
            break;
        case DashBoardMyBets:
            
            [self loadCurrentBetsView];
            
            break;
        case DashBoardWallet:
            [self loadWalletView];
            break;
        case DashBoardOddsBoard:
            
            break;
            
        case DashBoardQRCode:
            [self loadQRCodeScreen];
            break;
            
        case DashBoardVideoReplay:
            [self loadLiveVideoScreen];
            break;
            
        case DashBoardResults:
            [self loadResultsScreen];
            break;
        case DashBoardRedeem:
            [self loadRedeemScreen];
            break;
            
        case DashBoardScrChanges:
            [self loadScrChangesScreen];
            break;
        case DashBoardTutorial:
            [self loadTutorialsScreen];
            break;
        case DashBoardLogOut:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
            [alert show];
        }
            break;
            
            //        case DashBoardSettings:
            //            [self loadSettingsScreen];
            //            break;
            
        default:
            break;
    }
}

- (void)loadQRCodeScreen
{
    
    //ZLQRCodeViewController *qrCodeViewController=[[ZLQRCodeViewController alloc]init];
    SPQRCodeTypesViewController *qrCodeViewController=[[SPQRCodeTypesViewController alloc]initWithNibName:@"SPQRCodeTypesViewController" bundle:nil];
    
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:qrCodeViewController];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    [self.navigationController pushViewController:self.viewController animated:YES];
    
    qrCodeViewController=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
    
}
- (void)alertViewController
{
    /*
     SPAlertsViewController *alertsViewCntr = [[SPAlertsViewController alloc]initWithNibName:@"SPAlertsViewController" bundle:nil];
     
     ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:alertsViewCntr];
     RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
     self.viewController = revealController;
     [self.navigationController pushViewController:self.viewController animated:YES];
     
     alertsViewCntr=nil;
     wagerLeftViewController=nil;
     navigationController=nil;
     revealController=nil;
     */
    
}
- (void) loadWagerView
{
    
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
    [apiWrapper getFavorites:nil success:^(NSDictionary *_userInfo){
        [self wagerView];
        
    }failure:^(NSError *error){
        [self wagerView];
        
    }];
    
    
    
}
- (void)wagerView
{
    ZLWagerViewController *wagerViewController=[[ZLWagerViewController alloc]init];
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:wagerViewController];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    [self.navigationController pushViewController:self.viewController animated:YES];
}

- (void) loadCurrentBetsView
{
    
    
    
    ZLCurrentBetTypeViewController *objCurrentBets = [[ZLCurrentBetTypeViewController alloc] init];
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objCurrentBets];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    [self.navigationController pushViewController:self.viewController animated:YES];
    
    
    objCurrentBets=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
    
}

- (void)loadWalletView
{
    ZLWalletViewController *objWallet = [[ZLWalletViewController alloc] init];
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:objWallet];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    [self.navigationController pushViewController:self.viewController animated:YES];
    
    objWallet=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
    
}

- (void)loadResultsScreen
{
    ZLResultsViewController *resultView=[[ZLResultsViewController alloc]init];
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:resultView];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    [self.navigationController pushViewController:self.viewController animated:YES];
    
    resultView=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
}
- (void)loadRedeemScreen
{
    SPRedeemViewController *redeemViewCntr = [[SPRedeemViewController alloc]init];
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:redeemViewCntr];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    [self.navigationController pushViewController:self.viewController animated:YES];
    redeemViewCntr=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
}

- (void)loadScrChangesScreen
{
    
    
    SPSCRChangesDetailViewController *scrChangesViewCntr = [[SPSCRChangesDetailViewController alloc] initWithNibName:@"SPSCRChangesDetailViewController" bundle:nil];
    
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:scrChangesViewCntr];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    scrChangesViewCntr.isPostLoginFlag = YES;
    
    [self.navigationController pushViewController:self.viewController animated:YES];
    
    scrChangesViewCntr=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
    
}
- (void)loadTutorialsScreen
{
    
    SPGetStartedViewController *tutorialViewCntr = [[SPGetStartedViewController alloc] initWithNibName:@"SPGetStartedViewController" bundle:nil];
    
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tutorialViewCntr];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    tutorialViewCntr.isPostLoginTutorialFlag = YES;
    
    [self.navigationController pushViewController:self.viewController animated:YES];
    tutorialViewCntr=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
    
}


- (void)loadLiveVideoScreen
{
    SPLiveVideoViewController *liveVideo=[[SPLiveVideoViewController alloc]init];
    ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:liveVideo];
    RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
    self.viewController = revealController;
    [self.navigationController pushViewController:self.viewController animated:YES];
    
    liveVideo=nil;
    wagerLeftViewController=nil;
    navigationController=nil;
    revealController=nil;
}



/*
 - (void)loadSettingsScreen
 {
 SPSettingsViewController *settings=[[SPSettingsViewController alloc]init];
 ZLLeftSideMenuViewController *wagerLeftViewController=[[ZLLeftSideMenuViewController alloc]init];
 UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settings];
 RevealController *revealController = [[RevealController alloc] initWithFrontViewController:navigationController rearViewController:wagerLeftViewController];
 self.viewController = revealController;
 [self.navigationController pushViewController:self.viewController animated:YES];
 
 settings=nil;
 wagerLeftViewController=nil;
 navigationController=nil;
 revealController=nil;
 }
 */


- (void)loadData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"Wager" forKey:@"title"];
    [dic setValue:@"1.png" forKey:@"icon"];
    //[dic setObject:nil forKey:@"badgeNumber"];
    [dic setObject:[UIColor colorWithRed:11.0/255 green:144.0/255 blue:11.0/255 alpha:1.0] forKey:@"backgroundColor"];
    [self.numberArray addObject:dic];
    
    
    
    if ([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"true"]){
        if ([[WarHorseSingleton sharedInstance] isQRCodeEnable]==YES){
            NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
            [dic1 setValue:@"Digital Link" forKey:@"title"];
            [dic1 setValue:@"digitallink.png" forKey:@"icon"];
            [dic1 setValue:@"4" forKey:@"badgeNumber"];
            [dic1 setObject:[UIColor colorWithRed:211.0/255 green:0.0/255 blue:0.0/255 alpha:1.0] forKey:@"backgroundColor"];
            [self.numberArray addObject:dic1];
        }
        
    }
    
    
    
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"My Bets" forKey:@"title"];
    [dic2 setValue:@"3.png" forKey:@"icon"];
    [dic2 setValue:@"4" forKey:@"badgeNumber"];
    [dic2 setObject:[UIColor colorWithRed:255.0/255 green:66.0/255 blue:0.0/255 alpha:1.0] forKey:@"backgroundColor"];
    [self.numberArray addObject:dic2];
    
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        [dic3 setValue:@"Digital Voucher" forKey:@"title"];
    }else{
        [dic3 setValue:@"Wallet" forKey:@"title"];
    }
    
    [dic3 setValue:@"4.png" forKey:@"icon"];
    [dic3 setValue:@"Balance: " forKey:@"badgeNumber"];
    [dic3 setObject:[UIColor colorWithRed:13.0/255 green:118.0/255 blue:191.0/255 alpha:1.0] forKey:@"backgroundColor"];
    [self.numberArray addObject:dic3];
    
    
    _tableArray=[[NSMutableArray alloc]init];
    
    if([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES){
        NSMutableDictionary *tabledic3 = [NSMutableDictionary dictionary];
        [tabledic3 setValue:@"Live Videos/Replays" forKey:@"title"];
        [tabledic3 setValue:@"video.png" forKey:@"iconImages"];
        [self.tableArray addObject:tabledic3];
    }
    
    
    NSMutableDictionary *tabledic4 = [NSMutableDictionary dictionary];
    [tabledic4 setValue:@"Results/Payoffs" forKey:@"title"];
    [tabledic4 setValue:@"win.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic4];
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        if([[WarHorseSingleton sharedInstance] isRewordsEnable] == YES){
            NSMutableDictionary *tabledic5 = [NSMutableDictionary dictionary];
            [tabledic5 setValue:@"Redeem Rewards" forKey:@"title"];
            [tabledic5 setValue:@"rewards_dashboard.png" forKey:@"iconImages"];
            [self.tableArray addObject:tabledic5];
        }
        
        
    }
    
    
    
    NSMutableDictionary *tabledic7 = [NSMutableDictionary dictionary];
    [tabledic7 setValue:@"Non Runners" forKey:@"title"];
    [tabledic7 setValue:@"scr&changesPost.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic7];
    
    NSMutableDictionary *tabledic8 = [NSMutableDictionary dictionary];
    [tabledic8 setValue:@"Tutorial" forKey:@"title"];
    [tabledic8 setValue:@"getstarted.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic8];
    
    NSMutableDictionary *tabledic6 = [NSMutableDictionary dictionary];
    [tabledic6 setValue:@"Logout" forKey:@"title"];
    [tabledic6 setValue:@"logout_dasboard.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic6];
    
}

-(void)balanceUpdated:(NSNotification *)notification{
    
    [self.mainGridCollectionView reloadData];
}



- (void) timerMethod:(NSTimer *)timer
{
    int whichPage = (int)self.pageControl.currentPage;
    
    whichPage ++;
    if (whichPage >= self.pageControl.numberOfPages) {
        whichPage = 0;
    }
    self.pageControl.currentPage = whichPage;
    [self.imageScrollView setContentOffset:CGPointMake(whichPage * self.imageScrollView.frame.size.width, 0)];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.imageScrollView)
    {
        CGPoint point = scrollView.contentOffset;
        self.pageControl.currentPage = point.x/scrollView.frame.size.width;
    }
}


-(void)pageTurn:(UIPageControl *)aPageControl{
    int WhichPage = (int)aPageControl.currentPage;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [self.imageScrollView setContentOffset:CGPointMake(WhichPage *self.imageScrollView.frame.size.width, 0)];
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark UICollectionViewDelegate Methods
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [self.numberArray count];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if ([[WarHorseSingleton sharedInstance] isQRCodeEnable] == NO){
        if (indexPath.row == 0)
        {
            return CGSizeMake(300, 98);
        }
        
    }
    return CGSizeMake(145, 98);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZLMainTileCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    if ([self.numberArray count]>0) {
        NSMutableDictionary *dic = [self.numberArray objectAtIndex:indexPath.row];
        cell.iconImageView.image=[UIImage imageNamed:[dic valueForKey:@"icon"]];
        cell.backgroundColor = [dic objectForKey:@"backgroundColor"];
        cell.titleLabel.text = [dic valueForKey:@"title"];
        NSString *badgeNumber = [dic valueForKey:@"badgeNumber"];
        
        if (badgeNumber)
        {
            [cell.badgeButton setTitle:badgeNumber forState:UIControlStateNormal];
        }
        else
        {
            cell.badgeButton.hidden = YES;
        }
        if ([cell.titleLabel.text isEqualToString:@"Digital Link"]||[cell.titleLabel.text isEqualToString:@"Live Videos"])
        {
            
            cell.badgeButton.hidden = YES;
        }
        cell.badgeButton.userInteractionEnabled = NO;
        if ([cell.titleLabel.text isEqualToString:@"My Bets"])
        {
            if (self.allBetsString == nil)
            {
                
                [cell.badgeButton setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
            }else{
                cell.badgeButton.frame = CGRectMake(110, 0, 35, 25);
                
                [cell.badgeButton setTitle:[NSString stringWithFormat:@"%@",self.allBetsString] forState:UIControlStateNormal];
            }
            
            
            cell.badgeButton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
            
            cell.badgeButton.hidden = NO;
            
        }
        
        if ([cell.titleLabel.text isEqualToString:@"Wallet"])
        {
            cell.badgeButton.hidden = NO;
            cell.badgeButton.frame = CGRectMake(0, 0, cell.frame.size.width, 19);
            [cell.badgeButton setTitle:[NSString stringWithFormat:@"Balance: %@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel], [ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateNormal];
        }
        if ([cell.titleLabel.text isEqualToString:@"Digital Voucher"])
        {
            cell.badgeButton.hidden = NO;
            cell.badgeButton.frame = CGRectMake(0, 0, cell.frame.size.width, 19);
            [cell.badgeButton setTitle:[NSString stringWithFormat:@"Balance: %@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel] ,[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateNormal];
        }
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    // ZLMainTileCell *cell = (ZLMainTileCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if ([[WarHorseSingleton sharedInstance] isQRCodeEnable]==YES){
        
        if (indexPath.row == 0) {
            [self pushToView:DashBoardWager];
        }
        else if (indexPath.row == 1)
        {
            
            [self pushToView:DashBoardQRCode];
            
            
        }
        else if(indexPath.row == 2)
        {
            [self pushToView:DashBoardMyBets];
        }
        else if (indexPath.row == 3)
        {
            [self pushToView:DashBoardWallet];
        }
        else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Under Progress" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }
        
    }else{
        if (indexPath.row == 0) {
            [self pushToView:DashBoardWager];
        }
        
        else if(indexPath.row == 1)
        {
            [self pushToView:DashBoardMyBets];
        }
        else if (indexPath.row == 2)
        {
            [self pushToView:DashBoardWallet];
        }
        else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title" message:@"Under Progress" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }
    }
    
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
    
    // Return the number of rows in the section.
    
    return [self.tableArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    self.mainTableCustomCell  = (ZLMainTableCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.mainTableCustomCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ZLMainTableCustomCell" owner:self options:nil];
        
    }
    
    NSMutableDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    
    [self.mainTableCustomCell.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.mainTableCustomCell.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0f/255.0f alpha:1.0]];
    if ([[dic valueForKey:@"title"] isEqualToString:@"Logout"]){
        self.mainTableCustomCell.detailDisclosureImageView.hidden = YES;
    }else{
        self.mainTableCustomCell.detailDisclosureImageView.hidden = NO;
        
    }
    self.mainTableCustomCell.titleLabel.text=[dic valueForKey:@"title"];
    self.mainTableCustomCell.iconImages.image=[UIImage imageNamed:[dic valueForKey:@"iconImages"]];
    self.mainTableCustomCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return self.mainTableCustomCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 41;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSMutableDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    NSLog(@"dic %@",dic);
    NSString *typeOfScreen = [dic valueForKey:@"title"];
    //,,Non Runners,Tutorial,Logout

    if ([typeOfScreen isEqualToString:@"Live Videos/Replays"]){
        [self pushToView:DashBoardVideoReplay];

    }else if ([typeOfScreen isEqualToString:@"Results/Payoffs"]){
        [self pushToView:DashBoardResults];

    }else if ([typeOfScreen isEqualToString:@"Redeem Rewards"]){
        [self pushToView:DashBoardRedeem];

        
    }else if ([typeOfScreen isEqualToString:@"Non Runners"]){
        [self pushToView:DashBoardScrChanges];

        
    }else if ([typeOfScreen isEqualToString:@"Tutorial"]){
        [self pushToView:DashBoardTutorial];

        
    }else if ([typeOfScreen isEqualToString:@"Logout"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [alert show];
    }
    /*
    
    if ([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"true"]){
        if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
            // Rewords IS Enable add reword screen
            if (indexPath.row == 0)
            {
                [self videoEnable:indexPath];
                //[self pushToView:DashBoardVideoReplay];
            }
            else if (indexPath.row == 1)
            {
                [self pushToView:DashBoardResults];
            }
            else if (indexPath.row == 2)
            {
                
                [self pushToView:DashBoardRedeem];
                
            }
            else if (indexPath.row == 3)
            {
                [self pushToView:DashBoardScrChanges];
                
            }
            else if (indexPath.row == 4)
            {
                [self pushToView:DashBoardTutorial];
                
            }
            else if (indexPath.row == 5)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [alert show];
            }
            
            else {
                if (indexPath.row == 0)
                {
                    [self pushToView:DashBoardVideoReplay];
                }
                else if (indexPath.row == 1)
                {
                    [self pushToView:DashBoardResults];
                }
                else if (indexPath.row == 2)
                {
                    
                    
                    [self pushToView:DashBoardRedeem];
                    
                }
                else if (indexPath.row == 3)
                {
                    [self pushToView:DashBoardScrChanges];
                    
                }
                else if (indexPath.row == 4)
                {
                    [self pushToView:DashBoardTutorial];
                    
                }
                else if (indexPath.row == 5)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                    [alert show];
                }
            }
            
            
            
            
        }else{
            if (indexPath.row == 0)
            {
                [self pushToView:DashBoardVideoReplay];
            }
            else if (indexPath.row == 1)
            {
                [self pushToView:DashBoardResults];
            }
            
            else if (indexPath.row == 2)
            {
                [self pushToView:DashBoardScrChanges];
                
            }
            else if (indexPath.row == 3)
            {
                [self pushToView:DashBoardTutorial];
                
            }
            else if (indexPath.row == 4)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [alert show];
            }
            
        }
        
        
    }else{
        //ODP Disable Live Video Option Removed
        if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
            if (indexPath.row == 0)
            {
                [self pushToView:DashBoardResults];
                
            }
            else if (indexPath.row == 1)
            {
                [self pushToView:DashBoardRedeem];
                
            }
            else if (indexPath.row == 2)
            {
                [self pushToView:DashBoardScrChanges];
                
                
            }
            else if (indexPath.row == 3)
            {
                [self pushToView:DashBoardTutorial];
                
            }
            else if (indexPath.row == 4)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [alert show];
            }
            
            
            
        }else{
            if (indexPath.row == 0)
            {
                [self pushToView:DashBoardResults];
            }
            else if (indexPath.row == 1)
            {
                [self pushToView:DashBoardScrChanges];
                
            }
            
            else if (indexPath.row == 2)
            {
                [self pushToView:DashBoardTutorial];
                
            }
            else if (indexPath.row == 3)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
                [alert show];
                
            }
            
            
        }
        
        
        
        
        
    }
    */
    
}

- (void)videoEnable:(NSIndexPath*)path
{
    if ([[WarHorseSingleton sharedInstance] isVideoSteamingEnable] == YES){
        [self pushToView:DashBoardVideoReplay];

    }else{
       // []
    }
    //[self pushToView:DashBoardVideoReplay];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        [ZLAppDelegate getAppData].balanceAmount = 0.00;
        //        [[ZLAppDelegate getAppData].dictFavorites removeAllObjects];
        
        [[LeveyHUD sharedHUD] appearWithText:@"Logging out..."];
        ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
        
        [apiWrapper logoutUserWithParameters:nil success:^(NSDictionary *_userInfo) {
            [[LeveyHUD sharedHUD] disappear];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            [[LeveyHUD sharedHUD] disappear];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }];
        
    }
}

@end
