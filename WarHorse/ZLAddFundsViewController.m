//
//  ZLAddFundsViewController.m
//  WarHorse
//
//  Created by Sparity on 8/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLAddFundsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "SPACHConformationViewController.h"
#import "SPCreditCardConformViewController.h"
#import "WarHorseSingleton.h"


static NSString *const acceptableCharacters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

@interface ZLAddFundsViewController ()
{
    IBOutlet UIImageView *bottomLineImageview;
    
    int prevIndex,currentIndex;
    BOOL paymentFlag;
    
}

@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolBar;
@property(nonatomic,retain) IBOutlet UILabel *cardNum_Label;
@property(nonatomic,retain) IBOutlet UILabel *expiryDate_Label;
@property(nonatomic,retain) IBOutlet UILabel *firstName_Label;
@property (strong, nonatomic) IBOutlet UILabel *lastName_Label;
@property (strong, nonatomic) IBOutlet UILabel *telephoneNumberLabel;
@property(nonatomic,retain) IBOutlet UILabel *securityCode_Label;
@property (strong, nonatomic) IBOutlet UILabel *routingNumLabel;
@property(nonatomic,retain) IBOutlet UILabel *amountLabel;

@property(nonatomic,retain) IBOutlet UITextField *cardNumber_TF;
@property(nonatomic,retain) IBOutlet UITextField *expiryDate_TF;
@property(nonatomic,retain) IBOutlet UITextField *telephoneNumber_TF;
@property(nonatomic,retain) IBOutlet UITextField *firstName_TF;
@property(strong, nonatomic) IBOutlet UITextField *lastName_TF;
@property(nonatomic,retain) IBOutlet UITextField *cvvCode_TF;
@property (strong, nonatomic) IBOutlet UITextField *routingNum_TF;
@property(nonatomic, strong) IBOutlet UITextField *amount_TF;


@property (nonatomic,strong) NSString *currentDateStr;

@property (assign, nonatomic) int currentTextFieldIndex;

//@property (strong, nonatomic) IBOutlet UIImageView *helpImageView;
@property (strong, nonatomic) NSDictionary *paymentChargesDetailsDict;

@property (nonatomic,strong) NSString *processingFeeStr;


@property (nonatomic,strong) NSString *creditCardMax;
@property (nonatomic,strong) NSString *creditCardMin;

@property (nonatomic,strong) NSString *achCardMax;
@property (nonatomic,strong) NSString *achCardMin;

@property (nonatomic,strong) NSString *achFee;

@property (nonatomic, strong) IBOutlet UIButton *checkingRaidoBtn;
@property (nonatomic, strong) IBOutlet UIButton *savingsRadioBtn;

@property(nonatomic, assign) BOOL isCheckingRadioButtonSelected;
@property(nonatomic, assign) BOOL isSavingsgRadioButtonSelected;

@property (nonatomic,weak) IBOutlet UILabel *checkLabel;
@property (nonatomic,weak) IBOutlet UILabel *savingsLabel;

@property (nonatomic) int transactionPerDay;
@property (nonatomic) int transactionPerWeek;
@property (nonatomic) int transactionPerMonth;

@property (nonatomic,strong) NSString *amountPerDayDeposit;
@property (nonatomic,strong) NSString *amountPerWeekDeposit;
@property (nonatomic,strong) NSString *amountPerMonthDeposit;
@property (nonatomic,strong) NSString *cardTotalTranactionMade;


@end


@implementation UITextField (DisableCopyPaste)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    [UIMenuController sharedMenuController].menuVisible = NO;
    return NO;
}

@end

@implementation ZLAddFundsViewController

