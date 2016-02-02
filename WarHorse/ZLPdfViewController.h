//
//  ZLPdfViewController.h
//  WarHorse
//
//  Created by Sparity on 02/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLPdfViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;


- (IBAction)backButtonClicked:(id)sender;
@end
