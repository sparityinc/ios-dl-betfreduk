//
//  SPPromotionTableCell.h
//  WarHorse
//
//  Created by Ramya on 8/20/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPPromotion;

@interface SPPromotionTableCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *promotionImage;
@property (strong, nonatomic) SPPromotion *promotion;

- (void) updateViewAtIndexPath: (NSIndexPath *)indexPath;

@end
