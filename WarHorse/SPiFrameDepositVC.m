//
//  SPiFrameDepositVC.m
//  WarHorse
//
//  Created by Veeru on 22/12/14.
//  Copyright (c) 2014 Sparity. All rights reserved.
//

#import "SPiFrameDepositVC.h"
#import "LeveyHUD.h"
#import "WarHorseSingleton.h"
#import "ZLAppDelegate.h"

// test_sportechthree47019 CA Demo
// test_sptvenues49612 Mywiiners Staging
// test_sportech46580

#define kAppProductWebSiteURL @"%@MobileWeb/ProductInfo.aspx?ProductId=%d&CatId=%d&brand=%@&d=320&TileId=%@"

#define kAppSecuretradingURL @"https://payments.securetrading.net/process/payments/choice?version=1&parentcss=venues&sitereference=test_sportech46580&currencyiso3a=USD&orderreference=%@&mainamount=%@&consumerid=%@&amountforfunds=%@&processingfee=%@&flatfee=%@&billingfirstname=%@&billinglastname=%@"

@interface SPiFrameDepositVC ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,retain) UIButton *amountButton;

@property (nonatomic,strong) NSString *tractionIDStr;


@end

@implementation SPiFrameDepositVC
@synthesize pamentDict;
@synthesize secureTradingAPI;

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

    [ZLAppDelegate showLoadingView];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 21)];
    [title setText:@"Wallet"];
    [title setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title];
    title=nil;
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(276, 20, 44, 44)];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    [self.amountButton setBackgroundImage:[UIImage imageNamed:@"balancebg@2x.png"] forState:UIControlStateSelected];
    [self.amountButton setTitle:@"" forState:UIControlStateNormal];
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.amountButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.amountButton addTarget:self action:@selector(amountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.amountButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
    
    
    
    
    //NSDate *currentDate = [NSDate date];
    
    //NSString *userName = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] substringToIndex:3] capitalizedString];
    
    //self.tractionIDStr =[NSString stringWithFormat:@"%@%@",userName,[self.currentDateFormatter stringFromDate:currentDate]];
    

    NSString *urlStr = self.secureTradingAPI;//[NSString stringWithFormat:kAppSecuretradingURL,self.tractionIDStr,[pamentDict valueForKey:@"mainamount"],[pamentDict valueForKey:@"consumerId"],[pamentDict valueForKey:@"amountforfunds"],[pamentDict valueForKey:@"processingfee"],[pamentDict valueForKey:@"flatfee"],[pamentDict valueForKey:@"billingfirstname"],[pamentDict valueForKey:@"billinglastname"]];
    
    [self.view sendSubviewToBack:self.webView];
    [self.webView setOpaque:NO];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
//    [[LeveyHUD sharedHUD] appearWithText:@""];

    
    [self.webView loadRequest:requestObj];
    self.webView.scalesPageToFit = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDateFormatter *)currentDateFormatter
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/yyyyh:mm:ssa"];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    });
    return dateFormatter;
}



#pragma mark --
#pragma mark UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{

    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
   // [[LeveyHUD sharedHUD] disappear];
    [ZLAppDelegate hideLoadingView];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   // [[LeveyHUD sharedHUD] disappear];
    [ZLAppDelegate hideLoadingView];

}


- (IBAction)goToHome:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardHome]forKey:@"viewNumber"]];
}
- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}
- (IBAction)backClicked:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)balanceUpdated:(NSNotification *)notification
{
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
}


- (void)amountButtonClicked:(id)sender
{
    if ([self.amountButton isSelected]) {
        
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(276, 20, 44, 44)];
        
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
            //amountLabel.text = [NSString stringWithFormat:@"$%0.2f",[ZLAppDelegate getAppData].balanceAmount];
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
        }failure:^(NSError *error){
        }];
        
        [self.amountButton setSelected:YES];
        [self.amountButton setFrame:CGRectMake(237, 20, 71, 44)];
    }
}
- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 20, 44, 44)];
    }
}


@end
