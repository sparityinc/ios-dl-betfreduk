//
//  SPRegistrationVC.m
//  WarHorse
//
//  Created by APPLE on 19/05/15.
//  Copyright (c) 2015 Zytrix Labs. All rights reserved.
//

#import "SPRegistrationVC.h"
#import "WarHorseSingleton.h"
#import "ZLAPIWrapper.h"
#import "LeveyHUD.h"
#import "ZLAppDelegate.h"
#import "ZLVerificationCodeViewController.h"
#import "SPTermsAndConditionsViewController.h"


static NSString *const acceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
static NSString *const emailAcceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@._";

@interface SPRegistrationVC ()<UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    BOOL enableInfo;
    NSInteger noOfSegments;
    BOOL enablepromo;
    
    int infoScreenIndex;

  

}
@property (strong, nonatomic) IBOutlet UIButton *registrationFormBtn;
@property (strong, nonatomic) IBOutlet UIButton *accountInfoBtn;
@property (strong, nonatomic) IBOutlet UIView *registrationView;
@property (strong, nonatomic) IBOutlet UIView *accountInfoView;
@property (strong, nonatomic) IBOutlet UITextField *accountNumberTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *accountPinTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *stateTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *ssnTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *phoneTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *promotionalCodeTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *pswdTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *confirmPswdTxtFld;
@property (strong, nonatomic) UITapGestureRecognizer *infoTapRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *textView1;
@property	CGFloat shiftForKeyboard;
@property (strong,nonatomic) IBOutlet UIButton *stateDropDownBoxBtn;
@property (strong,nonatomic) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *userlabel;
@property (strong,nonatomic) NSArray *statesCodesArray;
@property (strong ,nonatomic) UIPickerView *statesPickerView;
@property (strong, nonatomic) UIToolbar *pickerToolBar1;
@property (nonatomic, strong) NSString *pickerSelectedStateString;
@property (nonatomic, strong) NSString *pickerSelectedStateCodeString;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;

@property (strong, nonatomic) IBOutlet UIImageView *promotionalImgView;
@property (strong, nonatomic) NSString *consumerId;
@property (strong, nonatomic) NSString *promocrmFieldName;


@property (nonatomic,strong) IBOutlet UIButton *infoBtn;
@property (strong,nonatomic) IBOutlet  UIView *infoPopView;
@property (nonatomic,strong) IBOutlet UIWebView *infoWebView;
@property (strong, nonatomic) IBOutlet UIView *termsAndConditionsView;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (nonatomic,strong) IBOutlet UILabel *onlineViewHeader;

@property (strong, nonatomic) IBOutlet UITextView *termsAndConditionTextView;


- (IBAction)checkBoxSelected:(id)sender;

- (IBAction)createAccount:(id)sender;
- (IBAction)nextBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;


@end