@synthesize cardsArray=_cardsArray;

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
    
        
    //self.checkingRaidoBtn.hidden = YES;
    //self.savingsRadioBtn.hidden = YES;
    
    //self.checkLabel.hidden = YES;
    //self.savingsLabel.hidden = YES;
    
    
    currentIndex = -1;
    prevIndex = -2;
    // Do any additional setup after loading the view from its nib.
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"ddMMM YYYY"];
    self.currentDateStr = [dateFormater stringFromDate:currentDate];
    
    [self prepareTopView];
    
    [self prepareView];
    
    self.firstName_TF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"firstname"];
    self.lastName_TF.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastname"];
    self.CardTypeSegmentedControl.selectedSegmentIndex = 0;
    
    [self.addFundLabel setText:@"Add funds to your account"];
    [self.addFundLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.addFundLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
    [self.addFundLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.selectLabel setText:@"Select one"];
    [self.selectLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.selectLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
    [self.selectLabel setBackgroundColor:[UIColor clearColor]];
    
    [processingFeeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:11]];
    [processingFeeLabel setTextColor:[UIColor redColor]];
    
    if (IS_IPHONE5) {
        _fundsTableView.frame = CGRectMake(_fundsTableView.frame.origin.x, _fundsTableView.frame.origin.y, _fundsTableView.frame.size.width, _fundsTableView.frame.size.height+55);
        bottomLineImageview.frame = CGRectMake(bottomLineImageview.frame.origin.x, 470, bottomLineImageview.frame.size.width, bottomLineImageview.frame.size.height);
        self.addAmountBtn.frame = CGRectMake(self.addAmountBtn.frame.origin.x, 500, self.addAmountBtn.frame.size.width, self.addAmountBtn.frame.size.height);
    }
    
    
    [self paymentServiceCharge];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.paymentChargesDetailsDict = [[NSDictionary alloc] initWithDictionary:[[WarHorseSingleton sharedInstance] paymentChargesDict]];
    
    
    if ([[[self.paymentChargesDetailsDict valueForKey:@"response-content"] valueForKey:@"statusMessage"]isEqualToString:@"SUCCESS"]){
        
        self.achCardMax = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"achMaxLimit"];//achMinLimit
        
        
        self.achCardMin = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"achMinLimit"];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.achCardMin forKey:@"AchMinAmount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        
        self.creditCardMax = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMaxDepositPerTransaction"];
        
        self.creditCardMin = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMinDepositPerTransaction"];
        
        self.achFee = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"achFee"];
        
        float processingFeeCR;
        
        processingFeeCR = [[[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardServiceChargePercentage"] floatValue];
        
        
        self.processingFeeStr = [NSString stringWithFormat:@"%.2f",processingFeeCR];
        
        
    }else{
        self.achCardMax = @"9999";
        self.achCardMin = @"25";
        self.creditCardMax = @"500";
        self.creditCardMin = @"1";
        self.achFee = @"0";
        self.processingFeeStr = @"3.5";
        
        
    }
   
    [self selectCardType:self.CardTypeSegmentedControl];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.cardNumber_TF.text = @"";
    self.expiryDate_TF.text = @"";
    self.telephoneNumber_TF.text = @"";
    //self.firstName_TF.text = @"";
    //self.lastName_TF.text = @"";
    self.cvvCode_TF.text = @"";
    self.routingNum_TF.text = @"";
    self.amount_TF.text = @"";
    
    [self.cvvCode_TF resignFirstResponder];
    [self.routingNum_TF resignFirstResponder];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private API

- (void)prepareTopView
{
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton = nil;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 21)];
    [title setText:@"Wallet"];
    [title setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title];
    title=nil;
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 20, 44, 44)];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    [self.amountButton setBackgroundImage:[UIImage imageNamed:@"balancebg@2x.png"] forState:UIControlStateSelected];
    [self.amountButton setTitle:@"" forState:UIControlStateNormal];
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.amountButton.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [self.amountButton addTarget:self action:@selector(amountButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.amountButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
}

- (void) prepareView
{
    [self.addAmountBtn setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
    [self.addAmountBtn setTitle:@"ADD AMOUNT" forState:UIControlStateNormal];
    [self.addAmountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addAmountBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [self.amountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.firstName_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.lastName_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.cardNum_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.expiryDate_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.telephoneNumberLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.securityCode_Label setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.routingNumLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [self.savingsLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.checkLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    
    [self.amount_TF.layer setBorderWidth:0.5];
    [self.amount_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.amount_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    [self.firstName_TF.layer setBorderWidth:0.5];
    [self.firstName_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.firstName_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    [self.lastName_TF.layer setBorderWidth:0.5];
    [self.lastName_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.lastName_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    [self.cardNumber_TF.layer setBorderWidth:0.5];
    [self.cardNumber_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.cardNumber_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    [self.expiryDate_TF.layer setBorderWidth:0.5];
    [self.expiryDate_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.expiryDate_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    [self.telephoneNumber_TF.layer setBorderWidth:0.5];
    [self.telephoneNumber_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.telephoneNumber_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    [self.cvvCode_TF.layer setBorderWidth:0.5];
    [self.cvvCode_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.cvvCode_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    [self.routingNum_TF.layer setBorderWidth:0.5];
    [self.routingNum_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.routingNum_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    UIView *amountTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.amount_TF.frame.size.height)];
    self.amount_TF.rightView = amountTFRightPaddingView;
    self.amount_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *amountTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.amount_TF.frame.size.height)];
    self.amount_TF.leftView = amountTFLeftPaddingView;
    self.amount_TF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *firstNameTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.firstName_TF.frame.size.height)];
    self.firstName_TF.rightView = firstNameTFRightPaddingView;
    self.firstName_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *firstNameTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.firstName_TF.frame.size.height)];
    self.firstName_TF.leftView = firstNameTFLeftPaddingView;
    self.firstName_TF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *lastNameTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.lastName_TF.frame.size.height)];
    self.lastName_TF.rightView = lastNameTFRightPaddingView;
    self.lastName_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *lastNameTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.lastName_TF.frame.size.height)];
    self.lastName_TF.leftView = lastNameTFLeftPaddingView;
    self.lastName_TF.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIView *cardNumberTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.cardNumber_TF.frame.size.height)];
    self.cardNumber_TF.rightView = cardNumberTFRightPaddingView;
    self.cardNumber_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *cardNumberTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.cardNumber_TF.frame.size.height)];
    self.cardNumber_TF.leftView = cardNumberTFLeftPaddingView;
    self.cardNumber_TF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *expiryDateTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.expiryDate_TF.frame.size.height)];
    self.expiryDate_TF.rightView = expiryDateTFRightPaddingView;
    self.expiryDate_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *expiryDateTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.expiryDate_TF.frame.size.height)];
    self.expiryDate_TF.leftView = expiryDateTFLeftPaddingView;
    self.expiryDate_TF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *telephoneNumberTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.telephoneNumber_TF.frame.size.height)];
    self.telephoneNumber_TF.rightView = telephoneNumberTFRightPaddingView;
    self.telephoneNumber_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *telephoneNumberTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.telephoneNumber_TF.frame.size.height)];
    self.telephoneNumber_TF.leftView = telephoneNumberTFLeftPaddingView;
    self.telephoneNumber_TF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *securityCodeTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.cvvCode_TF.frame.size.height)];
    self.cvvCode_TF.rightView = securityCodeTFRightPaddingView;
    self.cvvCode_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *securityCodeTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.cvvCode_TF.frame.size.height)];
    self.cvvCode_TF.leftView = securityCodeTFLeftPaddingView;
    self.cvvCode_TF.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *routingNumberTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.routingNum_TF.frame.size.height)];
    self.routingNum_TF.rightView = routingNumberTFRightPaddingView;
    self.routingNum_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *routingNumberTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, self.routingNum_TF.frame.size.height)];
    self.routingNum_TF.leftView = routingNumberTFLeftPaddingView;
    self.routingNum_TF.leftViewMode = UITextFieldViewModeAlways;
    
    //ToolBar functionality on top of keyboard.
    
    UIImage *backgroundImage = [UIImage imageNamed:@"keyboardbg"];
    
    [[UIToolbar appearance] setBackgroundImage:backgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setFrame:CGRectMake(0, 0, 75, 30)];
    [button1 setImage:[UIImage imageNamed:@"previous.png"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(backToPreviousTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* noSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIBarButtonItem* removeSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setFrame:CGRectMake(0, 0, 75, 30)];
    [button2 setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(moveToNextTextField:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setFrame:CGRectMake(0, 0, 75, 30)];
    [button3 setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.previousButton = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.nextButton = [[UIBarButtonItem alloc] initWithCustomView:button2];
    self.doneButton = [[UIBarButtonItem alloc] initWithCustomView:button3];
    
    noSpace.width = -10;
    removeSpace.width = -2;
    
    [self.keyboardToolBar setItems:[NSArray arrayWithObjects:removeSpace,self.previousButton,noSpace,self.nextButton,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil],self.doneButton,removeSpace, nil]];
    
    self.amount_TF.inputAccessoryView = self.keyboardToolBar;
    self.cardNumber_TF.inputAccessoryView = self.keyboardToolBar;
    self.firstName_TF.inputAccessoryView = self.keyboardToolBar;
    self.lastName_TF.inputAccessoryView = self.keyboardToolBar;
    self.expiryDate_TF.inputAccessoryView = self.keyboardToolBar;
    self.telephoneNumber_TF.inputAccessoryView = self.keyboardToolBar;
    self.cvvCode_TF.inputAccessoryView = self.keyboardToolBar;
    self.routingNum_TF.inputAccessoryView = self.keyboardToolBar;
    
    self.currentTextFieldIndex = 1;
    
    if (self.currentTextFieldIndex == 1) {
        
        [self.previousButton setEnabled:NO];
    }
    
}





- (void)paymentServiceCharge
{
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    [apiWrapper getPaymentServiceChargeInfo:nil success:^(NSDictionary *paymentDict)
     {
         NSLog(@"paymentDict %@",paymentDict);
         if ([[paymentDict valueForKey:@"response-status"] isEqualToString:@"success"]){
             
             [[WarHorseSingleton sharedInstance] setPaymentChargesDict:paymentDict];
             
             self.transactionPerDay =  [[[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMaxTransactionsPerDay"] intValue];
             
             
            self.transactionPerWeek = [[[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMaxDepositPerWeek"] intValue];
             
             self.transactionPerMonth = [[[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMaxDepositPerMonth"] intValue];
    
             
             self.amountPerDayDeposit = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardDayAmountDeposited"];
             
             self.amountPerWeekDeposit = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardWeeklyAmountDeposited"];
             
             self.amountPerMonthDeposit = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMonthAmountDeposited"];
             
             self.cardTotalTranactionMade = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardDayTransanactionsMade"];
             
             
             
         }else{
             
         }
         
     }failure:^(NSError *error){
         
     }];
}




-(void)balanceUpdated:(NSNotification *)notification
{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
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
            [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
        }failure:^(NSError *error){
        }];
        [self.amountButton setSelected:YES];
        
        rect.origin.x -= 30;
        rect.size.width += 30;
        [self.amountButton setFrame:rect];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }
}
- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(276, 20, 44, 44)];
    }
}
- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}

- (IBAction)backClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addAmountClicked:(id)sender
{
    
    [self.cvvCode_TF resignFirstResponder];
    NSString *amountStr = self.amount_TF.text;
    
    NSRange range;
    range.length = 4;
    range.location = 12;
    UIAlertView *alert;
    
    
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 0) && ([self.firstName_TF.text isEqualToString:@""] || [self.lastName_TF.text isEqualToString:@""] || [self.cardNumber_TF.text isEqualToString:@""] || [self.expiryDate_TF.text isEqualToString:@""] || [self.telephoneNumber_TF.text isEqualToString:@""] || [self.cvvCode_TF.text isEqualToString:@""])) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 0) && [[self.expiryDate_TF.text substringToIndex:2] isEqualToString:@"00"]){
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill the valid month" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 1) && ([self.firstName_TF.text isEqualToString:@""] || [self.lastName_TF.text isEqualToString:@""] || [self.cardNumber_TF.text isEqualToString:@""] || [self.routingNum_TF.text isEqualToString:@""])) {
        
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 0)&&[self.cardNumber_TF.text stringByReplacingOccurrencesOfString:@"-" withString:@""].length<7){
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please provide a complete credit card number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }

    
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 0) && (self.expiryDate_TF.text.length<7)){
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please check expiry date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 0) && [self.telephoneNumber_TF.text stringByReplacingOccurrencesOfString:@"-" withString:@""].length<10){
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please provide a complete telephone number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    // max amount value validation
    
    int amountInteger = [amountStr intValue];
    
    //this is ach acount max and min amount validation
    
    if (self.CardTypeSegmentedControl.selectedSegmentIndex == 0){ 
        
        // min amount value validation.
        if (amountInteger >=[_creditCardMin intValue]){
            
        }else{
            NSString *str = [NSString stringWithFormat:@"Minimum amount per transaction is $%@",_creditCardMin];
            
            alert = [[UIAlertView alloc] initWithTitle:@"Add funds" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
        
        
        if (amountInteger <= [_creditCardMax intValue]){
            
        }else{
            NSString *str = [NSString stringWithFormat:@"Maximum amount per transaction is $%@",_creditCardMax];
            alert = [[UIAlertView alloc] initWithTitle:@"Add funds" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
        
        int minYear = 2014;
        
        if (minYear <= [[self.expiryDate_TF.text substringFromIndex:3] intValue]){
            NSLog(@"no alert");
            
        }else{
            NSLog(@"alert");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"Please enter correct expiration date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 53;
            [alert show];
            return;
        }
        
       
        
    }else if (self.CardTypeSegmentedControl.selectedSegmentIndex == 1){
        
        
        if (amountInteger >=[self.achCardMin intValue]){
            
        }else{
            
            NSString *str = [NSString stringWithFormat:@"Minimum amount is %@",_achCardMin];
            
            alert = [[UIAlertView alloc] initWithTitle:@"Add funds" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
        
        
        if (amountInteger <=[self.achCardMax intValue]){
            
        }else{
            
            NSString *str = [NSString stringWithFormat:@"Max amount is  %@",_achCardMax];

            alert = [[UIAlertView alloc] initWithTitle:@"Add funds" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            return;
        }
        // min amount value validation.
        
        
        
        
    }else{
        //green dot card
    }
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 1)&&[self.cardNumber_TF.text stringByReplacingOccurrencesOfString:@"-" withString:@""].length<7){
        alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please fill the complete Account no" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return;
    }
    
    
    if (self.CardTypeSegmentedControl.selectedSegmentIndex == 0){
        
        //NSLog(@"CREDIT");self.telephoneNumber_TF.text
        NSDictionary *paymentDetailsDic = @{@"first":self.firstName_TF.text,
                                            @"last":self.lastName_TF.text,
                                            @"telephone":[self.telephoneNumber_TF.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                            @"accountnumber":[self.cardNumber_TF.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                            @"expirydate":self.expiryDate_TF.text,
                                            @"securitycode":self.cvvCode_TF.text,
                                            @"amount":amountStr,
                                            @"routingnumber":@"",
                                            @"type":@"CRD",
                                            @"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"username"],
                                            @"user_password":[[NSUserDefaults standardUserDefaults] valueForKey:@"password"],
                                            @"paymenttype":@"VISA",
                                            };
        
        SPCreditCardConformViewController *creditCardController = [[SPCreditCardConformViewController alloc] initWithNibName:@"SPCreditCardConformViewController" bundle:nil];
        creditCardController.processingFeeStr = self.processingFeeStr;
        creditCardController.enterAmount = amountStr;
        
        
        
        
        creditCardController.minAmountStr = self.creditCardMin;
        creditCardController.maxAmountStr = self.creditCardMax;
        
        creditCardController.creditPaymentDetailsDict = paymentDetailsDic;
        [self.navigationController pushViewController:creditCardController animated:YES];
        
       
    }else if (self.CardTypeSegmentedControl.selectedSegmentIndex == 1){
        //NSLog(@"ACH");
        NSDictionary *paymentDetailsDic = @{@"first":self.firstName_TF.text,
                                            @"last":self.lastName_TF.text,
                                            @"accountnumber":[self.cardNumber_TF.text stringByReplacingOccurrencesOfString:@"-" withString:@""],
                                            @"amount":self.amount_TF.text,
                                            @"routingnumber":self.routingNum_TF.text,
                                            @"type":@"ACH",
                                            @"user_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"username"],
                                            @"user_password":[[NSUserDefaults standardUserDefaults] valueForKey:@"password"],
                                            @"paymenttype":@"S",
                                            };
        

        
        
        SPACHConformationViewController *achConfirmViewController = [[SPACHConformationViewController alloc] initWithNibName:@"SPACHConformationViewController" bundle:nil];
        achConfirmViewController.achFeeStr = self.achFee;
        achConfirmViewController.userPaymentDetailsDic = paymentDetailsDic;
        [self.navigationController pushViewController:achConfirmViewController animated:YES];
        
        
    }else{
        NSLog(@"greendot");
    }
}

- (IBAction)fundCloseClicked:(id)sender
{
    [self.transparantView removeFromSuperview];
}


- (IBAction)cancelClicked:(id)sender
{
    [self.transparantView removeFromSuperview];
    
}

- (IBAction)resignKeyBoard
{
    [self.amount_TF resignFirstResponder];
    [self.firstName_TF resignFirstResponder];
    [self.lastName_TF resignFirstResponder];
    [self.cvvCode_TF resignFirstResponder];
    [self.cardNumber_TF resignFirstResponder];
    [self.routingNum_TF resignFirstResponder];
    [self.expiryDate_TF resignFirstResponder];
    [self.telephoneNumber_TF resignFirstResponder];
    
    
    
}

- (IBAction)selectCardType:(id)sender
{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"achEnableKey"] boolValue] == YES && [[[NSUserDefaults standardUserDefaults] objectForKey:@"cardEnabledKey"] boolValue] == YES) {
        

    }
    else {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"achEnableKey"] boolValue] == YES) {
            
            self.CardTypeSegmentedControl.selectedSegmentIndex = 1;
            
            [self.CardTypeSegmentedControl setEnabled:YES forSegmentAtIndex:1];
            [self.CardTypeSegmentedControl setEnabled:NO forSegmentAtIndex:0];

        }
        else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"cardEnabledKey"] boolValue] == YES) {
            
            self.CardTypeSegmentedControl.selectedSegmentIndex = 0;
            
            [self.CardTypeSegmentedControl setEnabled:YES forSegmentAtIndex:0];
            [self.CardTypeSegmentedControl setEnabled:NO forSegmentAtIndex:1];


        }
        else {
            
        }
    }
    
    
    if ([[[[WarHorseSingleton sharedInstance] paymentChargesDict] valueForKey:@"response-code"]isEqualToString:@"WH-200"]){
        paymentFlag = YES;
    }else{
        paymentFlag = NO;
    }
    
    
    
    if (self.CardTypeSegmentedControl.selectedSegmentIndex == 0) {
        
        
        NSString *placeHolderText =[NSString stringWithFormat:@"Minimum amount for deposit: $%@.00",self.creditCardMin];
        self.amount_TF.placeholder = placeHolderText;

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"achEnableKey"] boolValue] == YES && [[[NSUserDefaults standardUserDefaults] objectForKey:@"cardEnabledKey"] boolValue] == YES)    {
            [self.segmentedControlBackgroundImage setImage:[UIImage imageNamed:@"creditcard_active.png"]];
            
        }
        else {
            [self.segmentedControlBackgroundImage setImage:[UIImage imageNamed:@"creditcardNew.png"]];
            
        }
        
        processingFeeLabel.text = [NSString stringWithFormat:@"*Service Charge %@%@",self.processingFeeStr,@"%"];//@"*Processing Fee $3.5%";
        
        self.cardNum_Label.text = @"Card Number";
        
        self.routingNumLabel.hidden = YES;
        self.routingNum_TF.hidden = YES;
        
        self.expiryDate_Label.hidden = NO;
        self.expiryDate_TF.hidden = NO;
        self.telephoneNumberLabel.hidden = NO;
        self.telephoneNumber_TF.hidden = NO;
        
        self.cvvCode_TF.hidden = NO;
        self.securityCode_Label.hidden = NO;
        
        
        self.amount_TF.hidden = NO;
        self.amountLabel.hidden = NO;
        
        self.firstName_Label.hidden = NO;
        self.firstName_TF.hidden = NO;
        
        self.lastName_Label.hidden = NO;
        self.lastName_TF.hidden = NO;
        
        self.accountNumLabel.hidden = NO;
        self.cardNumber_TF.hidden = NO;
        self.cardNameLabel.hidden = NO;
        self.cardNum_Label.hidden = NO;
        processingFeeLabel.hidden = NO;
        self.addAmountBtn.hidden = NO;
        
        if (IS_IPHONE5) {
            [self.routingNum_TF setFrame:CGRectMake(15, 367, 290, 30)];
            
            [self.amountLabel setFrame:CGRectMake(15, 143, 129, 14)];
            [self.amount_TF setFrame:CGRectMake(15, 159, 290, 31)];
            
            [self.firstName_Label setFrame:CGRectMake(15, 211, 119, 14)];
            [self.firstName_TF setFrame:CGRectMake(15, 226, 138, 30)];
            
            [self.lastName_Label setFrame:CGRectMake(165, 211, 119, 14)];
            [self.lastName_TF setFrame:CGRectMake(166, 226, 139, 30)];
            
            [self.cardNum_Label setFrame:CGRectMake(15, 279, 214, 14)];
            [self.cardNumber_TF setFrame:CGRectMake(15, 294, 290, 30)];
            
            [self.expiryDate_Label setFrame:CGRectMake(15, 347, 90, 14)];
            [self.expiryDate_TF setFrame:CGRectMake(15, 361, 90, 30)];
            
            [self.telephoneNumberLabel setFrame:CGRectMake(116, 347, 214, 14)];
            [self.telephoneNumber_TF setFrame:CGRectMake(116, 361, 188, 30)];
            
            [self.securityCode_Label setFrame:CGRectMake(15, 414, 214, 14)];
            [self.cvvCode_TF setFrame:CGRectMake(15, 429, 90, 30)];
            [processingFeeLabel setFrame:CGRectMake(178, 190, 127, 14)];
            
        }
        else
        {
            [processingFeeLabel setFrame:CGRectMake(178, 202, 127, 14)];
            
            [self.amountLabel setFrame:CGRectMake(15, 154, 129, 14)];
            [self.amount_TF setFrame:CGRectMake(15, 170, 290, 31)];
            
            [self.firstName_Label setFrame:CGRectMake(15, 217, 119, 14)];
            [self.firstName_TF setFrame:CGRectMake(15, 232, 138, 30)];
            
            [self.lastName_Label setFrame:CGRectMake(165, 217, 119, 14)];
            [self.lastName_TF setFrame:CGRectMake(166, 232, 139, 30)];
            
            [self.cardNum_Label setFrame:CGRectMake(15, 272, 214, 14)];
            [self.cardNumber_TF setFrame:CGRectMake(15, 287, 290, 30)];
            
            [self.expiryDate_Label setFrame:CGRectMake(15, 333, 90, 14)];
            [self.expiryDate_TF setFrame:CGRectMake(15, 348, 90, 30)];
            
            [self.telephoneNumberLabel setFrame:CGRectMake(116, 333, 214, 14)];
            [self.telephoneNumber_TF setFrame:CGRectMake(116, 348, 188, 30)];
            
            [self.securityCode_Label setFrame:CGRectMake(15, 385, 214, 14)];
            [self.cvvCode_TF setFrame:CGRectMake(15, 405, 90, 30)];
            
        }
        
    }
    else if (self.CardTypeSegmentedControl.selectedSegmentIndex == 1)
    {
        NSString *placeHolderText =[NSString stringWithFormat:@"Minimum amount for deposit: $%@.00",self.achCardMin];
        self.amount_TF.placeholder = placeHolderText;
        

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"achEnableKey"] boolValue] == YES && [[[NSUserDefaults standardUserDefaults] objectForKey:@"cardEnabledKey"] boolValue] == YES)    {
            [self.segmentedControlBackgroundImage setImage:[UIImage imageNamed:@"ach_active.png"]];

        }
        else {
            [self.segmentedControlBackgroundImage setImage:[UIImage imageNamed:@"achNew.png"]];

        }
        

        //self.checkingRaidoBtn.hidden = NO;
        //self.savingsRadioBtn.hidden = NO;
        
        //self.checkLabel.hidden = NO;
        //self.savingsLabel.hidden = NO;

        //self.isCheckingRadioButtonSelected = YES;
        //self.isSavingsgRadioButtonSelected = NO;
        //[self.checkingRaidoBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsSelect.png"] forState:UIControlStateNormal];
        //[self.savingsRadioBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsNormal.png"] forState:UIControlStateNormal];
        
     
        
        processingFeeLabel.text =[NSString stringWithFormat:@"*Processing Fee $%@",self.achFee]; //@"*Processing Fee $1.5%";
        
        self.cardNum_Label.text = @"Account Number";
        
        self.routingNumLabel.hidden = NO;
        self.routingNum_TF.hidden = NO;
        
        self.expiryDate_Label.hidden = YES;
        self.expiryDate_TF.hidden = YES;
        self.telephoneNumberLabel.hidden = YES;
        self.telephoneNumber_TF.hidden = YES;
        
        self.cvvCode_TF.hidden = YES;
        self.securityCode_Label.hidden = YES;
        
        self.amount_TF.hidden = NO;
        self.amountLabel.hidden = NO;
        
        self.firstName_Label.hidden = NO;
        self.firstName_TF.hidden = NO;
        
        self.lastName_Label.hidden = NO;
        self.lastName_TF.hidden = NO;
        
        self.accountNumLabel.hidden = NO;
        self.cardNumber_TF.hidden = NO;
        self.cardNameLabel.hidden = NO;
        self.cardNum_Label.hidden = NO;
        processingFeeLabel.hidden = NO;
        self.addAmountBtn.hidden = NO;
        
        if (IS_IPHONE5) {
            
            [self.amountLabel setFrame:CGRectMake(15, 143, 129, 14)];
            [self.amount_TF setFrame:CGRectMake(15, 159, 290, 31)];
            
            [self.firstName_Label setFrame:CGRectMake(15, 213, 119, 14)];
            [self.firstName_TF setFrame:CGRectMake(15, 229, 138, 30)];
            
            [self.lastName_Label setFrame:CGRectMake(165, 213, 119, 14)];
            [self.lastName_TF setFrame:CGRectMake(166, 229, 139, 30)];
            
            [self.cardNum_Label setFrame:CGRectMake(15, 282, 214, 14)];
            [self.cardNumber_TF setFrame:CGRectMake(15, 298, 290, 30)];
            
            
            //[self.checkingRaidoBtn setFrame:CGRectMake(18, 332, 20, 20)];
            //[self.checkLabel setFrame:CGRectMake(43, 332, 106, 20)];
            
            //[self.savingsLabel setFrame:CGRectMake(192, 332, 106, 20)];
            //[self.savingsRadioBtn setFrame:CGRectMake(167, 332, 20, 20)];
            
            [processingFeeLabel setFrame:CGRectMake(178, 190, 127, 14)];

            
            [self.routingNumLabel setFrame:CGRectMake(15, 356, 214, 14)];
            [self.routingNum_TF setFrame:CGRectMake(15, 372, 290, 30)];
            
        }else
        {
            [self.amountLabel setFrame:CGRectMake(15, 154, 129, 14)];//154 170
            [self.amount_TF setFrame:CGRectMake(15, 170, 290, 31)];
            
            [self.firstName_Label setFrame:CGRectMake(15, 217, 119, 14)];//7y-axis
            [self.firstName_TF setFrame:CGRectMake(15, 232, 138, 30)];
            
            [self.lastName_Label setFrame:CGRectMake(165, 217, 119, 14)];
            [self.lastName_TF setFrame:CGRectMake(166, 232, 139, 30)];
            
            [self.cardNum_Label setFrame:CGRectMake(15, 279, 214, 14)];
            [self.cardNumber_TF setFrame:CGRectMake(15, 295, 290, 30)];
            
            
            //[self.checkingRaidoBtn setFrame:CGRectMake(18, 329, 20, 20)];
            //[self.checkLabel setFrame:CGRectMake(43, 329, 106, 20)];
            
            //[self.savingsLabel setFrame:CGRectMake(192, 329, 106, 20)];
            //[self.savingsRadioBtn setFrame:CGRectMake(167, 329, 20, 20)];
            
            
            [self.routingNumLabel setFrame:CGRectMake(15, 359, 214, 14)];
            [self.routingNum_TF setFrame:CGRectMake(15, 375, 290, 30)];
            
            [processingFeeLabel setFrame:CGRectMake(178, 201, 127, 14)];
        }
        
        
    }
    
    self.cardNumber_TF.text = @"";
    self.expiryDate_TF.text = @"";
    self.telephoneNumber_TF.text = @"";
    self.routingNum_TF.text = @"";
    self.cvvCode_TF.text = @"";
    self.amount_TF.text = @"";
}

