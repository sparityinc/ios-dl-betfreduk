//
//  ZLSideMenuTile.h
//  WarHorse
//
//  Created by Sparity on 08/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSideMenuDelegate.h"

@interface ZLSideMenuTile : UIView

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) int tag;

@end
