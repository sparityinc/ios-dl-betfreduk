//
//  ZLResultsViewController.m
//  WarHorse
//
//  Created by Sparity on 18/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLResultsViewController.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"

@interface ZLResultsViewController ()

@end

@implementation ZLResultsViewController

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
    
    self.navigationController.navigationBarHidden = YES;

    [self prepareTopView];
    
    [self.resultsNavigationController.view setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.view addSubview:self.resultsNavigationController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(balanceUpdated:) name:@"BalanceUpdated" object:nil];
}

-(void)balanceUpdated:(NSNotification *)notification{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}

- (void) prepareTopView
{
    
    [self.toggleButton addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.titleLabel setText:@"Results/Payoffs"];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"pound.png"] forState:UIControlStateNormal];
        
    }else{
        [self.amountButton setBackgroundImage:[UIImage imageNamed:@"symbol.png"] forState:UIControlStateNormal];
        
    }
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n$%0.2f",[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    [self.amountButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    
}

- (IBAction)amountButtonClicked:(id)sender
{
    /*CGRect rect = ((UIButton *)sender).frame;
    
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        
        rect.origin.x += 30;
        rect.size.width -= 30;
        [self.amountButton setFrame:rect];
        
    }
    else{
        [self.amountButton setSelected:YES];
        
        rect.origin.x -= 30;
        rect.size.width += 30;
        [self.amountButton setFrame:rect];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerMethod:) userInfo:nil repeats:NO];
    }*/
    
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

- (IBAction)wagerButtonClicked:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadView" object:self userInfo:[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:DashBoardWager]forKey:@"viewNumber"]];

}

- (void)timerMethod:(NSTimer *)timer
{
    if ([self.amountButton isSelected])
    {
        [self.amountButton setSelected:NO];
        [self.amountButton setFrame:CGRectMake(272, 20, 44, 44)];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
