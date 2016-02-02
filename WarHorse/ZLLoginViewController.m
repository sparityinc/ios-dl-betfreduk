//
//  ZLLoginViewController.m
//  WarHorse
//
//  Created by Sparity on 7/4/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLLoginViewController.h"
#import "ZLMainGridViewController.h"
#import "ZLResetPasswordViewController.h"
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "WarHorseSingleton.h"
#import "ZLVerificationCodeViewController.h"
#import "SPOndayPassVC.h"
#import "LeveyHUD.h"


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
static NSString *const acceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@interface ZLLoginViewController () <UIAlertViewDelegate>
{
    NSString *typeOfLoginStr;
    NSInteger noOfSegments;
}
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentedView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;

@property (strong, nonatomic) IBOutlet UITextField *accountidTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *pinTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (strong, nonatomic) IBOutlet UIView *oneDayPassView;
@property (strong, nonatomic) IBOutlet UIView *digitalVoucherView;

- (IBAction)segmentedBtn:(id)sender;

@end

@implementation ZLLoginViewController

@synthesize login_Label=_login_Label;
@synthesize usernameImgView = _usernameImgView;
@synthesize passwordImgView = _passwordImgView;
@synthesize pinImgView = _pinImgView;
@synthesize userName_TF = _userName_TF;
@synthesize password_TF = _password_TF;
@synthesize pinNumber_TF = _pinNumber_TF;
@synthesize selArrowImageView = _selArrowImageView;
@synthesize lineImageView = _lineImageView;
@synthesize typeOfUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.headerLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [self activeAccountIdForOdpDevice];

    
    //Segment Controller no of segments changed to dynamically
    
    if ([[[WarHorseSingleton sharedInstance] isAdwEnable] isEqualToString:@"false"]){
        [self.segmentedView removeSegmentAtIndex:0 animated:YES];
    }
    if([[[WarHorseSingleton sharedInstance] isOntEnable] isEqualToString:@"false"]){
        if (self.segmentedView.numberOfSegments == 2 ){
            [self.segmentedView removeSegmentAtIndex:0 animated:YES];
        }else{
            [self.segmentedView removeSegmentAtIndex:1 animated:YES];
        }
    }
    
    if([[[WarHorseSingleton sharedInstance] isCplEnable] isEqualToString:@"false"]){
        
        if (self.segmentedView.numberOfSegments == 3 ){
            [self.segmentedView removeSegmentAtIndex:2 animated:YES];
        }else{
            [self.segmentedView removeSegmentAtIndex:1 animated:YES];
        }
        
    }
    noOfSegments = self.segmentedView.numberOfSegments;
    
    //ADW View
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    paddingView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"username.png"]];
    self.userName_TF.leftView = paddingView;
    self.userName_TF.leftViewMode = UITextFieldViewModeAlways;
    // self.userName_TF.rightViewMode = UITextFieldViewModeAlways;
    [self.userName_TF setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.userName_TF.layer.borderColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.userName_TF setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.userName_TF.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    self.userName_TF.layer.borderWidth=0.5;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    paddingView1.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"password.png"]];
    self.pinNumber_TF.leftView = paddingView1;
    self.pinNumber_TF.leftViewMode = UITextFieldViewModeAlways;
    self.pinNumber_TF.rightViewMode = UITextFieldViewModeAlways;
    _pinNumber_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pinNumber_TF.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.pinNumber_TF setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.pinNumber_TF.layer.borderWidth=0.5;
    self.pinNumber_TF.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    
    
    //Oneday Pass
    [self.oneDayPassView setFrame:CGRectMake(320.0, 64, 320, 500)];
    
    
    UIView *accountIdPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    accountIdPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"username.png"]];
    self.accountidTxtFld.leftView = accountIdPadding;
    self.accountidTxtFld.leftViewMode = UITextFieldViewModeAlways;
    [self.accountidTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.accountidTxtFld.layer.borderColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.accountidTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.accountidTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    self.accountidTxtFld.layer.borderWidth=0.5;
    
    UIView *pinPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    pinPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"password.png"]];
    self.pinTxtFld.leftView = pinPadding;
    self.pinTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.pinTxtFld.rightViewMode = UITextFieldViewModeAlways;
    _pinTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pinTxtFld.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.pinTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.pinTxtFld.layer.borderWidth=0.5;
    self.pinTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    
    
    //Digital Voucher
    
    UIView *userNamePadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    userNamePadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"username.png"]];
    self.userNameTxtFld.leftView = userNamePadding;
    self.userNameTxtFld.leftViewMode = UITextFieldViewModeAlways;
    [self.userNameTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.userNameTxtFld.layer.borderColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.userNameTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.userNameTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    self.userNameTxtFld.layer.borderWidth=0.5;
    
    UIView *passWordPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    passWordPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"password.png"]];
    self.passwordTxtFld.leftView = passWordPadding;
    self.passwordTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTxtFld.rightViewMode = UITextFieldViewModeAlways;
    _passwordTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passwordTxtFld.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.passwordTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.passwordTxtFld.layer.borderWidth=0.5;
    self.passwordTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    
    
    self.lineImageView.frame = CGRectMake(0.0f, 57.0f, 320.0f, 0.5f);
    [self.forgotPWD_Button.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15.0]];
    
    

}

