//
//  SPGetStartedViewController.m
//  WarHorse
//
//  Created by sekhar on 25/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPGetStartedViewController.h"
#import "SPConstant.h"
#import "ZLMainGridViewController.h"

@interface SPGetStartedViewController ()

@property (nonatomic,strong) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UIImageView *helpImage;
@property (strong,nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic,strong) IBOutlet UIImageView *headerImage;
@property (nonatomic,strong) IBOutlet UIImageView *homeImage;
@property (nonatomic,strong) IBOutlet UIButton *homeBtn;
@property (assign) BOOL headerFlag;
@property  int height;


@end

@implementation SPGetStartedViewController
@synthesize helpView;
@synthesize isPostLoginTutorialFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;

    [firstImageView setUserInteractionEnabled:NO];
    
    
    NSLog(@"isPostLoginTutorialFlag %d",isPostLoginTutorialFlag);
    
    if (isPostLoginTutorialFlag == YES){
        [self.homeBtn setImage:[UIImage imageNamed:@"toggle.png"] forState:UIControlStateNormal];
        [self prepareTopView];
        
        
    }else{
        [self.homeBtn setBackgroundImage:[UIImage imageNamed:@"backarrow.png"] forState:UIControlStateNormal];
        [self.homeBtn addTarget:nil action:@selector(backToHome:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:self.tapGestureRecognizer];
    
    self.headerFlag = YES;
    [self.homeImage setHidden:YES];
    helpView.hidden = NO;
    self.helpImage.hidden = YES;
    self.contentLabel.hidden = YES;
    
    [self.homeBtn setHidden:YES];
    [self.titleLabel setHidden:YES];
    
    self.helpView.backgroundColor = [UIColor clearColor];
    
    if (IS_IPHONE5){
        self.height = 548;
    }else{
        self.height = 460;
    }
    
    
    lastImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0.0, 320.0, self.height)];
    firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(320.0, 0.0, 320.0, self.height)];
    nextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(640.0, 0.0, 320.0, self.height)];
    
    lastImageView.tag = 1;
    firstImageView.tag = 2;
    nextImageView.tag = 3;
    
    
    imageArray = [[NSMutableArray alloc] initWithObjects:@"1_login", @"4_dashboard",@"5_wager", @"6_wager_track", @"7_wager_race", @"8_wager_bettype", @"9_wager_amount", @"10_wager_runners", @"10_wager_runners_2", @"11_mybets", @"11_mybets_deleteoption", @"11_mybets_final", @"13_wallet_1", @"13_wallet_2", nil];
    arrTotalCount = [imageArray count];
    
    if (arrTotalCount>2){
        
        [self setImageForImageView:nextImageView withImageName:[imageArray objectAtIndex:2]];
    }
    
    if (arrTotalCount>1){
        
        [self setImageForImageView:firstImageView withImageName:[imageArray objectAtIndex:1]];
    }
    if (arrTotalCount>0){
        
        [self setImageForImageView:lastImageView withImageName:[imageArray objectAtIndex:0]];
    }
    
    
    self.scrollView.contentSize = CGSizeMake(arrTotalCount*320, self.height);
    
    self.scrollView.pagingEnabled = YES;
    
    [self.scrollView addSubview:lastImageView];
    [self.scrollView addSubview:firstImageView];
    [self.scrollView addSubview:nextImageView];

    
    
        [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    [self.titleLabel setText:@"Tutorial"];
    
    

}
- (void)prepareTopView
{
    [self.homeBtn addTarget:self.navigationController.parentViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (self.headerFlag == YES){
        self.headerFlag = NO;
        [self.homeImage setHidden:NO];
        [self.homeBtn setHidden:NO];
        [self.titleLabel setHidden:NO];
    }else{
        self.headerFlag = YES;
        [self.homeImage setHidden:YES];
        [self.homeBtn setHidden:YES];
        [self.titleLabel setHidden:YES];
    }
    [self.tapGestureRecognizer setEnabled:YES];
}

- (void)setImageForImageView:(UIImageView*)imageView withImageName:(NSString *)imageName
{
    UIImage *aImage = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"]];
    imageView.image = aImage;
    //[aImage release];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //CGFloat pageWidth = self.scrollView.frame.size.width;
    //int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    
    int x = scrollView.contentOffset.x/320;
        
    int index = x%3;
    
    
    if (isPostLoginTutorialFlag == YES){
        
        
        
        
    }else{
        if (index < (int)scrollView.contentOffset.x) {
            // moved right
        }
        else if (index > (int)scrollView.contentOffset.x) {
            // moved left
            NSString *mesAlert = @"To go back home screen.";
            [self alertViewMethod:mesAlert];            //To go back home screen.
            
        }
    }
    
    //NSLog(@"index: %d",index);
    //NSLog(@"Prev %d",prevIndex);
    

    if (x>=arrTotalCount-1) {
        //[self alertViewMethod];
        NSString *mesAlert = @"The End of Tutorial.";
        [self alertViewMethod:mesAlert];

        return;
    }
    
    if (prevIndex < x )
    {
        switch (index) {
                
                

            case 2:
                lastImageView.frame = CGRectMake((x*320)+320, 0, 320, self.height);
                [self setImageForImageView:lastImageView withImageName:[imageArray objectAtIndex:x+1]];

                break;
                
            case 0:
                firstImageView.frame= CGRectMake((x*320)+320, 0, 320, self.height);
                [self setImageForImageView:firstImageView withImageName:[imageArray objectAtIndex:x+1]];
                break;
            case 1:
                nextImageView.frame = CGRectMake((x*320)+320, 0, 320, self.height);
                [self setImageForImageView:nextImageView withImageName:[imageArray objectAtIndex:x+1]];
                break;
        }
    }
    if (x<1) {
        
        return;
    }
    if (prevIndex > x )
    {
        switch (index) {
            case 1:
                
                lastImageView.frame = CGRectMake((x*320)-320, 0, 320, self.height);
                [self setImageForImageView:lastImageView withImageName:[imageArray objectAtIndex:x-1]];
                
                break;
                
            case 2:
                firstImageView.frame= CGRectMake((x*320)-320, 0, 320, self.height);
                [self setImageForImageView:firstImageView withImageName:[imageArray objectAtIndex:x-1]];
                
                break;
            case 0:
                nextImageView.frame = CGRectMake((x*320)-320, 0, 320, self.height);
                [self setImageForImageView:nextImageView withImageName:[imageArray objectAtIndex:x-1]];
                
                break;
        }
    }
    prevIndex = x;
}
- (void)alertViewMethod:(NSString *)Mess
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Totepool" message:Mess delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];//The End of Tutorial
    [alert show];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"%s",__FUNCTION__);
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    //CGFloat pageWidth = self.scrollView.frame.size.width;
    //int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backToHome:(id)sender
{
    if (isPostLoginTutorialFlag == YES){
        
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
}
#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0){
        if (isPostLoginTutorialFlag == YES){
            
            
            ZLMainGridViewController *mainView = (ZLMainGridViewController *)self.navigationController.navigationController.viewControllers[2];
            [self.navigationController.navigationController popToViewController:mainView animated:YES];
            
            
        }else{
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }else{
        
    }
}

@end