@implementation SPRegistrationVC
@synthesize registerAppConfigDict;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    
    enableInfo = YES;
    infoScreenIndex = 1;
    NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"existreg_s1_info"];
    if (infoStr.length == 0){
        self.infoBtn.hidden = YES;
    }else{
        self.infoBtn.hidden = NO;
        
    }
    
 //  self.textView1.text = @"**Please note that only Connecticut residents are permitted to open accounts and wager online at Totepoolliveinfo.com.";
    self.textView1.textColor = [UIColor blackColor];
    self.textView1.editable = NO;
    self.textView1.scrollEnabled = NO;
    //To make the border look very close to a UITextField
    [self.textView1.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.textView1.layer setBorderWidth:1.0];
    [self.textView1 setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]];
    
    //The rounded corner part, where you specify your view's corner radius:
    self.textView1.layer.cornerRadius = 1.0;
    self.textView1.clipsToBounds = YES;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.textView1.frame.origin.y +self.textView1.frame.size.height + 20);
    self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    self.singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:self.singleTapGestureRecognizer];
    
    
    [self.stateDropDownBoxBtn addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.stateDropDownBoxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 10, 200, 36)];
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    self.titleLabel.textColor=[UIColor colorWithRed:(30/255.0) green:(30/255.0) blue:(30/255.0) alpha:1];
    self.titleLabel.shadowColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.7];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 0.8);
    [self.stateDropDownBoxBtn addSubview:self.titleLabel];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.titleLabel setText:[self.registerAppConfigDict valueForKey:@"reg_default_state"]];
    [[WarHorseSingleton sharedInstance] setStateString:[self.registerAppConfigDict valueForKey:@"reg_default_state"]];
    [[WarHorseSingleton sharedInstance] setStateCodeString:@"CT"];
    
    
    self.userlabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 68, 300.0,40.0)];
    self.userlabel.numberOfLines = 0;
    self.userlabel.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:241.0/255.0 blue:202.0/255.0 alpha:1];
    [self.userlabel setFont:[UIFont fontWithName:@"Roboto-Light" size:10]];
    self.userlabel.textAlignment = NSTextAlignmentCenter;
    self.userlabel.layer.borderWidth = 1.0;
    [self.userlabel setHidden:YES];
    [self.view addSubview:self.userlabel];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StateCodes" ofType:@"plist"];
    self.statesCodesArray = [[NSArray alloc] initWithContentsOfFile:path];
    [self prepareRegistrationForm];
    [self prepareAccountInfoScreen];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareRegistrationForm
{
    enablepromo = [[self.registerAppConfigDict valueForKey:@"promo_code_enabled"] boolValue];

    if (enablepromo == YES) {
        self.promotionalCodeTxtFld.hidden = NO;
        self.promotionalImgView.hidden = NO;
        
    }
    else{
        enablepromo = NO;
        self.promotionalCodeTxtFld.hidden = YES;
        self.promotionalImgView.hidden = YES;
        [self.nextBtn setFrame:CGRectMake(10, 286, 300, 36)];
        [self.textView1 setFrame:CGRectMake(10, 330, 300, 62)];

    }
    
    [self.stateDropDownBoxBtn setFrame:CGRectMake(13, 91, 297, 36)];

    [self.accountNumberTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.accountNumberTxtFld.layer setBorderWidth:1.0];
    
    [self.accountPinTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.accountPinTxtFld.layer setBorderWidth:1.0];
    
    [self.stateTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.stateTxtFld.layer setBorderWidth:1.0];
    
    [self.ssnTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.ssnTxtFld.layer setBorderWidth:1.0];
    
    [self.emailTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.emailTxtFld.layer setBorderWidth:1.0];
    
    
    [self.phoneTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.phoneTxtFld.layer setBorderWidth:1.0];
    
    [self.promotionalCodeTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.promotionalCodeTxtFld.layer setBorderWidth:1.0];
    

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.accountNumberTxtFld.leftView = paddingView;
    self.accountNumberTxtFld.rightView = paddingView;
    self.accountNumberTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.accountNumberTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.accountPinTxtFld.leftView = paddingView2;
    self.accountPinTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.accountPinTxtFld.rightView = paddingView2;
    self.accountPinTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.stateTxtFld.leftView = paddingView3;
    self.stateTxtFld.rightView = paddingView3;
    self.stateTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.stateTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.ssnTxtFld.leftView = paddingView4;
    self.ssnTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.ssnTxtFld.rightView = paddingView4;
    self.ssnTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.emailTxtFld.leftView = paddingView5;
    self.emailTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.emailTxtFld.rightView = paddingView5;
    self.emailTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.phoneTxtFld.leftView = paddingView6;
    self.phoneTxtFld.rightView = paddingView6;
    self.phoneTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.promotionalCodeTxtFld.leftView = paddingView7;
    self.promotionalCodeTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.promotionalCodeTxtFld.rightView = paddingView7;
    self.promotionalCodeTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
}
- (void)prepareAccountInfoScreen
{
   
    
    self.onlineViewHeader.text = [self.registerAppConfigDict valueForKey:@"newreg_s3_web_header"];
    self.onlineViewHeader.font =     [UIFont fontWithName:@"Roboto-Medium" size:13];
    self.onlineViewHeader.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];

    self.onlineView.frame =CGRectMake(10, 10, self.onlineView.frame.size.width, self.onlineView.frame.size.height);
    self.onlineView.layer.borderWidth = 1.0;
    self.onlineView.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0 green:190.0f/255.0 blue:190.0f/255.0 alpha:1.0] CGColor];

    
    [self.userNameTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.userNameTxtFld.layer setBorderWidth:1.0];
    
    [self.pswdTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.pswdTxtFld.layer setBorderWidth:1.0];
    
    [self.confirmPswdTxtFld.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.confirmPswdTxtFld.layer setBorderWidth:1.0];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.userNameTxtFld.leftView = paddingView;
    self.userNameTxtFld.rightView = paddingView;
    self.userNameTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.pswdTxtFld.leftView = paddingView2;
    self.pswdTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.pswdTxtFld.rightView = paddingView2;
    self.pswdTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.confirmPswdTxtFld.leftView = paddingView3;
    self.confirmPswdTxtFld.rightView = paddingView3;
    self.confirmPswdTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPswdTxtFld.rightViewMode = UITextFieldViewModeAlways;
    
    self.termsAndConditionsView.layer.borderWidth = 1.0;
    self.termsAndConditionsView.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0 green:190.0f/255.0 blue:190.0f/255.0 alpha:1.0] CGColor];
    self.termsAndConditionTextView.text = @"I have read and understand these Terms and Conditions and agree to abide by the account wagering policies and procedures.";
    self.termsAndConditionTextView.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    
    self.termsAndConditionTextView.attributedText = [self attributedTextViewString];
    
    
    UITapGestureRecognizer *termsandconditionTap;
    if (!termsandconditionTap){
        termsandconditionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];
        
    }
    [self.termsAndConditionTextView addGestureRecognizer:termsandconditionTap];

}


