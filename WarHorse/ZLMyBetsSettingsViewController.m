//
//  ZLMyBetsSettingsViewController.m
//  WarHorse
//
//  Created by Jugs VN on 1/22/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import "ZLMyBetsSettingsViewController.h"

@interface ZLMyBetsSettingsViewController ()

@end

@implementation ZLMyBetsSettingsViewController

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
    self.navigationController.navigationBarHidden = YES;

    [self.sortByBetTime.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.sortByMTPButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];

    self.sortByBetTime.selected = YES;
    self.sortByMTPButton.selected = NO;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