- (void)viewWillAppear:(BOOL)animated
{

    [self.pinNumber_TF setText:@""];
    [super viewWillAppear:animated];
    
    if ([[[WarHorseSingleton sharedInstance] isRegisterFlag] isEqualToString:@"Yes"]){
        [self.segmentedView setSelectedSegmentIndex:[[WarHorseSingleton sharedInstance] selectedIndexFromRegister]];

    }else{
        if ([[WarHorseSingleton sharedInstance] noofSegmentToStart] != noOfSegments){
            [self.segmentedView setSelectedSegmentIndex:0];
        }else{
            [self.segmentedView setSelectedSegmentIndex:[[WarHorseSingleton sharedInstance] selectedIndexSegmentCntr]];
        }
    }
    
    [[WarHorseSingleton sharedInstance] setNoofSegmentToStart:noOfSegments];
    
    [self segmentedBtn:self.segmentedView];
    
    
}


//Arrow Image frame changed here
- (void)moveSelArrowImageView:(NSInteger)sender
{
    
    //NSLog(@"noOfSegments %ld",(long)noOfSegments);
    
    if (noOfSegments ==3){
        if (sender == 0){
            self.selArrowImageView.frame = CGRectMake(51, 112, 15, 10);
            
        }else if (sender == 1){
            self.selArrowImageView.frame = CGRectMake(153, 112, 15, 10);
            
        }else if(sender == 2){
            self.selArrowImageView.frame = CGRectMake(251, 112, 15, 10);
            
        }
    }
    if (noOfSegments ==2){
        if (sender == 0){
            self.selArrowImageView.frame = CGRectMake(78, 112, 15, 10);
            
        }else if (sender == 1){
            self.selArrowImageView.frame = CGRectMake(228, 112, 15, 10);
            
        }
    }
    if (noOfSegments ==1){
        if (sender == 0){
            self.selArrowImageView.frame = CGRectMake(154, 112, 15, 10);
        }
    }
    
}

