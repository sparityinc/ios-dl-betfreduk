//
//  ZLQRCodeViewController.m
//  WarHorse
//
//  Created by Sparity on 18/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLQRCodeViewController.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "NSData+Base64.h"
#import "SPConstant.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "ZLMainScreenViewController.h"


static NSString *expireQrCodeTextForODP = @"The Generated Code is valid for %@ minutes.";

static NSString *expireQrCodeText = @"The Generated Code is valid for %@ minutes. Regenerate it after expiration.";


@interface ZLQRCodeViewController () <UITextFieldDelegate>
{
    IBOutlet UIButton *withDrawBtn;
    IBOutlet UIButton *addFundsBtn;
    NSString *userType;
    
}

@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong) IBOutlet UIImageView *qrCodeImageView;
@property (nonatomic,strong) IBOutlet UIImageView *lineImg;
@property (nonatomic, strong) IBOutlet UITextField *amountTF;
@property (nonatomic, strong) IBOutlet UILabel *QRCodeStatusLabel;
@property (nonatomic, strong) IBOutlet UILabel *withdrawLbl;

@property (nonatomic, strong) NSString *amountValueStr;

@property (strong, nonatomic) IBOutlet UIView *confirmPswdView;

@property (strong, nonatomic) IBOutlet UITextField *pinTxtFld;

- (IBAction)okBtnClicked:(id)sender;

@end

