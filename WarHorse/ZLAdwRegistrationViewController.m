//
//  ZLAdwRegistrationViewController.m
//  WarHorse
//
//  Created by Hiteshwar Vadlamudi on 21/10/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLAdwRegistrationViewController.h"
#import "SPVerificationQuestionsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"
#import "ZLVerificationCodeViewController.h"
#import "SPTermsAndConditionsViewController.h"
#import "SPVerficationVC.h"
#import "ZLLoginViewController.h"
#import "XMLToDictionary.h"



static NSString *const acceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'";
static NSString *const acceptableSecrteCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

static NSString *const emailAcceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@._";
static NSString *const invalidEmailStr = @"The email account you entered is already in use.\n If you forgot your username and/or password you can use the Forgot Password link to recover them.\n Otherwise, please contact Customer care for further assistance.";


static NSString *const zipCodeAPI = @"http://production.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=<CityStateLookupRequest USERID='804SPARI2703'><ZipCode ID='0'> <Zip5>%@</Zip5></ZipCode></CityStateLookupRequest>";

@interface ZLAdwRegistrationViewController () <UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger noOfSegments;
    BOOL enableInfo;
    int infoScreenIndex;
    NSMutableData *receivedData;
    
    
}
//Response Objects
@property (strong, nonatomic) NSMutableDictionary *personalInfoResponseDic;
@property (strong, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) IBOutlet UIView *personalInformationView;
@property (strong, nonatomic) IBOutlet UIView *accountInformationView;
@property (strong, nonatomic) IBOutlet UIView *registrationView;
@property (strong, nonatomic) IBOutlet UIButton *registrationInformationBtn;
@property (strong, nonatomic) IBOutlet UIButton *personalInformationBtn;
@property (strong, nonatomic) IBOutlet UIButton *accountInformationBtn;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIButton *personalNextBtn;
@property (strong, nonatomic) IBOutlet UIButton *calendarBtn;
@property (strong, nonatomic) IBOutlet UIButton *termsAndConditionsBtn;

@property (strong,nonatomic) NSArray *statesCodesArray;

@property	CGFloat shiftForKeyboard;

//Personal Information View
@property (strong, nonatomic) IBOutlet UITextField *firstNameTF;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTF;
@property (strong, nonatomic) IBOutlet UITextField *ssnTF;
@property (strong, nonatomic) IBOutlet UITextField *dateOfBirthTF;
@property (strong, nonatomic) IBOutlet UITextField *addressTF;
@property (strong, nonatomic) IBOutlet UITextField *zipCodeTF;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (strong, nonatomic) IBOutlet UITextField *emailAddressTF;
@property (strong, nonatomic) IBOutlet UITextField *stateTF;
@property (strong, nonatomic) IBOutlet UITextField *mywinnersIdTF;
@property (strong, nonatomic) IBOutlet UIImageView *mywinnersIdImgView;

@property (strong, nonatomic) IBOutlet UITextField *addressTF2;
@property (strong, nonatomic) IBOutlet UITextField *cityTF;
@property (strong, nonatomic) IBOutlet UITextField *resStateTF;
@property (strong, nonatomic) IBOutlet UITextField *secondaryPhoneTF;

@property (strong,nonatomic) IBOutlet UIButton *stateDropDownBoxBtn,*mesDropDownBoxBtn;
@property (strong,nonatomic) UILabel *titleLabel,*webTitleLabel;

@property (strong, nonatomic) IBOutlet UIImageView *addressImg2View;
@property (strong, nonatomic) IBOutlet UIImageView *cityImgView;
@property (strong, nonatomic) IBOutlet UIImageView *counrtyImgView;
@property (strong, nonatomic) IBOutlet UIImageView *resStateImgView;
@property (strong, nonatomic) IBOutlet UIImageView *messImgView;


@property (strong, nonatomic) IBOutlet UIImageView *firstNameImgView;
@property (strong, nonatomic) IBOutlet UIImageView *lastNameImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ssnImgView;
@property (strong, nonatomic) IBOutlet UIImageView *dateOfBirthImgView;
@property (strong, nonatomic) IBOutlet UIImageView *addressImgView;
@property (strong, nonatomic) IBOutlet UIImageView *zipCodeImgView;
@property (strong, nonatomic) IBOutlet UIImageView *phoneNumberImgView;
@property (strong, nonatomic) IBOutlet UIImageView *emailAddressImgView;
@property (strong, nonatomic) IBOutlet UIImageView *stateImgView;

//Account Information View
@property (strong, nonatomic) IBOutlet UITextField *usernameTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTF;

@property (strong, nonatomic) IBOutlet UIImageView *usernameImgview;
@property (strong, nonatomic) IBOutlet UIImageView *passwordImgView;
@property (strong, nonatomic) IBOutlet UIImageView *confirmPasswordImgView;
//New Screen Outlets
@property (weak, nonatomic) IBOutlet UIScrollView *accountInfoscrollView;
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;

@property (strong, nonatomic) IBOutlet UITextView *termsAndConditionTextView;


@property (weak, nonatomic) IBOutlet UIButton *adwRegisterBtn;

@property (weak, nonatomic) IBOutlet UITextField *ivrAccountPINTF;
@property (weak, nonatomic) IBOutlet UIImageView *ivrAccountPINImgView;

@property (weak, nonatomic) IBOutlet UITextField *confirmivrAccountPINTF;
@property (weak, nonatomic) IBOutlet UIImageView *confirmivrAccountPINImgView;


@property (weak, nonatomic) IBOutlet UITextField *secretWordTF;
@property (weak, nonatomic) IBOutlet UIImageView *secretWordImgView;



@property (weak, nonatomic) IBOutlet UITextField *confirmsecretWordTF;
@property (weak, nonatomic) IBOutlet UIImageView *confirmsecretWordImgView;


@property (weak, nonatomic) IBOutlet UITextField *promoCodeTF;
@property (weak, nonatomic) IBOutlet UIImageView *promoCodeImage;

@property (weak, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (weak, nonatomic) IBOutlet UIView *termsAndConditionView;


@property (assign) BOOL viewSecondPresent;
@property (assign) BOOL viewThirdPresent;
@property (assign) BOOL promoCodePresent;

@property (assign) BOOL mywinnerIDEnable;
@property (nonatomic,strong) IBOutlet UIButton *infoBtn;
@property (strong,nonatomic) IBOutlet  UIView *infoPopView;
@property (nonatomic,strong) IBOutlet UIWebView *infoWebView;


@property (nonatomic,weak) IBOutlet UILabel *firstViewHeader;
@property (nonatomic,weak) IBOutlet UILabel *secondViewHeader;
@property (nonatomic,weak) IBOutlet UILabel *thridViewHeader;




@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong ,nonatomic) UIPickerView *statesPickerView;

@property (strong, nonatomic) UITapGestureRecognizer *singleTapGestureRecognizer, *singleTapGestureRecognizer1,*singleTapGestureRecognizer2,*infoTapRecognizer;

//Alert View

@property (strong, nonatomic) IBOutlet UIView *popOverAlertView;

// Present calendar View
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) UIToolbar *pickerToolBar;

@property (strong, nonatomic) UIToolbar *pickerToolBar1;

@property (strong, nonatomic) NSDate *selectedDOB;


@property (assign, nonatomic) BOOL isRegisterClicked;

@property (nonatomic, strong) IBOutlet UIButton *termsAndConditionBtn;

@property (nonatomic,strong) NSString *dateFormateStr;
@property (nonatomic ,strong) NSArray *aboutusArray;
@property (nonatomic,strong) UILabel *userlabel;

@property (nonatomic, strong) NSString *pickerSelectedStateString;
@property (nonatomic, strong) NSString *pickerSelectedStateCodeString;

//New ReQ
@property (nonatomic,strong) IBOutlet UIButton *backViewBtn;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedView;

@property (strong, nonatomic) IBOutlet UIView *digitalVoucherView;
@property (strong, nonatomic) IBOutlet UITextField *pinTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *confirmPinTxtFld;
@property (strong, nonatomic) IBOutlet UILabel *registerLbl;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UITextField *userNameTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *passWordTxtFld;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassWordTxtFld;
@property (strong, nonatomic) IBOutlet UILabel *digitalVoucherLbl;

@property (strong,nonatomic) NSString *registerType;
@property (strong, nonatomic) IBOutlet UITextField *rewardsIdTxtFld;
@property (strong, nonatomic) UIView *datePickerView;
@property (nonatomic,strong) NSString *crmLead;

@property (strong, nonatomic) IBOutlet UITextField *confirmMyWinnersIdTf;
@property (strong, nonatomic) IBOutlet UIImageView *confirmMyWinnersIdImg;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)registerBtnClicked:(id)sender;
- (IBAction)backViewAction:(id)sender;
- (IBAction)backGroundClicked:(id)sender;


@end

@implementation ZLAdwRegistrationViewController
@synthesize registerAppConfigDict;

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
    [self.registerLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [self.headerNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [self.digitalVoucherLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:18]];
    [self.headerNameLabel setText:@"Register"];
    enableInfo = YES;
    
    
    NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"newreg_s1_info"];
    if (infoStr.length == 0){
        self.infoBtn.hidden = YES;
    }else{
        self.infoBtn.hidden = NO;
    }
    
    [self prepareView];
    
    self.isRegisterClicked = NO;
    
    [self preparePersonalInformationView];
    [self prepareAccountInformationView];
    [self prepareRegistrationForm];
    infoScreenIndex = 1;
    
    
    [self.personalInformationBtn setEnabled:NO];
    [self.accountInformationBtn setEnabled:NO];
    
    [self.registrationInformationBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.personalInformationBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.accountInformationBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    
    
    self.singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    self.singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.registrationView addGestureRecognizer:self.singleTapGestureRecognizer];
    
    self.singleTapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    self.singleTapGestureRecognizer1.numberOfTapsRequired = 1;
    [self.personalInformationView addGestureRecognizer:self.singleTapGestureRecognizer1];
    
    self.singleTapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyBoard)];
    self.singleTapGestureRecognizer2.numberOfTapsRequired = 1;
    [self.accountInformationView addGestureRecognizer:self.singleTapGestureRecognizer2];
    
    [self.stateDropDownBoxBtn addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.stateDropDownBoxBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, 200, 36)];
    self.titleLabel.font = [UIFont fontWithName:@"Roboto-Light" size:14];
    self.titleLabel.textColor=[UIColor colorWithRed:(30/255.0) green:(30/255.0) blue:(30/255.0) alpha:1];
    self.titleLabel.shadowColor=[UIColor colorWithRed:(255/255.0) green:(255/255.0) blue:(255/255.0) alpha:0.7];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, 0.8);
    [self.stateDropDownBoxBtn addSubview:self.titleLabel];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.titleLabel setText:[self.registerAppConfigDict valueForKey:@"reg_default_state"]];
    [[WarHorseSingleton sharedInstance] setStateString:[self.registerAppConfigDict valueForKey:@"reg_default_state"]];
    [[WarHorseSingleton sharedInstance] setStateCodeString:@"CT"];
    
    
