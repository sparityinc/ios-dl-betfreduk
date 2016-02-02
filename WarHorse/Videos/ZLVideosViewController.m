//
//  ZLVideosViewController.m
//  WarHorse
//
//  Created by Sparity on 18/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLVideosViewController.h"
#import "ZLAppDelegate.h"
#import "WarHorseSingleton.h"


@interface ZLVideosViewController ()

@property (nonatomic, strong) IBOutlet UIButton *amountButton;

- (IBAction)amountButtonClicked:(id)sender;

@end

@implementation ZLVideosViewController

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
    [self.amountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)balanceUpdated:(NSNotification *)notification{
    
    [self.amountButton setTitle:[NSString stringWithFormat:@"BALANCE: \n%@%0.2f",[[WarHorseSingleton sharedInstance] currencySymbel],[ZLAppDelegate getAppData].balanceAmount] forState:UIControlStateSelected];
    
}

- (IBAction)amountButtonClicked:(id)sender
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
        [self.amountButton setFrame:CGRectMake(272, 0, 45, 45)];
    }
}


@end
