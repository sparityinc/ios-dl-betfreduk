//
//  ZLRunnersViewCell.h
//  WarHorse
//
//  Created by Sparity on 13/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLRunnersViewCell : UITableViewCell

@property (retain,nonatomic) IBOutlet UILabel *runnerNumberLabel;
@property (retain,nonatomic) IBOutlet UILabel *jocyNameLabel;
@property (retain,nonatomic) IBOutlet UILabel *titleLabel;
@property (retain,nonatomic) IBOutlet UILabel *couchNameLabel;
@property (retain,nonatomic) IBOutlet UILabel *lbsNameLabel;
@property (retain,nonatomic) IBOutlet UILabel *bbLabel;
@property (retain,nonatomic) IBOutlet UILabel *oddNum_Label;
@property (retain,nonatomic) IBOutlet UIImageView *checkImageView;
@property (retain,nonatomic) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIImageView *silkImageView;
@property (weak, nonatomic) IBOutlet UILabel *runnerNumLbl;

@end