@implementation ZLQRCodeViewController
@synthesize actionStr;

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
    NSString *amountPlaceHolder = [NSString stringWithFormat:@"Enter amount in %@",[[WarHorseSingleton sharedInstance] currencySymbel]];

    self.amountTF.text = [[WarHorseSingleton sharedInstance] currencySymbel];
    self.amountTF.placeholder =  amountPlaceHolder;
    
    self.TitleTextLbl.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    
    UIView *pinPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    pinPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"password.png"]];
    self.pinTxtFld.leftView = pinPadding;
    self.pinTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.pinTxtFld.rightViewMode = UITextFieldViewModeAlways;
    _pinTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pinTxtFld.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.pinTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.pinTxtFld.layer.borderWidth=0.5;
    self.pinTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:14];
    
    
    //float balance =
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self.view bringSubviewToFront:self.lineImg];
    
    UIView *leftSidePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    
    self.amountTF.leftView = leftSidePaddingView;
    self.amountTF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightSidePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    
    self.amountTF.leftView = rightSidePaddingView;
    self.amountTF.leftViewMode = UITextFieldViewModeAlways;
    
    [self.amountTF.layer setBorderWidth:1.0];
    [self.amountTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.amountTF.layer setCornerRadius:2.0];
    
    [withDrawBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [withDrawBtn.layer setShadowColor:withDrawBtn.backgroundColor.CGColor];
    [withDrawBtn.layer setCornerRadius:4.0];
    
    [addFundsBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [addFundsBtn.layer setShadowColor:withDrawBtn.backgroundColor.CGColor];
    [addFundsBtn.layer setCornerRadius:4.0];
    
    [self.headerNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [self.withdrawLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.terminalQrCodeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.QRCodeStatusLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];//expireQrCodeLabel
    
    [self.expireQrCodeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    
    [self.terminalQrCodeLabel setTextColor:[UIColor colorWithRed:30/255.0f green:30/255.0f blue:30/255.0f alpha:1.0]];
    [self.terminalQrCodeLabel setText:@"Present the QR Code at the terminal Scanner"];
    
    [self.view bringSubviewToFront:self.terminalQrCodeLabel];
    
    if (IS_IPHONE5) {
        [self.terminalQrCodeLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:16]];
        
        self.terminalQrCodeLabel.frame = CGRectMake(self.terminalQrCodeLabel.frame.origin.x, 180 , self.terminalQrCodeLabel.frame.size.width, 38);
        
        self.qrCodeImageView.frame = CGRectMake(self.qrCodeImageView.frame.origin.x, 210 , self.qrCodeImageView.frame.size.width, self.qrCodeImageView.frame.size.height);
        self.expireQrCodeLabel.frame = CGRectMake(self.expireQrCodeLabel.frame.origin.x, self.expireQrCodeLabel.frame.origin.y+45, self.expireQrCodeLabel.frame.size.width, self.expireQrCodeLabel.frame.size.height);

        if ([actionStr isEqualToString:@"transfer"]||[actionStr isEqualToString:@"closedaccount"])
        {
            self.qrCodeImageView.frame = CGRectMake(self.qrCodeImageView.frame.origin.x, 165, self.qrCodeImageView.frame.size.width, self.qrCodeImageView.frame.size.height);
            
            self.terminalQrCodeLabel.frame = CGRectMake(self.terminalQrCodeLabel.frame.origin.x, self.terminalQrCodeLabel.frame.origin.y-40, self.terminalQrCodeLabel.frame.size.width, self.terminalQrCodeLabel.frame.size.height);
            self.expireQrCodeLabel.frame = CGRectMake(self.expireQrCodeLabel.frame.origin.x, self.expireQrCodeLabel.frame.origin.y-30, self.expireQrCodeLabel.frame.size.width, self.expireQrCodeLabel.frame.size.height);

        }
        
    }else{
        self.QRCodeStatusLabel.frame = CGRectMake(self.QRCodeStatusLabel.frame.origin.x, 270 , self.QRCodeStatusLabel.frame.size.width, self.QRCodeStatusLabel.frame.size.height);
        self.qrCodeImageView.frame = CGRectMake(self.qrCodeImageView.frame.origin.x, 159 , self.qrCodeImageView.frame.size.width, self.qrCodeImageView.frame.size.height);
        self.terminalQrCodeLabel.frame = CGRectMake(self.terminalQrCodeLabel.frame.origin.x, self.terminalQrCodeLabel.frame.origin.y, self.terminalQrCodeLabel.frame.size.width, self.terminalQrCodeLabel.frame.size.height);
        self.expireQrCodeLabel.frame = CGRectMake(self.expireQrCodeLabel.frame.origin.x, self.expireQrCodeLabel.frame.origin.y-25, self.expireQrCodeLabel.frame.size.width, self.expireQrCodeLabel.frame.size.height);
        
        
        
        if ([actionStr isEqualToString:@"transfer"]|| [actionStr isEqualToString:@"closedaccount"])
        {
            self.qrCodeImageView.frame = CGRectMake(self.qrCodeImageView.frame.origin.x, 129, self.qrCodeImageView.frame.size.width, self.qrCodeImageView.frame.size.height);
            
            self.terminalQrCodeLabel.frame = CGRectMake(self.terminalQrCodeLabel.frame.origin.x, self.terminalQrCodeLabel.frame.origin.y-50, self.terminalQrCodeLabel.frame.size.width, self.terminalQrCodeLabel.frame.size.height);
        }
        
    }
    
    [self prepareTopView];
    [self.view addSubview:self.confirmPswdView];
    
    if ([actionStr isEqualToString:@"withdraw"])
    {
        self.titleLabel.text = @"Withdrawal";
        [self.confirmPswdView setHidden:YES];
        
    }
    
    else if([actionStr isEqualToString:@"transfer"])
    {
        [self.confirmPswdView setHidden:YES];
        self.mainTitle.text = @"Terminal Connect";

        [self textfieldHidden:@"Terminal Connect"];
        [self getQRcodeImg];
        
    }
    else if([actionStr isEqualToString:@"closedaccount"])
    {
        
        [self.confirmPswdView setHidden:NO];
//        self.TitleTextLbl.text = @"Please Enter One Day Pass PIN";
//        self.pinTxtFld.placeholder = @"Enter 4 Digit Pin";
//        self.pinTxtFld.keyboardType = UIKeyboardTypeNumberPad;

        [self textfieldHidden:@"Back"];
        [self.headerNameLabel setText:@"Cash Out"];
        self.toggleButton.userInteractionEnabled = NO;
        self.toggleButton.enabled = NO;
        self.amountButton.enabled = NO;
        self.amountButton.userInteractionEnabled = NO;
        [self keyPadTypeAndTitleStr];

        
    }
    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    
    [self.tapGestureRecognizer setEnabled:NO];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self refreshBalance];
}

- (IBAction)okBtnClicked:(id)sender
{
    if ([self.pinTxtFld.text isEqualToString:@""] )
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Information" message:@"Please fill the field" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {    [self.pinTxtFld resignFirstResponder];
        [self.confirmPswdView setHidden:YES];
        [self getQRcodeImg];
    }
}
- (IBAction)CancelBtnClicked:(id)sender
{
    [self.pinTxtFld resignFirstResponder];
    [self.confirmPswdView setHidden:YES];
}

