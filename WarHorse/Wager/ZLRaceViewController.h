//
//  ZLRaceViewController.h
//  WarHorse
//
//  Created by Sparity on 7/8/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLRaceCustomCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ZLRaceViewController : UIViewController
@property(nonatomic,retain) IBOutlet UITableView *raceTableView;
@property(nonatomic,retain) IBOutlet ZLRaceCustomCell *raceCustomCell;
@property(nonatomic,retain) NSMutableArray *raceDetailsArray;
@property(nonatomic,retain) IBOutlet UILabel *selectRaceLabel;

@property(strong,nonatomic)  MPMoviePlayerController *moviePlayer;


@end
