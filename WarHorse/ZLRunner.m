//
//  ZLRunner.m
//  WarHorse
//
//  Created by Jugs VN on 8/28/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLRunner.h"

@implementation ZLRunner

@synthesize runner_id;

@synthesize scratched;

@synthesize winOdds;

@synthesize title;

@synthesize jockeyName;

@synthesize couchName;

@synthesize lbs;

@synthesize bb;

@synthesize textColor;

@synthesize backGroundColor;
@synthesize probablePay,silkImageStr;

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Ima Speedy Guy";
        self.jockeyName = @"Carrasco(J)";
        self.couchName = @"Victor(T)";
        self.lbs = @"";
        self.bb = @"";
        self.textColor = [UIColor whiteColor];
        
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        
        self.backGroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    }
    return self;
}

@end
