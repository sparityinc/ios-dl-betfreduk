//
//  SPRedeemViewController.h
//  WarHorse
//
//  Created by Ramya on 1/24/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRedeemViewController : UIViewController
{
    int pointsInt;
}
@property(nonatomic,retain) UIButton *amountButton;
@property (nonatomic, strong) IBOutlet UIButton *toggleButton;
@property (nonatomic,strong) NSString *isWalletView;
- (IBAction)backBtnClicked:(id)sender;

@end
