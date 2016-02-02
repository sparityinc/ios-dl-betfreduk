//
//  ZLSideMenu.m
//  WarHorse
//
//  Created by Sparity on 08/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLSideMenu.h"
#import "ZLSelectedValues.h"
#import "ZLAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "WarHorseSingleton.h"

//static int whichViewLoaded;

@implementation ZLSideMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.whichViewLoaded = 0;
        
        self.itemsArray = [[NSMutableArray alloc] init];
        self.tilesArray = [[NSMutableArray alloc] init];
        // Initialization code
        self.numberOfItems = 5;
        [self setBackgroundColor:[UIColor colorWithRed:70.0/256 green:67.0/256 blue:74.0/256 alpha:1.0]];
        [self prepareTilesWithFrame:frame];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTiles) name:@"ZLWagerTracksDidLoad" object:nil];
    }
    return self;
}

- (void) prepareTilesWithFrame:(CGRect)frame
{
    float cellWidth = frame.size.width;
    float cellHeight = frame.size.height/5;
    for (int i = 0; i < self.numberOfItems; i++)
    {
        ZLSideMenuTile *tile = [[ZLSideMenuTile alloc] initWithFrame:CGRectMake(0, i * cellHeight, cellWidth, cellHeight)];
        [tile setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
        tile.tag = i;
        tile.delegate = self;
        [self.tilesArray addObject:tile];
        [self addSubview:tile];
        
    }
}

- (void)tapDetectingView:(id)view
{
    ZLSideMenuTile *tile = (ZLSideMenuTile *)view;
    [self.delegate clearSelectedValuesWithIndex:tile.tag];
    
    if (tile.tag <= self.whichViewLoaded)
    {
        [self.delegate tapDetectingView:view];
        [self reloadTilesWithIndex:tile.tag];
    }
    
}

-(void) selectTileWithTag:(int) tag{
    
    [self reloadTilesWithIndex:tag];
}
- (void) nextViewLoaded
{
    if( (self.numberOfItems - 1 )> self.whichViewLoaded){
        self.whichViewLoaded++;
    }
    
    [self reloadTilesWithIndex:self.whichViewLoaded];
}

-(void) reloadTiles{
    [self reloadTilesWithIndex:self.whichViewLoaded];
}

- (void) reloadTilesWithIndex:(NSUInteger)index
{
    self.whichViewLoaded = index;
    
    for (int i = 0; i< self.numberOfItems; i++)
    {
        ZLSideMenuTile *tile = [self.tilesArray objectAtIndex:i];
        [tile setNeedsDisplay];
    }
}

- (void) clearAllData
{
    [self reloadTilesWithIndex:1];
}


- (NSString *) selectedValuesForIndex:(NSUInteger)index
{
    return [self.delegate selectedValuesForIndex:index];
}

- (UIImage *) imageForIndex:(NSUInteger)index
{
    return [self.delegate imageForIndex:index];
}

- (NSString *) titleForIndex:(NSUInteger)index
{
    return [self.delegate titleForIndex:index];
}

- (UIImage *) backgroundImage:(NSUInteger)index
{
    return [self.delegate backgroundImage:index];
}

- (UIView *) viewForSideTileIndex:(NSUInteger)index tile:(id)tile{
    CGRect titleRect ;
    UIFont *titleFont;
    
    ZLSideMenuTile * menuTile = (ZLSideMenuTile*) tile;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, menuTile.frame.size.width, 60)];
    [contentView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
    
    [contentView setBackgroundColor:[UIColor clearColor]];
    [contentView setCenter:CGPointMake(menuTile.frame.size.width/2, menuTile.frame.size.height/2)];
    
    ZLRaceCard * selectedRaceCard = [ZLRaceCard findRaceCardByMeetNumber:[ZLAppDelegate getAppData].currentWager.selectedRaceMeetNumber AndPerformanceNumber:[ZLAppDelegate getAppData].currentWager.selectedRacePerformanceNumber];
    ZLRaceDetails * selectedRaceDetails = nil;
    if( selectedRaceCard ){
        selectedRaceDetails = [selectedRaceCard findRaceDeatilsByRaceId:[ZLAppDelegate getAppData].currentWager.selectedRaceId];
    }

    NSString * selectedBetType = [ZLAppDelegate getAppData].currentWager.selectedBetType;
    double selectedAmount = [ZLAppDelegate getAppData].currentWager.amount;
    //    NSMutableDictionary * selectedRunners = [ZLAppDelegate getAppData].currentWager.selectedRunners;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((menuTile.frame.size.width - 43)/2, 0, 43,36)];
    [logoImageView setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
    titleRect = CGRectMake(0, 39, menuTile.frame.size.width, 21);
    titleFont = [UIFont fontWithName:@"Roboto-Light" size:14];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];
    [titleLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
    [titleLabel setFont:titleFont];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setAdjustsFontSizeToFitWidth:YES];
    
    
    if( index == WagerTrack){
        if(selectedRaceCard == nil){
            [logoImageView setImage:[UIImage imageNamed:@"track.png"]];
            [contentView addSubview:logoImageView];
            if ([[[WarHorseSingleton sharedInstance] localCountry] isEqualToString:@"en_UK"]){
                [titleLabel setText:@"COURSE"];
            }else{
                [titleLabel setText:@"TRACK"];

            }

            
            [contentView addSubview:titleLabel];
        }
        else{
            [titleLabel setAdjustsFontSizeToFitWidth:NO];
            
            titleLabel.frame = CGRectMake(5, 2.0, menuTile.frame.size.width - 10.0, 20.0);
            
            titleLabel.text = [selectedRaceCard.ticketName capitalizedString];
            [contentView addSubview:titleLabel];
            
            
            UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, contentView.frame.size.height-20, 15, 15)];
            
            if ([selectedRaceCard.trackCountry isEqualToString:@"UK"]){
                flagImageView.image = [UIImage imageNamed:@"uk.png"];

                
            }else {
                flagImageView.image = [UIImage imageNamed:@"us.png"];

            }
            
            
            [contentView addSubview:flagImageView];
 
            
            
            
            /*
            UILabel *raceLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, contentView.frame.size.height - 28, 30, 15)];
            [raceLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
            [raceLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            [raceLabel setText:@"Race"];
            [raceLabel setNumberOfLines:1];
            [raceLabel setTextColor:[UIColor whiteColor]];
            [raceLabel setBackgroundColor:[UIColor clearColor]];
            [raceLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:raceLabel];*/
            
            UILabel *MTPValue = [[UILabel alloc] init];
            
            [MTPValue setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            //UILabel *raceNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, contentView.frame.size.height - 13, 30, 15)];
            //[raceNumberLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:12]];
            //[raceNumberLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            
            
            if( [ZLAppDelegate getAppData].currentWager.selectedRaceId != -1 ){
                if ([selectedRaceCard.trackCountry isEqualToString:@"UK"]){
                   //[ raceNumberLabel setText:selectedRaceCard.currentRace];

                    
                }else {
                    //[raceNumberLabel setText:[NSString stringWithFormat:@"%d",[ZLAppDelegate getAppData].currentWager.selectedRaceId]];
                    
                }
            }
            else{
                if ([selectedRaceCard.trackCountry isEqualToString:@"UK"]){
                    //[raceNumberLabel setText:[NSString stringWithFormat:@"%@",selectedRaceCard.currentRace]];

                }else {
                    //[raceNumberLabel setText:[NSString stringWithFormat:@"%d",selectedRaceCard.currentRaceNumber]];
                    
                }
                

                [MTPValue setText:[NSString stringWithFormat:@"%d", selectedRaceCard.minutesToPost]];
            }

            //[raceNumberLabel setNumberOfLines:1];
            //[raceNumberLabel setTextColor:[UIColor whiteColor]];
            //[raceNumberLabel setBackgroundColor:[UIColor clearColor]];
            //[raceNumberLabel setTextAlignment:NSTextAlignmentCenter];
            //[contentView addSubview:raceNumberLabel];
            
            
            UILabel *MTPLabel = [[UILabel alloc] initWithFrame:CGRectMake(49, contentView.frame.size.height - 28, 28, 15)];
            [MTPLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            [MTPLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
            [MTPLabel setText:@"MTP"];
            [MTPLabel setTextColor:[UIColor whiteColor]];
            [MTPLabel setBackgroundColor:[UIColor clearColor]];
            [MTPLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:MTPLabel];
            
            UIView *MTPValuebackground = [[UIView alloc] initWithFrame:CGRectMake(49, contentView.frame.size.height - 13, 26, 15)];
            [MTPValuebackground setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            [contentView addSubview:MTPValuebackground];
            
            
            
            [MTPValue setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
            if( !selectedRaceDetails ){
                if( ![selectedRaceCard.currentRaceStatus isEqualToString:@"OFFICIAL"] ){
                    if ([selectedRaceCard.currentRaceStatus isEqualToString:@"BETTING_OFF"]) {
                        [MTPValue setText:@"OFF"];
                        
                        [MTPValue setTextColor:[UIColor whiteColor]];
                        [MTPValue setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                    }else{
                        if( selectedRaceCard.minutesToPost >= 0){
                            [MTPValue setText:[NSString stringWithFormat:@"%d", selectedRaceCard.minutesToPost]];
                            
                        }
                        else{
                            [MTPValue setText:@"-"];
                            
                        }
                        [MTPValue setTextColor:[UIColor whiteColor]];
                        [MTPValue setBackgroundColor:[UIColor clearColor]];
                    }
                    
                }
                else{
                    [MTPValue setText:@"FIN"];
                    [MTPValue setTextColor:[UIColor whiteColor]];
                    [MTPValue setBackgroundColor:[UIColor redColor]];
                    [MTPValuebackground setBackgroundColor:[UIColor clearColor]];
                }
                if( selectedRaceCard.minutesToPost <= 5 )
                    [MTPValuebackground setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                else if( selectedRaceCard.minutesToPost < 20 ){
                    [MTPValuebackground setBackgroundColor:[UIColor colorWithRed:250.0/255 green:228.0/255 blue:48.0/255 alpha:1.0]];
                    [MTPValue setTextColor:[UIColor blackColor]];
                }
                else
                    [MTPValuebackground setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
            }
            else{
                if( ![selectedRaceDetails.status isEqualToString:@"OFFICIAL"] ){
                    if ([selectedRaceDetails.status isEqualToString:@"BETTING_OFF"]) {
                        [MTPValue setText:@"OFF"];
                        [MTPValue setTextColor:[UIColor whiteColor]];
                        [MTPValue setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                    }else{
                        if( selectedRaceDetails.minutesToPost >= 0){
                            [MTPValue setText:[NSString stringWithFormat:@"%d", selectedRaceDetails.minutesToPost]];
                            
                        }
                        else{
                            [MTPValue setText:@"-"];
                        }
                        [MTPValue setTextColor:[UIColor whiteColor]];
                        [MTPValue setBackgroundColor:[UIColor clearColor]];
                    }
                    
                }
                else{
                    [MTPValue setText:@"FIN"];
                    [MTPValue setTextColor:[UIColor whiteColor]];
                    [MTPValue setBackgroundColor:[UIColor redColor]];
                    [MTPValuebackground setBackgroundColor:[UIColor clearColor]];
                }
                if( selectedRaceDetails.minutesToPost <= 5 ){
                    
                    if( selectedRaceDetails.minutesToPost < 0 ){
                        [MTPValuebackground setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                        
                    }else{
                        [MTPValuebackground setBackgroundColor:[UIColor colorWithRed:245.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]];
                    }
                    
                }
                //                NSLog(@"selectedRaceDetails.minutesToPost %d",selectedRaceDetails.minutesToPost);
                else if( selectedRaceDetails.minutesToPost < 20 ){
                    [MTPValuebackground setBackgroundColor:[UIColor colorWithRed:250.0/255 green:228.0/255 blue:48.0/255 alpha:1.0]];
                    [MTPValue setTextColor:[UIColor blackColor]];
                }
                else{
                    [MTPValuebackground setBackgroundColor:[UIColor colorWithRed:2.0/255 green:143.0/255 blue:26.0/255 alpha:1.0]];
                }
            }
            
            [MTPValue setTextAlignment:NSTextAlignmentCenter];
            [MTPValuebackground addSubview:MTPValue];
            
            CGSize maximumMTPValueSize = CGSizeMake(299,9999);
            
            CGSize expectedMTPValueSize=  [MTPValue.text boundingRectWithSize:maximumMTPValueSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:MTPValue.font } context:nil].size;
            
            // Deprecation method.
            //CGSize expectedMTPValueSize = [MTPValue.text sizeWithFont:MTPValue.font constrainedToSize:maximumMTPValueSize lineBreakMode:MTPValue.lineBreakMode];
            
            //adjust the label the the new height.
            CGRect MTPValueNewFrame = MTPValue.frame;
            MTPValueNewFrame.size.width = expectedMTPValueSize.width+4;
            MTPValueNewFrame.size.height = expectedMTPValueSize.height;
            MTPValueNewFrame.origin.x = (MTPValuebackground.frame.size.width - MTPValueNewFrame.size.width)/2;
            MTPValueNewFrame.origin.y = (MTPValuebackground.frame.size.height - MTPValueNewFrame.size.height)/2;
            MTPValue.frame = MTPValueNewFrame;
        }
    }
    else if( index == WagerRace){
        if(selectedRaceDetails == nil){
            [logoImageView setImage:[UIImage imageNamed:@"race.png"]];
            [contentView addSubview:logoImageView];
            [titleLabel setText:@"RACE"];
            [contentView addSubview:titleLabel];
            
        }
        else{
            titleLabel.frame = CGRectMake(5, 2.0, menuTile.frame.size.width - 10.0, 20.0);
            titleLabel.text = @"RACE";
            [contentView addSubview:titleLabel];
            
            UILabel *raceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 33.0, menuTile.frame.size.width - 10.0, 20)];
            [raceLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
            [raceLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            NSString *betTypeRange = [ZLAppDelegate getAppData].currentWager.raceTimeRange;
            //[raceLabel setText:betTypeRange];

            if(betTypeRange == nil || [betTypeRange length] <= 0){
                if ([selectedRaceCard.trackCountry isEqualToString:@"UK"]){
                    [raceLabel setText:selectedRaceDetails.trackRaceNumber];
                    
                }else {
                    [raceLabel setText:[NSString stringWithFormat:@"%d",selectedRaceDetails.number]];
                    
                }
            }else {
                [raceLabel setText:betTypeRange];

            }
            
/*
            if(selectedBetType != nil && [selectedBetType length] > 0){
                
                if( [selectedBetType isEqualToString:@"PK3"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 2]];
                }
                else if( [selectedBetType isEqualToString:@"PK4"]||[selectedBetType isEqualToString:@"QPT"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 3]];
                }
                else if( [selectedBetType isEqualToString:@"PK5"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 4]];
                }
                else if( [selectedBetType isEqualToString:@"PK6"]||[selectedBetType isEqualToString:@"PLP"]||[selectedBetType isEqualToString:@"JPT"]||[selectedBetType isEqualToString:@"SC6"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 5]];
                }
                else if( [selectedBetType isEqualToString:@"PK7"]||[selectedBetType isEqualToString:@"SP7"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 6]];
                }
                else if( [selectedBetType isEqualToString:@"PK8"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 7]];
                }
                else if( [selectedBetType isEqualToString:@"PK9"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 8]];
                }
                else if( [selectedBetType isEqualToString:@"P10"]){
                    [raceLabel setText:[NSString stringWithFormat:@"%d - %d",selectedRaceDetails.number, selectedRaceDetails.number + 9]];
                }
                
            }*/
            [raceLabel setNumberOfLines:1];
            [raceLabel setTextColor:[UIColor whiteColor]];
            [raceLabel setBackgroundColor:[UIColor clearColor]];
            [raceLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:raceLabel];
        }
    }
    else if( index == WagerBetType){
        if(selectedBetType == nil || [selectedBetType length] <= 0){
            [logoImageView setImage:[UIImage imageNamed:@"betype.png"]];
            [contentView addSubview:logoImageView];
            [titleLabel setText:@"BET TYPE"];
            [contentView addSubview:titleLabel];
        }
        else{
            titleLabel.frame = CGRectMake(5, 2.0, menuTile.frame.size.width - 10.0, 20.0);
            titleLabel.text = @"BET TYPE";
            [contentView addSubview:titleLabel];
            
            UILabel *raceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 33.0, menuTile.frame.size.width - 10.0, 20)];
            [raceLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
            [raceLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            if( [selectedBetType isEqualToString:@"E5N"]||[selectedBetType isEqualToString:@"HI5"]){
                [raceLabel setText:@"PEN"];
            }
            else{
                [raceLabel setText:selectedBetType];
            }
            [raceLabel setNumberOfLines:1];
            [raceLabel setTextColor:[UIColor whiteColor]];
            [raceLabel setBackgroundColor:[UIColor clearColor]];
            [raceLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:raceLabel];
        }
    }
    else if( index == WagerAmount){
        if(selectedAmount == 0){
            [logoImageView setImage:[UIImage imageNamed:@"Amount.png"]];
            [contentView addSubview:logoImageView];
            [titleLabel setText:@"AMOUNT"];
            [contentView addSubview:titleLabel];
        }
        else{
            titleLabel.frame = CGRectMake(5, 2.0, menuTile.frame.size.width - 10.0, 20.0);
            titleLabel.text = @"AMOUNT";
            [contentView addSubview:titleLabel];
            
            UILabel *raceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 33.0, menuTile.frame.size.width - 10.0, 20)];
            [raceLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:13]];
            [raceLabel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin)];
            
            NSString *amountValue =[NSString stringWithFormat:@"%.0f", selectedAmount];
            float amountInt = [amountValue floatValue];
            if (1<=amountInt){
                [raceLabel setText:[NSString stringWithFormat:@"%@%.02f",[[WarHorseSingleton sharedInstance] currencySymbel],selectedAmount]];
                
            }else{
                int amount  = selectedAmount*100;
                NSLog(@"cost %d",amount);
                
                [raceLabel setText:[NSString stringWithFormat:@"%d%@", amount,@"p"]];

                
            }
            
            [raceLabel setNumberOfLines:1];
            [raceLabel setTextColor:[UIColor whiteColor]];
            [raceLabel setBackgroundColor:[UIColor clearColor]];
            [raceLabel setTextAlignment:NSTextAlignmentCenter];
            [contentView addSubview:raceLabel];
        }
    }
    else if( index == WagerRunners){
        if( [[ZLAppDelegate getAppData].currentWager calculateTotalBetAmount] == 0){
            [logoImageView setImage:[UIImage imageNamed:@"runners.png"]];
            [contentView addSubview:logoImageView];
            [titleLabel setText:@"RUNNERS"];
            [contentView addSubview:titleLabel];
        }
    }
    return contentView;
}
- (UIColor *) lineColor:(NSUInteger)index
{
    if (index == self.whichViewLoaded) {
        return [UIColor colorWithRed:231.0/256 green:136.0/256 blue:66.0/256 alpha:1.0];
    }
    else
    {
        return [UIColor clearColor];
    }
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
