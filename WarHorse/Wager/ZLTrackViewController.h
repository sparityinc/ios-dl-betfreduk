//
//  ZLTrackViewController.h
//  WarHorse
//
//  Created by Sparity on 09/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLTrackCustomCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZLTrackViewController : UIViewController

@property(nonatomic,retain) IBOutlet UITableView *wagerTableView;

@property(nonatomic,retain) IBOutlet ZLTrackCustomCell *wagerCustomCell;

@property(nonatomic,retain) NSMutableArray *wager_Array;

@property(nonatomic,retain) IBOutlet UILabel *selectTrackLabel;

@property(nonatomic,retain) IBOutlet UIButton * settingsButton;

@property(strong,nonatomic)  MPMoviePlayerController *moviePlayer;

@property BOOL isFavourite;

-(IBAction)settingsButtonSelected:(id)sender;
- (void)playVideo:(int)selectedRow;

@end
