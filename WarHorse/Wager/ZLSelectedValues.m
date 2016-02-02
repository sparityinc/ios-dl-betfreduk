//
//  ZLSelectedValues.m
//  WarHorse
//
//  Created by Sparity on 11/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLSelectedValues.h"
static ZLSelectedValues *selectedValue;
@implementation ZLSelectedValues

NSMutableArray *selectedRunners;

+ (id) sharedInstance
{
    if (!selectedValue) {
        selectedRunners = [[NSMutableArray alloc] init];
        selectedValue = [[ZLSelectedValues alloc] init];
        return selectedValue;
    }
    else
    {
        return selectedValue;
    }
}

- (NSMutableArray *)selectedRunnersArray
{
    return selectedRunners;
}

-(void) setSelectedRunnersArray:(NSMutableArray *)selectedRunnersArray
{
    selectedRunners = [NSMutableArray arrayWithArray:selectedRunnersArray];
}



@end