// Handle changing the value of the segmented view controller.
- (IBAction)segmentedBtn:(id)sender
{
    [self moveSelArrowImageView:self.segmentedView.selectedSegmentIndex];
    
    [[WarHorseSingleton sharedInstance] setSelectedIndexSegmentCntr:self.segmentedView.selectedSegmentIndex];
    
    if ([[self.segmentedView titleForSegmentAtIndex:self.segmentedView.selectedSegmentIndex] isEqualToString:@"Totepool"]){
        self.userName_TF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"AccountName"];
        [[WarHorseSingleton sharedInstance] setUserType:@"ADW"];

        typeOfLoginStr = @"ADW";
        if (![[[[WarHorseSingleton sharedInstance] loginADWRequiredfieldsDic] valueForKey:@"userid"] isEqualToString:@"true"] && [[[WarHorseSingleton sharedInstance] loginADWRequiredfieldsDic] isKindOfClass:[NSDictionary class]]) {
            self.userName_TF.placeholder = @"Account ID";
            self.pinNumber_TF.placeholder = @"Enter 4 Digit PIN Number";
            self.userName_TF.keyboardType = UIKeyboardTypeNumberPad;
            self.pinNumber_TF.keyboardType = UIKeyboardTypeNumberPad;

        }
        
        //[self keyBoardResign];
        [self.oneDayPassView removeFromSuperview];
        [self.digitalVoucherView removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred" forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }else if ([[self.segmentedView titleForSegmentAtIndex:self.segmentedView.selectedSegmentIndex] isEqualToString:@"One Day Pass"]){
        NSLog(@"ODP Acount ID %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"OntAccountId"]);
        //self.accountidTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"OntAccountId"];

        typeOfLoginStr = @"ODP";
        [[WarHorseSingleton sharedInstance] setUserType:@"ODP"];
        if (![[[[WarHorseSingleton sharedInstance] loginODPRequiredfieldsDic] valueForKey:@"accountid"] isEqualToString:@"true"]&&[[[WarHorseSingleton sharedInstance] loginADWRequiredfieldsDic] isKindOfClass:[NSDictionary class]]) {
            self.accountidTxtFld.placeholder = @"User Name";
            self.pinTxtFld.placeholder = @"Password";
            self.accountidTxtFld.keyboardType = UIKeyboardTypeDefault;
            self.pinTxtFld.keyboardType = UIKeyboardTypeDefault;

        }
        //[self keyBoardResign];
        [self.oneDayPassView setFrame:CGRectMake(0.0, 130, 320, 500)];
        
        [self.view addSubview:self.oneDayPassView];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred-ODP" forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if ([[self.segmentedView titleForSegmentAtIndex:self.segmentedView.selectedSegmentIndex] isEqualToString:@"Voucher"]){
        [[WarHorseSingleton sharedInstance] setUserType:@"DV"];
        self.userNameTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"CplUserName"];

        typeOfLoginStr = @"DV";
        
        if (![[[[WarHorseSingleton sharedInstance] loginDVRequiredfieldsDic] valueForKey:@"userid"] isEqualToString:@"true"]) {
            self.userName_TF.placeholder = @"Account ID";
            self.pinNumber_TF.placeholder = @"Enter 4 Digit PIN Number";
            self.userName_TF.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred-DV" forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[self keyBoardResign];
        [self.digitalVoucherView setFrame:CGRectMake(0.0, 130, 320, 500)];
        
        [self.view addSubview:self.digitalVoucherView];
        [self.oneDayPassView removeFromSuperview];
        
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//ODP Account id checking
- (void)activeAccountIdForOdpDevice
{
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];

    [apiWrapper activeAccountIdForODP:nil success:^(NSDictionary *userDict){
        [[LeveyHUD sharedHUD] disappear];//"response-status
        if ([[userDict valueForKey:@"response-status"] isEqualToString:@"success"]){
            id isActiveid = [[userDict valueForKey:@"response-content"] valueForKey:@"isActive"];
            NSString *isActive = [NSString stringWithFormat:@"%@",isActiveid];
            if ([isActive isEqualToString:@"1"]){
                [[NSUserDefaults standardUserDefaults] setValue:[[userDict valueForKey:@"response-content"] valueForKey:@"accountId"] forKey:@"OntAccountId"];
            }else{

                [[NSUserDefaults standardUserDefaults] setValue:[[userDict valueForKey:@"response-content"] valueForKey:@"accountId"] forKey:@"OntAccountId"];

            }
            
        }else{

        }
        self.accountidTxtFld.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"OntAccountId"];

        [[NSUserDefaults standardUserDefaults] synchronize];

        [self odpAccountEnable];

        
    }failure:^(NSError *error){
        [[LeveyHUD sharedHUD] disappear];
        [self odpAccountEnable];
        
    }];
}
- (void)odpAccountEnable
{
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"OntAccountId"]||[[[NSUserDefaults standardUserDefaults] valueForKey:@"OntAccountId"] isEqualToString:@""]){
        self.accountidTxtFld.enabled = YES;
        self.accountidTxtFld.text = @"";
    }
}

