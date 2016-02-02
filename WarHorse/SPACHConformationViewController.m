//
//  SPACHConformationViewController.m
//  WarHorse
//
//  Created by subbu on 16/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPACHConformationViewController.h"
#import "ZLAPIWrapper.h"
#import "ZLAppDelegate.h"
#import "SPConstant.h"
#import "WarHorseSingleton.h"
#import "LeveyHUD.h"

@interface SPACHConformationViewController ()
@property (nonatomic,strong) IBOutlet UIButton *submitAmountBtn;
@end

@implementation SPACHConformationViewController
@synthesize userPaymentDetailsDic;
@synthesize achFeeStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        userPaymentDetailsDic = [[NSDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [achTextView setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [nameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [bankNameLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [routingLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [bankNoLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [achAmountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [lessPriseLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [totalamountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    [userNameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [banknameLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [achRoutingLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [bankAcountNoLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [achAcountAmountLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [lessPriseAmountLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    [totalWageringAmountLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:12]];
    
    
    
    if (IS_IPHONE5){
        //y-510
    }else
    {
        [self.submitAmountBtn setFrame:CGRectMake(11, 426, 298, 29)];
        
        [nameLabel setFrame:CGRectMake(10, 242,140,16)];
        [bankNameLabel setFrame:CGRectMake(10, 265, 140, 16)];
        [routingLabel setFrame:CGRectMake(10, 290, 140, 16)];
        [bankNoLabel setFrame:CGRectMake(10, 316, 140, 16)];
        [achAmountLabel setFrame:CGRectMake(10, 348, 140, 16)];
        [lessPriseLabel setFrame:CGRectMake(10, 378,140, 16)];
        [totalamountLabel setFrame:CGRectMake(10, 406,164, 16)];
        
        [userNameLabel setFrame:CGRectMake(169, 242,139, 16)];
        [banknameLabel setFrame:CGRectMake(169, 265,139, 16)];
        [achRoutingLabel setFrame:CGRectMake(169, 290, 139, 16)];
        [bankAcountNoLabel setFrame:CGRectMake(169, 316, 139, 16)];
        [achAcountAmountLabel setFrame:CGRectMake(169, 348, 139, 16)];
        [lessPriseAmountLabel setFrame:CGRectMake(169, 378, 139, 16)];
        [totalWageringAmountLabel setFrame:CGRectMake(169, 406,139, 16)];
         [achImageView setFrame:CGRectMake(10, 117, 300, 118)];
        [achTextView setFrame:CGRectMake(10, 117, 300, 118)];

        
    }
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 21)];
    [title setText:@"Wallet"];
    [title setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
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
    
    
    [self.submitAmountBtn setBackgroundColor:[UIColor colorWithRed:47.0/255.0f green:58.0/255.0f blue:65.0/255.0f alpha:1.0]];
    [self.submitAmountBtn setTitle:@"SUBMIT AMOUNT" forState:UIControlStateNormal];
    [self.submitAmountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitAmountBtn.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:15]];
    
    //acoutname back name routing no,bank acount no,ach amount ,less fee,total amount
    
    
    NSString *amountStr1 = [NSString stringWithFormat:@"%0.2f",([[userPaymentDetailsDic valueForKey:@"amount"]doubleValue])];
    
    
    float achFee =[achFeeStr floatValue];
    float feeAmmount = [amountStr1 floatValue]-achFee;
    
    
    achAcountAmountLabel.text = [NSString stringWithFormat:@"$%@", amountStr1];
    lessPriseAmountLabel.text = [NSString stringWithFormat:@"$%0.2f",achFee];
    totalWageringAmountLabel.text = [NSString stringWithFormat:@"$%0.2f",feeAmmount];
    
    
    
    NSString *userName = [NSString stringWithFormat:@"%@,%@",[userPaymentDetailsDic valueForKey:@"first"],[userPaymentDetailsDic valueForKey:@"last"]];
    userNameLabel.text = userName;
    banknameLabel.text = @"BANK";
    achRoutingLabel.text = [userPaymentDetailsDic valueForKey:@"routingnumber"];
    bankAcountNoLabel.text = [userPaymentDetailsDic valueForKey:@"accountnumber"];
    
    
    NSString *achMinAmount = [[NSUserDefaults standardUserDefaults] valueForKey:@"AchMinAmount"];

   
    NSString *tempStr = @"ACH (Automatic Clearing House)\n\nA method of funding where you can transfer funds into your wagering account directly from your checking account.\n\nMinimum deposit is $";
    NSString *tempStr1 = @"The first time you transfer funds from a particular bank account:\n\nRequests of $50 or less will be deposited immediately to your account\nRequests greater than$50 may be held for up to five (5) business days (excluding Saturday, Sunday and holidays).\n    If you have had one (1) or more successful ACH transfers using the same bank account your immediate funding limit will automatically be increased to $200.00\n    If you would like to increase your available limit, please contact Customer Service at 1-800-468-2260.";
    
    
    achTextView.text = [NSString stringWithFormat:@"%@%@\n\n %@",tempStr,achMinAmount,tempStr1];
    
    //achTextView.text = tempStr;
    
    self.amountButton = [[UIButton alloc] initWithFrame:CGRectMake(276, 20, 44, 44)];
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
- (void)viewWillDisappear:(BOOL)animated
{
    [[LeveyHUD sharedHUD] disappear];
    [super viewWillDisappear:animated];
}


#pragma mark ---
#pragma mark private API

-(void)balanceUpdated:(NSNotification *)notification
{
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
}

- (void)amountButtonClicked:(id)sender
{
    if ([self.amountButton isSelected]) {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(276, 20, 44, 44)];
        
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
        [self.amountButton setFrame:CGRectMake(272, 20, 44, 44)];
    }
}

- (IBAction)submitBtnClicked:(id)sender
{
    
    NSDictionary *paymentDetailsDic = @{@"first":[userPaymentDetailsDic valueForKey:@"first"],
                                        @"last":[userPaymentDetailsDic valueForKey:@"last"],
                                        @"telephone":@"",
                                        @"accountnumber":[userPaymentDetailsDic valueForKey:@"accountnumber"],
                                        @"expirydate":@"",
                                        @"securitycode":@"",
                                        @"amount":[userPaymentDetailsDic valueForKey:@"amount"],
                                        @"routingnumber":[userPaymentDetailsDic valueForKey:@"routingnumber"],
                                        @"type":@"ACH",
                                        @"user_id":[userPaymentDetailsDic valueForKey:@"user_id"],
                                        @"user_password":[userPaymentDetailsDic valueForKey:@"user_password"],
                                        @"paymenttype":@"C",
                                        };
    
   // NSLog(@"paymentDetailsDic %@",paymentDetailsDic);
    
    if (![[WarHorseSingleton sharedInstance] isInternetConnectionAvailable]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:Aleart_Title message:@"Unable to connect to the server, please check your internet connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    [[LeveyHUD sharedHUD] appearWithText:@"Deposit in process..."];
    [apiWrapper amountDepositWithPaymentDetails:paymentDetailsDic success:^(NSDictionary *_userInfo) {
        
        //[ZLAppDelegate hideLoadingView];
        
        [[LeveyHUD sharedHUD] disappear];
        [self.submitAmountBtn setEnabled:NO];
        
        if ([[_userInfo valueForKey:@"response-status"] isEqualToString:@"success"]) {
            [[ZLAppDelegate getApiWrapper] refreshBalance:NO success:^(NSDictionary* _userInfo){
                //        amountLabel.text = [NSString stringWithFormat:@"$%0.2f",[ZLAppDelegate getAppData].balanceAmount];
            }failure:^(NSError *error){
                
            }];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Funds added successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else
        {
            //[ZLAppDelegate hideLoadingView];
            [[LeveyHUD sharedHUD] disappear];
            
            [[LeveyHUD sharedHUD] disappear];
            //NSLog(@"diposit info %@",_userInfo);
            NSString *responeMes = [_userInfo valueForKey:@"response-message"];
            //NSLog(@"alertMes111 %@",responeMes);
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
        //[ZLAppDelegate hideLoadingView];
        [[LeveyHUD sharedHUD] disappear];
        //NSLog(@"Error is %@", error);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Unable to add funds, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
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