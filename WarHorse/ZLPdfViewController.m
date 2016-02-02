//
//  ZLPdfViewController.m
//  WarHorse
//
//  Created by Sparity on 02/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLPdfViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ZLPdfViewController ()

@end

@implementation ZLPdfViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];

    self.webView.layer.borderWidth = 1;
    self.webView.layer.borderColor = [UIColor colorWithRed:193.0/255 green:193.0/255 blue:193.0/255 alpha:1.0].CGColor;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"results" ofType:@"pdf"];
    NSData *data = [NSData dataWithContentsOfFile:path];
        [self.webView loadData:data MIMEType: @"text/pdf" textEncodingName: @"UTF-8" baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
