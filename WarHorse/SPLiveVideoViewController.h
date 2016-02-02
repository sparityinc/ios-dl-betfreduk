//
//  SPLiveVideoViewController.h
//  WarHorse
//
//  Created by Ramya on 10/1/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface SPLiveVideoViewController : UIViewController 

@property (nonatomic, strong) IBOutlet UIButton *amountButton;
@property (nonatomic, strong) IBOutlet UINavigationController *resultsNavigationController;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *toggleButton;
@property(strong,nonatomic)  MPMoviePlayerController *moviePlayer;

- (IBAction)wagerButtonClicked:(id)sender;

@end
