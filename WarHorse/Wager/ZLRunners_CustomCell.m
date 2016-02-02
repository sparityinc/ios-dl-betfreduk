//
//  ZLTile_CustomCell.m
//  WarHorse
//
//  Created by Sparity on 7/9/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLRunners_CustomCell.h"

@implementation ZLRunners_CustomCell

@synthesize horseNum_Label = _horseNum_Label;
@synthesize oddNum_Label = _oddNum_Label;
@synthesize isSelectedState = _isSelectedState;
@synthesize runnerSilkImage = _runnerSilkImage;
@synthesize runnerNumLbl = _runnerNumLbl;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:self.backgroundLabel];
        
        
        self.horseNum_Label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.0, frame.size.width, frame.size.height-13)];
        self.horseNum_Label.textAlignment = NSTextAlignmentCenter;
        self.horseNum_Label.textColor = [UIColor blackColor];
        self.horseNum_Label.font = [UIFont boldSystemFontOfSize:20.0];
        [self addSubview:self.horseNum_Label];
        
        self.oddNum_Label=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-12, frame.size.width, 12)];
        [self.oddNum_Label setBackgroundColor:[UIColor clearColor]];
        [self.oddNum_Label setTextAlignment:NSTextAlignmentRight];
        [self.oddNum_Label setFont:[UIFont fontWithName:@"Arial" size:10]];
        [self addSubview:self.oddNum_Label];
        
        
        
        //Ramya
        self.runnerSilkImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 15, 40, 30)];
        [self addSubview:self.runnerSilkImage];
        
        self.runnerNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 15, 10)];
        self.runnerNumLbl.textAlignment = NSTextAlignmentCenter;
        self.runnerNumLbl.textColor = [UIColor blackColor];
        self.runnerNumLbl.font = [UIFont boldSystemFontOfSize:12.0];
        [self addSubview:self.runnerNumLbl];
        
        self.topImageView = [[UIImageView alloc] init]; //ramya
        [self addSubview:self.topImageView];

        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
