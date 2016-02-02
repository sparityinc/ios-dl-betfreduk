//
//  AKLegSelectionView.m
//  LegSelection
//
//  Created by Sparity on 03/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "AKLegSelection.h"
#import "ZLAppDelegate.h"

#define BORDER_COLOR [UIColor colorWithRed:0.823529 green:0.823529 blue:0.823529 alpha:1.0].CGColor
#define BACKGROUND_COLOR [UIColor whiteColor]
#define LEFT_RIGHT_BUTTON_WIDTH 24
#define BORDER_WIDTH 0.5

@interface AKLegSelection()

@property(assign) int currentRaceNumber;
@property(assign) BOOL isMultiBetRunner;

@end

@implementation AKLegSelection


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setupSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame totalnumberOfLegs:(NSUInteger)numberOfLegs legsPerPage:(NSUInteger)legsPerPage currentRace:(int) currentRace delegate:(id<AKLegSelectionDelegate>)delegate isMultiBetSelected:(BOOL)isMultiRunnerBet
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.legsInSinglePage = legsPerPage;
        self.totalLegs = numberOfLegs;
        self.delegate = delegate;
        self.currentRaceNumber = currentRace;
        self.isMultiBetRunner = isMultiRunnerBet;
        
        [self setupSubViews];
    }
    return self;
}

- (void) setupSubViews
{
    self.itemsArray = [[NSMutableArray alloc] init];

    [self setBackgroundColor:[UIColor clearColor]];
    
    float topPadding = 5.5;
    float buttonHeight = self.frame.size.height - topPadding;
    
    float legWidth = (self.frame.size.width - (2 * LEFT_RIGHT_BUTTON_WIDTH))/ self.legsInSinglePage;

    float width = 0.0;
    if (self.totalLegs >= self.legsInSinglePage) {
        width = self.frame.size.width;
    }
    else{
        width = (legWidth * self.totalLegs) + (2 * LEFT_RIGHT_BUTTON_WIDTH);
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
    [backgroundView setBackgroundColor:[UIColor clearColor]];
    [backgroundView setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
    [self addSubview:backgroundView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0,topPadding,LEFT_RIGHT_BUTTON_WIDTH,buttonHeight)];
    //[leftButton setTitle:@"<" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:11]];
    [[leftButton layer] setBorderWidth:BORDER_WIDTH];
    [[leftButton layer] setBorderColor:BORDER_COLOR];
    [leftButton setBackgroundColor:BACKGROUND_COLOR];

    [backgroundView addSubview:leftButton];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rightButton setFrame:CGRectMake(backgroundView.frame.size.width-LEFT_RIGHT_BUTTON_WIDTH,topPadding,LEFT_RIGHT_BUTTON_WIDTH,buttonHeight)];
    //[rightButton setTitle:@">" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [[rightButton layer] setBorderWidth:BORDER_WIDTH];
    [[rightButton layer] setBorderColor:BORDER_COLOR];
    [rightButton setBackgroundColor:BACKGROUND_COLOR];
    
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:rightButton];
    

    
    UIView *view = [[UIView alloc] init];
    [view setFrame:CGRectMake(LEFT_RIGHT_BUTTON_WIDTH, topPadding, backgroundView.frame.size.width-(LEFT_RIGHT_BUTTON_WIDTH *2), buttonHeight)];
    [view setBackgroundColor:BACKGROUND_COLOR];
    [backgroundView addSubview:view];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(LEFT_RIGHT_BUTTON_WIDTH, 0, backgroundView.frame.size.width-(LEFT_RIGHT_BUTTON_WIDTH *2), self.frame.size.height)];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setScrollEnabled:NO];
    [backgroundView addSubview:self.scrollView];
    
    
    self.selectionImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, legWidth, self.frame.size.height)];
    [self.selectionImage setImage:[UIImage imageNamed:@"Selected Leg.png"]];
    [self.scrollView addSubview:self.selectionImage];

    int i = 0;
    int k = 0;
        for (i = 0, k = 0; i < self.totalLegs; i++, k++) {
        UIButton *legButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [legButton setTitleColor:[UIColor colorWithRed:0.015686 green:0.015686 blue:0.015686 alpha:1.0] forState:UIControlStateNormal];
        legButton.tag = i;
        [legButton setFrame:CGRectMake(i*legWidth,topPadding,legWidth,buttonHeight)];
        
        if (self.isMultiBetRunner) {
            [legButton setTitle:[NSString stringWithFormat:@"%i",(self.currentRaceNumber + i)] forState:UIControlStateNormal];

        }
        else {
//            [ZLAppDelegate getAppData].currentWager.isBankarBetType = @"Banker";
            
            
            
            if ([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"EXB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"TRB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"SFB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"PEB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"SWB")]){
                float legWidth = 40;
                width = (legWidth * self.totalLegs) + (2 * LEFT_RIGHT_BUTTON_WIDTH);
                [backgroundView setFrame:CGRectMake(45, 0, width, self.frame.size.height)];
                
                [view setFrame:CGRectMake(LEFT_RIGHT_BUTTON_WIDTH, topPadding, backgroundView.frame.size.width-(LEFT_RIGHT_BUTTON_WIDTH *2), buttonHeight)];
                 [rightButton setFrame:CGRectMake(backgroundView.frame.size.width-LEFT_RIGHT_BUTTON_WIDTH,topPadding,LEFT_RIGHT_BUTTON_WIDTH,buttonHeight)];
                [self.scrollView setFrame:CGRectMake(LEFT_RIGHT_BUTTON_WIDTH, 0, backgroundView.frame.size.width-(LEFT_RIGHT_BUTTON_WIDTH *2), self.frame.size.height)];
                [self.selectionImage setFrame:CGRectMake(0, 0, legWidth, self.frame.size.height)];

                [legButton setFrame:CGRectMake(i*legWidth,topPadding,legWidth,buttonHeight)];


                
                if(k == 0)
                    [legButton setTitle:@"Banker" forState:UIControlStateNormal];
                if(k == 1)
                    [legButton setTitle:@"Other" forState:UIControlStateNormal];
                leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
                
            }else{
                [legButton setTitle:[NSString stringWithFormat:@"%i",i+1] forState:UIControlStateNormal];
                
            }
            
            

        }
        
        [[legButton layer] setBorderWidth:BORDER_WIDTH];
        [[legButton layer] setBorderColor:BORDER_COLOR];
        [legButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Medium" size:11]];
        [legButton addTarget:self action:@selector(legButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemsArray addObject:legButton];
        [self.scrollView addSubview:legButton];
    }
    
    [self.scrollView setContentSize:CGSizeMake(legWidth*self.totalLegs, 0)];
    
       self.currentLeg = 0;
}

