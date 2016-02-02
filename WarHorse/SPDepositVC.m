//
//  SPDepositVC.m
//  WarHorse
//
//  Created by Veeru on 22/12/14.
//  Copyright (c) 2014 Sparity. All rights reserved.
//

#import "SPDepositVC.h"
#import "LeveyHUD.h"
#import "WarHorseSingleton.h"
#import "SPiFrameDepositVC.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"


//static NSString *const cardMaxandMinAmount = @"You may request a minimum of $%@.00 and maximum up to %@%@ for each Credit/Debit card transaction.\nFor each transaction, a fee of %@%@the amount requested will apply.";

static NSString *const cardMaxandMinAmount = @"You may request a minimum of %@%@.00 and maximum up to %@%@ for each Credit/Debit card transaction.\nFor each transaction, a fee of %@%@the amount requested will apply.";


static NSString *const acceptableCharacters =@"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";// @"^\\d[0,2](\\.\\d[0,2])[0,1]$";//@"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";

#define REGEX_FOR_NUMBERS   @"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$"
#define REGEX_FOR_INTEGERS  @"^([+-]?)(?:|0|[1-9]\\d*)?$"
#define IS_A_NUMBER(string) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_FOR_NUMBERS] evaluateWithObject:string]
#define IS_AN_INTEGER(string) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REGEX_FOR_INTEGERS] evaluateWithObject:string]

@interface SPDepositVC ()

@property (nonatomic,strong) IBOutlet UIButton *addAmountBtn;
@property (nonatomic,strong) IBOutlet UILabel *addFundLabel;


@property (nonatomic,strong) IBOutlet UILabel *ammountLbl;
@property (nonatomic,strong) IBOutlet UITextField *amount_TF;
@property (nonatomic,strong) IBOutlet UILabel *creditCardLbl;
@property (nonatomic,strong) IBOutlet UITextField *creditCardDiscreption_TF;
@property (nonatomic,strong) IBOutlet UILabel *feeLbl;
@property (nonatomic,strong) IBOutlet UITextField *fee_TF;
@property (nonatomic,strong) IBOutlet UILabel *flatLbl;
@property (nonatomic,strong) IBOutlet UITextField *flat_TF;
@property (nonatomic,strong) IBOutlet UILabel *totalAmoutLbl;
@property (nonatomic,strong) IBOutlet UITextField *totalAmount_TF;

@property (nonatomic,strong) IBOutlet UILabel *termsAndConditionLbl;

@property (nonatomic,strong) IBOutlet UILabel *creditCardDiscreptionLbl;
@property (nonatomic,strong) IBOutlet UIButton *checkMarkBtn;

@property (strong, nonatomic) NSDictionary *paymentChargesDetailsDict;
@property (nonatomic,strong) NSString *processingFeeStr;
@property (nonatomic,strong) NSString *creditCardMax;
@property (nonatomic,strong) NSString *creditCardMin;

@property (nonatomic,strong) NSString *achCardMax;
@property (nonatomic,strong) NSString *achCardMin;

@property (nonatomic,strong) NSString *achFee;
@property (nonatomic,strong) NSString *totalAmountStr;

@property (assign) float processingFlatFee;

@property (nonatomic,strong) NSString *processFeeStr;
@end