//    UILabel * lblInfo = [[UILabel alloc] initWithFrame:CGRectMake(10.0, self.nextBtn.frame.origin.y + 43.0, 300.0,40.0)];
//    lblInfo.numberOfLines = 0;
//    lblInfo.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:241.0/255.0 blue:202.0/255.0 alpha:1];
//    [lblInfo setText:@" Only Connecticut residents are permitted to open accounts \n for online wagering."];
//    [lblInfo setFont:[UIFont fontWithName:@"Roboto-Medium" size:11]];
//    [lblInfo setTextColor:[UIColor colorWithRed:30.0f/255.0 green:30.0f/255.0 blue:30.0f/255.0 alpha:1.0]];
//    [lblInfo setBackgroundColor:[UIColor clearColor]];
//    lblInfo.layer.borderWidth = 1.0;
//    lblInfo.layer.borderColor = [UIColor colorWithRed:197.0/255.0 green:199.0/255.0 blue:198.0/255.0 alpha:1].CGColor;
//    lblInfo.textAlignment = NSTextAlignmentCenter;
//    
//    [self.registrationView addSubview:lblInfo];
   // self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, lblInfo.frame.origin.y +lblInfo.frame.size.height + 20);
    
    self.userlabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 68, 300.0,40.0)];
    self.userlabel.numberOfLines = 0;
    self.userlabel.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:241.0/255.0 blue:202.0/255.0 alpha:1];
    [self.userlabel setFont:[UIFont fontWithName:@"Roboto-Light" size:10]];
    self.userlabel.textAlignment = NSTextAlignmentCenter;
    self.userlabel.layer.borderWidth = 1.0;
    [self.userlabel setHidden:YES];
    [self.view addSubview:self.userlabel];
    [self.accountInfoscrollView bringSubviewToFront:self.userlabel];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"StateCodes" ofType:@"plist"];
    self.statesCodesArray = [[NSArray alloc] initWithContentsOfFile:path];
    [self.view bringSubviewToFront:self.accountInfoscrollView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backViewAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)backGroundClicked:(id)sender
{
    [self keyBoardResign];
    
}

- (void)keyBoardResign
{
    [self.pinTxtFld resignFirstResponder];
    [self.confirmPinTxtFld resignFirstResponder];
    [self.userNameTxtFld resignFirstResponder];
    [self.passWordTxtFld resignFirstResponder];
    [self.confirmPassWordTxtFld resignFirstResponder];
    [self.rewardsIdTxtFld resignFirstResponder];
    [self.ivrAccountPINTF resignFirstResponder];
    [self.confirmivrAccountPINTF resignFirstResponder];
    
    [self.secretWordTF resignFirstResponder];
    [self.confirmsecretWordTF resignFirstResponder];
    [self.promoCodeTF resignFirstResponder];
    
    
    [self.userlabel setHidden:YES];
    self.isClicked =YES;
    
}

- (void)prepareView
{
    if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ADW"]){
        self.registerType = @"ADW";
        [self.headerNameLabel setText:@"Create Totepool Account"];
        [self resignKeyBoard];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred" forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.ondayPassView removeFromSuperview];
        [self.digitalVoucherView removeFromSuperview];
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"ODP"]){
        [self.infoBtn setHidden:YES];

        [self oneDayPassLayout];
        [self resignKeyBoard];
        [self.accountInfoscrollView setHidden:YES];
        
        if ([[[WarHorseSingleton sharedInstance] isOdpPlayerIdEnable] isEqualToString:@"true"]){
            self.rewardsIdTxtFld.hidden = NO;
            self.registerBtn.frame = CGRectMake(self.registerBtn.frame.origin.x, 356, self.registerBtn.frame.size.width, self.registerBtn.frame.size.height);
        }else{
            self.rewardsIdTxtFld.hidden = YES;
        }
        self.registerType = @"ODP";
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred-ODP" forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.ondayPassView setFrame:CGRectMake(0.0, 65, 320, 500)];
        [self.view addSubview:self.ondayPassView];
        
    }else if ([[[WarHorseSingleton sharedInstance] userType] isEqualToString:@"DV"]){
        [self.infoBtn setHidden:YES];

        [self digitalVoucherLayout];
        [self.accountInfoscrollView setHidden:YES];
        
        self.registerType = @"DV";
        [[NSUserDefaults standardUserDefaults] setObject:@"BetFred-DV" forKey:@"ClientId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.ondayPassView removeFromSuperview];
        [self.digitalVoucherView setFrame:CGRectMake(0.0, 65, 320, 500)];
        [self.view addSubview:self.digitalVoucherView];
        [self resignKeyBoard];
        
    }
    
}

#pragma mark ---
#pragma mark ---RegistrationForm1 Layout

- (void)preparePersonalInformationView
{
    
    self.mywinnerIDEnable = [[self.registerAppConfigDict valueForKey:@"player_id_enabled"] boolValue];
    
    [self.accountInfoscrollView setHidden:YES];
    
    if (IS_IPHONE5) {
        
        [self.firstNameTF setFrame:CGRectMake(13, 10, 297, 36)];
        [self.firstNameImgView setFrame:CGRectMake(10, 10, 4, 36)];
        
        [self.lastNameTF setFrame:CGRectMake(13, 56, 297, 36)];
        [self.lastNameImgView setFrame:CGRectMake(10, 56, 4, 36)];
        
        [self.emailAddressTF setFrame: CGRectMake(13, 102, 297, 36)];
        [self.emailAddressImgView setFrame:CGRectMake(10, 102, 4, 36)];
        
        [self.phoneNumberTF setFrame:CGRectMake(13, 148, 297, 36)];
        [self.phoneNumberImgView setFrame:CGRectMake(10, 148, 4, 36)];
        
        
        [self.stateDropDownBoxBtn setFrame:CGRectMake(13,194, 297, 36)];
        [self.resStateImgView setFrame:CGRectMake(10, 194, 4, 36)];
        
        
        if (self.mywinnerIDEnable){
            [self.mywinnersIdTF setFrame:CGRectMake(CGRectGetMinX(self.mywinnersIdTF.frame), 240, CGRectGetWidth(self.mywinnersIdTF.frame), CGRectGetHeight((self.mywinnersIdTF.frame)))];
            
            [self.mywinnersIdImgView setFrame:CGRectMake(CGRectGetMinX(self.mywinnersIdImgView.frame), 240, CGRectGetWidth(self.mywinnersIdImgView.frame), CGRectGetHeight((self.mywinnersIdImgView.frame)))];
            [self.confirmMyWinnersIdTf setFrame:CGRectMake(CGRectGetMinX(self.confirmMyWinnersIdTf.frame), 286, CGRectGetWidth(self.confirmMyWinnersIdTf.frame), CGRectGetHeight((self.confirmMyWinnersIdTf.frame)))];
            
            [self.confirmMyWinnersIdImg setFrame:CGRectMake(CGRectGetMinX(self.confirmMyWinnersIdImg.frame), 286, CGRectGetWidth(self.confirmMyWinnersIdImg.frame), CGRectGetHeight((self.confirmMyWinnersIdImg.frame)))];
            
            [self.nextBtn setFrame:CGRectMake(10, 332, 300, 36)];
            
            
        }else{
            self.mywinnersIdImgView.hidden = YES;
            self.mywinnersIdTF.hidden = YES;
            self.confirmMyWinnersIdTf.hidden = YES;
            self.confirmMyWinnersIdImg.hidden = YES;
            [self.nextBtn setFrame:CGRectMake(10, 240, 300, 36)];
            
        }
        
    }else{
        
        if (!self.mywinnerIDEnable){
            self.mywinnersIdImgView.hidden = YES;
            self.mywinnersIdTF.hidden = YES;
            self.confirmMyWinnersIdTf.hidden = YES;
            self.confirmMyWinnersIdImg.hidden = YES;
            
            [self.nextBtn setFrame:CGRectMake(10, 240, 300, 36)];
            
        }
        
        
    }
    
    [self.firstNameTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.firstNameTF.layer setBorderWidth:1.0];
    
    [self.lastNameTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.lastNameTF.layer setBorderWidth:1.0];
    
    [self.phoneNumberTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.phoneNumberTF.layer setBorderWidth:1.0];
    
    [self.emailAddressTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.emailAddressTF.layer setBorderWidth:1.0];
    
    [self.resStateTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.resStateTF.layer setBorderWidth:1.0];
    
    [self.stateDropDownBoxBtn.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.stateDropDownBoxBtn.layer setBorderWidth:1.0];
    
    [self.mywinnersIdTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.mywinnersIdTF.layer setBorderWidth:1.0];
    
    [self.confirmMyWinnersIdTf.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.confirmMyWinnersIdTf.layer setBorderWidth:1.0];
    
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.firstNameTF.leftView = paddingView;
    self.firstNameTF.rightView = paddingView;
    self.firstNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.firstNameTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.lastNameTF.leftView = paddingView1;
    self.lastNameTF.leftViewMode = UITextFieldViewModeAlways;
    self.lastNameTF.rightView = paddingView1;
    self.lastNameTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.phoneNumberTF.leftView = paddingView2;
    self.phoneNumberTF.rightView = paddingView2;
    self.phoneNumberTF.leftViewMode = UITextFieldViewModeAlways;
    self.phoneNumberTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.emailAddressTF.leftView = paddingView3;
    self.emailAddressTF.leftViewMode = UITextFieldViewModeAlways;
    self.emailAddressTF.rightView = paddingView3;
    self.emailAddressTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.stateTF.leftView = paddingView4;
    self.stateTF.leftViewMode = UITextFieldViewModeAlways;
    self.stateTF.rightView = paddingView4;
    self.stateTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.mywinnersIdTF.leftView = paddingView5;
    self.mywinnersIdTF.leftViewMode = UITextFieldViewModeAlways;
    self.mywinnersIdTF.rightView = paddingView5;
    self.mywinnersIdTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.confirmMyWinnersIdTf.leftView = paddingView6;
    self.confirmMyWinnersIdTf.leftViewMode = UITextFieldViewModeAlways;
    self.confirmMyWinnersIdTf.rightView = paddingView6;
    self.confirmMyWinnersIdTf.rightViewMode = UITextFieldViewModeAlways;
    
    
}


