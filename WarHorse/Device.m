//
//  Device.m
//  ClosetRemix
//
//  Created by Jugs VN on 6/25/13.
//  Copyright (c) 2013 XMinds. All rights reserved.
//

#import "Device.h"

@implementation Device
@synthesize is_iphone5;
@synthesize is_retina;
@synthesize screen_height;
@synthesize content_view_height;
-(id) init {

    if (self = [super init])
	{
        self.is_iphone5 = NO;
        self.screen_height = 460; //minus status bar
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
            self.is_iphone5 = YES;
            self.screen_height = 548;
        }
        
        self.content_view_height = self.screen_height - 85;
        self.is_retina = NO;
        if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            self.is_retina = [[UIScreen mainScreen] scale] == 2.0 ? YES : NO;

	}
	return self;
}

@end
