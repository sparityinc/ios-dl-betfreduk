//
//  ZLMatrixCell.h
//  OddsMatrix
//
//  Created by Sparity on 08/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLMatrixViewDeleagate.h"

@interface ZLMatrixCell : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSUInteger rowNumbar;
@property (nonatomic, assign) NSUInteger columnNumber;
@property (nonatomic, strong) UILabel *titleLabel;
@end