#pragma mark ---
#pragma mark ---PersonalInformationView2 Layout
- (void)prepareRegistrationForm
{
    [self.accountInfoscrollView setHidden:YES];
//    infoScreenIndex = 2;
    
    if (IS_IPHONE5){
        //1
        [self.addressImgView setFrame:CGRectMake(10, 20, 4, 36)];
        [self.addressTF setFrame:CGRectMake(13, 20, 297, 36)];
        //2 address 2
        [self.addressTF2 setFrame:CGRectMake(13, 73, 297, 36)];
        [self.addressImg2View setFrame:CGRectMake(10, 73, 4, 36)];
        
        //3 Zip
        [self.zipCodeImgView setFrame:CGRectMake(10, 126, 4, 36)];
        [self.zipCodeTF setFrame:CGRectMake(13, 126, 297, 36)];
        
        //4 City, State
        [self.cityImgView setFrame:CGRectMake(10, 179, 4, 36)];
        [self.cityTF setFrame:CGRectMake(13, 179, 130, 36)];
        
        [self.stateImgView setFrame:CGRectMake(159, 179, 4, 36)];
        [self.stateTF setFrame:CGRectMake(159, 179, 151, 36)];
        
        //5 Do of Birth
        [self.dateOfBirthImgView setFrame:CGRectMake(10, 232, 4, 36)];
        [self.dateOfBirthTF setFrame:CGRectMake(13, 232, 297, 36)];
        [self.calendarBtn setFrame:CGRectMake(13, 232, 297, 36)];
        
        //6 SSN
        [self.ssnImgView setFrame:CGRectMake(10, 285, 4, 36)];
        [self.ssnTF setFrame:CGRectMake(13, 285, 297, 36)];
        
        
        [self.messImgView setFrame:CGRectMake(10, 337, 4, 36)];
        [self.secondaryPhoneTF setFrame:CGRectMake(13, 337, 297, 36)];
        [self.personalNextBtn setFrame:CGRectMake(10, 400, 300, 36)];
        
    }
    
   
    
    
    [self.ssnTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.ssnTF.layer setBorderWidth:1.0];
    
    [self.dateOfBirthTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.dateOfBirthTF.layer setBorderWidth:1.0];
    
    [self.addressTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.addressTF.layer setBorderWidth:1.0];
    
    [self.zipCodeTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.zipCodeTF.layer setBorderWidth:1.0];
    
    [self.addressTF2.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.addressTF2.layer setBorderWidth:1.0];
    
    [self.cityTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.cityTF.layer setBorderWidth:1.0];
    
    
    [self.stateTF.layer setBorderColor:[[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0] CGColor]];
    [self.stateTF.layer setBorderWidth:0.5];
    
    [self.secondaryPhoneTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.secondaryPhoneTF.layer setBorderWidth:1.0];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.ssnTF.leftView = paddingView;
    self.ssnTF.rightView = paddingView;
    self.ssnTF.leftViewMode = UITextFieldViewModeAlways;
    self.ssnTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.zipCodeTF.leftView = paddingView2;
    self.zipCodeTF.leftViewMode = UITextFieldViewModeAlways;
    self.zipCodeTF.rightView = paddingView2;
    self.zipCodeTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.dateOfBirthTF.leftView = paddingView3;
    self.dateOfBirthTF.rightView = paddingView3;
    self.dateOfBirthTF.leftViewMode = UITextFieldViewModeAlways;
    self.dateOfBirthTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.addressTF.leftView = paddingView4;
    self.addressTF.leftViewMode = UITextFieldViewModeAlways;
    self.addressTF.rightView = paddingView4;
    self.addressTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.addressTF2.leftView = paddingView6;
    self.addressTF2.rightView = paddingView6;
    self.addressTF2.leftViewMode = UITextFieldViewModeAlways;
    self.addressTF2.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.cityTF.leftView = paddingView7;
    self.cityTF.leftViewMode = UITextFieldViewModeAlways;
    self.cityTF.rightView = paddingView7;
    self.cityTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView8 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.resStateTF.leftView = paddingView8;
    self.resStateTF.leftViewMode = UITextFieldViewModeAlways;
    self.resStateTF.rightView = paddingView8;
    self.resStateTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView9 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.secondaryPhoneTF.leftView = paddingView9;
    self.secondaryPhoneTF.leftViewMode = UITextFieldViewModeAlways;
    self.secondaryPhoneTF.rightView = paddingView9;
    self.secondaryPhoneTF.rightViewMode = UITextFieldViewModeAlways;
    
}
#pragma mark ---
#pragma mark ---AccountInformationView Layout

- (void)prepareAccountInformationView
{
    
    [self.accountInfoscrollView setHidden:NO];
    
    _viewSecondPresent = [[self.registerAppConfigDict valueForKey:@"account_pin_enabled"] boolValue];
    _viewThirdPresent = [[self.registerAppConfigDict valueForKey:@"secret_word_enabled"] boolValue];
    _promoCodePresent = [[self.registerAppConfigDict valueForKey:@"promo_code_enabled"] boolValue];
    
    self.termsAndConditionTextView.text = @"I have read and understand these Terms & Conditions and agree to abide by the account wagering policies and procedures.";
    self.termsAndConditionTextView.font = [UIFont fontWithName:@"Roboto-Medium" size:12];
    
    self.termsAndConditionTextView.attributedText = [self attributedTextViewString];
    

    self.promoCodeTF.hidden = YES;
    self.promoCodeImage.hidden = YES;
    self.viewTwo.hidden = YES;
    self.viewThree.hidden = YES;
    [self setUpAccountInfoView];
    
    [self.usernameTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.usernameTF.layer setBorderWidth:1.0];
    
    [self.passwordTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.passwordTF.layer setBorderWidth:1.0];
    
    [self.confirmPasswordTF.layer setBorderColor:[[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] CGColor]];
    [self.confirmPasswordTF.layer setBorderWidth:1.0];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.usernameTF.leftView = paddingView;
    self.usernameTF.rightView = paddingView;
    self.usernameTF.leftViewMode = UITextFieldViewModeAlways;
    self.usernameTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.passwordTF.leftView = paddingView1;
    self.passwordTF.rightView = paddingView1;
    self.passwordTF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 40)];
    self.confirmPasswordTF.leftView = paddingView2;
    self.confirmPasswordTF.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPasswordTF.rightView = paddingView2;
    self.confirmPasswordTF.rightViewMode = UITextFieldViewModeAlways;
    
    
    self.firstViewHeader.text = [self.registerAppConfigDict valueForKey:@"newreg_s3_web_header"];
    self.firstViewHeader.font =     [UIFont fontWithName:@"Roboto-Medium" size:13];
    self.firstViewHeader.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
    
    
    
    if (_viewSecondPresent) {
        
        UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 36)];
        _ivrAccountPINTF.layer.borderColor=[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0].CGColor;
        _ivrAccountPINTF.layer.borderWidth = 1.0;
        _ivrAccountPINTF.leftView = paddingView3;
        _ivrAccountPINTF.rightView = paddingView3;
        _ivrAccountPINTF.leftViewMode = UITextFieldViewModeAlways;
        _ivrAccountPINTF.rightViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 36)];
        _confirmivrAccountPINTF.layer.borderWidth = 1.0;
        _confirmivrAccountPINTF.layer.borderColor=[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0].CGColor;
        
        _confirmivrAccountPINTF.leftView = paddingView4;
        _confirmivrAccountPINTF.rightView = paddingView4;
        _confirmivrAccountPINTF.leftViewMode = UITextFieldViewModeAlways;
        _confirmivrAccountPINTF.rightViewMode = UITextFieldViewModeAlways;
        
        self.secondViewHeader.text = [self.registerAppConfigDict valueForKey:@"newreg_s3_account_pin_header"];
        self.secondViewHeader.font =     [UIFont fontWithName:@"Roboto-Medium" size:13];
        self.secondViewHeader.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
        
    }
    
    //Third View
    if (_viewThirdPresent) {
        UIView *paddingView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 36)];
        _secretWordTF.layer.borderColor=[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0].CGColor;
        _secretWordTF.layer.borderWidth = 1.0;
        _secretWordTF.leftView = paddingView5;
        _secretWordTF.rightView = paddingView5;
        _secretWordTF.leftViewMode = UITextFieldViewModeAlways;
        _secretWordTF.rightViewMode = UITextFieldViewModeAlways;
        
        UIView *paddingView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 36)];
        _confirmsecretWordTF.layer.borderColor=[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0].CGColor;
        _confirmsecretWordTF.layer.borderWidth = 1.0;
        _confirmsecretWordTF.leftView = paddingView6;
        _confirmsecretWordTF.rightView = paddingView6;
        _confirmsecretWordTF.leftViewMode = UITextFieldViewModeAlways;
        _confirmsecretWordTF.rightViewMode = UITextFieldViewModeAlways;
        
        self.thridViewHeader.text = [self.registerAppConfigDict valueForKey:@"newreg_s3_secret_word_header"];
        self.thridViewHeader.font =     [UIFont fontWithName:@"Roboto-Medium" size:13];
        self.thridViewHeader.textColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1.0];
        
    }
    
    if (self.promoCodePresent) {
        UIView *paddingView7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 36)];
        _promoCodeTF.layer.borderColor=[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0].CGColor;
        _promoCodeTF.leftView = paddingView7;
        _promoCodeTF.rightView = paddingView7;
        _promoCodeTF.leftViewMode = UITextFieldViewModeAlways;
        _promoCodeTF.rightViewMode = UITextFieldViewModeAlways;
    }
    
    
    //self.testTextView.attributedText = [self attributedTextViewString];
    
    UITapGestureRecognizer *termsandconditionTap;
    if (!termsandconditionTap){
        termsandconditionTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textTapped:)];

    }
    
    [self.termsAndConditionTextView addGestureRecognizer:termsandconditionTap];
}

