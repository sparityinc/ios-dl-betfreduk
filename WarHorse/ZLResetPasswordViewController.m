//
//  ZLResetPasswordViewController.m
//  WarHorse
//
//  Created by Sparity on 8/6/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLResetPasswordViewController.h"
#import "ZLAPIWrapper.h"
#import "LeveyHUD.h"
#import "ZLAppDelegate.h"

@interface ZLResetPasswordViewController ()

@property (nonatomic,strong) IBOutlet UIView *resetPasswordView;
@property (nonatomic,strong) IBOutlet UIView *forgotPasswordView;
@property (nonatomic,strong) IBOutlet UITextField *verificationCodeTF;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognize,*singleTapGestureRecognize1;
@property (strong ,nonatomic) IBOutlet UILabel *resetPasswordLbl;
@property (strong,nonatomic) NSString *consumerId;
@property (strong,nonatomic) IBOutlet UILabel *forgotLabel1;
@property (strong,nonatomic) IBOutlet UILabel *forgotLabel2;

@property (strong ,nonatomic) IBOutlet UILabel *resetPassMesLbl;
@property (strong ,nonatomic) IBOutlet UILabel *resetPassMesLbl1;

@property (nonatomic, strong) IBOutlet UIButton *resetBtn;
@end

@implementation ZLResetPasswordViewController
@synthesize Pwd_TF=_Pwd_TF;
@synthesize resetLabel = _resetLabel;
@synthesize submitBtn = _submitBtn;

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
    
    if (IS_IPHONE5)
    {
        self.logoImageView.frame = CGRectMake(71, 45, 176, 119);
        self.resetPasswordView.frame = CGRectMake(0, 49, 320, 500);
        
        self.resetBtn.frame = CGRectMake(31, 329, 258, 44);
        
        self.verificationCodeTF.frame = CGRectMake(71, 182, 218, 40);
        self.Pwd_TF .frame = CGRectMake(71, 236, 218, 40);
        self.confirmPwd_TF.frame = CGRectMake(71, 290, 218, 40);
        
        self.verificationImage.frame = CGRectMake(31, 182, 40, 40);
        self.passwordImg.frame = CGRectMake(31, 236, 40, 40);
        
        self.confirmPwdImage.frame = CGRectMake(31, 290, 40, 40);
        
        self.submitButton.frame = CGRectMake(31, 344, 258, 44);
        self.refreshBtn.frame = CGRectMake(58, 405, 203, 24);
        
    }
    
    [self.resetPasswordLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    
    [self.forgotLabel1 setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    self.forgotLabel1.text = @"Please enter the email address associated with your account and we will send an email with instructions to reset your password.";
    
    
    [self.forgotLabel2 setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    self.forgotLabel2.text =@"If you need further assistance please contact Customer Support.";
    
    [self.resetPassMesLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    self.resetPassMesLbl.text = @"Verification code is sent to your E-mail Address.Please check your email...";
    
    [self.resetLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:24]];
    
    [self.Pwd_TF setPlaceholder:@"New Password"];
    _Pwd_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.confirmPwd_TF setPlaceholder:@"Confirm Password"];
    _confirmPwd_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [_submitBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    _Pwd_TF.leftView = paddingView;
    _Pwd_TF.rightView = paddingView;
    _Pwd_TF.leftViewMode = UITextFieldViewModeAlways;
    _Pwd_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    _confirmPwd_TF.leftView = paddingView1;
    _confirmPwd_TF.leftViewMode = UITextFieldViewModeAlways;
    _confirmPwd_TF.rightView = paddingView1;
    _confirmPwd_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.verificationCodeTF.leftView = paddingView2;
    self.verificationCodeTF.rightView = paddingView2;
    self.verificationCodeTF.leftViewMode = UITextFieldViewModeAlways;
    self.verificationCodeTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.email_TF.leftView = paddingView3;
    self.email_TF.rightView = paddingView3;
    self.email_TF.leftViewMode = UITextFieldViewModeAlways;
    self.email_TF.rightViewMode = UITextFieldViewModeAlways;
    [self.email_TF setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    
    
    if (IS_IPHONE5)
    {
        self.resetPasswordView.frame = CGRectMake(0, 80, self.resetPasswordView.frame.size.width, self.resetPasswordView.frame.size.height);
        
        self.forgotPasswordView.frame = CGRectMake(0, 80, self.forgotPasswordView.frame.size.width, self.forgotPasswordView.frame.size.height);
    }
    
    self.singleTapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    self.singleTapGestureRecognize.numberOfTapsRequired = 1;
    [self.resetPasswordView addGestureRecognizer:self.singleTapGestureRecognize];
    
    self.singleTapGestureRecognize1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    self.singleTapGestureRecognize1.numberOfTapsRequired = 1;
    [self.forgotPasswordView addGestureRecognizer:self.singleTapGestureRecognize1];
    
    
}

- (void)resignKeyBoard
{
    
    [self.email_TF resignFirstResponder];
    [self.verificationCodeTF resignFirstResponder];
    [self.Pwd_TF resignFirstResponder];
    [self.confirmPwd_TF resignFirstResponder];
    
}

- (IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)resestPassword:(id)sender
{
    [self.email_TF resignFirstResponder];
    [self emailVerificationForServer];
    
}
- (IBAction)submitClicked:(id)sender
{
    [self resignKeyBoard];
    [self resetPasswordForServer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ---
#pragma Server Calls


- (void)emailVerificationForServer
{
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    
    if (![self validateEmail:self.email_TF.text])
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please enter a valid Email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[LeveyHUD sharedHUD] appearWithText:@"Checking Email..."];
    
    NSDictionary *argumentsDic = @{@"emailId": self.email_TF.text};
    [apiwrapper sendVerificationCodeForPassword:argumentsDic success:^(NSDictionary *userInfo)
     {
         
         
         NSString *successStatus = [userInfo objectForKey:@"response-status"];
         
         if( [successStatus isEqualToString:@"success"])
         {
             self.consumerId = [[userInfo valueForKey:@"response-content"]valueForKey:@"consumerId"];
             [self.resetPasswordView setHidden:YES];
             [self.forgotPasswordView setHidden:NO];
         }else{
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:[[userInfo objectForKey:@"response-content"] valueForKey:@"statusDescription"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             
             
         }
         
         [[LeveyHUD sharedHUD] disappear];
     }failure:^(NSError *error)
     {
         [[LeveyHUD sharedHUD] disappear];
         
         //         NSLog(@"error %@",error.description);
         //         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FAILED!" message:error.d delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         //         [alert show];
         
         
     }];
    
}


-(void)resetPasswordForServer
{
    
    UIAlertView *alert;
    
    if ([self.verificationCodeTF.text isEqualToString:@""]|| [self.Pwd_TF.text isEqualToString:@""]||[self.confirmPwd_TF.text isEqualToString:@""]){
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill all the fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    
    if (![self isPasswordValid:self.Pwd_TF.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Password" message:@"Your password must be a minimum of 6 characters and must contain 1 uppercase letter, 1 lowercase letter and 1 number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    if (![self.Pwd_TF.text isEqualToString:self.confirmPwd_TF.text])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Passwords doesn't match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    
    
    NSDictionary *argumentsDic = @{@"verificationCode": self.verificationCodeTF.text,
                                   @"newPassword" : self.Pwd_TF.text,
                                   @"consumerId" : self.consumerId
                                   };
    
    
    [[LeveyHUD sharedHUD] appearWithText:@"Resetting Password..."];
    [apiwrapper resetAccountPassword:argumentsDic success:^(NSDictionary *userDict){
        
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[userDict valueForKey:@"response-status"]isEqualToString:@"success"]){//SUCCESS
            //NSLog(@"userDict %@",userDict);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[userDict valueForKey:@"response-content"] valueForKey:@"statusMessage"] message:[[userDict valueForKey:@"response-content"] valueForKey:@"statusDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[[userDict valueForKey:@"response-content"] valueForKey:@"statusMessage"] message:[[userDict valueForKey:@"response-content"] valueForKey:@"statusDescription"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }failure:^(NSError *error)
     {
         
         //         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:[[userDict valueForKey:@"response-content"] valueForKey:@"statusDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         //         [alert show];
         [[LeveyHUD sharedHUD] disappear];
         
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)resendVerificationCode
{
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    //NSLog(@"self.email_TF.text %@",self.email_TF.text);
    
    
    
    [[LeveyHUD sharedHUD] appearWithText:@"Resend verification code!..."];
    
    NSDictionary *argumentsDic = @{@"emailId": self.email_TF.text};
    [apiwrapper sendVerificationCodeForPassword:argumentsDic success:^(NSDictionary *userInfo)
     {
         
         
         NSString *successStatus = [userInfo objectForKey:@"response-status"];
         
         if( [successStatus isEqualToString:@"success"])
         {
             self.consumerId = [[userInfo valueForKey:@"response-content"]valueForKey:@"consumerId"];
         }else{
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:[[userInfo objectForKey:@"response-content"] valueForKey:@"statusDescription"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             
             
             
         }
         
         [[LeveyHUD sharedHUD] disappear];
     }failure:^(NSError *error)
     {
         [[LeveyHUD sharedHUD] disappear];
         
         //         NSLog(@"error %@",error.description);
         //         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FAILED!" message:error.d delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         //         [alert show];
         
         
     }];
    
}


- (BOOL)validateEmail:(NSString *) emailAddress
{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailAddress];
}



- (BOOL)isPasswordValid:(NSString *)pwd {
    
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    
    //NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ( [pwd length]<6 || [pwd length]>20 )

        return NO;  // too long or too short

    NSRange rang;
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )

        return NO;  // no number;
    rang = [pwd rangeOfCharacterFromSet:upperCaseChars];
    if ( !rang.length )

        return NO;  // no uppercase letter;
    rang = [pwd rangeOfCharacterFromSet:lowerCaseChars];
    if ( !rang.length )

        return NO;  // no lowerCase Chars;
    return YES;
}

#pragma mark - UIText Field Delegate Methods

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
        
    
	CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
	if (bottomEdge >= 140) {//250
        CGRect viewFrame = self.view.frame;
        
        if (IS_IPHONE5){
            self.shiftForKeyboard = bottomEdge - 285;//193
            
        }else{
            self.shiftForKeyboard = bottomEdge - 193;//193
        }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
     if (textField == self.confirmPwd_TF) {
     [self.confirmPwd_TF resignFirstResponder];
     }
    
    
    
    if (textField ==self.verificationCodeTF ) {
		[textField resignFirstResponder];
		[self.Pwd_TF becomeFirstResponder];
	}
	else if (textField == self.Pwd_TF) {
		[textField resignFirstResponder];
		[self.confirmPwd_TF becomeFirstResponder];
	}
	else if (textField == self.confirmPwd_TF) {
		[textField resignFirstResponder];
	}

    if (textField == self.email_TF) {
        [self.email_TF resignFirstResponder];
    }
    
	return YES;
    
}



@end