- (void)textfieldHidden:(NSString *)title
{
    self.titleLabel.text = title;
    self.amountTF.hidden = YES;
    self.submitButton.hidden = YES;
    self.withdrawLbl.hidden = YES;
}

- (void)prepareTopView
{
    
    [self.toggleButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
}

-(void)balanceUpdated:(NSNotification *)notification
{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}
- (void)amountButtonClicked:(id)sender
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
- (void)refreshBalance
{
    
    [[ZLAppDelegate getApiWrapper] refreshBalance:NO success:^(NSDictionary* _userInfo){
        self.amountValueStr = [NSString stringWithFormat:@"%0.2f",[[ZLAppDelegate getAppData] balanceAmount]];

        
    }failure:^(NSError *error){
        self.amountValueStr = @"0";
    }];
    
}


- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 20, 44, 44)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------
#pragma QRCode API Service


- (void)getQRcodeImg
{
    [self.amountTF resignFirstResponder];
    NSString *userNameOrAccountId;
    NSString *actionType;
    NSString *amountStr;
    
    if ([actionStr isEqualToString:@"withdraw"]){
        NSArray *array = [self.amountTF.text componentsSeparatedByString:[[WarHorseSingleton sharedInstance] currencySymbel]];
        
        amountStr = [NSString stringWithFormat:@"%@",([array count] > 1)?[array objectAtIndex:1]:@""];
        if ([self.amountValueStr intValue] >= [amountStr intValue]){
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information!" message:@"Insufficient funds" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [[LeveyHUD sharedHUD] disappear];
            
            return;
        }
        
        actionType = @"2";
        
    }else if ([actionStr isEqualToString:@"transfer"]){
        amountStr = @"";
        actionType = @"1";
        
        
    }else if ([actionStr isEqualToString:@"closedaccount"]){
        
        amountStr = self.amountValueStr;
        actionType = @"3";
        
    }
    
    // ACT=1 for sign On  2 for Withdraw  3 for cash out or close account
    
    NSString *passwordAndPin;
    
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        userType = @"ADW";
        userNameOrAccountId = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
        passwordAndPin = @"validatePass";
    }
    else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        userType = @"ODP";
        passwordAndPin = @"validatePin";
        
        userNameOrAccountId = [[NSUserDefaults standardUserDefaults] valueForKey:@"AccountID"];
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        userType = @"DV";
        userNameOrAccountId = [[NSUserDefaults standardUserDefaults] valueForKey:@"DVAccountId"];
        passwordAndPin = @"validatePass";
        
    }
    
    //
    self.amountTF.text = [[WarHorseSingleton sharedInstance] currencySymbel];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{@"Client-Identifier":[[NSUserDefaults standardUserDefaults] valueForKey:@"ClientId"],
                                       @"useStoredKey":@"true",
                                       @"value-to-encrypt":@{
                                               @"APP":userType,
                                               @"AID":userNameOrAccountId,
                                               @"ACT":actionType,
                                               @"AMT":[NSString stringWithFormat:@"%d",[amountStr intValue]*100],
                                               },
                                       @"encrypt":@"true",
                                       passwordAndPin:self.pinTxtFld.text,
                                       @"errorLevel":@"M",
                                       @"encryptMode":@"BlowFish",
                                       @"encodings":@"BASE64"
                                       }];
    
    NSLog(@"jsonDict %@",jsonDict);
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    self.terminalQrCodeLabel.hidden = YES;
    
    [apiWrapper odpandCpluserQRCode:jsonDict success:^(NSDictionary *_userInfo){
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]){
            self.terminalQrCodeLabel.hidden = NO;
            self.QRCodeStatusLabel.hidden = YES;
            
            NSData *imageData = [NSData dataFromBase64String:[_userInfo valueForKey:@"Encrypted-Value"]];//timeToExpire
            UIImage *image1 = [UIImage imageWithData:imageData];
            self.qrCodeImageView.image=image1;
            
            NSString *expireStr = [_userInfo valueForKey:@"timeToExpire"];
            if ([actionStr isEqualToString:@"closedaccount"]){
                self.expireQrCodeLabel.text = [NSString stringWithFormat:expireQrCodeTextForODP,expireStr];
                
            }else{
                self.expireQrCodeLabel.text = [NSString stringWithFormat:expireQrCodeText,expireStr];
            }
            
        }else{
            self.QRCodeStatusLabel.text = @"Failed to get QRCode";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information!" message:[_userInfo valueForKey:@"response-message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
        
        
        
    }failure:^(NSError *error) {
        self.QRCodeStatusLabel.text = @"Failed to get QRCode";
        [[LeveyHUD sharedHUD] disappear];
    }];
    
}