- (IBAction)checkingRadioButtonAction:(id)sender {
    /*
    if (self.isCheckingRadioButtonSelected) {
        self.isCheckingRadioButtonSelected = NO;
        [self.checkingRaidoBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsNormal.png"] forState:UIControlStateNormal];
        
        self.isSavingsgRadioButtonSelected = YES;
        [self.savingsRadioBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsSelect.png"] forState:UIControlStateNormal];


    }
    else {
        self.isCheckingRadioButtonSelected = YES;
        [self.checkingRaidoBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsSelect.png"] forState:UIControlStateNormal];
        
        self.isSavingsgRadioButtonSelected = NO;
        [self.savingsRadioBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsNormal.png"] forState:UIControlStateNormal];
        

    }
     */
    
}

- (IBAction)savingsRadioButtonAction:(id)sender {
    /*
    if (self.isSavingsgRadioButtonSelected) {
        self.isSavingsgRadioButtonSelected = NO;
        [self.savingsRadioBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsNormal.png"] forState:UIControlStateNormal];
        
        self.isCheckingRadioButtonSelected = YES;
        [self.checkingRaidoBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsSelect.png"] forState:UIControlStateNormal];


    }
    else {
        self.isSavingsgRadioButtonSelected = YES;
        [self.savingsRadioBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsSelect.png"] forState:UIControlStateNormal];

        self.isCheckingRadioButtonSelected = NO;
        [self.checkingRaidoBtn setImage:[UIImage imageNamed:@"walletTermsAndConditionsNormal.png"] forState:UIControlStateNormal];

    }
     */

}

