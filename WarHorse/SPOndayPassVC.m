//
//  SPOndayPassVC.m
//  WarHorse
//
//  Created by Veeru on 12/06/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import "SPOndayPassVC.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "NSData+Base64.h"
#import "SPConstant.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"


//static NSString *withdrawalText = @"This Account has Expired.You are Avalabile is $%.2f.Please click the below button To withdraw the entire funds.";
static NSString *withdrawalText = @"Your one day pass has expired. Your current available balance is %@%.2f,please use the link below to withdraw your funds.";


@interface SPOndayPassVC ()
@property (nonatomic,retain) IBOutlet UILabel *headerLbl;
@property (nonatomic,retain) IBOutlet UITextView *aTestview;
@property (nonatomic, strong) IBOutlet UILabel *QRCodeStatusLabel;
@property (nonatomic,strong) IBOutlet UIImageView *qrCodeImageView;
@property (nonatomic, strong) NSString *amountStr;


- (IBAction)backToView:(id)sender;

@end

@implementation SPOndayPassVC
@synthesize isExpUser;
@synthesize headerStr;
@synthesize totalAmount;

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
    NSLog(@"totalAmount %.2f",totalAmount);
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.headerLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [self.aTestview setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    self.headerLbl.text = headerStr;
    
    self.amountStr = [NSString stringWithFormat:@"%.2f",totalAmount];
    
    [self.terminalQrCodeLabel setTextColor:[UIColor colorWithRed:30/255.0f green:30/255.0f blue:30/255.0f alpha:1.0]];
    
    self.aTestview.text = [NSString stringWithFormat:[[WarHorseSingleton sharedInstance] currencySymbel],withdrawalText,totalAmount];
    
    [self.terminalQrCodeLabel setText:@"Please present the QR Code at the terminal Scanner"];
    self.terminalQrCodeLabel.hidden = YES;
    
    [self.view bringSubviewToFront:self.terminalQrCodeLabel];
    
    if (IS_IPHONE5){
        [self.terminalQrCodeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
        
        self.terminalQrCodeLabel.frame = CGRectMake(self.terminalQrCodeLabel.frame.origin.x, 510 , self.terminalQrCodeLabel.frame.size.width, 38);
        
        self.qrCodeImageView.frame = CGRectMake(self.qrCodeImageView.frame.origin.x, 175 , self.qrCodeImageView.frame.size.width, self.qrCodeImageView.frame.size.height+30);
        
    }else{
        [self.terminalQrCodeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
        
        self.qrCodeImageView.frame = CGRectMake(self.qrCodeImageView.frame.origin.x, 175 , self.qrCodeImageView.frame.size.width, self.qrCodeImageView.frame.size.height-5);
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backToView:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)getUserQRCodeImage
{
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *userType;
    NSString *userNameOrAccountId;
    NSString *actionType;
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        userType = @"ODP";
        
        userNameOrAccountId = [[NSUserDefaults standardUserDefaults] valueForKey:@"AccountID"];
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        userType = @"DV";
        userNameOrAccountId = [[NSUserDefaults standardUserDefaults] valueForKey:@"DVAccountId"];
        
    }
    actionType = @"3";

    
    // ACT=1 for sign On  2 for Withdraw  3 for cash out or close account
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{@"Client-Identifier":[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"],
                                       @"useStoredKey":@"true",
                                       @"value-to-encrypt":@{
                                               @"APP":userType,
                                               @"AID":userNameOrAccountId,
                                               @"ACT":actionType,
                                               @"AMT":[NSString stringWithFormat:@"%d",[self.amountStr intValue]*100],
                                               },
                                       @"encrypt":@"true",
                                       @"errorLevel":@"M",
                                       @"encryptMode":@"BlowFish",
                                       @"encodings":@"BASE64"
                                       }];
    
    NSLog(@"QrCode Dict %@",jsonDict);
    
    self.terminalQrCodeLabel.hidden = YES;
    [[LeveyHUD sharedHUD] appearWithText:@"Loading Withdrawal..."];
    
    [apiWrapper odpandCpluserQRCode:jsonDict success:^(NSDictionary *_userInfo){
        [[LeveyHUD sharedHUD] disappear];
        
        self.terminalQrCodeLabel.hidden = NO;
        [[LeveyHUD sharedHUD] disappear];
        self.QRCodeStatusLabel.hidden = YES;
        NSData *imageData = [NSData dataFromBase64String:[_userInfo valueForKey:@"Encrypted-Value"]];
        UIImage *image1 = [UIImage imageWithData:imageData];
        self.qrCodeImageView.image=image1;
        
    }failure:^(NSError *error) {
        self.QRCodeStatusLabel.text = @"Failed to get QRCode";
        [[LeveyHUD sharedHUD] disappear];
    }];
    
}



@end
