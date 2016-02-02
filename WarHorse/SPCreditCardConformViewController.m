//
//  SPCreditCardConformViewController.m
//  WarHorse
//
//  Created by subbu on 16/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPCreditCardConformViewController.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "SPConstant.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"


static NSString *const mesStriPhon4 = @"You may request a minimum of $%@.00 maximum up to $%@ per transaction.\nCredit card deposits are posted to the wagering account as soon as they are cleared by Secure Trading Limited.\nTo view the Secure Trading Limited Terms and Conditions or for more information about Secure Trading Limited,\nplease visit https://www.securetrading.com";

static NSString *const mesStriPhon5 = @"You may request a minimum of $%@.00 maximum up to $%@ per transaction.\n\nCredit card deposits are posted to the wagering account as soon as they are cleared by Secure Trading Limited.\nTo view the Secure Trading Limited Terms and Conditions or for more information about Secure Trading Limited,\nplease visit https://www.securetrading.com";


//You may request a minimum of $ %@.00 for each credit or debit card transaction.\nCredit card deposits are posted to the wagering account as soon as they are cleared by Secure Trading Limited.\nTo view the Secure Trading Limited Terms and Conditions or for more information about Secure Trading Limited,\nplease visit https://www.securetrading.com

@interface SPCreditCardConformViewController ()

@property (nonatomic,strong) IBOutlet UIButton *submitAmountBtn;
@property (nonatomic,strong) IBOutlet UILabel *creditCardDiscription1;
@property (nonatomic,strong) IBOutlet UILabel *creditCardDiscription2;

@property (nonatomic,strong) IBOutlet UILabel *processingFeeLabel;
@property (nonatomic,strong) IBOutlet UIImageView *boxImageview;

@end


@implementation SPCreditCardConformViewController
@synthesize creditPaymentDetailsDict;
@synthesize processingFeeStr;
@synthesize minAmountStr,maxAmountStr;
@synthesize enterAmount;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        creditPaymentDetailsDict = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    //There is a 3.5% service charge fee added to the amount you request.  Any fees charged by your credit/debit card issuer are additional and will not be displayed.
    
    
    
    
    
    
    [self prepareTopView];
    
    [enterAmtLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];//174
    [feeAmtLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [totalAmtLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [enterAmountLblD setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [feeAmountLblD setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [totalTransactionAmtLblD setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
    [acceptTermsLbl setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
    
    NSString *enterAmountUser = [NSString stringWithFormat:@"$ %0.2f",[enterAmount doubleValue]];
    
    float processingFee1 = [processingFeeStr floatValue];
    
    float feeAmount = ([enterAmount floatValue]/100)*processingFee1;
    
    NSString *proccssFee = [NSString stringWithFormat:@"$ %0.2f",feeAmount];
    
    NSString *test1 =[NSString stringWithFormat:@"%0.2f",feeAmount];

    float test =  [test1 floatValue];
    
    
    float finalAmount = [enterAmount floatValue]+test;
    
    NSString *finalAmountStr = [NSString stringWithFormat:@"$ %0.2f",finalAmount];
    
    enterAmountLblD.text = enterAmountUser;
    
    feeAmountLblD.text = proccssFee;
    
    totalTransactionAmtLblD.text = finalAmountStr;
    
    [self.processingFeeLabel setText:[NSString stringWithFormat:@"There is a %.1f%s service charge fee added to the amount you request.  Any fees charged by your credit/debit card issuer are additional and will not be displayed.",processingFee1,"%"]];

    
    if (IS_IPHONE5){
        //y-510
        [self.creditCardDiscription1 setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        
        [self.processingFeeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        
        [self.creditCardDiscription2 setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
        [self.creditCardDiscription2 setText:[NSString stringWithFormat:mesStriPhon5,minAmountStr,maxAmountStr]];

        
    }else
    {
        [self.creditCardDiscription2 setText:[NSString stringWithFormat:mesStriPhon4,minAmountStr,maxAmountStr]];

        
        self.boxImageview.frame = CGRectMake(10, 180, 300, 310);
        
        self.creditCardDiscription1.frame = CGRectMake(20, 177, 280, 46);
        self.processingFeeLabel.frame = CGRectMake(20, 197, 280, 86);
        self.creditCardDiscription2.frame = CGRectMake(20, 260, 280, 140);
        
        [self.creditCardDiscription1 setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
        
        [self.processingFeeLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
        
        [self.creditCardDiscription2 setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
        
    }
    
    [self.submitAmountBtn setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
    [self.submitAmountBtn setTitle:@"SUBMIT AMOUNT" forState:UIControlStateNormal];
    [self.submitAmountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitAmountBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[LeveyHUD sharedHUD] disappear];
    [super viewWillDisappear:animated];
}


- (void)prepareTopView
{
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 21)];
    [title setText:@"Wallet"];
    [title setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    [title setTextColor:[UIColor whiteColor]];
    [title setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:title];
    title=nil;
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
    [backButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    backButton = nil;
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(275, 20, 44, 46)];
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

#pragma mark ---
#pragma mark private API

- (void)balanceUpdated:(NSNotification *)notification
{
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
}


- (void)amountButtonClicked:(id)sender
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(230, 0, 45, 45)];
        
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
        [self.amountButton setFrame:CGRectMake(237, 20, 71, 44)];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }
}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 20, 45, 45)];
    }
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

- (IBAction)submitBtnClicked:(id)sender
{
    
    if (selectedBtn.selected == YES) {
        
        if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [[LeveyHUD sharedHUD] appearWithText:@"Deposit in process..."];
        ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
        [apiWrapper amountDepositWithPaymentDetails:creditPaymentDetailsDict success:^(NSDictionary *_userInfo) {
            
            [self.submitAmountBtn setEnabled:NO];
            if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]) {
                [[ZLAppDelegate getApiWrapper] refreshBalance:NO success:^(NSDictionary* _userInfo){
                    [[LeveyHUD sharedHUD] disappear];

                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Funds added successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                }failure:^(NSError *error){
                    
                }];
                
                
            }else{
                
                [[LeveyHUD sharedHUD] disappear];
                NSString *responeMes = [_userInfo valueForKey:@"response-message"];
                NSString *alertMes;
                if ([responeMes isEqual:[NSNull null]])
                {
                    alertMes = @"Unable to add funds, please try again";
                }else{
                    alertMes = [_userInfo valueForKey:@"response-message"];

                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information!" message:alertMes delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(NSError *error) {
            [[LeveyHUD sharedHUD] disappear];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information!" message:@"Unable to add funds, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Please Accept Terms & Conditions" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.submitAmountBtn setEnabled:YES];
    
    NSLog(@"ViewControllers = %@", [self.navigationController viewControllers]);
    if ([alertView.title isEqualToString:@"Success"]) {
        [self.navigationController popToViewController:[self.navigationController viewControllers][0] animated:YES];
    }
    
}
- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];
}


@end
