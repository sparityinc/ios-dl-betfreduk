//
//  ZLMainScreenViewController.m
//  WarHorse
//
//  Created by Sparity on 7/19/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLMainScreenViewController.h"
#import "ZLLoginViewController.h"
#import "ZLRegistrationViewController.h"
#import "SPPromotionViewController.h"
#import "SPCarryOversViewController.h"
#import "SPFeatureRacesViewController.h"
#import "SPWeeklyScheduleViewController.h"
#import "SPTodaysTracksViewController.h"
#import "SPRewardsDetailViewController.h"
#import "SPDetailSelectionViewController.h"
#import "SPSCRChangesDetailViewController.h"
#import "SPAboutWarhorseViewController.h"
#import "SPTermsAndConditionsViewController.h"
#import "SPGetStartedViewController.h"
#import "SPHelpAndSupportViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LeveyHUD.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "ZLMainGridViewController.h"
#import "ZLAdwRegistrationViewController.h"
#import "ZLPreLoginAPIWrapper.h"
#import "AsyncImageDownloader.h"
#import "ZLAnonymousUserRegistrationViewController.h"
#import "WarHorseSingleton.h"



@interface ZLMainScreenViewController () <CLLocationManagerDelegate>
{
    NSOperationQueue *queue;
}
@property (nonatomic, strong) IBOutlet UILabel * lblVersion;
@property (nonatomic, strong) IBOutlet UIImageView * logoImageView;
@property (nonatomic, strong) IBOutlet UIImageView * navigationBarImageView;
@property (nonatomic, strong) IBOutlet UIImageView * digitalLinkLogoImageView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong,nonatomic) NSMutableArray *preloginBannersArray;
@property (nonatomic,assign) BOOL isFirstTimeAppLoading;
@property (nonatomic,strong) NSString *geoFencingStr;
@property (nonatomic,strong) NSString *geoFencingErrorStr;

@property (nonatomic,strong) IBOutlet UIImageView *staticLineImg;


@property (nonatomic,assign) BOOL isPromotionsEnable;
@property (nonatomic,assign) BOOL isFetureRacesEnable;

@property (nonatomic,assign) BOOL isRewordAvailable;


- (IBAction)trunonNotifcations:(id)sender;

@end