#pragma mark ---
#pragma mark AttributedTextViewString

- (NSAttributedString *)attributedTextViewString
{
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"I have read and understand these Terms & conditions and agree to abide by the account wagering policies and procedures."];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0] range:NSMakeRange(0,33)];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:166.0/255.0 green:0.0/255.0 blue:43.0/255.0 alpha:1.0] range:NSMakeRange(33,19)];
    
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"Roboto-BoldCondensed" size:12]
                   range:NSMakeRange(33, 19)];
    
    
    
    
    return [string copy];
}

- (void)textTapped:(UITapGestureRecognizer *)recognizer
{
    UITextView *textView = (UITextView *)recognizer.view;
    
    // Location of the tap in text-container coordinates
    
    NSLayoutManager *layoutManager = textView.layoutManager;
    CGPoint location = [recognizer locationInView:textView];
    location.x -= textView.textContainerInset.left;
    location.y -= textView.textContainerInset.top;
    
    NSLog(@"location: %@", NSStringFromCGPoint(location));
    
    // Find the character that's been tapped on
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:textView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    NSLog(@"characterIndex %lu",(unsigned long)characterIndex);
    
    int lowValue = 32;
    int hightValue =52;
    
    
    NSLog(@"textView.textStorage.length %lu",(unsigned long)textView.textStorage.length);
    
    
    if (characterIndex < textView.textStorage.length) {
        
        if (lowValue < characterIndex && characterIndex < hightValue){
            NSLog(@"Final");
            SPTermsAndConditionsViewController *termsAndConditionViewController = [[SPTermsAndConditionsViewController alloc] initWithNibName:@"SPTermsAndConditionsViewController" bundle:nil];
            termsAndConditionViewController.isRegistrationFlag = YES;
            
            [self.navigationController pushViewController:termsAndConditionViewController animated:YES];
            
        }
        
    }
}



/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)switchBetweenRegistrationAndAccountInfo:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            infoScreenIndex = 1;
            NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"existreg_s1_info"];
            if (infoStr.length == 0){
                self.infoBtn.hidden = YES;
            }else{
                self.infoBtn.hidden = NO;
                
            }

            if (sender.selected == YES) {
                [sender setSelected:NO];
            }
            
            if (self.accountInfoBtn.selected == YES) {
                [self.accountInfoBtn setSelected:NO];
            
                self.registrationView.hidden = NO;
                [self.accountInfoBtn setEnabled:NO];
                
                [self.registrationView setFrame:CGRectMake(-320.0, 108, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.registrationView setFrame:CGRectMake(0.0, 0, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                                 }
                                 completion:nil];
            }else{
                self.registrationView.hidden = NO;
                [self.registrationFormBtn setEnabled:YES];
                [self.accountInfoBtn setEnabled:NO];
                [self.registrationFormBtn setTitleColor:[UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0] forState:UIControlStateNormal];

                [self.registrationFormBtn setImage:[UIImage imageNamed:@"registerform.png"] forState:UIControlStateNormal];
                [self.registrationFormBtn setImage:[UIImage imageNamed:@"registerform.png"] forState:UIControlStateHighlighted];
                [self.registrationFormBtn setImage:[UIImage imageNamed:@"registerform.png"] forState:UIControlStateSelected];
                
                [self resignKeyBoard];
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.registrationView setFrame:CGRectMake(0.0, 0, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                                 }
                                 completion:nil];
                
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.accountInfoView setFrame:CGRectMake(320.0f, 108, self.accountInfoView.frame.size.width, self.accountInfoView.frame.size.height)];
                                 }
                                 completion:^(BOOL finished) {
                                     self.accountInfoView.hidden = YES;
                                 }];
            }
        }

    break;
        case 2:
        {
            infoScreenIndex = 2;
            NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"existreg_s2_info"];
            if (infoStr.length == 0){
                self.infoBtn.hidden = YES;
            }else{
                self.infoBtn.hidden = NO;
                
            }
            if (sender.selected == YES) {
                [sender setSelected:NO];
            }
            
            self.accountInfoView.hidden = NO;
            [self.accountInfoBtn setEnabled:YES];
            
                      [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.accountInfoView setFrame:CGRectMake(0.0, 108, self.accountInfoView.frame.size.width, self.accountInfoView.frame.size.height)];
                             }
                             completion:nil];
            }
            break;
            
          }
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