- (IBAction)backToHome:(id)sender
{
    if([actionStr isEqualToString:@"closedaccount"]){
        ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
        NSMutableDictionary *jsonDict;
        jsonDict = [NSMutableDictionary dictionaryWithDictionary:@{@"consumerType":[[WarHorseSingleton sharedInstance] userType],@"accountType":@"0"}];
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
            
            return;
        }
        [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
        
        [apiWrapper accountClosedValidationForOdp:jsonDict success:^(NSDictionary *_userInfo){
            [[LeveyHUD sharedHUD] disappear];
            
            if ([[_userInfo valueForKey:@"response-code"] isEqualToString:@"WH-200"]){
                
                NSString *isClosedStr = [NSString stringWithFormat:@"%@",[[_userInfo valueForKey:@"response-content"]valueForKey:@"isClosed"]];
                if ([isClosedStr isEqualToString:@"0"]){
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
                    [apiWrapper logoutUserWithParameters:nil success:^(NSDictionary *_userInfo) {
                        [[LeveyHUD sharedHUD] disappear];
                        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"OntAccountId"];
                        [self.navigationController.navigationController popToRootViewControllerAnimated:YES];
                        
                    } failure:^(NSError *error) {
                        [[LeveyHUD sharedHUD] disappear];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }];
                    
                    
                }
            }
            
        }failure:^(NSError *error) {
            self.QRCodeStatusLabel.text = @"Failed to get QRCode";
            [[LeveyHUD sharedHUD] disappear];
        }];
        
        
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)resignKeyBoard
{
    [self.amountTF resignFirstResponder];
    [self.tapGestureRecognizer setEnabled:NO];
    [self.pinTxtFld resignFirstResponder];
    
}

- (IBAction)submitAmount:(id)sender
{
    
    
    NSString *title = [NSString stringWithFormat:@"%@0",[[WarHorseSingleton sharedInstance] currencySymbel]];
    NSString *title1 = [NSString stringWithFormat:@"%@0.0",[[WarHorseSingleton sharedInstance] currencySymbel]];
    NSString *title2 = [NSString stringWithFormat:@"%@0.00",[[WarHorseSingleton sharedInstance] currencySymbel]];

    if ([self.amountTF.text isEqualToString:[[WarHorseSingleton sharedInstance] currencySymbel]] || [self.amountTF.text isEqualToString:title] || [self.amountTF.text isEqualToString:title1] || [self.amountTF.text isEqualToString:title2]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid amount" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    if ([self.amountTF.text rangeOfString:@"."].location == NSNotFound) {
        self.amountTF.text = [NSString stringWithFormat:@"%@.00",self.amountTF.text];
    }
    
    [self.amountTF resignFirstResponder];
    
    self.mainTitle.text = @"Withdrawal";
    
    [self keyPadTypeAndTitleStr];
    [self.confirmPswdView setHidden:NO];
    
    
}


