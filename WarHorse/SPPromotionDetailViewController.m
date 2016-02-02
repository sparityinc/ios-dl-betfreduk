//
//  SPPromotionDetailViewController.m
//  WarHorse
//
//  Created by Ramya on 9/20/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import "SPPromotionDetailViewController.h"
#import "SPPromotionViewController.h"
#import "SPConstant.h"


@interface SPPromotionDetailViewController ()
{
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIImageView *promotionImage;
@property (nonatomic, weak) IBOutlet UILabel *headerLbl;

//@property (strong, nonatomic) IBOutlet UITextView *txtview;

- (IBAction)homeBtn:(id)sender;
- (IBAction)backBtn:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;



@end

@implementation SPPromotionDetailViewController

@synthesize promationTitle;
@synthesize promationDescription;
@synthesize promationImageName;
@synthesize promotionImage;
@synthesize selectImage;

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
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.headerLbl setText:@"Promotions"];
    [self.headerLbl setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    if (IS_IPHONE5) {
        self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y, self.descriptionTextView.frame.size.width, self.descriptionTextView.frame.size.height+108);
        
    }
    
    [self.descriptionTextView setFont:[UIFont fontWithName:@"Roboto-Light" size:14]];
    [self.titleLabel setFont:[UIFont fontWithName:@"Roboto-Light" size:15]];
    
    
    [self.titleLabel setTextColor:[UIColor colorWithRed:30.0/255.0f green:30.0/255.0f blue:30.0/255.0f alpha:1.0]];
    self.titleLabel.text = promationTitle;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.descriptionTextView.text = promationDescription;
    self.descriptionTextView.backgroundColor = [UIColor colorWithRed:243.0/255.0f green:243.0/255.0f blue:243.0/255.0f alpha:1.0];
    
    [promotionImage setImage:selectImage];
    [self.promotionImage setFrame:CGRectMake(10, 10, self.promotionImage.frame.size.width, selectImage.size.height/2)];
    [self.descriptionTextView setFrame:CGRectMake(10,CGRectGetMaxY(promotionImage.frame), CGRectGetWidth(self.descriptionTextView.frame), self.descriptionTextView.contentSize.height)];
    [self.descriptionTextView sizeToFit];
    self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y, self.descriptionTextView.frame.size.width, self.descriptionTextView.frame.size.height);

    if (!IS_IPHONE5) {
        self.descriptionTextView.frame = CGRectMake(self.descriptionTextView.frame.origin.x, self.descriptionTextView.frame.origin.y, self.descriptionTextView.frame.size.width, self.descriptionTextView.frame.size.height+90);

    }
    [self.scrollView setContentSize:(CGSizeMake(320, CGRectGetMaxY(self.descriptionTextView.frame)))];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backBtn:(id)sender {
   
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidUnload {
    [self setHeaderImageView:nil];
    [self setTitleLabel:nil];
    [self setDescriptionTextView:nil];
    [self setPromotionImage:nil];
    [super viewDidUnload];
}
@end