- (IBAction)moveToNextTextField:(id)sender
{
    
    
    if (self.CardTypeSegmentedControl.selectedSegmentIndex == 1 && self.currentTextFieldIndex == 4) {
        
        self.currentTextFieldIndex = self.currentTextFieldIndex + 4;
        
    }
    else
    {
        self.currentTextFieldIndex++;
        
    }
    
    UITextField *textField = (UITextField *)[self.view viewWithTag:self.currentTextFieldIndex];
    
    [textField becomeFirstResponder];
    
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 1 && self.currentTextFieldIndex == 8) || (self.CardTypeSegmentedControl.selectedSegmentIndex == 0 && self.currentTextFieldIndex == 7) ) {
        [self.nextButton setEnabled:NO];
    }
    
    [self.previousButton setEnabled:YES];
    
}

- (IBAction)backToPreviousTextField:(id)sender
{
    
    
    if (self.CardTypeSegmentedControl.selectedSegmentIndex == 1 && self.currentTextFieldIndex == 8) {
        
        self.currentTextFieldIndex = self.currentTextFieldIndex - 4;
        
    }
    else
    {
        self.currentTextFieldIndex--;
        
    }
    UITextField *textField = (UITextField *)[self.view viewWithTag:self.currentTextFieldIndex];
    
    [textField becomeFirstResponder];
    
    [self.nextButton setEnabled:YES];
    
    if (self.currentTextFieldIndex == 1) {
        [self.previousButton setEnabled:NO];
    }
    
}

