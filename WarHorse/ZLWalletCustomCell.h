//
//  ZLWalletCustomCell.h
//  WarHorse
//
//  Created by Sparity on 8/7/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLWalletCustomCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UILabel *dateLabel;
@property(nonatomic,retain) IBOutlet UILabel *cashLabel;
@property(nonatomic,retain) IBOutlet UILabel *titleLable;
@property(nonatomic,retain) IBOutlet UILabel *detailLabel;
@property(nonatomic,retain) IBOutlet UILabel *amountLable;

@end