- (void)setUpAccountInfoView
{
    self.onlineView.frame =CGRectMake(10, 10, self.onlineView.frame.size.width, self.onlineView.frame.size.height);
    self.onlineView.layer.borderWidth = 1.0;
    self.onlineView.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0 green:190.0f/255.0 blue:190.0f/255.0 alpha:1.0] CGColor];
    
    Float32 y = self.onlineView.frame.origin.y + self.onlineView.frame.size.height + 10;
    
    self.onlineView.backgroundColor = [UIColor whiteColor];
    
    if (_viewSecondPresent) {
        self.viewTwo.hidden = NO;
        self.viewTwo.frame =CGRectMake(10, y ,self.viewTwo.frame.size.width, self.viewTwo.frame.size.height);
        self.viewTwo.layer.borderWidth = 1.0;
        self.viewTwo.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0 green:190.0f/255.0 blue:190.0f/255.0 alpha:1.0] CGColor];
        self.viewTwo.backgroundColor = [UIColor whiteColor];
        y = CGRectGetMaxY(self.viewTwo.frame) +10;
        
    }
    if (_viewThirdPresent) {
        self.viewThree.hidden = NO;
        
        self.viewThree.frame =CGRectMake(10, y, self.viewThree.frame.size.width, self.viewThree.frame.size.height);
        self.viewThree.layer.borderWidth = 1.0;
        self.viewThree.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0 green:190.0f/255.0 blue:190.0f/255.0 alpha:1.0] CGColor];
        self.viewThree.backgroundColor = [UIColor whiteColor];
        
        y = CGRectGetMaxY(self.viewThree.frame)+ 10;
        
    }
    
    self.termsAndConditionView.frame = CGRectMake(10, y, self.termsAndConditionView.frame.size.width, self.termsAndConditionView.frame.size.height);
    self.termsAndConditionView.layer.borderWidth = 1.0;
    self.termsAndConditionView.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0 green:190.0f/255.0 blue:190.0f/255.0 alpha:1.0] CGColor];
    
    y = CGRectGetMaxY(self.termsAndConditionView.frame )+ 10;
    
    if (self.promoCodePresent) {
        self.promoCodeTF.hidden = NO;
        self.promoCodeImage.hidden = NO;
        self.promoCodeTF.frame = CGRectMake(14, y, self.promoCodeTF.frame.size.width, self.promoCodeTF.frame.size.height);
        self.promoCodeImage.frame = CGRectMake(10, y, self.promoCodeImage.frame.size.width, self.promoCodeImage.frame.size.height);
        self.promoCodeTF.layer.borderColor = [[UIColor colorWithRed:190.0f/255.0 green:190.0f/255.0 blue:190.0f/255.0 alpha:1.0] CGColor];
        self.promoCodeTF.layer.borderWidth = 1.0;
        y = CGRectGetMaxY(self.promoCodeTF.frame )+ 10;
        
    }
    self.adwRegisterBtn.frame = CGRectMake(10, y, self.adwRegisterBtn.frame.size.width, self.adwRegisterBtn.frame.size.height);
    
    y = CGRectGetMaxY(self.adwRegisterBtn.frame )+CGRectGetHeight(self.adwRegisterBtn.frame ) + 200;
    
    self.accountInfoscrollView.contentSize = CGSizeMake (self.view.frame.size.width, y);

    
}


#pragma mark ---
#pragma mark ---ODP Layout
- (void)oneDayPassLayout
{
    //onedaypass view
    
    UIView *pinOntPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 103, 40)];
    pinOntPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"choosepin.png"]];
    self.pinTxtFld.leftView = pinOntPadding;
    self.pinTxtFld.leftViewMode = UITextFieldViewModeAlways;
    [self.pinTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.pinTxtFld.layer.borderColor = [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.pinTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.pinTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    self.pinTxtFld.layer.borderWidth=0.5;
    
    UIView *confirmPinOntPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 103, 40)];
    confirmPinOntPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"confirmpin.png"]];
    self.confirmPinTxtFld.leftView = confirmPinOntPadding;
    self.confirmPinTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPinTxtFld.rightViewMode = UITextFieldViewModeAlways;
    _confirmPinTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.confirmPinTxtFld.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.confirmPinTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.confirmPinTxtFld.layer.borderWidth=0.5;
    self.confirmPinTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    
    UIView *RewardsIdPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 103, 40)];
    RewardsIdPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"rewardsID.png"]];
    self.rewardsIdTxtFld.leftView = RewardsIdPadding;
    self.rewardsIdTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.rewardsIdTxtFld.rightViewMode = UITextFieldViewModeAlways;
    _rewardsIdTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.rewardsIdTxtFld.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.rewardsIdTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.rewardsIdTxtFld.layer.borderWidth=0.5;
    self.rewardsIdTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [RewardsIdPadding addGestureRecognizer:gestureRecognizer];
    self.isClicked = YES;
    
    
}


#pragma mark ---
#pragma mark ---DV Layout

- (void)digitalVoucherLayout
{
    //digitalvoucher view
    
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
    self.passWordTxtFld.leftView = passWordPadding;
    self.passWordTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.passWordTxtFld.rightViewMode = UITextFieldViewModeAlways;
    _passWordTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.passWordTxtFld.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.passWordTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.passWordTxtFld.layer.borderWidth=0.5;
    self.passWordTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    
    UIView *confirmPwdPadding= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    confirmPwdPadding.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"confirmpassword.png"]];
    self.confirmPassWordTxtFld.leftView = confirmPwdPadding;
    self.confirmPassWordTxtFld.leftViewMode = UITextFieldViewModeAlways;
    self.confirmPassWordTxtFld.rightViewMode = UITextFieldViewModeAlways;
    _confirmPassWordTxtFld.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.confirmPassWordTxtFld.layer.borderColor=[UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0].CGColor;
    [self.confirmPassWordTxtFld setTextColor:[UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0]];
    self.confirmPassWordTxtFld.layer.borderWidth=0.5;
    self.confirmPassWordTxtFld.font=[UIFont fontWithName:@"Roboto-Light" size:16];
    
    
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
    [self.ivrAccountPINTF resignFirstResponder];
    [self.confirmivrAccountPINTF resignFirstResponder];
    [self.secretWordTF resignFirstResponder];
    [self.confirmsecretWordTF resignFirstResponder];
    
    
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

#pragma mark ---
#pragma mark PickerView Methods

- (void)buttonPressed
{
    
    [self.firstNameTF resignFirstResponder];
    [self.lastNameTF resignFirstResponder];
    [self.emailAddressTF resignFirstResponder];
    [self.phoneNumberTF resignFirstResponder];
    [self.mywinnersIdTF resignFirstResponder];
    [self.confirmMyWinnersIdTf resignFirstResponder];
    
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
    self.statesPickerView = nil;
    self.pickerToolBar1 = nil;
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
    self.statesPickerView = nil;
    self.pickerToolBar1 = nil;
    
}

- (IBAction)termsAndConditions
{
    SPTermsAndConditionsViewController *termsAndConditionViewController = [[SPTermsAndConditionsViewController alloc] initWithNibName:@"SPTermsAndConditionsViewController" bundle:nil];
    termsAndConditionViewController.isRegistrationFlag = YES;
    
    [self.navigationController pushViewController:termsAndConditionViewController animated:YES];
}

- (void)doneCustomPickerAction
{
    [self.pickerToolBar removeFromSuperview];
    [self.statesPickerView removeFromSuperview];
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




- (IBAction)backToRegistrationtypes:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)switchBetweenPersonalInformationAndAccountInformationViews:(UIButton *)sender
{
    [self resignKeyBoard];
    
    switch (sender.tag) {
        case 1:
        {
            infoScreenIndex = 1;
            NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"newreg_s1_info"];
            if (infoStr.length == 0){
                self.infoBtn.hidden = YES;
            }else{
                self.infoBtn.hidden = NO;

            }
            
            [self.accountInfoscrollView setHidden:YES];
            
            if (sender.selected == YES) {
                [sender setSelected:NO];
            }
            
            if (self.personalInformationBtn.selected == YES) {
                [self.personalInformationBtn setSelected:NO];
                
                [self.backBtn removeTarget:self action:@selector(backToPersonalInforamtion) forControlEvents:UIControlEventTouchUpInside];
                [self.backBtn addTarget:self action:@selector(backToRegistrationtypes:) forControlEvents:UIControlEventTouchUpInside];
                
                self.registrationView.hidden = NO;
                [self.personalInformationBtn setEnabled:NO];
                [self.accountInformationBtn setEnabled:NO];
                
                [self.registrationView setFrame:CGRectMake(-320.0, self.registrationView.frame.origin.y, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.registrationView setFrame:CGRectMake(0.0, self.registrationView.frame.origin.y, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                                 }
                                 completion:nil];
                
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.accountInformationView setFrame:CGRectMake(320.0f, self.accountInformationView.frame.origin.y, self.accountInformationView.frame.size.width, self.accountInformationView.frame.size.height)];
                                 }
                                 completion:^(BOOL finished) {
                                     NSLog(@"finish account view ");
                                     self.accountInformationView.hidden = YES;
                                 }];
                
            }
            else
            {
                self.registrationView.hidden = NO;
                [self.registrationInformationBtn setEnabled:YES];
                [self.personalInformationBtn setEnabled:NO];
                
                [self.backBtn removeTarget:self action:@selector(backToRegistrationInforamtion) forControlEvents:UIControlEventTouchUpInside];
                [self.backBtn addTarget:self action:@selector(backToRegistrationtypes:) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.registrationView setFrame:CGRectMake(0.0, self.registrationView.frame.origin.y, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                                 }
                                 completion:nil];
                
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.personalInformationView setFrame:CGRectMake(320.0f, self.personalInformationView.frame.origin.y, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
                                 }
                                 completion:^(BOOL finished) {
                                     self.accountInformationView.hidden = YES;
                                     self.personalInformationView.hidden = YES;
                                 }];
                
            }
            
            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateNormal];
            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateHighlighted];
            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateSelected];
        }
            
            break;
            
        case 2:
        {
            infoScreenIndex = 2;
            NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"newreg_s2_info"];

            if (infoStr.length == 0){
                self.infoBtn.hidden = YES;
            }else{
                self.infoBtn.hidden = NO;
                
            }
            
            [self.accountInfoscrollView setHidden:YES];
            
            if (sender.selected == YES) {
                [sender setSelected:NO];
                [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateNormal];
                [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateHighlighted];
                [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateSelected];
            }
            
            self.personalInformationView.hidden = NO;
            [self.accountInformationBtn setEnabled:NO];
            [self.personalInformationBtn setEnabled:YES];
            
            [self.accountInformationView setFrame:CGRectMake(0.0, self.accountInformationView.frame.origin.y, self.accountInformationView.frame.size.width, self.accountInformationView.frame.size.height)];
            [self.accountInfoscrollView scrollRectToVisible:CGRectMake(0, 0, 320, 480) animated:NO];
            
            [self.backBtn removeTarget:self action:@selector(backToPersonalInforamtion) forControlEvents:UIControlEventTouchUpInside];
            [self.backBtn addTarget:self action:@selector(backToRegistrationInforamtion) forControlEvents:UIControlEventTouchUpInside];
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.personalInformationView setFrame:CGRectMake(0.0, self.personalInformationView.frame.origin.y, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
                             }
                             completion:nil];
            
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.accountInformationView setFrame:CGRectMake(320.0f, self.accountInformationView.frame.origin.y, self.accountInformationView.frame.size.width, self.accountInformationView.frame.size.height)];
                             }
                             completion:^(BOOL finished) {
                                 self.accountInformationView.hidden = YES;
                                 self.registrationView.hidden = YES;
                             }];
            
            
            
        }
            
            break;
        case 3:
        {
            self.accountInformationView.hidden = NO;
            [self.accountInfoscrollView setHidden:NO];
            infoScreenIndex = 3;
            NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"newreg_s3_info"];
            
            if (infoStr.length == 0){
                self.infoBtn.hidden = YES;
            }else{
                self.infoBtn.hidden = NO;
                
            }
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.accountInformationView setFrame:CGRectMake(0.0, self.accountInformationView.frame.origin.y, self.accountInformationView.frame.size.width, self.accountInformationView.frame.size.height)];
                             }
                             completion:nil];
            
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.registrationView setFrame:CGRectMake(320.0f, self.registrationView.frame.origin.y, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                             }
                             completion:^(BOOL finished) {
                                 self.registrationView.hidden = YES;
                                 self.personalInformationView.hidden = YES;
                                 
                             }];
            
        }
            
            break;
        default:
            break;
    }
    
}