- (void) leftButtonClicked:(id)sender
{
 
    self.currentLeg = self.currentLeg-1;

    if([self.delegate conformsToProtocol:@protocol(AKLegSelectionDelegate)]
       && [self.delegate respondsToSelector:@selector(moveLefttToLegSelection:didSelect:)])
    {
        NSLog(@"%s Narasimham leg = %lu", __FUNCTION__, (unsigned long)self.currentLeg);
        [self.delegate moveLefttToLegSelection:self didSelect:self.currentLeg-1];
    }

    if (self.scrollView.contentOffset.x > 0) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x -  self.scrollView.frame.size.width, 0)];
    }
    
    //Handling for last page
    if (self.scrollView.contentOffset.x < 0)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void) rightButtonClicked:(id)sender
{
    
    
    self.currentLeg = self.currentLeg+1;

    if([self.delegate conformsToProtocol:@protocol(AKLegSelectionDelegate)]
       && [self.delegate respondsToSelector:@selector(moveRightToLegSelection:didSelect:)])
    {
        NSLog(@"%s Narasimham leg = %lu", __FUNCTION__, (unsigned long)self.currentLeg);
        [self.delegate moveRightToLegSelection:self didSelect:self.currentLeg];
    }

    
    if (self.scrollView.contentOffset.x < self.scrollView.contentSize.width - self.scrollView.frame.size.width)
    {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x +  self.scrollView.frame.size.width, 0)];
    }
    
    //Handling for last page
    if (self.scrollView.contentOffset.x > self.scrollView.contentSize.width - self.scrollView.frame.size.width)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }
}

- (void) legButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    self.currentLeg = button.tag;
    
    if([self.delegate conformsToProtocol:@protocol(AKLegSelectionDelegate)]
       && [self.delegate respondsToSelector:@selector(LegSelection:didSelect:)])
    {
        [self.delegate LegSelection:self didSelect:button.tag+1];
    }
    
}

- (void)setCurrentLeg:(NSUInteger)currentPage
{
    if (currentPage >= self.totalLegs && currentPage > 0)
    {
        return;
    }
    
    _currentLeg = currentPage;
    float legWidth = (self.frame.size.width - (2 * LEFT_RIGHT_BUTTON_WIDTH))/ self.legsInSinglePage;
    CGRect frame = self.selectionImage.frame;
    frame.origin.x = legWidth * currentPage;

    [self reloadLookWithCurrentSelectedLeg:-1];

    if ([[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"EXB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"TRB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"SFB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"PEB")]||[[ZLAppDelegate getAppData].currentWager.selectedBetType isEqualToString:(@"SWB")]){
        float legWidth = 40;
        [self.selectionImage setFrame:CGRectMake(0, 0, legWidth, self.frame.size.height)];
         frame= self.selectionImage.frame;
        frame.origin.x = legWidth * currentPage;
        
    }
   
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.selectionImage.frame = frame;
                         
                     }
                     completion:^(BOOL finished){
                         if(finished)
                             [self reloadLookWithCurrentSelectedLeg:self.currentLeg];
                     }];
}


- (void) reloadLookWithCurrentSelectedLeg:(NSInteger)currentPage
{
    for (UIButton *button in self.itemsArray) {
        if (button.tag == currentPage) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [[button layer] setBorderColor:[UIColor clearColor].CGColor];
        }
        else{
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [[button layer] setBorderColor:BORDER_COLOR];
        }
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