- (void)alertViewMethod:(NSString *)title messageText:(NSString *)mes
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:mes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}


- (IBAction)nextBtnClicked:(id)sender
{
    [self resignKeyBoard];
    if ([self.accountNumberTxtFld.text isEqualToString:@""] || [self.accountPinTxtFld.text isEqualToString:@""] || [self.ssnTxtFld.text isEqualToString:@""] || [self.emailTxtFld.text isEqualToString:@""] || [self.phoneTxtFld.text isEqualToString:@""]) {
        [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
        
        return;
    }
    NSInteger totepinNo = [self.accountPinTxtFld.text integerValue];

    if (totepinNo<=0){
        [self alertViewMethod:@"Information" messageText:@"Please enter valid PIN"];
        return;
    }
    if (![[[WarHorseSingleton sharedInstance] stateString] isEqualToString:@"Connecticut"])
    {
        [self alertViewMethod:@"Information" messageText:@"Only Connecticut residents are permitted to open accounts for online wagering."];
        
        return;
    }
    if ([self.ssnTxtFld.text length] < 4) {
        
        [self alertViewMethod:@"Information" messageText:@"Please enter your last 4 digit SSN number"];
        return;
    }
    if (![self validateEmail:self.emailTxtFld.text])
    {
        [self alertViewMethod:@"Information" messageText:@"Please enter a valid Email address"];
        return;
    }

    
    if ([self.phoneTxtFld.text length] < 12) {
        
        [self alertViewMethod:@"Information" messageText:@"Please enter your 10 digit mobile number"];
        
        return;
    }
    
    
    [self.registrationFormBtn setSelected:YES];
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];

    NSDictionary *argumentsDic = @{@"toteAccountId":self.accountNumberTxtFld.text,
                                   @"toteAccountPin":self.accountPinTxtFld.text,
                                   @"ssn": self.ssnTxtFld.text,
                                   @"email":self.emailTxtFld.text,
                                   @"state":[[WarHorseSingleton sharedInstance] stateCodeString],
                                   @"mobilePhone":[self.phoneTxtFld.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                   @"promocode":self.promotionalCodeTxtFld.text
                                   };
    [apiwrapper validateExistingAccount:argumentsDic success:^(NSDictionary *userInfo){
        infoScreenIndex = 2;
        
        [[LeveyHUD sharedHUD] disappear];

        if ([[userInfo valueForKey:@"response-status"] isEqualToString:@"success"]){
            
            NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"existreg_s2_info"];
            if (infoStr.length == 0){
                self.infoBtn.hidden = YES;
            }else{
                self.infoBtn.hidden = NO;
                
            }
            
            
            self.consumerId =[NSString stringWithString:[[userInfo valueForKey:@"response-content"] valueForKey:@"consumerId"]];
            self.promocrmFieldName = [NSString stringWithString:[[userInfo valueForKey:@"response-content"] valueForKey:@"promocrmFieldName"]];

            
            if ([self.promotionalCodeTxtFld.text isEqualToString:@""]){
                [self accountInformationScreen];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[userInfo valueForKey:@"response-content"] valueForKey:@"promoname"] message:[[userInfo valueForKey:@"response-content"] valueForKey:@"promodescription"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                alertView.tag = 100;
                [alertView show];
            }
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[userInfo valueForKey:@"response-message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        }

        
        
    }failure:^(NSError *error){
        [[LeveyHUD sharedHUD] disappear];
    }];


}


- (IBAction)checkBoxSelected:(UIButton *)sender {
    
    if (sender.selected == YES) {
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
}

- (IBAction)createAccount:(id)sender
{
    [self resignKeyBoard];
    
    
    if ( [self.userNameTxtFld.text isEqualToString:@""] || [self.pswdTxtFld.text isEqualToString:@""]|| [self.confirmPswdTxtFld.text isEqualToString:@""]) {
        
        [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
        
        return;
    }
    //Your username must contain at least 6 and a maximum of 12 characters
    
    if ([self.userNameTxtFld.text length] < 5){
        
        [self alertViewMethod:@"Invalid User" messageText:@"Your username must contain at least 6 and a maximum of 12 characters"];
        return;
        
    }
    if (![self validateUsernameOrPassword:self.pswdTxtFld.text]) {
        
        [self alertViewMethod:@"Invalid Password" messageText:@"our password must be a minimum of 6 characters and must contain 1 uppercase letter, 1 lowercase letter and 1 number."];
        return;
        
    }
    
    if (![self.pswdTxtFld.text isEqualToString:self.confirmPswdTxtFld.text]) {
        
        [self alertViewMethod:@"Information" messageText:@"Password doesn't match"];
        return;
    }
    
    if (self.checkBoxBtn.selected == NO) {
        [self alertViewMethod:@"Information" messageText:@"Please agree Terms and Conditions"];
        return;
        
    }
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Registration..."];
    NSDictionary *argumentsDic = @{@"username":self.userNameTxtFld.text,
                                   @"password":self.pswdTxtFld.text,
                                   @"consumerId": self.consumerId,
                                   @"crmFieldName":self.promocrmFieldName,
                                   @"toteAccountPin":self.accountPinTxtFld.text
                                   };
    
    [apiwrapper registerExistingUser:argumentsDic success:^(NSDictionary *userInfo){
        
        [[LeveyHUD sharedHUD] disappear];
        
        if ([[userInfo valueForKey:@"response-status"] isEqualToString:@"success"]){
            
            
            ZLVerificationCodeViewController *accountIdViewCntrl = [[ZLVerificationCodeViewController alloc] initWithNibName:@"ZLVerificationCodeViewController" bundle:nil];
            accountIdViewCntrl.userDetailsDict = [userInfo valueForKey:@"response-content"];
            accountIdViewCntrl.userName = self.userNameTxtFld.text;
            [self.navigationController pushViewController:accountIdViewCntrl animated:YES];

            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[userInfo valueForKey:@"response-message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
        
        
        
    }failure:^(NSError *error){
        [[LeveyHUD sharedHUD] disappear];
    }];

    
}


- (void)accountInformationScreen
{
    self.accountInfoView.hidden = NO;
    [self.accountInfoBtn setEnabled:YES];
    
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.registrationView setFrame:CGRectMake(-320.0, 0, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         self.registrationView.hidden = YES;
                         
                     }];
    
    [self.accountInfoView setFrame:CGRectMake(320.0, 108, self.accountInfoView.frame.size.width, self.accountInfoView.frame.size.height)];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.accountInfoView setFrame:CGRectMake(0.0, 108, self.accountInfoView.frame.size.width, self.accountInfoView.frame.size.height)];
                         if (noOfSegments == 3){
                             [self.segmentedView setEnabled:NO forSegmentAtIndex:1];
                             [self.segmentedView setEnabled:NO forSegmentAtIndex:2];
                             
                             
                         }else if (noOfSegments == 2){
                             [self.segmentedView setEnabled:NO forSegmentAtIndex:1];
                             
                         }
                         
                     }
                     completion:^(BOOL finished) {
                         self.accountInfoView.hidden = NO;
                         
                     }];
    [self.registrationFormBtn setTitleColor:[UIColor colorWithRed:28.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.registrationFormBtn setImage:[UIImage imageNamed:@"personalInfo_Correct.png"] forState:UIControlStateNormal];
    [self.registrationFormBtn setImage:[UIImage imageNamed:@"personalInfo_Correct.png"] forState:UIControlStateHighlighted];
    [self.registrationFormBtn setImage:[UIImage imageNamed:@"personalInfo_Correct.png"] forState:UIControlStateSelected];
}

-(void)resignKeyBoard
{
    [self.accountNumberTxtFld resignFirstResponder];
    [self.accountNumberTxtFld resignFirstResponder];
    [self.stateTxtFld resignFirstResponder];
    [self.ssnTxtFld resignFirstResponder];
    [self.emailTxtFld resignFirstResponder];
    [self.phoneTxtFld resignFirstResponder];
    [self.promotionalCodeTxtFld resignFirstResponder];
    [self.userNameTxtFld resignFirstResponder];
    [self.pswdTxtFld resignFirstResponder];
    [self.confirmPswdTxtFld resignFirstResponder];
    
    [self.statesPickerView setHidden:YES];
    [self.pickerToolBar1 removeFromSuperview];

}
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)validateUsernameOrPassword:(NSString *)usernameOrpassword
{
    
    NSString *emailRegex =
    @"((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,12})";
    NSPredicate *usernameOrPasswordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [usernameOrPasswordTest evaluateWithObject:usernameOrpassword];
    
}

- (void)buttonPressed
{
    
    [self.accountNumberTxtFld resignFirstResponder];
    [self.accountPinTxtFld resignFirstResponder];
    [self.ssnTxtFld resignFirstResponder];
    [self.emailTxtFld resignFirstResponder];
    [self.phoneTxtFld resignFirstResponder];
    [self.promotionalCodeTxtFld resignFirstResponder];
    [self.statesPickerView removeFromSuperview];
    [self.pickerToolBar1 removeFromSuperview];
    
    self.statesPickerView = nil;
    self.pickerToolBar1 = nil;
    NSMutableArray *barItems;
    UIBarButtonItem *cancelBtn;
    UIBarButtonItem *doneBtn;
    doneBtn = nil;
    barItems = nil;
    cancelBtn = nil;
    
    if(!self.statesPickerView){
        self.statesPickerView = [[UIPickerView alloc] init];
        self.pickerToolBar1 = [[UIToolbar alloc] init];

        barItems = [[NSMutableArray alloc] init];
        cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelbuttonClicked:)];
        [barItems addObject:cancelBtn];
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        
        doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButton:)];
        
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        
        
        [barItems addObject:flexSpace];
        [barItems addObject:doneBtn];
        
    }
    if (IS_IPHONE5){
        self.statesPickerView.frame = CGRectMake(0.0, 366, 320, 216);//352,216
        self.pickerToolBar1.frame = CGRectMake(0.0,340.0,320.0f,44.0);//313
        
    }else{
        self.statesPickerView.frame = CGRectMake(0.0, 304, 320, 210);//265,220
        self.pickerToolBar1.frame = CGRectMake(0.0,264,320.0,44.0);//225,
    }
    self.statesPickerView.delegate = self;
    self.statesPickerView.dataSource = self;
    self.statesPickerView.showsSelectionIndicator = YES;
    [self.statesPickerView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.statesPickerView];
    
    self.pickerToolBar1.barStyle=UIBarStyleBlackOpaque;
    [self.pickerToolBar1 setItems:barItems];
    [self.view addSubview:self.pickerToolBar1];
    [self.statesPickerView selectRow:1 inComponent:0 animated:YES];
    

    
}
- (void)doneButton:(id)sender
{
    
    if (![self.pickerSelectedStateString length]) {
        [self.titleLabel setText:[self.registerAppConfigDict valueForKey:@"reg_default_state"]];
        [[WarHorseSingleton sharedInstance] setStateString:[self.registerAppConfigDict valueForKey:@"reg_default_state"]];
        [[WarHorseSingleton sharedInstance] setStateCodeString:@"CT"];
    }
    else {
        [[WarHorseSingleton sharedInstance] setStateString:self.pickerSelectedStateString];
        [[WarHorseSingleton sharedInstance] setStateCodeString:self.pickerSelectedStateCodeString];
        self.titleLabel.text = [[WarHorseSingleton sharedInstance] stateString];
    }
    
    [self.statesPickerView removeFromSuperview];
    [self.pickerToolBar1 removeFromSuperview];
}
- (void)cancelbuttonClicked:(id)sender
{
    
    if (![[[WarHorseSingleton sharedInstance] stateString] length]) {
        [self.titleLabel setText:@" Select State"];
    }
    else {
        [self.titleLabel setText:[[WarHorseSingleton sharedInstance] stateString]];
    }
    
    [self.statesPickerView removeFromSuperview];
    [self.pickerToolBar1 removeFromSuperview];
}
#pragma mark -
#pragma mark picker methods


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//specify that there are three components in the picker view.
}


