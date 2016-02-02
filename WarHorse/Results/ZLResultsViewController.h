//
//  ZLResultsViewController.h
//  WarHorse
//
//  Created by Sparity on 18/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLResultsViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIButton *amountButton;
@property (nonatomic, strong) IBOutlet UINavigationController *resultsNavigationController;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *toggleButton;

- (IBAction)amountButtonClicked:(id)sender;
- (IBAction)wagerButtonClicked:(id)sender;

@end
