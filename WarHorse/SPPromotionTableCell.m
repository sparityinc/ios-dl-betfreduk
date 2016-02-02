//
//  SPPromotionTableCell.m
//  WarHorse
//
//  Created by Ramya on 8/20/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "SPPromotionTableCell.h"
#import "SPPromotion.h"
@implementation SPPromotionTableCell
@synthesize promotionImage;

-  (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-  (void) updateViewAtIndexPath: (NSIndexPath *)indexPath
{
    
    self.promotionImage.image =[UIImage imageNamed:self.promotion.Image];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