//method of the picker view to determine that how many rows in the component is there.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.statesCodesArray count];
}

//to populate the row cell in the picker view.

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.statesCodesArray objectAtIndex: row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSDictionary *localDic = [self.statesCodesArray objectAtIndex:row];
    NSString *stateCode = [localDic valueForKey:@"StateCode"];
    self.pickerSelectedStateString = [localDic valueForKey:@"State"];
    self.pickerSelectedStateCodeString = stateCode;
    
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSDictionary *localDict = [self.statesCodesArray objectAtIndex:row];
    NSString *rowItem = [localDict valueForKey:@"State"];//[dataArray objectAtIndex: row];
    
    // Create and init a new UILabel.
    // We must set our label's width equal to our picker's width.
    // We'll give the default height in each row.
    UILabel *lblRow = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, [pickerView bounds].size.width, 44.0f)];
    
    // Center the text.
    [lblRow setTextAlignment:NSTextAlignmentCenter];
    
    // Make the text color red.
    lblRow.font = [UIFont fontWithName:@"Roboto-Light" size:18];
    [lblRow setTextColor:[UIColor blackColor]];
    
    // Add the text.
    [lblRow setText:rowItem];
    
    // Clear the background color to avoid problems with the display.
    [lblRow setBackgroundColor:[UIColor clearColor]];
    
    // Return the label.
    return lblRow;
}

