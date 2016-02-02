//
//  SPOndayPassVC.h
//  WarHorse
//
//  Created by Veeru on 12/06/14.
//  Copyright (c) 2014 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPOndayPassVC : UIViewController

@property (nonatomic,strong) NSString *isExpUser;
@property(assign) double totalAmount;
@property(nonatomic,retain) IBOutlet UILabel *terminalQrCodeLabel;
@property (nonatomic,retain) NSString *headerStr;

@end
