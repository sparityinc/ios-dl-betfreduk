//
//  SPWalletViewAllViewController.h
//  WarHorse
//
//  Created by Ramya on 8/29/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLWalletCustomCell.h"
@interface SPWalletViewAllViewController : UIViewController
{
    int pageSize;
    int indexPage;
    NSMutableArray *objectArray;
    
    UIActivityIndicatorView *activityIndicator;
    UILabel *loadMoreLabel;
    int page;
}

@property (strong, nonatomic) IBOutlet UITableView *walletTableView;
@property (strong, nonatomic) NSMutableArray *walletArray;
@property (strong, nonatomic) ZLWalletCustomCell *walletCustomCell;
@property (strong, nonatomic) UIButton *amountButton;
@property (strong ,nonatomic) NSMutableArray *accountActivityArray;
@property (strong, nonatomic) NSMutableArray *userActivityArray;


- (IBAction)wagerBtnClicked:(id)sender;
- (IBAction)backBtnClicked:(id)sender;
- (IBAction)refreshBtnClicked:(id)sender;
@end