#pragma mark - Delegates

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *nextTextField1 = (UITextField *)[self.registrationView viewWithTag:textField.tag + 1];
    UITextField *nextTextField = (UITextField *)[self.accountInfoView viewWithTag:textField.tag + 1];
    
    if (textField == self.accountNumberTxtFld || textField == self.accountPinTxtFld|| textField == self.stateTxtFld ||textField == self.ssnTxtFld ||textField == self.emailTxtFld ||textField == self.phoneTxtFld ||textField == self.promotionalCodeTxtFld) {
        [nextTextField1 becomeFirstResponder];
    }
    
    if ( textField == self.userNameTxtFld || textField == self.pswdTxtFld || textField == self.confirmPswdTxtFld) {
        [nextTextField becomeFirstResponder];
    }
    
    
    if (textField == self.ssnTxtFld) {
        [self.stateTxtFld becomeFirstResponder];
    }
    
    
    if (textField == self.emailTxtFld) {
        [self.phoneTxtFld becomeFirstResponder];
    }
    if (textField == self.pswdTxtFld) {
        [self.userNameTxtFld becomeFirstResponder];
    }
    if (textField == self.confirmPswdTxtFld) {
        [self.pswdTxtFld becomeFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self.statesPickerView removeFromSuperview];
    [self.pickerToolBar1 removeFromSuperview];
    
    UIImageView *leftSideImgView;
    
    if (self.registrationFormBtn.selected == NO) {
        leftSideImgView = (UIImageView *)[self.registrationView viewWithTag:textField.tag - 30];
    }
    else if(self.accountInfoBtn.selected == NO)
    {
        leftSideImgView = (UIImageView *)[self.accountInfoView viewWithTag:textField.tag - 40];
    }
    
    [leftSideImgView setBackgroundColor:[UIColor colorWithRed:2.0/255.0 green:121.0/255.0 blue:205.0/255.0 alpha:1.0]];
    
    
    
    
    CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    
    if (bottomEdge >= 250) {//250
        CGRect viewFrame = self.view.frame;
        
        if (IS_IPHONE5) {
            
            if (self.registrationFormBtn.selected == NO) {
                
                self.shiftForKeyboard = bottomEdge - 239;
            }
            else
            {
                self.shiftForKeyboard = bottomEdge - 190;
            }
        }
        else
        {
            if (self.registrationFormBtn.selected == NO) {
                
                self.shiftForKeyboard = bottomEdge - 210 ;
            }
            else
            {
                self.shiftForKeyboard = bottomEdge - 134;
            }
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
    UIImageView *leftSideImgView;
    
    if (self.registrationFormBtn.selected == NO) {
        leftSideImgView = (UIImageView *)[self.registrationView viewWithTag:textField.tag - 30];
    }
    else if(self.accountInfoBtn.selected == NO)
    {
        leftSideImgView = (UIImageView *)[self.accountInfoView viewWithTag:textField.tag - 40];
    }
    
    if ([textField.text isEqualToString:@""]) {
        [leftSideImgView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0]];
    }
    else
    {
        [leftSideImgView setBackgroundColor:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0]];
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
    [self.statesPickerView removeFromSuperview];
    [self.pickerToolBar1 removeFromSuperview];
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    switch (textField.tag) {
        case 60://Username Text field
        {
            
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacters] invertedSet];
            
            if (range.length == 0 &&
                [cs characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return ((newLength <= 12) ? YES : NO);
            
        }
            break;
        case 61://Password Text field
        case 62://Confirm Password Text field
        {
            return ((newLength <= 12) ? YES : NO);
        }
          
        case 40: // accountID TF
            
            return (newLength <= 10) ? YES : NO;
            
            break;
            
        case 41: // accountPin TF
            
            return (newLength <= 4) ? YES : NO;
            
            break;
            // All digits entered
        case 43: // SSN Text field
        {
            return (newLength <= 4) ? YES : NO;
            
        }
            break;
        case 44: // Email TF
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:emailAcceptableCharacters] invertedSet];
            
            if (range.length == 0 &&
                [cs characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            return YES;
        }
        case 45: //Phone Number Text Field
        {
            // All digits entered
            if (range.location == 12) {
                return NO;
            }
            
            // Reject appending non-digit characters
            
            if (range.location == 12 || newLength > 12 ) {
                return NO;
            }
            //            if (range.length == 0 &&
            //                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
            //                return NO;
            //            }
            
            // Auto-add hyphen before appending 3rd or 7th digit
            if (range.length == 0 &&
                (range.location == 3 || range.location == 7)) {
                textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
                return NO;
            }
            
            // Delete hyphen when deleting its trailing digit
            if (range.length == 1 &&
                (range.location == 4 || range.location == 8))  {
                range.location--;
                range.length = 2;
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
            
            return YES;
        }
            break;
            
            case 46:
        {
            int promocodeLenth = [[self.registerAppConfigDict valueForKey:@"reg_promo_code_limit"] intValue];
            
            return ((newLength <= promocodeLenth) ? YES : NO);
        }
            break;
            
        
        default:
            return YES;
            break;
            
            
    }
    
}



#pragma mark - UIAlertView delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1){
            [self accountInformationScreen];
        }
        
    }
    
    
}
#pragma mark -----
#pragma mark InFo Screen