@implementation ZLMainScreenViewController
@synthesize menuTableView = _menuTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View LifeCycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden=YES;
    
    self.isPromotionsEnable = YES;
    self.isFetureRacesEnable = YES;
    
    self.isFirstTimeAppLoading = YES;
    
    self.preloginBannersArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.tableArray = [[NSMutableArray alloc]init];
    self.collectionArray = [[NSMutableArray alloc] init];

    
    self.staticBannerImgView.image =[UIImage imageNamed:@"BanerNew1.jpg"];
    
    [self getBannersService];
    
    [self.view sendSubviewToBack:self.mainScrollView];
    [self.mainScrollView setContentSize:CGSizeMake(320, 480)];
    
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [self.collectionView registerClass:[ZLMainScreenCollectionCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    [self loadData];
    
    [_menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //[[NSUserDefaults standardUserDefaults] setValue:@"17.4533333" forKey:@"Latitude"];
    //[[NSUserDefaults standardUserDefaults] setValue:@"78.4624999" forKey:@"Longitude"];
    //[[NSUserDefaults standardUserDefaults] synchronize];

    
    //Location Manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    //self.locationManager.pausesLocationUpdatesAutomatically = NO;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }

    
    [self.locationManager startUpdatingLocation];
    
    
    float ver = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *iosVesion = [NSString stringWithFormat:@"iOS %0.1f",ver];
    [[WarHorseSingleton sharedInstance]setIosVersionNo:iosVesion];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_UK"];
    NSString *currencyCode = @"GBP";
    NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
    
    
    [[WarHorseSingleton sharedInstance] setCurrencySymbel:currencySymbol];
    //[[NSUserDefaults standardUserDefaults] setValue:@"17.4533333" forKey:@"Latitude"];
    //[[NSUserDefaults standardUserDefaults] setValue:@"78.4624999" forKey:@"Longitude"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    [self appConfigCMSService];

    
}
- (NSString *)findCurrencySymbolByCode:(NSString *)_currencyCode
{
    NSNumberFormatter *fmtr = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [self findLocaleByCurrencyCode:_currencyCode];
    NSString *currencySymbol;
    if (locale)
        [fmtr setLocale:locale];
    [fmtr setNumberStyle:NSNumberFormatterCurrencyStyle];
    currencySymbol = [fmtr currencySymbol];
    
    if (currencySymbol.length > 1)
        currencySymbol = [currencySymbol substringToIndex:1];
    return currencySymbol;
}

- (NSLocale *) findLocaleByCurrencyCode:(NSString *)_currencyCode
{
    NSArray *locales = [NSLocale availableLocaleIdentifiers];
    NSLocale *locale = nil;
    
    for (NSString *localeId in locales) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:localeId];
        NSString *code = [locale objectForKey:NSLocaleCurrencyCode];
        if ([code isEqualToString:_currencyCode])
            break;
        else
            locale = nil;
        
    }
    
    return locale;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    if ([self.imageTimer isValid]) {
        [self.imageTimer invalidate];
        self.imageTimer = nil;
    }
}
-(void)viewDidUnload{
    self.accountButton=nil;
    self.loginButton=nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private API

- (void)timerMethod:(NSTimer *)timer
{
    int whichPage = (int)self.pageControl.currentPage;
    
    whichPage ++;
    if (whichPage >= self.pageControl.numberOfPages) {
        whichPage = 0;
    }
    self.pageControl.currentPage = whichPage;
    [self.imageScrollView setContentOffset:CGPointMake(whichPage * self.imageScrollView.frame.size.width, 0)];
}

- (void)loadData
{
    
   
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"Today's Courses" forKey:@"title"];
    [dic setValue:@"schdeules.png" forKey:@"icon"];
    [dic setObject:[UIColor colorWithRed:11.0/255 green:144.0/255 blue:11.0/255 alpha:1.0] forKey:@"backgroundColor"];
    [self.collectionArray addObject:dic];
    
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:@"Non Runners" forKey:@"title"];
    [dic1 setValue:@"scr&changes.png" forKey:@"icon"];
    [dic1 setObject:[UIColor colorWithRed:211.0/255 green:0.0/255 blue:0.0/255 alpha:1.0] forKey:@"backgroundColor"];
    
    [self.collectionArray addObject:dic1];
    
    if (self.isPromotionsEnable == YES){
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
        [dic3 setValue:@"Promotions" forKey:@"title"];
        [dic3 setValue:@"promotions.png" forKey:@"icon"];
        [dic3 setObject:[UIColor colorWithRed:255.0/255 green:66.0/255 blue:0.0/255 alpha:1.0] forKey:@"backgroundColor"];
        [self.collectionArray addObject:dic3];
    }
    if (self.isFetureRacesEnable == YES){
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
        [dic5 setValue:@"Feature Races" forKey:@"title"];//Get Started
        [dic5 setValue:@"featureraces.png" forKey:@"icon"];//getstarted.png
        [dic5 setObject:[UIColor colorWithRed:13.0/255 green:118.0/255 blue:191.0/255 alpha:1.0] forKey:@"backgroundColor"];
        [self.collectionArray addObject:dic5];
    }
    if (self.isPromotionsEnable == NO&& self.isFetureRacesEnable == NO){
        self.staticLineImg.frame = CGRectMake(self.staticLineImg.frame.origin.x,self.staticLineImg.frame.origin.y-40, self.staticLineImg.frame.size.width, self.staticLineImg.frame.size.height);
        
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x,self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height-40);
        
        self.menuTableView.frame = CGRectMake(self.menuTableView.frame.origin.x,self.collectionView.frame.origin.y+47, self.menuTableView.frame.size.width, self.menuTableView.frame.size.height);
        
        
    }
    if (self.isRewordAvailable == YES){
        NSMutableDictionary *tabledic1 = [NSMutableDictionary dictionary];
        [tabledic1 setValue:@"Rewards Structure" forKey:@"title"];
        [tabledic1 setValue:@"rewardstructure.png" forKey:@"iconImages"];
        [self.tableArray addObject:tabledic1];
    }
    
    
    
    NSMutableDictionary *tabledic2 = [NSMutableDictionary dictionary];
    [tabledic2 setValue:@"Help/Support" forKey:@"title"];//Selections
    [tabledic2 setValue:@"help&support.png" forKey:@"iconImages"];//selections.png
    [self.tableArray addObject:tabledic2];
    
    NSMutableDictionary *tabledic3 = [NSMutableDictionary dictionary];
    [tabledic3 setValue:@"Tutorial" forKey:@"title"];//Feature Races
    [tabledic3 setValue:@"getstarted.png" forKey:@"iconImages"];//featureraces.png
    [self.tableArray addObject:tabledic3];
    
    NSMutableDictionary *tabledic4 = [NSMutableDictionary dictionary];
    [tabledic4 setValue:@"About Totepool" forKey:@"title"];
    [tabledic4 setValue:@"aboutdigitallink.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic4];
    
    NSMutableDictionary *tabledic5 = [NSMutableDictionary dictionary];
    [tabledic5 setValue:@"Terms & Conditions" forKey:@"title"];
    [tabledic5 setValue:@"terms&conditions.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic5];
 
    
    
    
    
}
- (void)collectionData
{
    [self.collectionArray removeAllObjects];
    [self.tableArray removeAllObjects];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"Today's Courses" forKey:@"title"];
    [dic setValue:@"schdeules.png" forKey:@"icon"];
    [dic setObject:[UIColor colorWithRed:11.0/255 green:144.0/255 blue:11.0/255 alpha:1.0] forKey:@"backgroundColor"];
    [self.collectionArray addObject:dic];
    
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:@"Non Runners" forKey:@"title"];
    [dic1 setValue:@"scr&changes.png" forKey:@"icon"];
    [dic1 setObject:[UIColor colorWithRed:211.0/255 green:0.0/255 blue:0.0/255 alpha:1.0] forKey:@"backgroundColor"];
    
    [self.collectionArray addObject:dic1];
    
    if (self.isPromotionsEnable == YES){
        NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
        [dic3 setValue:@"Promotions" forKey:@"title"];
        [dic3 setValue:@"promotions.png" forKey:@"icon"];
        [dic3 setObject:[UIColor colorWithRed:255.0/255 green:66.0/255 blue:0.0/255 alpha:1.0] forKey:@"backgroundColor"];
        [self.collectionArray addObject:dic3];
    }
    if (self.isFetureRacesEnable == YES){
        NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
        [dic5 setValue:@"Feature Races" forKey:@"title"];//Get Started
        [dic5 setValue:@"featureraces.png" forKey:@"icon"];//getstarted.png
        [dic5 setObject:[UIColor colorWithRed:13.0/255 green:118.0/255 blue:191.0/255 alpha:1.0] forKey:@"backgroundColor"];
        [self.collectionArray addObject:dic5];
    }
    if (self.isPromotionsEnable == NO&& self.isFetureRacesEnable == NO){
        self.staticLineImg.frame = CGRectMake(self.staticLineImg.frame.origin.x,self.staticLineImg.frame.origin.y-20, self.staticLineImg.frame.size.width, self.staticLineImg.frame.size.height);
        
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x,self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height-20);
        
        self.menuTableView.frame = CGRectMake(self.menuTableView.frame.origin.x,self.collectionView.frame.origin.y+47, self.menuTableView.frame.size.width, self.menuTableView.frame.size.height);


    }
    if (self.isRewordAvailable == YES){
        NSMutableDictionary *tabledic1 = [NSMutableDictionary dictionary];
        [tabledic1 setValue:@"Rewards Structure" forKey:@"title"];
        [tabledic1 setValue:@"rewardstructure.png" forKey:@"iconImages"];
        [self.tableArray addObject:tabledic1];
    }
    
    
    
    NSMutableDictionary *tabledic2 = [NSMutableDictionary dictionary];
    [tabledic2 setValue:@"Help/Support" forKey:@"title"];//Selections
    [tabledic2 setValue:@"help&support.png" forKey:@"iconImages"];//selections.png
    [self.tableArray addObject:tabledic2];
    
    NSMutableDictionary *tabledic3 = [NSMutableDictionary dictionary];
    [tabledic3 setValue:@"Tutorial" forKey:@"title"];//Feature Races
    [tabledic3 setValue:@"getstarted.png" forKey:@"iconImages"];//featureraces.png
    [self.tableArray addObject:tabledic3];
    
    NSMutableDictionary *tabledic4 = [NSMutableDictionary dictionary];
    [tabledic4 setValue:@"About Totepool" forKey:@"title"];
    [tabledic4 setValue:@"aboutdigitallink.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic4];
    
    NSMutableDictionary *tabledic5 = [NSMutableDictionary dictionary];
    [tabledic5 setValue:@"Terms & Conditions" forKey:@"title"];
    [tabledic5 setValue:@"terms&conditions.png" forKey:@"iconImages"];
    [self.tableArray addObject:tabledic5];
   
    [self.collectionView reloadData];
    [self.menuTableView reloadData];

    
    
    
   

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.imageScrollView)
    {
        CGPoint point = scrollView.contentOffset;
        self.pageControl.currentPage = point.x/scrollView.frame.size.width;
    }
}
- (IBAction)trunonNotifcations:(id)sender;
{
    NSString *isNotifcationOn = [[WarHorseSingleton sharedInstance] notificationTrunOnStr];
    NSString *alertMes;
    NSString *notification;

    NSString *devicetoken;
    
    
    
    if ([isNotifcationOn isEqualToString:@"YES"]){
                
        notification = @"PUSH NOTIFICATION:ON";
        devicetoken = [NSString stringWithFormat:@"DEVICE ID: %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"decvice_token"]];
        alertMes = [NSString stringWithFormat:@"%@\n%@",notification,devicetoken];
    }else{
        notification = @"PUSH NOTIFICATION:OFF";
        devicetoken = [NSString stringWithFormat:@"DEVICE ID:"];
        alertMes = [NSString stringWithFormat:@"%@\n%@",notification,devicetoken];
        
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:alertMes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}


#pragma mark - Public API -

- (void)getBannersService
{
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [self loginBtnDisble];
        
        return;
    }
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    
    NSDictionary *argumentsDic = @{@"queryName":@"framework_json_data",
                                   @"queryParams":@{@"json_data_id":@"PreLoginBanners"}};
    
    [apiWrapper preloginBanners:argumentsDic success:^(NSDictionary *_userInfo){
        if ([[_userInfo valueForKey:@"response-status"]isEqualToString:@"success"]){
            self.preloginBannersArray = [[[[_userInfo valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"Json_Data"] valueForKey:@"Banners"];
            
            for (int i = 0; i < [self.preloginBannersArray count] ; i++) {
                
                //get a dispatch queue
                dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //this will start the image loading in bg
                dispatch_async(concurrentQueue, ^{
                    //NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImagesBaseUrl,[[self.preloginBannersArray valueForKey:@"Image"] objectAtIndex:i]]];
                    
                    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[self.preloginBannersArray valueForKey:@"URL"] objectAtIndex:i]]];
                    
                    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
                    
                    //this will set the image when loading is finished
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.imageScrollView setContentSize:CGSizeMake([self.preloginBannersArray count] * self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height)];
                        [self.imageScrollView setPagingEnabled:YES];
                        [self.imageScrollView setShowsHorizontalScrollIndicator:NO];
                        [self.imageScrollView setDelegate:self];
                        [self.pageControl setNumberOfPages:[self.preloginBannersArray count]];
                        [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
                        self.staticBannerImgView.hidden = YES;
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.imageScrollView.frame.size.width, 0, self.imageScrollView.frame.size.width, self.imageScrollView.frame.size.height)];
                        imageView.image = [UIImage imageWithData:imageData];
                        imageView.contentMode = UIViewContentModeScaleToFill;
                        [self.imageScrollView addSubview:imageView];
                        
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

- (void)appConfigCMSService
{
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        [self loginBtnDisble];
        
        return;
    }
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"AppConfig Loading..."];
    [apiWrapper getAppConfigurationForClientID:nil success:^(NSDictionary *appDetails){
        NSLog(@"appDetails %@",appDetails);
        NSString *succesMesStr = [appDetails valueForKey:@"response-status"];
        if ([succesMesStr isEqualToString:@"success"]){
            [[LeveyHUD sharedHUD] disappear];
            self.isFirstTimeAppLoading = NO;
            
            
            self.isPromotionsEnable = [[[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_promotions"] boolValue];
            self.isFetureRacesEnable = [[[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_featureRaces"] boolValue];
            
            self.isRewordAvailable = [[[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_rewards"] boolValue];
            [self collectionData];
            
            NSString *currency_symbol = [[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_country_code"];
            
            [[WarHorseSingleton sharedInstance] setLocalCountry:currency_symbol];
            
            //currency symbol
            
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:currency_symbol];
            NSString *currencyCode = [[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_currency_code"];
            NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
            [[WarHorseSingleton sharedInstance] setCurrencySymbel:currencySymbol];
            
            
            /*
            NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:@"50.00"];
            NSNumberFormatter *currencyFormat = [[NSNumberFormatter alloc] init];
            
            NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:currency_symbol];
            
            
            [currencyFormat setNumberStyle:NSNumberFormatterCurrencyStyle];
            [currencyFormat setLocale:usLocale];
            NSLog(@"Amount with symbol: %@", [currencyFormat stringFromNumber:amount]);//Eg: $50.00
            NSLog(@"Current Locale : %@", [usLocale localeIdentifier]);//Eg: en_US
*/

            //WithDrwal,QRCODE,Rewords,Video keys params from backend.
            [[WarHorseSingleton sharedInstance] setIsRewordsEnable:self.isRewordAvailable];
            
            [[WarHorseSingleton sharedInstance] setIsVideoSteamingEnable:[[[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_videoStreaming"] boolValue]];
            [[WarHorseSingleton sharedInstance] setIsWithDrawEnable:[[[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_withdrawal"] boolValue]];
            [[WarHorseSingleton sharedInstance] setIsQRCodeEnable:[[[[[appDetails valueForKey:@"response-content"] objectAtIndex:0]valueForKey:@"AppFeatureConfig"] valueForKey:@"dl_config_QRCode"] boolValue]];
            
        
            
            NSArray *geoFencingArray = [[[appDetails valueForKey:@"response-content"] valueForKey:@"Configuration_Text"] valueForKey:@"GlobalGeofence"];
            self.geoFencingStr = [[geoFencingArray objectAtIndex:0] valueForKey:@"onLocation"];
            self.geoFencingErrorStr = [[geoFencingArray objectAtIndex:0]valueForKey:@"geofenceErrorMessage"];

            

            NSArray *AdwArray = [[[appDetails valueForKey:@"response-content"] valueForKey:@"Configuration_Text"] valueForKey:@"ADW"];
            NSArray *ontArray = [[[appDetails valueForKey:@"response-content"] valueForKey:@"Configuration_Text"] valueForKey:@"ODP"];
            NSArray *dvArray = [[[appDetails valueForKey:@"response-content"] valueForKey:@"Configuration_Text"] valueForKey:@"DV"];
            
            [[WarHorseSingleton sharedInstance] setIsAdwEnable:[[AdwArray objectAtIndex:0] valueForKey:@"enabled"]];
            [[WarHorseSingleton sharedInstance] setIsOntEnable:[[ontArray objectAtIndex:0] valueForKey:@"enabled"]];
            [[WarHorseSingleton sharedInstance] setIsCplEnable:[[dvArray objectAtIndex:0] valueForKey:@"enabled"]];
            
            if ([[[WarHorseSingleton sharedInstance] isAdwEnable] isEqualToString:@"true"]){
                //userType
                [[WarHorseSingleton sharedInstance] setIsAdwFundingEnable:[[AdwArray objectAtIndex:0] valueForKey:@"funding"]];
                [[WarHorseSingleton sharedInstance] setIsAdwSupervisorEnable:[[AdwArray objectAtIndex:0] valueForKey:@"supervisor"]];
                [[WarHorseSingleton sharedInstance] setLoginADWRequiredfieldsDic:[[AdwArray objectAtIndex:0] valueForKey:@"requiredfields"]];

            }
            if ([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"true"]){
                [[WarHorseSingleton sharedInstance] setIsOntFundingEnable:[[ontArray objectAtIndex:0] valueForKey:@"funding"]];
                [[WarHorseSingleton sharedInstance] setIsOntSupervisorEnable:[[ontArray objectAtIndex:0] valueForKey:@"supervisor"]];
                [[WarHorseSingleton sharedInstance] setIsOdpPlayerIdEnable:[[ontArray objectAtIndex:0] valueForKey:@"playerid"]];
                [[WarHorseSingleton sharedInstance] setLoginODPRequiredfieldsDic:[[ontArray objectAtIndex:0] valueForKey:@"requiredfields"]];

                
            }
            if ([[[WarHorseSingleton sharedInstance] isCplEnable] isEqualToString:@"true"]){
                [[WarHorseSingleton sharedInstance] setIsCplFundingEnable:[[dvArray objectAtIndex:0] valueForKey:@"funding"]];
                [[WarHorseSingleton sharedInstance] setIsCplSupervisorEnable:[[dvArray objectAtIndex:0] valueForKey:@"supervisor"]];
                [[WarHorseSingleton sharedInstance] setLoginDVRequiredfieldsDic:[[dvArray objectAtIndex:0] valueForKey:@"requiredfields"]];

                
            }
            [self loginBtnAndSignUpBtnDisable];
            if ([self.geoFencingStr isEqualToString:@"false"]){
                [self alertViewMethod];
            }
            
            
        }else{

            
            self.loginButton.enabled = NO;
            self.loginButton.userInteractionEnabled = NO;
            self.accountButton.enabled = NO;
            self.accountButton.userInteractionEnabled = NO;

        }
        
    }failure:^(NSError *error){
        self.loginButton.enabled = NO;
        self.loginButton.userInteractionEnabled = NO;
        self.accountButton.enabled = NO;
        self.accountButton.userInteractionEnabled = NO;
        
        [[LeveyHUD sharedHUD] disappear];
        
    }];
    
}
- (void)loginBtnAndSignUpBtnDisable
{
    if (([[[WarHorseSingleton sharedInstance] isAdwEnable] isEqualToString:@"false"]&&[[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"false"]&&[[[WarHorseSingleton sharedInstance] isCplEnable] isEqualToString:@"false"])){
        [self loginBtnDisble];
    }else{
        self.loginButton.enabled = YES;
        self.loginButton.userInteractionEnabled = YES;
        self.accountButton.enabled = YES;
        self.accountButton.userInteractionEnabled = YES;
    }
}
- (void)loginBtnDisble
{
    self.loginButton.enabled = NO;
    self.loginButton.userInteractionEnabled = NO;
    self.accountButton.enabled = NO;
    self.accountButton.userInteractionEnabled = NO;
    
}

-(void)pageTurn:(UIPageControl *)aPageControl
{
	int WhichPage =(int) aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];
	[self.imageScrollView setContentOffset:CGPointMake(WhichPage *self.imageScrollView.frame.size.width, 0)];
	[UIView commitAnimations];
}

-(IBAction)loginClicked:(id)sender
{
    
    ZLLoginViewController *loginViewController=[[ZLLoginViewController alloc] initWithNibName:@"ZLLoginViewController" bundle:nil];
    loginViewController.typeOfUser = @"ODP";
    //[loginViewController setIsRegistration:NO];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

-(IBAction)accountCLicked:(id)sender
{
    ZLRegistrationViewController *typeOfRegistrations = [[ZLRegistrationViewController alloc] initWithNibName:@"ZLRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:typeOfRegistrations animated:YES];
    /*
    ZLAdwRegistrationViewController *adwRegisterView = [[ZLAdwRegistrationViewController alloc] initWithNibName:@"ZLAdwRegistrationViewController" bundle:nil];
    [self.navigationController pushViewController:adwRegisterView animated:YES];
     */
    
}


#pragma mark -
#pragma mark UICollectionViewDelegate Methods

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    //return [self.collectionArray count];
    /*
    if ((self.isSecondOne == YES) && (self.isFirstOne == YES))
    {
        return [self.collectionArray count] - 2;
    }
    if((self.isFirstOne == NO) && (self.isSecondOne == YES))
    {
        return [self.collectionArray count] - 1;
        
    }
    
    if ((self.isSecondOne == NO)&&(self.isFirstOne == YES))
    {
        return [self.collectionArray count] - 1;
        
    }
    */
    
    return [self.collectionArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLMainScreenCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    NSMutableDictionary *dic = [self.collectionArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = [dic valueForKey:@"title"];
    cell.iconImageView.image = [UIImage imageNamed:[dic valueForKey:@"icon"]];
    cell.backgroundColor = [dic valueForKey:@"backgroundColor"];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    if((self.isFetureRacesEnable == YES) && (self.isPromotionsEnable == NO))
    {
        if (indexPath.row == 2)
        {
            return CGSizeMake(308, 37);
          }
    }
    if ((self.isFetureRacesEnable == NO) && (self.isPromotionsEnable == YES))
    {
        if (indexPath.row == 2||indexPath.row == 3)
        {
            return CGSizeMake(308, 37);

        }
    }
    if ((self.isFetureRacesEnable == NO) && (self.isPromotionsEnable == NO))
    {
        
            [self.staticLineImg setFrame:CGRectMake(self.staticLineImg.frame.origin.x, self.staticLineImg.frame.origin.y-10, self.staticLineImg.frame.size.width, self.staticLineImg.frame.size.height)
             ];
        [self.collectionView setFrame:CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width,40)];

    }

    
    
    return CGSizeMake(151, 37);
 
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
        {
            if ([self.geoFencingStr isEqualToString:@"true"]){
                
                SPTodaysTracksViewController *weeklyScheduleViewCntr  = [[SPTodaysTracksViewController alloc] initWithNibName:@"SPTodaysTracksViewController" bundle:nil];
                [self.navigationController pushViewController:weeklyScheduleViewCntr animated:YES];
            }else{
                [self alertViewMethod];
            }
        }
            break;
            
        case 1:
        {
            if ([self.geoFencingStr isEqualToString:@"true"]){
                SPSCRChangesDetailViewController *scrChangesDetailViewController = [[SPSCRChangesDetailViewController alloc] initWithNibName:@"SPSCRChangesDetailViewController" bundle:nil];
                [self.navigationController pushViewController:scrChangesDetailViewController animated:YES];
            }else{
                [self alertViewMethod];
                
            }
        }
            break;
            
        case 2:
        {
            
            if (self.isPromotionsEnable == YES){
                SPPromotionViewController *promotion = [[SPPromotionViewController alloc] initWithNibName:@"SPPromotionViewController" bundle:nil];
                [self.navigationController pushViewController:promotion animated:YES];

            }else{
                SPFeatureRacesViewController *featureRaces = [[SPFeatureRacesViewController alloc] initWithNibName:@"SPFeatureRacesViewController" bundle:nil];
                [self.navigationController pushViewController:featureRaces animated:YES];
            }
                    }
            break;
            
            
            
        case 3:
        {
            
            if ([self.geoFencingStr isEqualToString:@"true"]){
                SPFeatureRacesViewController *featureRaces = [[SPFeatureRacesViewController alloc] initWithNibName:@"SPFeatureRacesViewController" bundle:nil];
                [self.navigationController pushViewController:featureRaces animated:YES];
            }else{
                [self alertViewMethod];
                
            }
        }
            break;
            
            
        default:
            break;
    }
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)alertViewMethod
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:Aleart_Title message:self.geoFencingErrorStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    self.objTableViewCell  = (ZLMainScreenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.objTableViewCell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"ZLMainScreenTableViewCell" owner:self options:nil];
    }
    
    NSMutableDictionary *dic = [self.tableArray objectAtIndex:indexPath.row];
    
    [self.objTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.objTableViewCell.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.objTableViewCell.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0f/255.0f alpha:1.0]];
    self.objTableViewCell.titleLabel.text=[dic valueForKey:@"title"];
    self.objTableViewCell.iconImages.image=[UIImage imageNamed:[dic valueForKey:@"iconImages"]];
    
    return self.objTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.isRewordAvailable == YES){
        if (indexPath.row == 0)
        {
            SPRewardsDetailViewController *rewards = [[SPRewardsDetailViewController alloc] initWithNibName:@"SPRewardsDetailViewController" bundle:nil];
            [self.navigationController pushViewController:rewards animated:YES];
        }
        else if (indexPath.row == 1)
        {
            SPHelpAndSupportViewController *helpSupportViewCntr = [[SPHelpAndSupportViewController alloc] initWithNibName:@"SPHelpAndSupportViewController" bundle:nil];
            [self.navigationController pushViewController:helpSupportViewCntr animated:YES];
        }
        else if (indexPath.row == 2)
        {
            SPGetStartedViewController *getStartedViewCntr = [[SPGetStartedViewController alloc] initWithNibName:@"SPGetStartedViewController" bundle:nil];
            [self.navigationController pushViewController:getStartedViewCntr animated:YES];
            
        }
        else if (indexPath.row == 3)
        {
            SPAboutWarhorseViewController *about = [[SPAboutWarhorseViewController alloc] initWithNibName:@"SPAboutWarhorseViewController" bundle:nil];
            [self.navigationController pushViewController:about animated:YES];
            
        }
        else if (indexPath.row == 4)
        {
            SPTermsAndConditionsViewController *termsandconditions = [[SPTermsAndConditionsViewController alloc] initWithNibName:@"SPTermsAndConditionsViewController" bundle:nil];
            [self.navigationController pushViewController:termsandconditions animated:YES];
        }
        
        
    }else{
         if (indexPath.row == 0)
        {
            SPHelpAndSupportViewController *helpSupportViewCntr = [[SPHelpAndSupportViewController alloc] initWithNibName:@"SPHelpAndSupportViewController" bundle:nil];
            [self.navigationController pushViewController:helpSupportViewCntr animated:YES];
        }
        else if (indexPath.row == 1)
        {
            SPGetStartedViewController *getStartedViewCntr = [[SPGetStartedViewController alloc] initWithNibName:@"SPGetStartedViewController" bundle:nil];
            [self.navigationController pushViewController:getStartedViewCntr animated:YES];
            
        }
        else if (indexPath.row == 2)
        {
            SPAboutWarhorseViewController *about = [[SPAboutWarhorseViewController alloc] initWithNibName:@"SPAboutWarhorseViewController" bundle:nil];
            [self.navigationController pushViewController:about animated:YES];
            
        }
        else if (indexPath.row == 3)
        {
            SPTermsAndConditionsViewController *termsandconditions = [[SPTermsAndConditionsViewController alloc] initWithNibName:@"SPTermsAndConditionsViewController" bundle:nil];
            [self.navigationController pushViewController:termsandconditions animated:YES];
        }
    }
    
   /*
    
    switch (indexPath.row) {
            
        case 0:
        {
            
            SPRewardsDetailViewController *rewards = [[SPRewardsDetailViewController alloc] initWithNibName:@"SPRewardsDetailViewController" bundle:nil];
            [self.navigationController pushViewController:rewards animated:YES];
            
            
        }
            break;
        case 1:
        {
            
            SPHelpAndSupportViewController *helpSupportViewCntr = [[SPHelpAndSupportViewController alloc] initWithNibName:@"SPHelpAndSupportViewController" bundle:nil];
            [self.navigationController pushViewController:helpSupportViewCntr animated:YES];
            
        }
            break;
        case 2:
        {
            SPGetStartedViewController *getStartedViewCntr = [[SPGetStartedViewController alloc] initWithNibName:@"SPGetStartedViewController" bundle:nil];
            [self.navigationController pushViewController:getStartedViewCntr animated:YES];
            
        }
            break;
        case 3:
        {
            
            SPAboutWarhorseViewController *about = [[SPAboutWarhorseViewController alloc] initWithNibName:@"SPAboutWarhorseViewController" bundle:nil];
            [self.navigationController pushViewController:about animated:YES];
            
            
        }
            break;
        case 4:
        {
            SPTermsAndConditionsViewController *termsandconditions = [[SPTermsAndConditionsViewController alloc] initWithNibName:@"SPTermsAndConditionsViewController" bundle:nil];
            [self.navigationController pushViewController:termsandconditions animated:YES];
        }
            break;
            
        default:
            break;
    }
    */
}

#pragma mark - Location Manager delegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"CLLocation Test");
    
    self.latitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    
    [[NSUserDefaults standardUserDefaults] setValue:self.latitude forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] setValue:self.longitude forKey:@"Longitude"];
    
    //[[NSUserDefaults standardUserDefaults] setValue:@"17.4533333" forKey:@"Latitude"];
    //[[NSUserDefaults standardUserDefaults] setValue:@"78.4624999" forKey:@"Longitude"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    //[self.locationManager stopUpdatingLocation];

    
    if (self.isFirstTimeAppLoading == YES){
        self.isFirstTimeAppLoading = NO;

        [self appConfigCMSService];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    if (status == 2) {
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Latitude"];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"Longitude"];
        if (self.isFirstTimeAppLoading == YES){
            self.isFirstTimeAppLoading = NO;
            [self appConfigCMSService];
        }
        /*
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enable location service,Turn on location service to allow you to App" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 100;
        [alert show];*/
        
    }
    
    if (status == 3) {

        
        [[NSUserDefaults standardUserDefaults] setValue:self.latitude forKey:@"Latitude"];
        [[NSUserDefaults standardUserDefaults] setValue:self.longitude forKey:@"Longitude"];
        
        //[[NSUserDefaults standardUserDefaults] setValue:@"17.4533333" forKey:@"Latitude"];
        //[[NSUserDefaults standardUserDefaults] setValue:@"78.4624999" forKey:@"Longitude"];

    }
    
}


- (void)locationError:(NSError *)error {
    NSLog(@"locationError :::  description is: %@",error.localizedDescription);
    
}



- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (alertView.tag == 100 && buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
    
}
@end