- (void)keyPadTypeAndTitleStr
{
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]) {
        self.TitleTextLbl.text = @"Please Enter Your ADW Password";
        self.pinTxtFld.placeholder = @"Enter Password";
        self.pinTxtFld.text = @"";
        
    }
    else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        self.TitleTextLbl.text = @"Please Enter One Day Pass PIN";
        self.pinTxtFld.placeholder = @"Enter 4 Digit Pin";
        self.pinTxtFld.keyboardType = UIKeyboardTypeNumberPad;
        self.pinTxtFld.text = @"";
        
    }
    else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        self.TitleTextLbl.text = @"Please Enter Digital Voucher Password";
        self.pinTxtFld.placeholder = @"Enter Password";
        self.pinTxtFld.text = @"";
        
        
        
    }
}


#pragma mark - TextField Delegate Methods
// became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.tapGestureRecognizer setEnabled:YES];
    
    CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    
    int bottomValue,staticValue;
    if (IS_IPHONE5) {
        bottomValue = 300;
        staticValue = 294;//294
    }else{
        bottomValue = 200;
        staticValue = 210;
        
    }
    
	if (bottomEdge >= bottomValue) {//250
        CGRect viewFrame = self.view.frame;
        
        self.shiftForKeyboard = bottomEdge - staticValue;
        
        viewFrame.origin.y -= self.shiftForKeyboard;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
		
	}else{
		self.shiftForKeyboard = 0.0f;
	}
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    switch (textField.tag) {
            
        case 0:
        {
            return YES;
            break;
        }
        case 1: //Amount Text field
        {
            
            if ([textField.text isEqualToString:[[WarHorseSingleton sharedInstance] currencySymbel]] && range.length == 1)
            {
                return NO;
            }
            
            if ([textField.text isEqualToString:[[WarHorseSingleton sharedInstance] currencySymbel]] && range.length == 0 && range.location == 2 && [string intValue] == 0)
            {
                return NO;
            }
            
            
            if (range.location == 0 || (range.location == 1 && [string isEqualToString:@"."])) {
                return NO;
            }
            
            if (([textField.text rangeOfString:@"."].location == NSNotFound) && [string isEqualToString:@"."]) {
                return YES;
            }
            
            
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            
            NSArray *sep = [newString componentsSeparatedByString:@"."];
            if([sep count] >= 2)
            {
                NSString *sepStr=[NSString stringWithFormat:@"%@",[sep objectAtIndex:1]];
                return !([sepStr length]>2);
            }
            
            if ([textField.text rangeOfString:@"."].location == NSNotFound)
            {
                return ((newLength <= 6) ? YES : NO);
            }
            
            return ((newLength <= 8) ? YES : NO);
            
            
        }
            break;
            case 2:
        {
            if([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"])
            {
                return (newLength <= 4) ? YES : NO;
            }else{
                return YES;
            }

        }
            break;
            
        default:
            return NO;
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(self.view.frame.origin.y == 0) {
        [textField resignFirstResponder];
    }
    else{
     	// Resign first responder
        [textField resignFirstResponder];
        
        
        // Make a CGRect for the view (which should be positioned at 0,0 and be 320px wide and 480px tall)
        CGRect viewFrame = self.view.frame;
        if(viewFrame.origin.y!=0)
        {
            // Adjust the origin back for the viewFrame CGRect
            viewFrame.origin.y += self.shiftForKeyboard;
            // Set the shift value back to zero
            self.shiftForKeyboard = 0.0f;
            
            // As above, the following animation setup just makes it look nice when shifting
            // Again, we don't really need the animation code, but we'll leave it in here
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationDuration:0.3];
            // Apply the new shifted vewFrame to the view
            [self.view setFrame:viewFrame];
            // More animation code
            [UIView commitAnimations];
        }
    }
    [self.tapGestureRecognizer setEnabled:NO];
}

@end
