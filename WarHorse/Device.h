//
//  Device.h
//  ClosetRemix
//
//  Created by Jugs VN on 6/25/13.
//  Copyright (c) 2013 XMinds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject{
    
    BOOL is_retina;
    BOOL is_iphone5;
    int screen_height;
    int content_view_height;
}

@property BOOL is_retina;
@property BOOL is_iphone5;
@property int screen_height;
@property int content_view_height;
@end
