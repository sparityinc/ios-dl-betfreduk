//
//  ZLQRCodeViewController.h
//  WarHorse
//
//  Created by Sparity on 18/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLQRCodeViewController : UIViewController
{
    
}
@property (nonatomic, strong) IBOutlet UIButton *toggleButton;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *amountButton;
@property(nonatomic,retain) IBOutlet UILabel *terminalQrCodeLabel;
@property(nonatomic,retain) IBOutlet UILabel *expireQrCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *TitleTextLbl;
@property (nonatomic ,strong) NSString *actionStr;
@property (strong, nonatomic) IBOutlet UILabel *mainTitle;
@property	CGFloat shiftForKeyboard;

- (IBAction)amountButtonClicked:(id)sender;
- (IBAction)backToHome:(id)sender;
@end
