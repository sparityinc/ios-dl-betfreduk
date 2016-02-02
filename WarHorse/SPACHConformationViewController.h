//
//  SPACHConformationViewController.h
//  WarHorse
//
//  Created by subbu on 16/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPACHConformationViewController : UIViewController
{
    IBOutlet UITextView *achTextView;
    IBOutlet UILabel *nameLabel;
    
    IBOutlet UILabel *bankNameLabel;
    IBOutlet UILabel *routingLabel;
    IBOutlet UILabel *bankNoLabel;
    IBOutlet UILabel *achAmountLabel;
    IBOutlet UILabel *lessPriseLabel;
    IBOutlet UILabel *totalamountLabel;
    
    //this Labels dynamic data assign
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *banknameLabel;
    IBOutlet UILabel *achRoutingLabel;
    IBOutlet UILabel *bankAcountNoLabel;
    IBOutlet UILabel *achAcountAmountLabel;
    IBOutlet UILabel *lessPriseAmountLabel;
    IBOutlet UILabel *totalWageringAmountLabel;
    IBOutlet UIImageView *achImageView;
        
}
@property (nonatomic,strong) NSDictionary *userPaymentDetailsDic;
@property(nonatomic,retain) UIButton *amountButton;
@property (nonatomic,retain) NSString *achFeeStr;

- (IBAction)backBtnClicked:(id)sender;
- (IBAction)submitBtnClicked:(id)sender;
- (IBAction)wagerButtonClicked:(id)sender;
@end
