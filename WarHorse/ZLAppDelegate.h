//
//  ZLAppDelegate.h
//  WarHorse
//
//  Created by Sparity on 10/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/Restkit.h>

#import "ZLAPIWrapper.h"
#import "Device.h"
#import "ZLAppData.h"
#import "ZLPreLoginAPIWrapper.h"
#import "GAI.h"

@interface ZLAppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL didEnterBackground;

}
@property (strong, nonatomic) NSDictionary *notifyDic;


@property (assign) BOOL isOrientation;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,strong) UINavigationController *navigationController;

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) NSTimer * wagerDataRefreshTimer;

@property (strong, nonatomic) NSTimer * balanceRefreshTimer;
@property(nonatomic, strong) id<GAITracker> tracker;


- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

+(ZLAPIWrapper*) getApiWrapper;

+ (void)showLoadingView;

+ (void)hideLoadingView;

+(Device*)getDevice;

+(ZLAppData*)getAppData;

+ (ZLPreLoginAPIWrapper*)getPreLoginApiWrapper;


@end
