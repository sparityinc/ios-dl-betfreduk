//
//  ZLVerificationCodeViewController.m
//  WarHorse
//
//  Created by PVnarasimham on 04/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLVerificationCodeViewController.h"
#import "ZLLoginViewController.h"
#import "ZLAppDelegate.h"
#import "ZLAPIWrapper.h"
#import "ZLMainGridViewController.h"

@interface ZLVerificationCodeViewController ()

@property (strong, nonatomic) IBOutlet UILabel *verificationCodeLabel;
@property (strong,nonatomic) IBOutlet UILabel *textLabel;
@property (strong ,nonatomic) IBOutlet UIButton *webBtn;
- (IBAction)webUrl:(id)sender;

@end

@implementation ZLVerificationCodeViewController
@synthesize accountId;
@synthesize  userDetailsDict;
@synthesize userName;

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
    
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:[userDetailsDict valueForKey:@"totePin"] forKey:@"password"];
    
    
    [self.accountLbl1 setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [self.accountLbl2 setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    [self.accountLbl3 setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.accountLbl4 setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    
    [self.accountLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.userLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.passwordLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    [self.pinLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
    
    if (IS_IPHONE5)
    {
        
        self.accountLbl1.frame = CGRectMake(41, 252, 121, 21);//20,40,60,80,
        self.accountLbl2.frame = CGRectMake(41, 308, 121, 21);
        self.accountLbl3.frame = CGRectMake(41, 364, 121, 21);
        self.accountLbl4.frame = CGRectMake(41, 420, 121, 21);
        
        
        self.accountLabel.frame = CGRectMake(156, 252, 154, 21);
        self.userLabel.frame = CGRectMake(156, 308, 154, 21);
        self.passwordLabel.frame = CGRectMake(156, 364, 154, 21);
        self.pinLabel.frame = CGRectMake(156, 420, 154, 21);
        
        
        self.image1.frame = CGRectMake(28, 277, 264, 1);//20
        self.image2.frame = CGRectMake(28, 333, 264, 1);
        self.image3.frame = CGRectMake(28, 389, 264, 1);
        self.image4.frame = CGRectMake(28, 448, 264, 1);
        
        
        self.loginBtn.frame = CGRectMake(31,490, 258, 44);
        

    }
    
    
    self.accountLabel.text = [userDetailsDict valueForKey:@"toteAccountId"];
    self.userLabel.text = userName;
    self.passwordLabel.text = [userDetailsDict valueForKey:@"loginPassword"];
    self.pinLabel.text = [userDetailsDict valueForKey:@"totePin"];
    
    
    [self prepareView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private API

- (void)prepareView
{
    
    
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"AccountName"];

    

    [[NSUserDefaults standardUserDefaults] synchronize];
    /*
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:@"Your tote account has been successfully created. Please use the following account ID to complete your registration on www.gx.spodemo.com"];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:24.0/255.0 alpha:1.0] range:NSMakeRange(117,19)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Roboto-Medium" size:16.0] range:NSMakeRange(0, string.length)];
    [self.textLabel setAttributedText:string];
    */
    
    [self.verificationCodeLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:13.0]];
    [self.verificationCodeLabel setText:@"Congratulations! Your Account has been created successfully. Please Login with the credentials shown below, to start Wagering."];
    
    
}

- (IBAction)backToRegister:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)loginClicked:(id)sender
{

        ZLLoginViewController *loginView = [[ZLLoginViewController alloc] initWithNibName:@"ZLLoginViewController" bundle:nil];
        [self.navigationController pushViewController:loginView animated:YES];
    
}

@end
