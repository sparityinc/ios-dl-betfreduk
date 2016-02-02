//
//  SPSCRChangesDetailViewController.h
//  WarHorse
//
//  Created by Enterpi on 22/08/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZUUIRevealController.h"

@interface SPSCRChangesDetailViewController : UIViewController <UIScrollViewDelegate,ZUUIRevealControllerDelegate>

@property (nonatomic,assign) BOOL isPostLoginFlag;
@end
