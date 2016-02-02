//
//  ZLRegisterViewController.m
//  WarHorse
//
//  Created by Sparity on 8/6/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLAnonymousUserRegistrationViewController.h"
#import "ZLLoginViewController.h"
#import "ZLVerificationCodeViewController.h"
#import "ZLAPIWrapper.h"
#import "SPConstant.h"
#import "ZLAppDelegate.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

static NSString *const acceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

@interface ZLAnonymousUserRegistrationViewController ()

@end

@implementation ZLAnonymousUserRegistrationViewController
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
    [self.enterPin_TF setPlaceholder:@" Enter 4 digit PIN number"];
    [self.enterPin_TF setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    _enterPin_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.confirmPin_TF setPlaceholder:@" Confirm PIN number"];
    [self.confirmPin_TF setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    _confirmPwd_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.createActLabel setText:@"Register"];
    [self.createActLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    
    [self.accountLabel setText:@"Already registered?"];
    [self.accountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [_loginButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [_registerBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.enterPin_TF.text =@"";
    self.confirmPin_TF.text = @"";
}

#pragma mark - Private API

-(IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)registerClicked:(id)sender
{
    
    
    UIAlertView *alert;
    
    if (  [self.enterPin_TF.text isEqualToString:@""] || [self.confirmPin_TF.text isEqualToString:@""]) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill all the fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    
    if (![self.enterPin_TF.text isEqualToString:self.confirmPin_TF.text]) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"PIN numbers does't match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if ([self.enterPin_TF.text intValue] <= 1000) {
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"PIN number should be greater than 999" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self.confirmPin_TF resignFirstResponder];
    
    CGFloat axisY;
    if (IS_IPHONE5) {
        axisY = 269;
    }
    else {
        axisY = 215;
    }
    
    //UIActivityIndicatorView *spinner;
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, axisY, 50, 50)];
        [self.view addSubview:spinner];
    }
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    
    [apiWrapper registerOneDayUserWithDetails:_enterPin_TF.text success:^(NSDictionary *userDict){
        [spinner stopAnimating];
        self.enterPin_TF.text =@"";
        self.confirmPin_TF.text = @"";
        if ([[userDict valueForKey:@"response-status"] isEqualToString:@"success"]){
            
            NSString *accountId = [[userDict valueForKey:@"response-content"] valueForKey:@"toteAccountId"];
            [[NSUserDefaults standardUserDefaults] setValue:accountId forKey:@"AccountID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *successMes = [NSString stringWithFormat:@"User Registered Successfully. Your Account Pin is %@",accountId];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success"
                                                              message:successMes
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
            
            
        }else{
            [spinner stopAnimating];
            
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                              message:@"Failed to register."
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
        
        
        
    }failure:^(NSError *error){
        
        NSLog(@"Error: %@", error);
        [spinner stopAnimating];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                          message:@"Failed to register."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
        
    }];
    
    
    
}

- (BOOL)validateUsernameOrPassword:(NSString *)usernameOrpassword
{
    
    NSString *emailRegex =
    @"((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%]).{6,12})";
    NSPredicate *usernameOrPasswordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [usernameOrPasswordTest evaluateWithObject:usernameOrpassword];
    
}

- (IBAction)loginClicked:(id)sender
{
    ZLLoginViewController *loginView = [[ZLLoginViewController alloc] initWithNibName:@"ZLLoginViewController" bundle:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"BetFred-ODP" forKey:@"ClientId"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    loginView.typeOfUser = @"ODP";
    [self.navigationController pushViewController:loginView animated:YES];
}

-(IBAction)BackGroundClicked
{
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
