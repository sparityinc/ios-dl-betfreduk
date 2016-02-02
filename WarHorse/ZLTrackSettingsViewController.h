//
//  ZLTrackSettingsViewController.h
//  WarHorse
//
//  Created by Jugs VN on 10/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLTrackSettingsViewController : UIViewController

@property(nonatomic,retain) IBOutlet UIButton *sortByAlphabetButton;

@property(nonatomic,retain) IBOutlet UIButton *sortByMTPButton;

@property(nonatomic,retain) IBOutlet UIButton *filterByFavoriteButton;

@property(nonatomic,retain) IBOutlet UIButton *filterByThoruoghbred;

@property(nonatomic,retain) IBOutlet UIButton *filterByHarness;

@property (nonatomic, retain) IBOutlet UIButton *filterByAll;

@end