@implementation SPDepositVC

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
    
    [self loadData];
    
    
}
- (void)loadData
{
    
    
    if (!IS_IPHONE5){
        self.ammountLbl.frame = CGRectMake(self.ammountLbl.frame.origin.x, 113, self.ammountLbl.frame.size.width, self.ammountLbl.frame.size.height);
        self.amount_TF.frame = CGRectMake(self.amount_TF.frame.origin.x, 132, self.amount_TF.frame.size.width, self.amount_TF.frame.size.height);
        
        self.creditCardLbl.frame = CGRectMake(self.creditCardLbl.frame.origin.x, 167, self.creditCardLbl.frame.size.width, self.creditCardLbl.frame.size.height);
        self.creditCardDiscreptionLbl.frame = CGRectMake(self.creditCardDiscreptionLbl.frame.origin.x, 186, self.creditCardDiscreptionLbl.frame.size.width, self.creditCardDiscreptionLbl.frame.size.height);
        
        self.feeLbl.frame = CGRectMake(self.feeLbl.frame.origin.x, 276, self.feeLbl.frame.size.width, self.feeLbl.frame.size.height);
        self.fee_TF.frame = CGRectMake(self.fee_TF.frame.origin.x, 293, self.fee_TF.frame.size.width, self.fee_TF.frame.size.height);
        
        self.flatLbl.frame = CGRectMake(self.flatLbl.frame.origin.x, 276, self.flatLbl.frame.size.width, self.flatLbl.frame.size.height);
        self.flat_TF.frame = CGRectMake(self.flat_TF.frame.origin.x, 293, self.flat_TF.frame.size.width, self.flat_TF.frame.size.height);
        
        
        self.totalAmoutLbl.frame = CGRectMake(self.totalAmoutLbl.frame.origin.x, 331, self.totalAmoutLbl.frame.size.width, self.totalAmoutLbl.frame.size.height);
        self.totalAmount_TF.frame = CGRectMake(self.totalAmount_TF.frame.origin.x, 351, self.totalAmount_TF.frame.size.width, self.totalAmount_TF.frame.size.height);
        
        
        self.termsAndConditionLbl.frame = CGRectMake(self.termsAndConditionLbl.frame.origin.x, 378, self.termsAndConditionLbl.frame.size.width, self.termsAndConditionLbl.frame.size.height);
        
        self.checkMarkBtn.frame = CGRectMake(self.checkMarkBtn.frame.origin.x, 386, self.checkMarkBtn.frame.size.width, self.checkMarkBtn.frame.size.height);
        
        
        
        
    }
    
    
    
    self.termsAndConditionLbl.text = @"I have read and understand the Terms and Conditions of using this service to fund my account using my credit or debit card.";
    
    [self.termsAndConditionLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    
    [self.ammountLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    
    
    [self.creditCardLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:12.8]];
    
    [self.creditCardDiscreptionLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [self.feeLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    
    [self.flatLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    
    [self.totalAmoutLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    
    
    
    
    [self.addFundLabel setText:@"Add funds to your account"];
    [self.addFundLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.addFundLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
    
    
    //[self.addAmountBtn setBackgroundColor:[UIColor colorWithRed:182.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
    [self.addAmountBtn setTitle:@"NEXT" forState:UIControlStateNormal];
    [self.addAmountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.addAmountBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    [self.amount_TF.layer setBorderWidth:0.5];
    [self.amount_TF setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.amount_TF.layer setBorderColor:[[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1.0] CGColor]];
    
    
    UIView *amountTFRightPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.amount_TF.frame.size.height)];
    self.amount_TF.rightView = amountTFRightPaddingView;
    self.amount_TF.rightViewMode = UITextFieldViewModeAlways;
    
    UIView *amountTFLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.amount_TF.frame.size.height)];
    self.amount_TF.leftView = amountTFLeftPaddingView;
    self.amount_TF.leftViewMode = UITextFieldViewModeAlways;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.paymentChargesDetailsDict = [[NSDictionary alloc] initWithDictionary:[[WarHorseSingleton sharedInstance] paymentChargesDict]];
    
    
    if ([[[self.paymentChargesDetailsDict valueForKey:@"response-content"] valueForKey:@"statusMessage"]isEqualToString:@"SUCCESS"]){
        
        self.achCardMax = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"achMaxLimit"];//achMinLimit
        
        
        self.achCardMin = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"achMinLimit"];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.achCardMin forKey:@"AchMinAmount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        
        self.creditCardMax = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMaxDepositPerTransaction"];
        
        self.creditCardMin = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardMinDepositPerTransaction"];
        
        self.achFee = [[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"achFee"];
        
        self.processingFlatFee = [[[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardFee"] floatValue];
        self.flat_TF.text = [NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],self.processingFlatFee];
        
        
        
        
        self.processFeeStr =[NSString stringWithFormat:@"%@",[[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardServiceChargePercentage"]];
        float processingFeeCR;
        
        processingFeeCR = [self.processFeeStr floatValue];
        
        
        NSString *placeHolderText =[NSString stringWithFormat:@"Minimum amount for deposit: %@%@.00",[[WarHorseSingleton sharedInstance] currencySymbel],self.creditCardMin];
        self.amount_TF.placeholder = placeHolderText;
        
        
        
        self.processingFeeStr = [NSString stringWithFormat:@"%@%.2f",[[WarHorseSingleton sharedInstance] currencySymbel],processingFeeCR];
        
        self.feeLbl.text =[NSString stringWithFormat:@"Fees (%.1f%s)",processingFeeCR,"%"];
        
        
    }else{
        self.achCardMax = @"9999";
        self.achCardMin = @"25";
        self.creditCardMax = @"500";
        self.creditCardMin = @"1";
        self.achFee = @"0";
        self.processingFeeStr = @"3.5";
        self.processFeeStr = @"3.5";
        
        
    }
    
    NSString *temp = [NSString stringWithFormat:cardMaxandMinAmount,[[WarHorseSingleton sharedInstance] currencySymbel],self.creditCardMin,[[WarHorseSingleton sharedInstance] currencySymbel],self.creditCardMax,self.processFeeStr,@"%"];
    
    NSLog(@"temp %@",temp);
    
    
    self.creditCardDiscreptionLbl.text = [NSString stringWithFormat:cardMaxandMinAmount,[[WarHorseSingleton sharedInstance] currencySymbel],self.creditCardMin,[[WarHorseSingleton sharedInstance] currencySymbel],self.creditCardMax,self.processFeeStr,@"%"];

    //self.creditCardDiscreptionLbl.text = [NSString stringWithFormat:[[WarHorseSingleton sharedInstance] currencySymbel],cardMaxandMinAmount,[[WarHorseSingleton sharedInstance] currencySymbel],self.creditCardMin,self.creditCardMax,self.processFeeStr,@"%"];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addAmountClicked:(id)sender
{
    
    if (![self validateAmout:self.amount_TF.text])
    {
        [self alertViewMethod:@"Information!" messageText:@"Invalid amount requested"];
        return;
    }

    
    int amountInteger = [self.amount_TF.text intValue];
    
    //this is ach acount max and min amount validation
    
    if (self.amount_TF.text.length == 0){
        [self alertViewMethod:@"Information!" messageText:@"Please fill amount field"];

        return;
        
    }
    
    // min amount value validation.
    if (amountInteger >=[_creditCardMin intValue]){
        
    }else{
        NSString *str = [NSString stringWithFormat:@"Minimum amount is %@",_creditCardMin];
        
        [self alertViewMethod:@"Add funds" messageText:str];

        
        return;
    }
    
    
    if (amountInteger <= [_creditCardMax intValue]){
        
    }else{
        NSString *str = [NSString stringWithFormat:@"Max amount is  %@",_creditCardMax];
        
        
        [self alertViewMethod:@"Add funds" messageText:str];

        return;
    }
    
    
    
    if (self.checkMarkBtn.selected == NO) {
        
        [self alertViewMethod:@"Information!" messageText:@"Please Accept Terms & Conditions"];

        return;
    }
    
    self.totalAmountStr = [self.totalAmountStr stringByReplacingOccurrencesOfString:[[WarHorseSingleton sharedInstance] currencySymbel] withString:@""];
    
    
    if([self.paymentChargesDetailsDict count] > 0){
        [[LeveyHUD sharedHUD] appearWithText:@"Loading..."];

        
        NSString *flatFee = [NSString stringWithFormat:@"%@",[[[self.paymentChargesDetailsDict valueForKey:@"response-content"]valueForKey:@"playerPaymentPreferences"] valueForKey:@"cardFee"]];;
        NSDictionary *paymentDetailsDic = @{@"totalAmount":self.totalAmountStr,
                                            @"depositAmount":self.amount_TF.text,
                                            @"processingFee":self.processFeeStr,
                                            @"flatFee":flatFee,
                                            
                                            };
        
        ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
        [apiWrapper creditCardDepositUrl:paymentDetailsDic success:^(NSDictionary *_userInfo) {
            [[LeveyHUD sharedHUD] disappear];

            if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]) {
                SPiFrameDepositVC *iFrameVC = [[SPiFrameDepositVC alloc] initWithNibName:@"SPiFrameDepositVC" bundle:nil];
                iFrameVC.secureTradingAPI = [[_userInfo valueForKey:@"response-content"] valueForKey:@"creditCardUrl"];
                [self.navigationController pushViewController:iFrameVC animated:YES];
                
                
                
            }else{
                NSString *errorMes = [_userInfo valueForKey:@"response-message"];
               
                
                [self alertViewMethod:@"Information!" messageText:errorMes];


            }
            
        } failure:^(NSError *error) {
            [[LeveyHUD sharedHUD] disappear];
            
            [self alertViewMethod:@"Information!" messageText:@"Unable to add funds, please try again"];
            
        }];
        
        
        
        
    }
    else{
        [[LeveyHUD sharedHUD] disappear];

        [self alertViewMethod:@"Information!" messageText:@"The server could not process your request at this time, please try later"];

    }
    
    
    
    
}

- (BOOL)validateAmout:(NSString *)amountStr
{
    NSString *amountRegex = @"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *amoutTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", amountRegex];
    
    return [amoutTest evaluateWithObject:amountStr];
    
}

- (void)alertViewMethod:(NSString *)title messageText:(NSString *)mes
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:title message:mes delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)backClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)acceptTermsButtonClicked:(id)sender
{
    if ([sender isSelected]) {
        
        [sender setSelected:NO];
    }
    else{
        [sender setSelected:YES];
    }
    
}
- (IBAction)BackGroundClicked
{
    [self keyBoardResign];
    
}
- (void)keyBoardResign
{
    [self.amount_TF resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   /*
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:acceptableCharacters] invertedSet];
    
    if (range.length == 0 &&
        [cs characterIsMember:[string characterAtIndex:0]]) {
        return NO;
    }
    */
    NSString *totalAmount;
    if (range.length == 1 && string.length == 0){
        
        totalAmount = [textField.text substringToIndex:[textField.text length]-1];
        
    }else{
        totalAmount = [textField.text stringByAppendingString:string];
        
    }
    NSString *enterAmountUser = totalAmount;//[NSString stringWithFormat:@"$ %0.2f",[enterAmount doubleValue]];
    
    
    self.processingFeeStr = [self.processingFeeStr stringByReplacingOccurrencesOfString:[[WarHorseSingleton sharedInstance] currencySymbel] withString:@""];
    float processingFee1 = [self.processingFeeStr floatValue];
    
    float feeAmount = ([enterAmountUser floatValue]/100)*processingFee1;
    
    NSString *test1 =[NSString stringWithFormat:@"%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],feeAmount];
    
    //    float test =  [test1 floatValue];
    
    
    float finalAmount = [enterAmountUser floatValue]+feeAmount+self.processingFlatFee;
    
    
    self.totalAmountStr = [NSString stringWithFormat:@"%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],finalAmount];
    self.fee_TF.text = test1;
    if (totalAmount.length == 0){
        self.totalAmountStr =@"";
    }
    self.totalAmount_TF.text = self.totalAmountStr;
    
    return YES;
}

@end
