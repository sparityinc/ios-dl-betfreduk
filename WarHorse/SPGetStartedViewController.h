//
//  SPGetStartedViewController.h
//  WarHorse
//
//  Created by sekhar on 25/10/13.
//  Copyright (c) 2013 Zytrix Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPGetStartedViewController : UIViewController
    
{
    UIImageView *firstImageView, *lastImageView, *nextImageView;
    NSMutableArray *imageArray;
    int arrTotalCount,prevIndex;
    
}
- (void)setImageForImageView:(UIImageView*)imageView withImageName:(NSString *)imageName;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UIView *helpView;
@property (nonatomic,assign) BOOL isPostLoginTutorialFlag;
- (IBAction)backToHome:(id)sender;
@end
