//
//  SPCreditCardConformViewController.h
//  WarHorse
//
//  Created by subbu on 16/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPCreditCardConformViewController : UIViewController
{
    IBOutlet UITextView *creditcardTextView;

    IBOutlet UILabel *enterAmtLbl;
    IBOutlet UILabel *feeAmtLbl;
    IBOutlet UILabel *totalAmtLbl;
    
    IBOutlet UILabel *enterAmountLblD;
    IBOutlet UILabel *feeAmountLblD;
    IBOutlet UILabel *totalTransactionAmtLblD;
    
    IBOutlet UILabel *acceptTermsLbl;
    IBOutlet UIButton *selectedBtn;
    
}
@property (nonatomic,strong) NSDictionary *creditPaymentDetailsDict;
@property (nonatomic,retain) UIButton *amountButton;
@property (nonatomic,retain) NSString *processingFeeStr;
@property (nonatomic,strong) NSString *minAmountStr;
@property (nonatomic,strong) NSString *maxAmountStr;

@property (nonatomic,strong) NSString *enterAmount;


- (IBAction)backBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)acceptTermsButtonClicked:(id)sender;
- (IBAction)wagerButtonClicked:(id)sender;
@end