- (IBAction)infoBtnAction:(id)sender
{
    
    [self.view bringSubviewToFront:self.infoPopView];
    NSString *infoHTMLContent = nil;
    if (infoScreenIndex == 1){
        infoHTMLContent = [self.registerAppConfigDict valueForKey:@"existreg_s1_info"];
    }else if (infoScreenIndex == 2){
        infoHTMLContent = [self.registerAppConfigDict valueForKey:@"existreg_s2_info"];
        
    }else{
        infoHTMLContent = @"";
    }
    if (infoHTMLContent.length == 0 ){
        infoHTMLContent = @"No Information Available";
    }
    
    if (enableInfo == YES){
        self.infoPopView.hidden = NO;
        
        enableInfo = NO;
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.infoPopView.alpha = 1;

                             NSString *embedHTML =infoHTMLContent;
                             
                             self.infoWebView.userInteractionEnabled = YES;
                             self.infoWebView.layer.borderWidth = 1;
                             self.infoWebView.clipsToBounds = YES;
                             self.infoWebView.layer.cornerRadius = 8;
                             self.infoWebView.backgroundColor = [UIColor whiteColor];
                             self.infoWebView.layer.borderColor = [UIColor whiteColor].CGColor;

                             self.infoWebView.opaque = NO;
                             [self.infoWebView loadHTMLString: embedHTML baseURL: nil];
                             
                         }
                         completion:^(BOOL finished){
                             //infoBtn.enabled = YES;
                         }];
        
        if (!self.infoTapRecognizer){
            self.infoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleInfoTap:)];
            [self.infoPopView addGestureRecognizer:self.infoTapRecognizer];
        }
        self.infoTapRecognizer.enabled = YES;
        
    }else{
        self.infoPopView.hidden = YES;
        
        enableInfo = YES;
        self.infoPopView.alpha = 0;
        
    }
}

- (void)handleInfoTap:(UITapGestureRecognizer*)recognizer
{
    // Do Your thing.
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.infoPopView.alpha = 0;
        self.infoPopView.hidden = YES;
        enableInfo = YES;
        self.infoTapRecognizer.enabled = NO;
        
    }
}

#pragma mark --
#pragma mark UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    
    frame.size.height = 5.0f;
    
    webView.frame = frame;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[LeveyHUD sharedHUD] disappear];
    CGSize mWebViewTextSize = [webView sizeThatFits:CGSizeMake(1.0f, 1.0f)];  // Pass about any size
    
    CGRect mWebViewFrame = webView.frame;
    
    
    mWebViewFrame.size.height = mWebViewTextSize.height+15;
    
    if (mWebViewFrame.size.height >= 350){
        mWebViewFrame.size.height = 350;
        
    }
    
    webView.frame = mWebViewFrame;
    
    
    //Disable bouncing in webview
    for (id subview in webView.subviews)
    {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            [subview setBounces:NO];
        }
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[LeveyHUD sharedHUD] disappear];
}

@end
