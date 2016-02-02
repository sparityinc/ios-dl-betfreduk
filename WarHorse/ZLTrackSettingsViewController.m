//
//  ZLTrackSettingsViewController.m
//  WarHorse
//
//  Created by Jugs VN on 10/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLTrackSettingsViewController.h"

@interface ZLTrackSettingsViewController ()

@end

@implementation ZLTrackSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.filterByFavoriteButton.selected = NO;
    self.sortByMTPButton.selected = NO;
    self.sortByAlphabetButton.selected = NO;
    self.filterByAll.selected = YES;
    
    [self.filterByFavoriteButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.sortByMTPButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.sortByAlphabetButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.filterByAll.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    
    [self.filterByHarness.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
    [self.filterByThoruoghbred.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];

}

@end
