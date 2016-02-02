//
//  SPVerficationVC.m
//  WarHorse
//
//  Created by Veeru on 13/06/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import "SPVerficationVC.h"

@interface SPVerficationVC ()

@property (nonatomic,strong) IBOutlet UILabel *verificationCodeLabel;
- (IBAction)backviewCnt:(id)sender;
- (IBAction)loginViewCntr:(id)sender;

@end

@implementation SPVerficationVC

@synthesize vCodeStr;
@synthesize codeString;
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
    self.verificationCodeLabel.text= codeString;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backviewCnt:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)loginViewCntr:(id)sender
{
    
}
@end
