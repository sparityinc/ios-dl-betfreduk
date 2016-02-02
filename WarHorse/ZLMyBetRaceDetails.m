//
//  ZLMyBetRaceDetails.m
//  WarHorse
//
//  Created by Jugs VN on 10/8/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "ZLMyBetRaceDetails.h"

@implementation ZLMyBetRaceDetails

-(void) removeBetFromRaceDetails:(ZLBetTransaction*) transaction{
    transaction.selection = [NSString stringWithFormat:@"%@ %@",transaction.selection,@"(Cancelled)"];
}

@end
