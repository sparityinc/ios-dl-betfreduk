//
//  SPCustomFeatureRacesCell.h
//  WarHorse
//
//  Created by Ramya on 8/24/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SPfeatureRaces;

@interface SPCustomFeatureRacesCell : UITableViewCell

@property (nonatomic, strong) SPfeatureRaces *featureRaces;

- (void) updateViewIndex : (NSIndexPath *)indexPath;

@end