- (void)backToPersonalInforamtion
{
    
    [self.accountInfoscrollView setHidden:YES];
    
    if (self.personalInformationBtn.selected == YES) {
        [self.personalInformationBtn setSelected:NO];
    }
    
    [self.backBtn removeTarget:self action:@selector(backToPersonalInforamtion) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(backToRegistrationInforamtion) forControlEvents:UIControlEventTouchUpInside];
    
    self.personalInformationView.hidden = NO;
    [self.accountInformationBtn setEnabled:NO];
    [self.registrationInformationBtn setEnabled:YES];
    
    [self.personalInformationView setFrame:CGRectMake(-320.0, self.personalInformationView.frame.origin.y, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.personalInformationView setFrame:CGRectMake(0.0, self.personalInformationView.frame.origin.y, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
                     }
                     completion:nil];
    
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.accountInformationView setFrame:CGRectMake(320.0f, self.accountInformationView.frame.origin.y, self.accountInformationView.frame.size.width, self.accountInformationView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finish account view ");
                         self.accountInformationView.hidden = YES;
                     }];
    
    
}

- (void)backToRegistrationInforamtion
{
    if (self.registrationInformationBtn.selected == YES) {
        [self.registrationInformationBtn setSelected:NO];
    }
    [self.accountInfoscrollView setHidden:YES];
    
    
    
    [self.backBtn removeTarget:self action:@selector(backToRegistrationInforamtion) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn addTarget:self action:@selector(backToRegistrationtypes:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registrationView.hidden = NO;
    [self.personalInformationBtn setEnabled:NO];
    
    [self.registrationView setFrame:CGRectMake(-320.0, self.registrationView.frame.origin.y, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.registrationView setFrame:CGRectMake(0.0, self.registrationView.frame.origin.y, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                     }
                     completion:nil];
    
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.personalInformationView setFrame:CGRectMake(320.0f, 0, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"finish account view ");
                         self.personalInformationView.hidden = YES;
                     }];
}


- (IBAction)nextToPersonalInformation:(id)sender
{
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        
        [self alertViewMethod:Aleart_Title messageText:@"Unable to connect to the server, please check your internet connection"];
        return;
    }
    
    
    if ([self.firstNameTF.text isEqualToString:@""] || [self.lastNameTF.text isEqualToString:@""] ||  [self.phoneNumberTF.text isEqualToString:@""] || [self.emailAddressTF.text isEqualToString:@""] ) {
        
        [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
        
        return;
    }
    if ([self.firstNameTF.text length]<2||[self.lastNameTF.text length]<2)
    {
        [self alertViewMethod:@"Information" messageText:@"First name and Last name should contain minimum 2 characters"];
        
        return;
    }
    
    if (![self validateEmail:self.emailAddressTF.text])
    {
        [self alertViewMethod:@"Information" messageText:@"Please enter a valid Email address"];
        return;
    }
    
    if ([self.phoneNumberTF.text length] < 12) {
        
        [self alertViewMethod:@"Information" messageText:@"Please enter your 10 digit mobile number"];
        
        return;
    }
    
//    if (![[[WarHorseSingleton sharedInstance] stateString] isEqualToString:@"Connecticut"])
//    {
//        [self alertViewMethod:@"Information" messageText:@"Only Connecticut residents are permitted to open accounts for online wagering."];
//        
//        return;
//    }
    if (self.mywinnerIDEnable){
        if (![self.mywinnersIdTF.text isEqualToString:self.confirmMyWinnersIdTf.text]) {
            [self.confirmMyWinnersIdTf resignFirstResponder];
            [self alertViewMethod:@"Information" messageText:@"TotepoolID doesn't match"];
            return;
        }
    }
    [self resignKeyBoard];
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Checking Email..."];
    
    NSDictionary *argumentsDic = @{@"firstName":self.firstNameTF.text,
                                   @"lastName":self.lastNameTF.text,
                                   @"email": self.emailAddressTF.text,
                                   @"homePhone":[self.phoneNumberTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                   @"state":[[WarHorseSingleton sharedInstance] stateCodeString],
                                   @"playerId":self.mywinnersIdTF.text
                                   };
    
    [apiwrapper isAccountValid:argumentsDic success:^(NSDictionary *_userInfo){
        
        
        if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]){
            if ([[[_userInfo valueForKey:@"response-content"] valueForKey:@"accountExist"] boolValue]){
                
                //email id already exists so invalid
                [[LeveyHUD sharedHUD] disappear];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[_userInfo valueForKey:@"response-message"]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alertView show];
                
            }else{
                //this email id valid.
                [[LeveyHUD sharedHUD] disappear];
                infoScreenIndex = 2;
                NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"newreg_s2_info"];
                if (infoStr.length == 0){
                    self.infoBtn.hidden = YES;
                }else{
                    self.infoBtn.hidden = NO;
                    
                }

                self.crmLead = [[_userInfo valueForKey:@"response-content"] valueForKey:@"crmLead"];
                
                [self.emailAddressImgView setBackgroundColor:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0]];
                
                self.personalInformationView.hidden = NO;
                [self.registrationInformationBtn setSelected:YES];
                [self.personalInformationBtn setEnabled:YES];
                self.stateTF.font = [UIFont fontWithName:@"Roboto-Light" size:14];
                self.stateTF.text = [[WarHorseSingleton sharedInstance] stateString];
                
                [self.backBtn removeTarget:self action:@selector(backToRegistrationtypes:) forControlEvents:UIControlEventTouchUpInside];
                [self.backBtn addTarget:self action:@selector(backToRegistrationInforamtion) forControlEvents:UIControlEventTouchUpInside];
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.registrationView setFrame:CGRectMake(-320.0, self.registrationView.frame.origin.y, self.registrationView.frame.size.width, self.registrationView.frame.size.height)];
                                 }
                                 completion:^(BOOL finished) {
                                     self.registrationView.hidden = YES;
                                     
                                 }];
                
                [self.personalInformationView setFrame:CGRectMake(320.0, self.personalInformationView.frame.origin.y, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
                
                [UIView animateWithDuration:0.3f
                                      delay:0.0f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     [self.personalInformationView setFrame:CGRectMake(0.0, self.personalInformationView.frame.origin.y, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
                                     if (noOfSegments == 3){
                                         [self.segmentedView setEnabled:NO forSegmentAtIndex:1];
                                         [self.segmentedView setEnabled:NO forSegmentAtIndex:2];
                                         
                                         
                                     }else if (noOfSegments == 2){
                                         [self.segmentedView setEnabled:NO forSegmentAtIndex:1];
                                         
                                     }
                                     
                                 }
                                 completion:^(BOOL finished) {
                                     self.personalInformationView.hidden = NO;
                                     
                                 }];
                
                
                //                            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateNormal];
                //                            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateHighlighted];
                //                            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalinfo.png"] forState:UIControlStateSelected];
                
            }
            
        }else{
            //failure
            [[LeveyHUD sharedHUD] disappear];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[_userInfo valueForKey:@"response-message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertView show];
        }
    }failure:^(NSError *error){
        
        [[LeveyHUD sharedHUD] disappear];
        
    }];
    
}


- (IBAction)nextToAccountInformation:(id)sender
{
    
    if ([self.ssnTF.text isEqualToString:@""]||[self.dateOfBirthTF.text isEqualToString:@""] ||  [self.addressTF.text isEqualToString:@""] || [self.cityTF.text isEqualToString:@""] || [self.stateTF.text isEqualToString:@""]|| [self.zipCodeTF.text isEqualToString:@""]){
        
        [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
        return;
        
    }
    
    if ([self.ssnTF.text length] < 11) {
        
        [self alertViewMethod:@"Information" messageText:@"Please enter your 9 digit SSN number"];
        return;
    }
    
    if ([self.addressTF.text length]<5)
    {
        [self alertViewMethod:@"Information" messageText:@"Address should contain minimum 5 characters"];
        
        return;
    }
    
    
    if ([self.zipCodeTF.text length] != 5) {
        
        [self alertViewMethod:@"Information" messageText:@"Please enter a valid zipcode"];
        return;
    }
    
    
    [self resignKeyBoard];
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
    
    NSDictionary *argumentsDic = @{@"addressLine1":self.addressTF.text,
                                   @"addressLine2":self.addressTF2.text,
                                   @"city":self.cityTF.text,
                                   @"dateOfBirth":self.dateFormateStr,
                                   @"firstName":self.firstNameTF.text,
                                   @"lastName":self.lastNameTF.text,
                                   @"ssn":[self.ssnTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                   @"state":[[WarHorseSingleton sharedInstance] stateCodeString],
                                   @"zipCode":self.zipCodeTF.text,
                                   @"crmLead":self.crmLead
                                   };
    
    
    
    
    [apiwrapper getIdologyWithParameters:argumentsDic success:^(NSDictionary *_userInfo) {
        
        if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"])
        {
            
            [[LeveyHUD sharedHUD] disappear];
            infoScreenIndex = 3;
            NSString *infoStr =  [self.registerAppConfigDict valueForKey:@"newreg_s3_info"];
            if (infoStr.length == 0){
                self.infoBtn.hidden = YES;
            }else{
                self.infoBtn.hidden = NO;
                
            }
            
            [self.personalInfoResponseDic setDictionary:_userInfo];
            
            [self.emailAddressImgView setBackgroundColor:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0]];
            
            [self.personalInformationBtn setSelected:YES];
            [self.accountInformationBtn setEnabled:YES];
            self.accountInformationView.hidden = NO;
            [self.accountInfoscrollView setHidden:NO];
            
            
            [self.backBtn removeTarget:self action:@selector(backToRegistrationInforamtion) forControlEvents:UIControlEventTouchUpInside];
            [self.backBtn addTarget:self action:@selector(backToPersonalInforamtion) forControlEvents:UIControlEventTouchUpInside];
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.personalInformationView setFrame:CGRectMake(-320.0, self.personalInformationView.frame.origin.y, self.personalInformationView.frame.size.width, self.personalInformationView.frame.size.height)];
                             }
                             completion:^(BOOL finished) {
                                 self.personalInformationView.hidden = YES;
                             }];
            
            [UIView animateWithDuration:0.3f
                                  delay:0.0f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 [self.accountInformationView setFrame:CGRectMake(0.0, self.accountInformationView.frame.origin.y, self.accountInformationView.frame.size.width, self.accountInformationView.frame.size.height)];
                                 
                                 
                             }
                             completion:^(BOOL finished) {
                             }];
            
            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalInfo_Correct.png"] forState:UIControlStateNormal];
            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalInfo_Correct.png"] forState:UIControlStateHighlighted];
            [self.personalInformationBtn setImage:[UIImage imageNamed:@"personalInfo_Correct.png"] forState:UIControlStateSelected];
            
        }else{
            
            [self alertViewMethod:@"Information" messageText:[_userInfo valueForKey:@"response-message"]];
            
            [[LeveyHUD sharedHUD] disappear];
            
        }
        
        
    } failure:^(NSError *error) {
        [[LeveyHUD sharedHUD] disappear];
        
        [self alertViewMethod:@"Information" messageText:@"The server could not process your request at this time, please try later"];
        
    }];
}

