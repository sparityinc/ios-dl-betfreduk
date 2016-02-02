//
//  ZLTile_CustomCell.h
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLRunners_CustomCell : UICollectionViewCell
@property (retain,nonatomic) UILabel *oddNum_Label;
@property (retain,nonatomic) UILabel *horseNum_Label;
@property (retain,nonatomic) UILabel *backgroundLabel;
@property (assign,nonatomic) BOOL isSelectedState;
@property (retain,nonatomic) UIImageView *topImageView;
@property (retain, nonatomic) UIImageView *runnerSilkImage;
@property (retain, nonatomic) UILabel *runnerNumLbl;
@end
