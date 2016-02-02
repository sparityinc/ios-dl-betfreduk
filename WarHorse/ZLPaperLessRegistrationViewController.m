//
//  ZLPaperLessRegistrationViewController.m
//  WarHorse
//
//  Created by Hiteshwar Vadlamudi on 21/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLPaperLessRegistrationViewController.h"
#import "ZLLoginViewController.h"
#import "ZLVerificationCodeViewController.h"
#import "ZLAPIWrapper.h"
#import "SPConstant.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

static NSString *const acceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@interface ZLPaperLessRegistrationViewController () 

@end

@implementation ZLPaperLessRegistrationViewController
@synthesize loginButton = _loginButton;
@synthesize registerBtn = _registerBtn;

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
    
    [self.userName_TF setPlaceholder:@" User name"];
    [self.userName_TF setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    _userName_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.pwd_TF setPlaceholder:@" Password"];
    [self.pwd_TF setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    _pwd_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.confirmPwd_TF setPlaceholder:@" Confirm Password"];
    [self.confirmPwd_TF setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    _confirmPwd_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.enterPin_TF setPlaceholder:@" Enter 4 digit PIN number"];
    [self.enterPin_TF setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    _enterPin_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.confirmPin_TF setPlaceholder:@" Confirm PIN number"];
    [self.confirmPin_TF setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    _confirmPwd_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.createActLabel setText:@"Create new account"];
    [self.createActLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    
    [self.accountLabel setText:@"Already have an account?"];
    [self.accountLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
    [_loginButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    [_registerBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
    if (IS_IPHONE5) {
        
        [_createActLabel setFrame:CGRectMake(_createActLabel.frame.origin.x, _createActLabel.frame.origin.y + 31, _createActLabel.frame.size.width, _createActLabel.frame.size.height)];
        [_usernameImgView setFrame:CGRectMake(_usernameImgView.frame.origin.x, _usernameImgView.frame.origin.y + 31, _usernameImgView.frame.size.width, _usernameImgView.frame.size.height)];
        [_passwordImgView setFrame:CGRectMake(_passwordImgView.frame.origin.x, _passwordImgView.frame.origin.y + 31, _passwordImgView.frame.size.width, _passwordImgView.frame.size.height)];
        [_cnfrmpswdImgView setFrame:CGRectMake(_cnfrmpswdImgView.frame.origin.x, _cnfrmpswdImgView.frame.origin.y + 31, _cnfrmpswdImgView.frame.size.width, _cnfrmpswdImgView.frame.size.height)];
        [_pinNumbrImgView setFrame:CGRectMake(_pinNumbrImgView.frame.origin.x, _pinNumbrImgView.frame.origin.y + 31, _pinNumbrImgView.frame.size.width, _pinNumbrImgView.frame.size.height)];
        [_cnfrmPinImgView setFrame:CGRectMake(_cnfrmPinImgView.frame.origin.x, _cnfrmPinImgView.frame.origin.y + 31, _cnfrmPinImgView.frame.size.width, _cnfrmPinImgView.frame.size.height)];
        [_registerBtn setFrame:CGRectMake(_registerBtn.frame.origin.x, _registerBtn.frame.origin.y + 31, _registerBtn.frame.size.width, _registerBtn.frame.size.height)];
        [_userName_TF setFrame:CGRectMake(_userName_TF.frame.origin.x, _userName_TF.frame.origin.y + 31, _userName_TF.frame.size.width, _userName_TF.frame.size.height)];
        [_pwd_TF setFrame:CGRectMake(_pwd_TF.frame.origin.x, _pwd_TF.frame.origin.y + 31, _pwd_TF.frame.size.width, _pwd_TF.frame.size.height)];
        [_enterPin_TF setFrame:CGRectMake(_enterPin_TF.frame.origin.x, _enterPin_TF.frame.origin.y + 31, _enterPin_TF.frame.size.width, _enterPin_TF.frame.size.height)];
        [_confirmPin_TF setFrame:CGRectMake(_confirmPin_TF.frame.origin.x, _confirmPin_TF.frame.origin.y + 31, _confirmPin_TF.frame.size.width, _confirmPin_TF.frame.size.height)];
        [_confirmPwd_TF setFrame:CGRectMake(_confirmPwd_TF.frame.origin.x, _confirmPwd_TF.frame.origin.y + 31, _confirmPwd_TF.frame.size.width, _confirmPwd_TF.frame.size.height)];
        [_accountLabel setFrame:CGRectMake(_accountLabel.frame.origin.x, _accountLabel.frame.origin.y + 31, _accountLabel.frame.size.width, _accountLabel.frame.size.height)];
        [_loginButton setFrame:CGRectMake(_loginButton.frame.origin.x, _loginButton.frame.origin.y + 31, _loginButton.frame.size.width, _loginButton.frame.size.height)];
        
    }
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    _userName_TF.leftView = paddingView;
    _userName_TF.rightView = paddingView;
    _userName_TF.leftViewMode = UITextFieldViewModeAlways;
    _userName_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    _pwd_TF.leftView = paddingView1;
    _pwd_TF.leftViewMode = UITextFieldViewModeAlways;
    _pwd_TF.rightView = paddingView1;
    _pwd_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    _enterPin_TF.leftView = paddingView2;
    _enterPin_TF.leftViewMode = UITextFieldViewModeAlways;
    _enterPin_TF.rightView = paddingView2;
    _enterPin_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    _confirmPwd_TF.leftView = paddingView3;
    _confirmPwd_TF.rightView = paddingView3;
    _confirmPwd_TF.leftViewMode = UITextFieldViewModeAlways;
    _confirmPwd_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    _confirmPin_TF.leftView = paddingView4;
    _confirmPin_TF.leftViewMode = UITextFieldViewModeAlways;
    _confirmPin_TF.rightView = paddingView4;
    _confirmPin_TF.rightViewMode = UITextFieldViewModeAlways;
    
}

#pragma mark - Private API

-(IBAction)backClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)registerClicked:(id)sender{
    
    UIAlertView *alert;
    
    if ([self.userName_TF.text isEqualToString:@""] || [self.pwd_TF.text isEqualToString:@""] || [self.confirmPwd_TF.text isEqualToString:@""] || [self.enterPin_TF.text isEqualToString:@""] || [self.confirmPin_TF.text isEqualToString:@""]) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
//        if (![self validateUsernameOrPassword:self.userName_TF.text]) {
//    
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username!" message:@"Your usename must contain one digit, one upper case letter, one lowercase letter, one special charater and must contain atleast 6 and maximum of 12 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//    
//        }
    
//        if (![self validateUsernameOrPassword:self.pwd_TF.text]) {
//    
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Password!" message:@"Your password must contain one digit, one upper case letter, one lowercase letter, one special charater and must contain atleast 6 and maximum of 12 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            return;
//    
//        }
    
    if (![self.pwd_TF.text isEqualToString:self.confirmPwd_TF.text]) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Passwords doesn't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.enterPin_TF.text intValue] <= 1000) {
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"PIN Number should be greater than 999" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    
    if (![self.enterPin_TF.text isEqualToString:self.confirmPin_TF.text]) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"PIN numbers doesn't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [ZLAppDelegate showLoadingView];
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.userName_TF.text,@"user_name",
                            self.pwd_TF.text,@"user_password",
                            self.enterPin_TF.text,@"user_pin",
                            nil];
    
    [apiWrapper savePaperLessUser:params atLat:[[NSUserDefaults standardUserDefaults] valueForKey:@"Latitude"] andLongitude:[[NSUserDefaults standardUserDefaults] valueForKey:@"Longitude"] success:^(NSDictionary *_userInfo) {
        
        [ZLAppDelegate hideLoadingView];
        NSString *succesMes = [_userInfo valueForKey:@"response-status"];
        if ([succesMes isEqualToString:@"success"]) {
            ZLVerificationCodeViewController *verificationView = [[ZLVerificationCodeViewController alloc] init];
            [verificationView setResponseDictionary:_userInfo];
            [self.navigationController pushViewController:verificationView animated:YES];
            
        }else{
            [ZLAppDelegate hideLoadingView];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"User already exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }
        
        
        
    }
    failure:^(NSError *error)
     {
         [ZLAppDelegate hideLoadingView];
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Save" message:@"Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         
         [alert show];
     }];
    
}

- (BOOL)validateUsernameOrPassword:(NSString *)usernameOrpassword
{
    
    NSString *emailRegex =
    @"((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,12})";
    NSPredicate *usernameOrPasswordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [usernameOrPasswordTest evaluateWithObject:usernameOrpassword];
    
}

-(IBAction)loginClicked:(id)sender
{
    ZLLoginViewController *loginView = [[ZLLoginViewController alloc] initWithNibName:@"ZLLoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginView animated:YES];
}

-(IBAction)BackGroundClicked{
    [self.userName_TF resignFirstResponder];
    [self.pwd_TF resignFirstResponder];
    [self.confirmPwd_TF resignFirstResponder];
    [self.enterPin_TF resignFirstResponder];
    [self.confirmPin_TF resignFirstResponder];
}
#pragma mark-
#pragma mark- TextField Delegate Method.

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.userName_TF) {
        [self.pwd_TF becomeFirstResponder];
        return YES;
    }
    else if (textField == self.pwd_TF)
    {
        [self.confirmPwd_TF becomeFirstResponder];
        return YES;
    }
    else if (textField == self.confirmPwd_TF)
    {
        [self.enterPin_TF becomeFirstResponder];
        return YES;
    }
    
	[textField resignFirstResponder];
	return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
	CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
	if (bottomEdge >= 250) {//250
        CGRect viewFrame = self.view.frame;
        self.shiftForKeyboard = bottomEdge - 200;
        viewFrame.origin.y -= self.shiftForKeyboard;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:0.3];
        [self.view setFrame:viewFrame];
        [UIView commitAnimations];
		
	} else {
		self.shiftForKeyboard = 0.0f;
	}
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
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
            
            return ((newLength <= 12) ? YES : NO);
            
        }
            break;
            
        case 2: //Password Text field
        case 3:
            
            return (newLength <= 12) ? YES : NO;
            
            break;
            
        case 4: //Pin number Text Field
        case 5:
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return (newLength <= 4) ? YES : NO;
            
            break;
            
        default:
            
            return NO;
            
            break;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