- (BOOL)validateUsernameOrPassword:(NSString *)usernameOrpassword
{
    
    NSString *emailRegex =
    @"((?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,12})";
    NSPredicate *usernameOrPasswordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [usernameOrPasswordTest evaluateWithObject:usernameOrpassword];
    
}

- (IBAction)createAccount:(id)sender
{
    
    self.isRegisterClicked = YES;
    [self resignKeyBoard];
    
    if ( [self.usernameTF.text isEqualToString:@""] || [self.passwordTF.text isEqualToString:@""]|| [self.confirmPasswordTF.text isEqualToString:@""]) {
        [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
        return;
    }
    //Your username must contain at least 6 and a maximum of 12 characters
    
    if ([self.usernameTF.text length] < 5){
        [self alertViewMethod:@"Invalid User" messageText:@"Your username must contain at least 6 and a maximum of 12 characters"];
        return;
        
    }
    if (![self validateUsernameOrPassword:self.passwordTF.text]) {
        [self alertViewMethod:@"Invalid Password" messageText:@"our password must be a minimum of 6 characters and must contain 1 uppercase letter, 1 lowercase letter and 1 number."];
        return;
        
    }
    
    if (![self.passwordTF.text isEqualToString:self.confirmPasswordTF.text]) {
        [self alertViewMethod:@"Information" messageText:@"Password doesn't match"];
        return;
    }
    if (_viewSecondPresent) {
        if ([self.ivrAccountPINTF.text isEqualToString:@""]||[self.confirmivrAccountPINTF.text isEqualToString:@""]){
            [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
            return;
        }
        NSInteger totepinNo = [self.ivrAccountPINTF.text integerValue];
        
        if (totepinNo <= 0){
            [self alertViewMethod:@"Information" messageText:@"Please enter valid PIN"];
            return;
        }
        
        if (![self.ivrAccountPINTF.text isEqualToString:self.confirmivrAccountPINTF.text]) {
            [self alertViewMethod:@"Information" messageText:@"IVR PIN doesn't match"];
            return;
        }
        
    }
    if(_viewThirdPresent){
        if ([self.secretWordTF.text isEqualToString:@""]||[self.confirmsecretWordTF.text isEqualToString:@""]){
            [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
            return;
        }
        if (![self.secretWordTF.text isEqualToString:self.confirmsecretWordTF.text]) {
            [self alertViewMethod:@"Information" messageText:@"Secret Word doesn't match"];
            return;
        }
        
    }
    
    
    
    if (self.checkBoxButton.selected == NO) {
        [self alertViewMethod:@"Information" messageText:@"Please agree Terms and Conditions"];
        return;
        
    }
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        [self alertViewMethod:Aleart_Title messageText:@"Unable to connect to the server, please check your internet connection"];
        return;
    }
    
    
    
    [[LeveyHUD sharedHUD] appearWithText:@"Promo Code Checking..."];
    
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    
    if ([self.promoCodeTF.text isEqualToString:@""]){
        [self conFirmScreenUserDetails];
    }else{
        NSDictionary *argumentsDic = @{@"promocode":self.promoCodeTF.text
                                       };
        [apiwrapper promoCodeValidation:argumentsDic success:^(NSDictionary *userDic){
            [[LeveyHUD sharedHUD] disappear];
            if ([[userDic valueForKey:@"response-status"] isEqualToString:@"success"]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[userDic valueForKey:@"response-content"] valueForKey:@"promoname"] message:[[userDic valueForKey:@"response-content"] valueForKey:@"promodescription"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
                alertView.tag = 101;
                [alertView show];
            }else {
                [self alertViewMethod:@"Information" messageText:[userDic valueForKey:@"response-message"]];
                
            }
            
            
        }failure:^(NSError *error){
            [[LeveyHUD sharedHUD] disappear];
            
        }];
    }
    
}
- (void)conFirmScreenUserDetails
{
    [[LeveyHUD sharedHUD] appearWithText:@"Registration in progress..."];
    
    NSDictionary *argumentsDic = @{@"totePin":self.ivrAccountPINTF.text,
                                   @"firstName":self.firstNameTF.text,
                                   @"lastName":self.lastNameTF.text,
                                   @"address1":self.addressTF.text,
                                   @"address2":self.addressTF2.text,
                                   @"city":self.cityTF.text,
                                   @"state":[[WarHorseSingleton sharedInstance] stateCodeString],//self.stateTF.text
                                   @"zip":self.zipCodeTF.text,
                                   @"homePhone":[self.phoneNumberTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                   @"ssn":[self.ssnTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                   @"dateOfBirth":self.dateFormateStr,//@"1990-01-01",
                                   @"emailAddress":self.emailAddressTF.text,
                                   @"loginUsername":self.usernameTF.text,
                                   @"loginPassword":self.passwordTF.text,
                                   @"secretWord":self.secretWordTF.text,
                                   @"crmLead":self.crmLead,
                                   @"playerId":self.mywinnersIdTF.text,
                                   @"secondaryPhone":[self.secondaryPhoneTF.text stringByReplacingOccurrencesOfString:@"-" withString:@""]
                                   };
    
    ZLAPIWrapper *apiwrapper = [ZLAppDelegate getApiWrapper];
    [apiwrapper registerUserWithdetails:argumentsDic success:^(NSDictionary *userInfo){
        
        [[LeveyHUD sharedHUD] disappear];
        
        NSString *successStr = [userInfo valueForKey:@"response-status"];
        if ([successStr isEqualToString:@"success"])
        {
            [[WarHorseSingleton sharedInstance] setIsRegisterFlag:@"Yes"];
            
            ZLVerificationCodeViewController *accountIdViewCntrl = [[ZLVerificationCodeViewController alloc] initWithNibName:@"ZLVerificationCodeViewController" bundle:nil];
            accountIdViewCntrl.userDetailsDict = [userInfo valueForKey:@"response-content"];
            accountIdViewCntrl.userName = self.usernameTF.text;
            [self.navigationController pushViewController:accountIdViewCntrl animated:YES];
            
            
        }else{
            
            [self alertViewMethod:@"Information" messageText:[[userInfo valueForKey:@"response-content"] valueForKey:@"statusDescription"]];
            return;
        }
        
    }failure:^(NSError *error)
     {
         NSLog(@"error %@",error);
         [[LeveyHUD sharedHUD] disappear];
     }];
}


- (IBAction)agreeTermsAndConditions:(UIButton *)sender
{
    [self.ivrAccountPINTF resignFirstResponder];
    [self.confirmivrAccountPINTF resignFirstResponder];
    [self.secretWordTF resignFirstResponder];
    [self.confirmsecretWordTF resignFirstResponder];
    
    if (sender.selected == YES) {
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
}

- (void)resignKeyBoard
{
    [self.userlabel setHidden:YES];
    
    [self.firstNameTF resignFirstResponder];
    [self.lastNameTF resignFirstResponder];
    [self.phoneNumberTF resignFirstResponder];
    [self.emailAddressTF resignFirstResponder];
    [self.stateTF resignFirstResponder];
    [self.mywinnersIdTF resignFirstResponder];
    [self.confirmMyWinnersIdTf resignFirstResponder];
    
    
    [self.ssnTF resignFirstResponder];
    [self.addressTF2 resignFirstResponder];
    [self.dateOfBirthTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.cityTF resignFirstResponder];
    [self.resStateTF resignFirstResponder];
    [self.zipCodeTF resignFirstResponder];
    [self.secondaryPhoneTF resignFirstResponder];
    
    [self.usernameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.confirmPasswordTF resignFirstResponder];
    
    [self.ivrAccountPINTF resignFirstResponder];
    [self.confirmivrAccountPINTF resignFirstResponder];
    
    [self.secretWordTF resignFirstResponder];
    [self.confirmsecretWordTF resignFirstResponder];
    [self.promoCodeTF resignFirstResponder];
    
    
    [self.statesPickerView setHidden:YES];
    [self.pickerToolBar1 removeFromSuperview];
    [self keyBoardResign];
    
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

- (IBAction)showCalendar:(id)sender {
    
    [self resignKeyboardsInPickerView];
    if(!self.datePicker)
    {
        self.datePickerView = [[UIView alloc]init];
        self.datePicker = [[UIDatePicker alloc]init];
        self.pickerToolBar = [[UIToolbar alloc] init];
    }
    if (IS_IPHONE5)
    {
        self.datePickerView.frame = CGRectMake(0, 0, 320, 568);
        self.datePicker.frame = CGRectMake(0, 374, 320, 260);
        self.pickerToolBar.frame = CGRectMake(0, 329, 320, 44);
    }else{
        self.datePickerView.frame = CGRectMake(0, 0, 320, 480);
        self.datePicker.frame = CGRectMake(0, 285, 320, 260);
        self.pickerToolBar.frame = CGRectMake(0, 240, 320, 44);
    }
    
    self.datePickerView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.pickerToolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin;
    self.pickerToolBar.barStyle = UIBarStyleBlackOpaque;
    [self.pickerToolBar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(datecancelbuttonClicked:)];
    [barItems addObject:cancelBtn];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donebuttonClicked:)];
    [barItems addObject:flexSpace];
    [barItems addObject:doneBtn];
    [self.pickerToolBar setItems:barItems animated:YES];
    
    [self.datePicker setBackgroundColor:[UIColor whiteColor]];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.datePicker.minimumDate = [self numberOfPreviousYears:110 fromDate:[NSDate date]];
    //self.datePicker.maximumDate = [self numberOfPreviousYears:18 fromDate:[NSDate date]];
    [self.datePickerView addSubview:self.pickerToolBar];
    [self.datePickerView addSubview:self.datePicker];
    [self.view addSubview:self.datePickerView];
    
}
-(void)resignKeyboardsInPickerView
{
    [self.ssnTF resignFirstResponder];
    [self.addressTF2 resignFirstResponder];
    [self.dateOfBirthTF resignFirstResponder];
    [self.addressTF resignFirstResponder];
    [self.cityTF resignFirstResponder];
    [self.resStateTF resignFirstResponder];
    [self.zipCodeTF resignFirstResponder];
    [self.secondaryPhoneTF resignFirstResponder];
    [self.phoneNumberTF resignFirstResponder];
    [self.pinTxtFld resignFirstResponder];
    
}
- (NSDate *)numberOfPreviousYears:(NSInteger)years fromDate:(NSDate *)from {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-years];
    
    return [gregorian dateByAddingComponents:offsetComponents toDate:from options:0];
    
}

- (void)donebuttonClicked:(id) sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    
    self.dateFormateStr = [dateFormatter1 stringFromDate:self.datePicker.date];
    
    NSString *str = [dateFormatter stringFromDate:self.datePicker.date];
    
    self.selectedDOB = self.datePicker.date;
    
    [self.dateOfBirthTF setText:str];
    [self.datePickerView removeFromSuperview];
    
    
    [self.ssnTF becomeFirstResponder];
}

- (void)datecancelbuttonClicked:(id) sender
{
    [self.datePickerView removeFromSuperview];
    [self.ssnTF becomeFirstResponder];
}


#pragma mark - Delegates

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *nextTextField1 = (UITextField *)[self.registrationView viewWithTag:textField.tag + 1];
    UITextField *nextTextField = (UITextField *)[self.personalInformationView viewWithTag:textField.tag + 1];
    UITextField *nextTextField2 = (UITextField *)[self.accountInformationView viewWithTag:textField.tag + 1];
    
    UITextField *nextTextField3 = (UITextField *)[self.accountInformationView viewWithTag:textField.tag + 1];
    UITextField *nextTextField4 = (UITextField *)[self.digitalVoucherView viewWithTag:textField.tag + 1];
    
    if (textField == self.firstNameTF || textField == self.lastNameTF|| textField == self.phoneNumberTF ||textField == self.emailAddressTF) {
        [nextTextField1 becomeFirstResponder];
    }
    
    
    if ( textField == self.addressTF || textField == self.addressTF2 || textField == self.zipCodeTF || textField == self.cityTF || textField == self.dateOfBirthTF   || textField == self.ssnTF) {
        [nextTextField becomeFirstResponder];
    }
    
    if (textField == self.usernameTF || textField == self.passwordTF || textField == self.confirmPasswordTF ) {
        [nextTextField2 becomeFirstResponder];
    }
    if (textField == self.pinTxtFld || textField == self.confirmPinTxtFld || textField == self.rewardsIdTxtFld) {
        [nextTextField3 becomeFirstResponder];
    }
    
    
    
    
    
    //    if (textField == self.countryTF) {
    //        [self.zipCodeTF becomeFirstResponder];
    //    }
    
    if (textField == self.confirmPasswordTF) {
        //[self.questionTF becomeFirstResponder];
    }
    
    
    if (textField == self.pinTxtFld) {
        [self.confirmPinTxtFld becomeFirstResponder];
    }
    
    if (textField == self.confirmPinTxtFld) {
        //[self.questionTF becomeFirstResponder];
    }
    
    
    if (textField == self.userNameTxtFld) {
        
        [nextTextField4 becomeFirstResponder];
        
    }
    
    else if (textField == self.passWordTxtFld) {
        
        [nextTextField4 becomeFirstResponder];
        
    }
    [textField resignFirstResponder];
    return YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    switch (textField.tag) {
            
        case 80://Username Text field
        {
            [self.userlabel setHidden:YES];
            /*
            if (IS_IPHONE5){
                [self.userlabel setFrame:CGRectMake(10, 65, 300, 60)];
            }else{
                [self.userlabel setFrame:CGRectMake(10, 65, 300, 57)];
                
            }
            [self.userlabel setText:@"Please create a username. This will be your username on MyWinners.com.\n Username must be a minimum of 6 characters and may contain any combination of letters and numbers."];*/
            
        }
            break;
        case 81://Password Text field
        {
            [self.userlabel setHidden:YES];
            /*
            [self.userlabel setFrame:CGRectMake(10, 65, 300, 44)];
            [self.userlabel setText:@"Please create a password. Your password must be a minimum of 6 characters and must contain 1 uppercase letter, 1 lowercase letter and 1 number."];*/
            
        }
            break;
        case 62://Password Text field
        {
            [self.addressTF2 resignFirstResponder];
        }
            break;
        default:
            [self.userlabel setHidden:YES];
            
            break;
            
            
    }
    
    [self.statesPickerView removeFromSuperview];
    [self.pickerToolBar1 removeFromSuperview];
    UIImageView *leftSideImgView;
    
    if (self.registrationInformationBtn.selected == NO) {
        leftSideImgView = (UIImageView *)[self.registrationView viewWithTag:textField.tag - 30];
    }
    else if(self.personalInformationBtn.selected == NO)
    {
        leftSideImgView = (UIImageView *)[self.personalInformationView viewWithTag:textField.tag - 30];
    }
    else
    {
        leftSideImgView = (UIImageView *)[self.accountInformationView viewWithTag:textField.tag - 30];
    }
    
    
    [leftSideImgView setBackgroundColor:[UIColor colorWithRed:2.0/255.0 green:121.0/255.0 blue:205.0/255.0 alpha:1.0]];
    
    if (textField == self.dateOfBirthTF) {
        [self showCalendar:self.calendarBtn];
    }
    
    
    CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
    
    if (bottomEdge >= 250) {//250
        CGRect viewFrame = self.view.frame;
        
        if (IS_IPHONE5) {
            if (self.personalInformationBtn.selected == NO) {
                self.shiftForKeyboard = bottomEdge - 239;
            }else{
                self.shiftForKeyboard = bottomEdge - 190;
            }
        }
        else{
            if (self.personalInformationBtn.selected == NO) {
                
                self.shiftForKeyboard = bottomEdge - 210 ;
            }else{
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
    if (self.registrationInformationBtn.selected == NO) {
        
        leftSideImgView = (UIImageView *)[self.registrationView viewWithTag:textField.tag - 30];
    }else if(self.personalInformationBtn.selected == NO){
        leftSideImgView = (UIImageView *)[self.personalInformationView viewWithTag:textField.tag - 30];
    }else if (self.accountInformationBtn.selected == NO){
        leftSideImgView = (UIImageView *)[self.accountInformationView viewWithTag:textField.tag - 30];
    }
    
    if ([textField.text isEqualToString:@""]) {
        [leftSideImgView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:14.0/255.0 blue:14.0/255.0 alpha:1.0]];
    }else{
        [leftSideImgView setBackgroundColor:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0]];
    }
    
    
    if (self.view.frame.origin.y == 0) {
        [textField resignFirstResponder];
    }else{
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
            
        case 40://Firstname Text field
        case 41://Lastname Text field
        {
            return ((newLength <= 25) ? YES : NO);
        }
        case 80://Username Text field
        {
            
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacters] invertedSet];
            
            if (range.length == 0 &&
                [cs characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return ((newLength <= 25) ? YES : NO);
            
        }
            break;
            
        case 45: // MyWinnersID
        case 46:
        {
            int mywinnerIdLenth = [[self.registerAppConfigDict valueForKey:@"newreg_s1_playerId_limit"] intValue];
            return ((newLength <= mywinnerIdLenth) ? YES : NO);
            
        }
            break;
            
        case 81://Password Text field
        case 82://Confirm Password Text field
        {
            return ((newLength <= 12) ? YES : NO);
        }
            
        case 60: //Address Text field
            
            return (newLength <= 140) ? YES : NO;
            
            break;
        case 61: // Winner Pin TF
            
            return (newLength <= 140) ? YES : NO;
            
            break;
            
        case 62: //Zip Code Text Field
            
            if (newLength == 5){
                NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
                
                
                NSLog(@"text %@",str);//zipcodeConvertToCity
                
                [self zipcodeConvertToCity:str];
            }
            return (newLength <= 5) ? YES : NO;
            
            break;
            
        case 63: //City TF
            
            return YES;
            break;
            
            //        case 65: //Country TF
            //
            //            return YES;
            //            break;
            
        case 64: // State TF
            
            return YES;
            break;
        case 65: //Date of Birth text field
        {// All digits entered
            if (range.location == 10) {
                return NO;
            }
            
            // Reject appending non-digit characters
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            // Auto-add hyphen before appending 2nd digit
            if (range.length == 0 &&
                (range.location == 2 || range.location == 5)) {
                textField.text = [NSString stringWithFormat:@"%@/%@", textField.text, string];
                return NO;
            }
            
            // Delete slash when deleting its trailing digit
            if (range.length == 1 && (range.location == 3 || range.location == 6))  {
                range.location--;
                range.length = 2;
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
            
            return YES;
        }
            break;
            
        case 66: // SSN Text field
        {
            // All digits entered
            if (range.location == 11) {
                return NO;
            }
            /*
             // Reject appending non-digit characters
             if (range.length == 0 &&
             ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
             return NO;
             }*/
            
            if (range.location == 12 || newLength > 11 ) {
                return NO;
            }
            
            // Auto-add hyphen before appending 3th or 7th
            if (range.length == 0 &&
                (range.location == 3 || range.location == 6)) {
                textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
                return NO;
            }
            
            // Delete hyphen when deleting its trailing digit
            if (range.length == 1 &&
                (range.location == 4 || range.location == 7))  {
                range.location--;
                range.length = 2;
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
            
            if (range.location == 9) {
                NSLog(@"Pasted");
            }
            
            
            return YES;
        }
            break;
            
        case 67: // Secondary Phone No TF
            
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
            break;
            
        case 44: // State res Text field
            
            return YES;
            break;
            
        case 43: //Phone Number number Text Field
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
            
        case 42: // Email TF
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:emailAcceptableCharacters] invertedSet];
            
            if (range.length == 0 &&
                [cs characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            return YES;
        }
            
        case 83: // PIN number TF
        case 84: // Confirm PIN NUmber TF
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return (newLength <= 4) ? YES : NO;
            
            break;
            
        case 85: // secret word TF
        case 86: // Confirm secret word TF
        {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableSecrteCharacters] invertedSet];
            
            if (range.length == 0 &&
                [cs characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            int secrectWordLenth = [[self.registerAppConfigDict valueForKey:@"newreg_s3_secret_word_limit"] intValue];
            return ((newLength <= secrectWordLenth) ? YES : NO);
        }
            break;
            
            
            
            
            
            
       
        case 87:
        {
            int promocodeLenth = [[self.registerAppConfigDict valueForKey:@"reg_promo_code_limit"] intValue];
            
            return ((newLength <= promocodeLenth) ? YES : NO);
            break;
        }
            
        case 4: // pin Number TF
        case 5: // confirm pinnumber TF
            
            return (newLength <= 4) ? YES : NO;
            break;
            
        case 6: // Player ID TF
            
            return (newLength <= 20) ? YES : NO;
            
            break;
            
        case 2: //digital voucher password
        case 3: //confirm pswd
            
            
            
        default:
            
            return YES;
            
            break;
            
    }
    
    
}



#pragma mark ----
#pragma mark ZIP Code API


- (void)zipcodeConvertToCity:(NSString *)zipCode
{
    NSString *tempStr = [NSString stringWithFormat:zipCodeAPI,zipCode];
    
    NSString* encodedUrl = [tempStr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:encodedUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0] ;
    NSURLConnection *urlConnection= [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    if (urlConnection) {
        receivedData=[NSMutableData data];
    }
    
}

#pragma mark ----
#pragma XMLto Dic

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse:::");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [receivedData appendData:data];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    XMLToDictionary *toDictionary=[[XMLToDictionary alloc]init];
    NSDictionary *zipCodeDict = [toDictionary parseData:receivedData enableDebug:YES];
    NSLog(@"dataDic %@", zipCodeDict);
    
    NSDictionary *tempDict = [[zipCodeDict  valueForKey:@"CityStateLookupResponse"] valueForKey:@"ZipCode"];
    
    [[LeveyHUD sharedHUD] disappear];
    //Error
    NSString *cityStr;
    NSLog(@"All Keys %@",[tempDict allKeys]);
    if ([[tempDict allKeys]  containsObject:@"Error"]){
        cityStr = [[tempDict valueForKey:@"Error"] valueForKey:@"Description"];
        [self alertViewMethod:Aleart_Title messageText:cityStr];
        return;
        
        
    }else{
        cityStr = [tempDict valueForKey:@"City"];
        
        NSString *zipCodeState = [tempDict valueForKey:@"State"];
        if (![zipCodeState isEqualToString:@"CT"]){
            [self alertViewMethod:@"Information" messageText:@"Please enter valid Zip Code of Connecticut"];
            return;
            
        }
        self.cityTF.text = [cityStr capitalizedString];
        
    }
    
    // [[dictionaryLayout allKeys] containsObject:@"ListTiles"]
    
    
    
    
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[LeveyHUD sharedHUD] disappear];
    
    NSLog(@"error %@",error);
    
}







#pragma mark - Onedaypass methods


- (IBAction)registerBtnClicked:(id)sender
{
    
    NSDictionary *ondayPassDict;
    //This is OneDay Pass Code Here
    if ([self.registerType isEqualToString:@"ODP"]){
        [self.confirmPinTxtFld resignFirstResponder];
        [self.rewardsIdTxtFld resignFirstResponder];
        [self.userlabel setHidden:YES];
        
        if (  [self.pinTxtFld.text isEqualToString:@""] || [self.confirmPinTxtFld.text isEqualToString:@""]) {
            [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
            return;
        }
        
        if (![self.pinTxtFld.text isEqualToString:self.confirmPinTxtFld.text]) {
            [self alertViewMethod:@"Information" messageText:@"PIN numbers does't match"];
            return;
        }
        
        if ([self.pinTxtFld.text intValue] <= 1000) {
            [self alertViewMethod:@"Information" messageText:@"PIN number should be greater than 999"];
            return;
        }
        ondayPassDict = @{@"consumerType":@"ODP",
                          @"accountType":@"0",
                          @"supervisor":[[WarHorseSingleton sharedInstance] isOntSupervisorEnable],
                          @"userName":@"",
                          @"userPassword":@"",
                          @"totePin":self.pinTxtFld.text,
                          @"playerID":self.rewardsIdTxtFld.text};
    }else{
        
        [self.confirmPassWordTxtFld resignFirstResponder];
        
        if ([self.userNameTxtFld.text isEqualToString:@""] || [self.passWordTxtFld.text isEqualToString:@""] || [self.confirmPassWordTxtFld.text isEqualToString:@""]) {
            [self alertViewMethod:@"Information" messageText:@"Please fill all the fields"];
            return;
        }
        
        if (![self.passWordTxtFld.text isEqualToString:self.confirmPassWordTxtFld.text]) {
            [self alertViewMethod:@"Information" messageText:@"Password does't match"];
            return;
        }
        ondayPassDict = @{@"consumerType":@"DV",
                          @"accountType":@"0",
                          @"supervisor":[[WarHorseSingleton sharedInstance] isCplSupervisorEnable],//[[WarHorseSingleton sharedInstance] isOntEnable]
                          @"userName":self.userNameTxtFld.text,
                          @"userPassword":self.passWordTxtFld.text,
                          @"totePin":@""};
    }
    
    CGFloat axisY;
    if (IS_IPHONE5) {
        axisY = 269;
    }
    else {
        axisY = 215;
    }
    
    if (!spinner) {
        spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, axisY, 50, 50)];
        [self.view addSubview:spinner];
    }
    [spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [apiWrapper registerForAnonymousUsers:ondayPassDict success:^(NSDictionary *userDict){
        [spinner stopAnimating];
        
        if ([self.registerType isEqualToString:@"ODP"]){
            self.pinTxtFld.text = @"";
            self.confirmPinTxtFld.text = @"";
            if ([[userDict valueForKey:@"response-status"] isEqualToString:@"success"]){
                [[WarHorseSingleton sharedInstance] setIsRegisterFlag:@"Yes"];
                [[NSUserDefaults standardUserDefaults] setValue:self.rewardsIdTxtFld.text forKey:@"RewardsID"];
                self.rewardsIdTxtFld.text = @"";
                NSString *accountId = [[userDict valueForKey:@"response-content"] valueForKey:@"toteAccountId"];
                [[NSUserDefaults standardUserDefaults] setValue:accountId forKey:@"AccountID"];
                [[NSUserDefaults standardUserDefaults] setValue:accountId forKey:@"OntAccountId"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSString *successMes = [NSString stringWithFormat:@"User Registered Successfully. Your Account ID is %@",accountId];
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success" message:successMes delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                message.tag = 102;
                [message show];
                
            }else{
                self.rewardsIdTxtFld.text = @"";
                NSString *str = [userDict valueForKey:@"response-message"];
                [self alertViewMethod:@"Information" messageText:str];
                
            }
            
        }else if ([self.registerType isEqualToString:@"DV"]){
            
            if ([[userDict valueForKey:@"response-status"] isEqualToString:@"success"]){
                [[WarHorseSingleton sharedInstance] setIsRegisterFlag:@"Yes"];
                
                NSString *successMes = [NSString stringWithFormat:@"User Registered Successfully. "];
                [[NSUserDefaults standardUserDefaults] setValue:self.userNameTxtFld.text forKey:@"CplUserName"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Success" message:successMes delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                message.tag = 103;
                [message show];
                
            }else{
                self.rewardsIdTxtFld.text = @"";
                NSString *str = [userDict valueForKey:@"response-message"];
                [self alertViewMethod:@"Information" messageText:str];
                
            }
            
            
        }
        
    }failure:^(NSError *error){
        self.rewardsIdTxtFld.text = @"";
        NSLog(@"Error: %@", error.description);
        [spinner stopAnimating];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Failed to register." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [message show];
        
        
    }];
    
    
}
- (void)alertViewMethod:(NSString *)title messageText:(NSString *)mes
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:mes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UIAlertView delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.isRegisterClicked == YES && alertView.tag == 100) {
        if (buttonIndex == 0 ){
            self.isRegisterClicked = NO;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
    if(alertView.tag == 102 || alertView.tag == 103){
        ZLLoginViewController *loginViewCntr = [[ZLLoginViewController alloc] initWithNibName:@"ZLLoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginViewCntr animated:YES];
        
    }
    if(alertView.tag == 101){
        if (buttonIndex == 1 ){
            [self conFirmScreenUserDetails];
            
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
        infoHTMLContent = [self.registerAppConfigDict valueForKey:@"newreg_s1_info"];
        
    }else if (infoScreenIndex == 2){
        infoHTMLContent = [self.registerAppConfigDict valueForKey:@"newreg_s2_info"];
        
        
    }else if (infoScreenIndex == 3){
        infoHTMLContent = [self.registerAppConfigDict valueForKey:@"newreg_s3_info"];
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
                             self.infoWebView.layer.cornerRadius = 8;
                             self.infoWebView.backgroundColor = [UIColor whiteColor];
                             self.infoWebView.opaque = NO;
                             self.infoWebView.clipsToBounds = YES;
                             self.infoWebView.layer.borderColor = [UIColor whiteColor].CGColor;
                             
                             [self.infoWebView sizeThatFits:CGSizeZero];
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
    NSLog(@"recognizer %@",recognizer);
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        self.infoPopView.alpha = 0;
        self.infoPopView.hidden = YES;
        enableInfo = YES;
        self.infoTapRecognizer.enabled = NO;
        
    }
}
- (void)handleTap:(UITapGestureRecognizer*)recognizer
{
    // Do Your thing.
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.isClicked == YES){
            [self.userlabel setHidden:NO];
            [self.userlabel setText:@"Please enter your player id number to associate it with \n One Day Pass."];
            self.isClicked =NO;
            if (IS_IPHONE5){
                [self.userlabel setFrame:CGRectMake(31, 470, 260, 40)];
            }else{
                [self.userlabel setFrame:CGRectMake(31, 215, 260, 40)];
            }
        }else{
            self.isClicked =YES;
            [self.userlabel setHidden:YES];
        }
        
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
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
    
    [webView sizeThatFits:CGSizeZero];  // Pass about any size
    CGRect mWebViewFrame = webView.frame;
    
    mWebViewFrame.size.height = height+15;
    
    if (mWebViewFrame.size.height >= 350){
        mWebViewFrame.size.height = 350;
        
    }
    
    webView.frame = mWebViewFrame;
    
    
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
