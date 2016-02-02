//
//  ZLWagerLeftViewController.h
//  WarHorse
//
//  Created by Sparity on 7/5/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLLeftSideMenuCell.h"
@interface ZLLeftSideMenuViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) IBOutlet ZLLeftSideMenuCell *objCell;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UITableView *leftSideMenuTableView;

@end
