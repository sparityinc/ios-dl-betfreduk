//
//  ZLSideMenuTile.m
//  WarHorse
//
//  Created by Sparity on 08/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLSideMenuTile.h"
#import "ZLSelectedValues.h"
@implementation ZLSideMenuTile

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired=1;
        [self addGestureRecognizer:tapGesture];
        

    }
    return self;
}

-(void) handleTapGesture:(UITapGestureRecognizer *)sender{
    [self.delegate tapDetectingView:self];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code

    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [backgroundImage setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
    [backgroundImage setImage:[self.delegate backgroundImage:self.tag]];
    [self addSubview:backgroundImage];
        
    UIView *contentView = [self viewForSideTileIndex:self.tag tile:self];
    [contentView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];

    [self addSubview:contentView];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 3, self.frame.size.width, 3)];
    [line setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];

    [line setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
    [line setBackgroundColor:[self.delegate lineColor:self.tag]];
    [self addSubview:line];
}

- (UIView *) viewForSideTileIndex:(NSUInteger)index tile:(id)tile
{
    UIView *contentView = [self.delegate viewForSideTileIndex:index tile:tile];
    
    /*CGRect titleRect ;
    UIFont *titleFont;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
    [contentView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];

    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];

    id result = [self.delegate selectedValuesForIndex:self.tag];
    if (!result)
        
    {
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 43)/2, 0, 43,36)];
        [logoImageView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];

        [logoImageView setImage:[self.delegate imageForIndex:self.tag]];
        [contentView addSubview:logoImageView];
        
        titleRect = CGRectMake(0, 39, self.frame.size.width, 21);
        titleFont = [UIFont fontWithName:@"Roboto-Medium" size:14];
    }
    else
    {
        
        titleRect = CGRectMake(0, 1, self.frame.size.width, 21);
        titleFont = [UIFont fontWithName:@"Roboto-Medium" size:13];
        
        if (index == 1 || index == 2) {
            titleRect = CGRectMake(0, 4, self.frame.size.width, 21);
            titleFont = [UIFont fontWithName:@"Roboto-Medium" size:14];
        }
        
        if (index == 3) {
            titleRect = CGRectMake(0, 2, self.frame.size.width, 21);
            titleFont = [UIFont fontWithName:@"Roboto-Medium" size:14];
        }
        
        if (WagerTrack == self.tag)
        {
            UILabel *raceLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, contentView.frame.size.height - 28, 30, 15)];
            [raceLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
            [raceLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            [raceLabel setText:@"Race"];
            [raceLabel setNumberOfLines:1];
            [raceLabel setTextColor:[UIColor whiteColor]];
            [raceLabel setBackgroundColor:[UIColor clearColor]];
            [raceLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:raceLabel];
            
            UILabel *raceNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, contentView.frame.size.height - 13, 30, 15)];
            [raceNumberLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:14]];
            [raceNumberLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            [raceNumberLabel setText:[[ZLSelectedValues sharedInstance] selectedRace]];
            [raceNumberLabel setNumberOfLines:1];
            [raceNumberLabel setTextColor:[UIColor whiteColor]];
            [raceNumberLabel setBackgroundColor:[UIColor clearColor]];
            [raceNumberLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:raceNumberLabel];
            
            
            UILabel *MTPLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, contentView.frame.size.height - 28, 28, 15)];
            [MTPLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];

            [MTPLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
            [MTPLabel setText:@"MTP"];
            [MTPLabel setTextColor:[UIColor whiteColor]];
            [MTPLabel setBackgroundColor:[UIColor clearColor]];
            [MTPLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:MTPLabel];
            
            UIView *MTPValuebackground = [[UIView alloc] initWithFrame:CGRectMake(49, contentView.frame.size.height - 13, 26, 15)];
            [MTPValuebackground setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            [MTPValuebackground setBackgroundColor:[UIColor redColor]];
            [contentView addSubview:MTPValuebackground];
            
            UILabel *MTPValue = [[UILabel alloc] init];
            [MTPValue setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            [MTPValue setFont:[UIFont fontWithName:@"Roboto-Bold" size:14]];
            [MTPValue setText:[[ZLSelectedValues sharedInstance] selectedMTP]];
            [MTPValue setTextColor:[UIColor whiteColor]];
            [MTPValue setBackgroundColor:[UIColor clearColor]];
            [MTPValue setTextAlignment:NSTextAlignmentCenter];
            [MTPValuebackground addSubview:MTPValue];
            
            CGSize maximumMTPValueSize = CGSizeMake(299,9999);
            
            CGSize expectedMTPValueSize = [MTPValue.text sizeWithFont:MTPValue.font constrainedToSize:maximumMTPValueSize lineBreakMode:MTPValue.lineBreakMode];
            
            //adjust the label the the new height.
            CGRect MTPValueNewFrame = MTPValue.frame;
            MTPValueNewFrame.size.width = expectedMTPValueSize.width;
            MTPValueNewFrame.size.height = expectedMTPValueSize.height;
            MTPValueNewFrame.origin.x = (MTPValuebackground.frame.size.width - MTPValueNewFrame.size.width)/2;
            MTPValueNewFrame.origin.y = (MTPValuebackground.frame.size.height - MTPValueNewFrame.size.height)/2;
            MTPValue.frame = MTPValueNewFrame;
            
            
        }
        else
        {
            UILabel *resultLabel = [[UILabel alloc] init];
            [resultLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            [resultLabel setTextAlignment:NSTextAlignmentCenter];
            [resultLabel setFrame:CGRectMake(0, contentView.frame.size.height - 29, self.frame.size.width, 22)];
            [resultLabel setFont:[UIFont fontWithName:@"Roboto-Bold" size:20]];
            
            if (index == 2) {
                 [resultLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:20]];
            }
            
            if (index == 3) {
                  [resultLabel setFrame:CGRectMake(0, contentView.frame.size.height - 31, self.frame.size.width, 22)];
            }
            
            if (index == 4) {
                 [resultLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:13]];
                [resultLabel setFrame:CGRectMake(17, 3.5, self.frame.size.width - 34, 18.5)];
                [resultLabel setTextAlignment:NSTextAlignmentRight];
            }
            
            
            [resultLabel setText:[self.delegate selectedValuesForIndex:self.tag]];
            [resultLabel setTextColor:[UIColor whiteColor]];
            [resultLabel setBackgroundColor:[UIColor clearColor]];
            
            [contentView addSubview:resultLabel];

        }
        
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    [titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];

    [titleLabel setText:[self.delegate titleForIndex:self.tag]];
    [titleLabel setFont:titleFont];
    [titleLabel setMinimumFontSize:10];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [contentView addSubview:titleLabel];

    
       */
    return contentView;
}


@end