- (IBAction)doneClicked:(id)sender
{
    [self resignKeyBoard];
}


#pragma mark- TextField Delegate Methods.

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField.tag == 7 || textField.tag == 8) {
        
        [textField resignFirstResponder];
        [self addAmountClicked:self.amountButton];
        
        return YES;
    }
    
    if (self.CardTypeSegmentedControl.selectedSegmentIndex == 1 && self.currentTextFieldIndex == 4) {
        
        self.currentTextFieldIndex = textField.tag + 4;
        
    }
    else
    {
        self.currentTextFieldIndex++;
        
    }
    
    UITextField *nextTextField = (UITextField *)[self.view viewWithTag:self.currentTextFieldIndex];
    
    [nextTextField becomeFirstResponder];
    
    
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    //cvvCode_TF
    
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    switch (textField.tag) {
            
        case 1: //Amount Text field
        {
        
            if (range.location == 0 && [string isEqualToString:@"."]) {
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

            return ((newLength <= 10) ? YES : NO);
            
        }
            break;
            
        case 2: //First Name Text field
        case 3: //Last Name Text Field
        {
            
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacters] invertedSet];
            
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            return ((newLength <= 15) ? YES : NO) && [string isEqualToString:filtered];
            
        }
            break;
            
        case 4: //card/account number Text Field
        {
            // All digits entered
            if (range.location == 20 || newLength > 20)
            {
                return NO;
            }
            
            // Reject appending non-digit characters
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            /*
            // Auto-add hyphen before appending 4th or 9th or 14th digit
            if (range.length == 0 &&
                (range.location == 4 || range.location == 9 || range.location == 14)) {
                textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
                return NO;
            }
            
            // Delete hyphen when deleting its trailing digit
            if (range.length == 1 &&
                (range.location == 5 || range.location == 10 || range.location == 15))  {
                range.location--;
                range.length = 2;
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
            */
            if (range.location == 20) {
                NSLog(@"Pasted");
            }
            
            
            return YES;
        }
            break;
            
        case 5: //Expiry date Text field
            
            
        {// All digits entered
            if (range.location == 7) {
                return NO;
            }
            
            // Reject appending non-digit characters
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            
            //Validation for month
            if (range.location == 0) {
                
                if ([string intValue] < 2) {
                    return YES;
                }
                
                return NO;
            }
            
            else if (range.location == 1) {
                
                if ([textField.text intValue] < 1 && [string intValue]!=0) {
                    return YES;
                }
                else
                {
                    if ([string intValue] <= 2) {
                        return  YES;
                    }
                    return NO;
                }
            }
            
            // Auto-add hyphen before appending 2nd digit
            if (range.length == 0 &&
                range.location == 2) {
                textField.text = [NSString stringWithFormat:@"%@/%@", textField.text, string];
                return NO;
            }
            
            // Delete slash when deleting its trailing digit
            if (range.length == 1 &&
                (range.location == 3))  {
                range.location--;
                range.length = 2;
                textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
            
            return YES;
        }
            
            break;
            
        case 6: // Telephone nuber Text field
        {
            // All digits entered
            if (range.location == 12 || newLength > 12 )
            {
                return NO;
            }
            
            // Reject appending non-digit characters
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
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
            
        case 7: // Cvv code Text filed
            
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return (newLength <= 4) ? YES : NO;
            break;
            
        case 8: //routing number Text field
            
            
            if (range.length == 0 &&
                ![[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]]) {
                return NO;
            }
            
            return (newLength <= 10) ? YES : NO;
            break;
            
        default:
            
            return NO;
            
            break;
    }
    
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
          self.currentTextFieldIndex = textField.tag;
    
    if (self.currentTextFieldIndex == 1) {
        [self.previousButton setEnabled:NO];
    }
    else
    {
        [self.previousButton setEnabled:YES];
    }
    
    if ((self.CardTypeSegmentedControl.selectedSegmentIndex == 0 && self.currentTextFieldIndex == 7) || (self.CardTypeSegmentedControl.selectedSegmentIndex == 1 && self.currentTextFieldIndex == 8) ) {
        [self.nextButton setEnabled:NO];
    }
    else
    {
        [self.nextButton setEnabled:YES];
    }
    
    
    
	CGRect textViewRect = [self.view.window convertRect:textField.bounds fromView:textField];
	CGFloat bottomEdge = textViewRect.origin.y + textViewRect.size.height;
	if (bottomEdge >= 250) {//250
        CGRect viewFrame = self.view.frame;
        
        if (self.CardTypeSegmentedControl.selectedSegmentIndex == 0) {
            
            if (IS_IPHONE5) {
                self.shiftForKeyboard = bottomEdge - 221; //265
                
            }
            else
            {
                self.shiftForKeyboard = bottomEdge - 171; //215
                
            }
            
        }
        else
        {
            
            if (IS_IPHONE5) {
                self.shiftForKeyboard = bottomEdge - 161; //205
                
            }
            else
            {
                self.shiftForKeyboard = bottomEdge - 123; //167
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

- (void)textFieldDidEndEditing:(UITextField *)textField
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

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 50) {
        [self.expiryDate_TF becomeFirstResponder];
        return;
    }
    
    [self.addAmountBtn setEnabled:YES];
    [self resignKeyBoard];
    
    if ([alertView.title isEqualToString:@"Success!"]) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

@end