#pragma mark - Private API
//Forgot Password ?
- (BOOL)validateUsernameOrPassword:(NSString *)usernameOrpassword
{
    
    NSString *emailRegex =
    @"((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,12})";
    NSPredicate *usernameOrPasswordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [usernameOrPasswordTest evaluateWithObject:usernameOrpassword];
    
}

- (IBAction)login_Clicked:(id)sender
{
    
    
    [self keyBoardResign];
    NSString *userNameandPin;
    NSString *userPasswordandPin;
    UIAlertView *alert;
    
    if([typeOfLoginStr isEqualToString:@"ADW"]){
        
        if ([self.userName_TF.text isEqualToString:@""] || [self.pinNumber_TF.text isEqualToString:@""]) {
            
            alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred" forKey:@"ClientId"];
        
        userNameandPin = self.userName_TF.text;
        userPasswordandPin = self.pinNumber_TF.text;
        
        if ([[[[WarHorseSingleton sharedInstance] loginADWRequiredfieldsDic] valueForKey:@"userid"] isEqualToString:@"true"]) {
            [[NSUserDefaults standardUserDefaults] setValue:userNameandPin forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:userPasswordandPin forKey:@"password"];
            
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"UserPin"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"AccountID"];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"password"];
            
            [[NSUserDefaults standardUserDefaults] setValue:userPasswordandPin forKey:@"UserPin"];
            [[NSUserDefaults standardUserDefaults] setValue:userNameandPin forKey:@"AccountID"];
        }
        
    }else if ([typeOfLoginStr isEqualToString:@"ODP"]){
        
        if ([self.accountidTxtFld.text isEqualToString:@""] || [self.pinTxtFld.text isEqualToString:@""]) {
            
            alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        userNameandPin = self.accountidTxtFld.text;
        userPasswordandPin = self.pinTxtFld.text;
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred-ODP" forKey:@"ClientId"];
        
        if ([[[[WarHorseSingleton sharedInstance] loginODPRequiredfieldsDic] valueForKey:@"accountid"] isEqualToString:@"true"]) {
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:userPasswordandPin forKey:@"UserPin"];
            [[NSUserDefaults standardUserDefaults] setValue:userNameandPin forKey:@"AccountID"];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:userNameandPin forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setValue:userPasswordandPin forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"UserPin"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"AccountID"];
        }
        
        
        
    }else if ([typeOfLoginStr isEqualToString:@"DV"]){
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred-DV" forKey:@"ClientId"];
        
        if ([self.userNameTxtFld.text isEqualToString:@""] || [self.passwordTxtFld.text isEqualToString:@""]) {
            
            alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        userNameandPin = self.userNameTxtFld.text;
        userPasswordandPin = self.passwordTxtFld.text;
        
        
        if ([[[[WarHorseSingleton sharedInstance] loginADWRequiredfieldsDic] valueForKey:@"userid"] isEqualToString:@"true"]) {
            [[NSUserDefaults standardUserDefaults] setValue:self.userNameTxtFld.text forKey:@"CplUserName"];
            [[NSUserDefaults standardUserDefaults] setValue:self.passwordTxtFld.text forKey:@"CplPassword"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"UserPin"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"AccountID"];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CplUserName"];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"CplPassword"];
            [[NSUserDefaults standardUserDefaults] setValue:self.passwordTxtFld.text forKey:@"UserPin"];
            [[NSUserDefaults standardUserDefaults] setValue:self.userNameTxtFld.text forKey:@"AccountID"];
        }
        
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self.login_Button setEnabled:NO];
    
    [ZLAppDelegate showLoadingView];
    ZLAPIWrapper * apiWrapper = [ZLAppDelegate getApiWrapper];
    
    [apiWrapper authenticateUser:userNameandPin withPassword:userPasswordandPin Pin:nil Lat:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"] andLon:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"]
                         success:^(NSDictionary* _userInfo){
//                             NSLog(@"login Deatails %@",_userInfo);

                             [self.login_Button setEnabled:YES];
                             //response-status
                             NSString *userStatusStr;
                             if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]){
                                 [[WarHorseSingleton sharedInstance] setUserDetailsDict:[[_userInfo valueForKey:@"response-content"] valueForKey:@"loginResponse"]];
                                 NSString *amountValue = [[_userInfo valueForKey:@"response-content"] valueForKey:@"availableBalance"];

                                 if ([typeOfLoginStr isEqualToString:@"ADW"]){
                                     
                                     [self dashBoardView];
                                     [[NSUserDefaults standardUserDefaults] setValue:userNameandPin forKey:@"AccountName"];
                                     [[NSUserDefaults standardUserDefaults] setValue:[[_userInfo valueForKey:@"response-content"] valueForKey:@"accountId"] forKey:@"DVAccountId"];
                                     
                                     
                                 }else if ([typeOfLoginStr isEqualToString:@"ODP"]){
                                     
                                     userStatusStr = [[_userInfo valueForKey:@"response-content"] valueForKey:@"accountStatus"];
                                     NSLog(@"userStatusStr %@",userStatusStr);
                                     if ([userStatusStr isEqualToString:@"ACCOUNT"]){
                                         
                                         [[NSUserDefaults standardUserDefaults] setValue:userNameandPin forKey:@"OntAccountId"];
                                         
                                         [self dashBoardView];
                                         
                                     }else if( [userStatusStr isEqualToString:@"VOUCHER"]){
                                         //Acount is Expired
                                         SPOndayPassVC *onePassViewCntr = [[SPOndayPassVC alloc] initWithNibName:@"SPOndayPassVC" bundle:nil];
                                         onePassViewCntr.headerStr = @"Withdrawal";
                                         onePassViewCntr.isExpUser = @"YES";
                                         onePassViewCntr.totalAmount = [amountValue doubleValue]/ 100.0;
                                         [self.navigationController pushViewController:onePassViewCntr animated:YES];
                                         
                                     }else{
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Your account is closed please create new account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alertView show];
                                     }
                                     
                                 }else if ([typeOfLoginStr isEqualToString:@"DV"]){
                                     
                                     userStatusStr = [[_userInfo valueForKey:@"response-content"] valueForKey:@"accountStatus"];
                                     NSLog(@"userStatusStr %@",userStatusStr);//accountId
                                     
                                     if ([userStatusStr isEqualToString:@"ACCOUNT"]){
                                         [[NSUserDefaults standardUserDefaults] setValue:[[_userInfo valueForKey:@"response-content"] valueForKey:@"accountId"] forKey:@"DVAccountId"];

                                         [self dashBoardView];
                                         
                                     }else if( [userStatusStr isEqualToString:@"VOUCHER"]){
                                         //Acount is Expired
                                         SPOndayPassVC *onePassViewCntr = [[SPOndayPassVC alloc] initWithNibName:@"SPOndayPassVC" bundle:nil];
                                         onePassViewCntr.headerStr = @"Withdrawal";
                                         onePassViewCntr.isExpUser = @"YES";
                                         onePassViewCntr.totalAmount = [amountValue doubleValue]/ 100.0;

                                         [self.navigationController pushViewController:onePassViewCntr animated:YES];
                                     }else{
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Your account is closed please create new account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alertView show];
                                     }
                                     
                                 }
                                 
                             }else{
                                 NSString *mesStr = [_userInfo valueForKey:@"response-message"];//response-message
                                 [self showAlertView:mesStr];
                             }
                             
                             [ZLAppDelegate hideLoadingView];
                             
                         }failure:^(NSError *error){
                             
                             [self.login_Button setEnabled:YES];
                             [ZLAppDelegate hideLoadingView];
                             
                             if (error.description == nil) {
                                 [self showAlertView:@"Invalid User credentials"];
                                 
                             }
                             else {
                                 NSString *mesStr = [NSString stringWithFormat:@"%@",error.description];
                                 [self showAlertView:mesStr];
                             }
                             
                             
                         }];
}

