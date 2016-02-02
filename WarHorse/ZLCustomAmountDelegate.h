//
//  ZLCustomAmountDelegate.h
//  WarHorse
//
//  Created by Sparity on 30/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZLCustomAmountDelegate <NSObject>
- (void) selectedAmount:(NSString *)amount;
@end
