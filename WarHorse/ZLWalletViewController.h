//
//  ZLWalletViewController.h
//  WarHorse
//
//  Created by Sparity on 18/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLWalletCustomCell.h"
#import "ZUUIRevealController.h"

@interface ZLWalletViewController : UIViewController<ZUUIRevealControllerDelegate>
{
    
    IBOutlet UILabel *rewardPointsLbl;
    IBOutlet UILabel *rewardAmountLbl;
    IBOutlet UIButton *redeemButton;
    
    IBOutlet UILabel *onHoldLbl;
    IBOutlet UILabel *onHoldAmountLbl;
    
    int pageSize;
    int indexPage;
    NSMutableArray *objectArray;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *loadMoreLabel;
    int page;
    
}


@property(nonatomic,retain) UIButton *amountButton;
@property(nonatomic,retain) IBOutlet UIView *currentBalanceView;
@property(nonatomic,retain) IBOutlet UITableView *walletTableView;
@property(nonatomic,retain) IBOutlet ZLWalletCustomCell *walletCustomCell;
@property(nonatomic,retain) IBOutlet UILabel *balanceLabel;
@property(nonatomic,retain) IBOutlet UILabel *amountLabel;
@property(nonatomic,retain) IBOutlet UIButton *AddFundsBtn;
@property(nonatomic,retain) IBOutlet UIButton *withDrawalBtn;
@property(nonatomic,retain) IBOutlet UILabel *accountActivityLabel;
@property(nonatomic,retain) IBOutlet UIButton *viewBtn;
@property (nonatomic,retain) NSMutableArray *accountActivityArry;

- (IBAction)viewClicked:(id)sender;
- (IBAction)addFundsClicked:(id)sender;
- (IBAction)withDrawalClicked:(id)sender;
- (IBAction)wagerButtonClicked:(id)sender;
- (IBAction)redeemPointsClicked:(id)sender;
- (IBAction)refreshClicked:(id)sender;

@end
