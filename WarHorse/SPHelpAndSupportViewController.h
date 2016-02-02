//
//  SPHelpAndSupportViewController.h
//  WarHorse
//
//  Created by sekhar on 25/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SPHelpAndSupportViewController : UIViewController<MFMailComposeViewControllerDelegate>
- (IBAction)backToHome:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *customCareLbl;
@property (strong, nonatomic) IBOutlet UILabel *techSuppLbl;
@property (strong, nonatomic) IBOutlet UILabel *callTollFreeLbl;
@property (strong, nonatomic) IBOutlet UILabel *emailLbl;
@property (strong, nonatomic) IBOutlet UILabel *callTollFreeLbl1;
@property (strong, nonatomic) IBOutlet UILabel *askForTech;
@property (strong, nonatomic) IBOutlet UILabel *emailLbl1;
@property (strong, nonatomic) IBOutlet UIButton *callBtn1;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn1;
@property (strong, nonatomic) IBOutlet UIButton *callBtn2;
@property (strong, nonatomic) IBOutlet UIButton *emailBtn2;

//- (IBAction)customerCallBtnClicked:(id)sender;
//- (IBAction)customerEmailBtnClicked:(id)sender;

@end
