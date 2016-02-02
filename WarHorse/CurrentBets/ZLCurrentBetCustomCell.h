//
//  ZLCurrentBetCustomCell.h
//  WarHorse
//
//  Created by Sparity on 7/11/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLCurrentBetTypeViewController.h"

@interface ZLCurrentBetCustomCell : UITableViewCell  <ZLCurrentBetTypeViewControllerProtocol>
@property(nonatomic,strong) IBOutlet UILabel *betDollar_Label;
@property(nonatomic,strong) IBOutlet UILabel *betType_Label;
@property(nonatomic,strong) IBOutlet UILabel *amountDollar_Label;
@property(nonatomic, strong) IBOutlet UIButton *cancelBetButton;
@property (strong, nonatomic) IBOutlet UIImageView *separatorLine;
@property (strong, nonatomic) id <ZLCurrentBetTypeViewControllerProtocol> currentBetTypeDelegate;

- (void)updateViewAtIndexPath:(NSIndexPath *)indexPath;

@end