- (void)dashBoardView
{
    ZLMainGridViewController *mainGridViewController=[[ZLMainGridViewController alloc]init];
    [self.navigationController pushViewController:mainGridViewController animated:YES];
}
- (void)showAlertView:(NSString *)alertMes
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:alertMes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    alertView.delegate = self;
    [alertView show];
}


- (IBAction)back_Clicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)BackGroundClicked
{
    [self keyBoardResign];
    
}
- (void)keyBoardResign
{
    [self.userName_TF resignFirstResponder];
    [self.password_TF resignFirstResponder];
    [self.pinNumber_TF resignFirstResponder];
    [self.userNameTxtFld resignFirstResponder];
    [self.passwordTxtFld resignFirstResponder];
    [self.accountidTxtFld resignFirstResponder];
    [self.pinTxtFld resignFirstResponder];
}
- (IBAction)resetPassword:(id)sender
{
    
    [self keyBoardResign];
    ZLResetPasswordViewController *resetViewCntr = [[ZLResetPasswordViewController alloc] initWithNibName:@"ZLResetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:resetViewCntr animated:YES];
    
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.password_TF setText:@""];
    [self.pinNumber_TF setText:@""];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] <= 10 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark-
#pragma mark- TextField Delegate Method.

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.userName_TF) {
        [self.pinNumber_TF becomeFirstResponder];
    }
    if (textField == self.userNameTxtFld) {
        [self.passwordTxtFld becomeFirstResponder];
    }

    
	[textField resignFirstResponder];
	return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
	CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    
    int bottomValue,staticValue;
    if (IS_IPHONE5) {
        bottomValue = 300;
        staticValue = 305;//294
    }else{
        bottomValue = 170;
        staticValue = 185;
        
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

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    
    if ([textField.text  rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location == NSNotFound && textField.tag == 1) {
        
        /*if ([textField.text length] == 6) {
         
         textField.text = [NSString stringWithFormat:@"0000%@",textField.text];
         
         }
         else if ([textField.text length] == 7) {
         
         textField.text = [NSString stringWithFormat:@"000%@",textField.text];
         
         }
         if ([textField.text length] == 8) {
         
         textField.text = [NSString stringWithFormat:@"00%@",textField.text];
         
         }
         if ([textField.text length] == 9) {
         
         textField.text = [NSString stringWithFormat:@"0%@",textField.text];
         
         }
         
         self.userName_TF.text = textField.text;*/
    }
    
    
    if (self.view.frame.origin.y == 0) {
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
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    switch (textField.tag) {
            
        case 1: //Username Text field
        {
            
            //return YES;
            return ((newLength <= 30) ? YES : NO);
            
        }
            break;
            
        case 2: //Password Text field
            
            return (newLength <= 20) ? YES : NO;
            
        case 3: //Pin number Text Field
            
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return (newLength <= 4) ? YES : NO;
            
            break;
        case 4: //pin textField
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return (newLength <= 4) ? YES : NO;
            
            
            
            return YES;
            break;
            
            
        default:
            
            return YES;
            
            break;
    }
    
    
}


@end
