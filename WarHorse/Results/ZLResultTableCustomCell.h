//
//  ZLResultTableCustomCell.h
//  WarHorse
//
//  Created by Sparity on 7/31/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLResultTableCustomCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UILabel *trackName_Label;
@property(nonatomic,retain) IBOutlet UILabel *address_Label;
@property (nonatomic,retain) IBOutlet UIImageView *countryFlag;

@end
