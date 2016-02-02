//
//  ZLAppDelegate.m
//  WarHorse
//
//  Created by Sparity on 10/07/13.
//  Copyright (c) 2013 Sparity. All rights reserved.
//

#import "ZLAppDelegate.h"
#import "ZLMainScreenViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "GAITracker.h"
#import "GAIFields.h"
#import "WarHorseSingleton.h"

/******* Set your tracking ID here *******/
static NSString *const kTrackingId = @"UA-48042394-1";
static NSString *const kAllowTracking = @"allowTracking";



@interface ZLAppDelegate() <UIAlertViewDelegate>

@property(nonatomic, retain) ZLAPIWrapper * apiWrapper;
@property (nonatomic, retain) NSMutableDictionary *localDict;
@property (nonatomic,retain) NSTimer *logoutTimer;


@end

@implementation ZLAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.wagerDataRefreshTimer = nil;
    self.balanceRefreshTimer = nil;
    
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }

    
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //UIRemoteNotificationType enabledTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    //NSLog(@"enabledTypes %d", enabledTypes);
    
    if ([[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]isKindOfClass:[NSDictionary class]]) {
        
        self.notifyDic = launchOptions;
        NSLog(@"launchOptions %@",launchOptions);
    }
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    self.localDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"alert",@"",@"sound",nil];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    ZLMainScreenViewController *mainSCreenVC=[[ZLMainScreenViewController alloc]init];
    navigationController=[[UINavigationController alloc]initWithRootViewController:mainSCreenVC];
    self.window.rootViewController=navigationController;
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self.window makeKeyAndVisible];
    
    [ZLAppDelegate getApiWrapper];
    return YES;
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceTokenKey
{
    NSString *deviceToken = [NSString stringWithFormat:@"%@",deviceTokenKey];
    
    NSString *device_Token = [[[deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSLog(@"device_Token %@",device_Token);
    
    //[[NSUserDefaults standardUserDefaults]setObject:@"XXXXX-987654321-XDEF" forKey:@"decvice_token"];// XXXXX-194584891-XDEF Sai9999

    [[NSUserDefaults standardUserDefaults]setObject:device_Token forKey:@"decvice_token"];
    
    [[WarHorseSingleton sharedInstance]setNotificationTrunOnStr:@"YES"];

    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    NSLog(@"Error %@",str);
    [[WarHorseSingleton sharedInstance]setNotificationTrunOnStr:@"NO"];

    [[NSUserDefaults standardUserDefaults]setObject:@"XXXXX-19kjh225245545684891-XDEF" forKey:@"decvice_token"];//XXXXX-19ppgl222524584891-XDEF
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    if ([application applicationState] == UIApplicationStateActive)
    {
        // Foreground
        NSLog(@"UIApplicationStateactive ");
        if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] rangeOfString:@"Your account has been successfully created"].location != NSNotFound)
        {
            NSString *acountIdStr = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] substringFromIndex:[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] length] - 6];
            
            NSString *userId = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MyWinn" message:userId delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [[NSUserDefaults standardUserDefaults] setValue:acountIdStr forKey:@"AccountID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            
            
        }else{
            //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Digital Link" message:messageStr delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //[alert show];
        }
        
        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        
        
    }else{
        NSLog(@"background");
        if ([[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] rangeOfString:@"Your account has been successfully created"].location != NSNotFound)
        {
            NSString *acountIdStr = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] substringFromIndex:[[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] length] - 6];
            
            //NSString *userId = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"];
            NSLog(@"PushNotification Dict2 %@",userInfo);
            
            
            [[NSUserDefaults standardUserDefaults] setValue:acountIdStr forKey:@"AccountID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ZLMainScreenViewController *preloginVIewController = [[ZLMainScreenViewController alloc] initWithNibName:@"ZLMainScreenViewController" bundle:nil];
            navigationController=[[UINavigationController alloc]initWithRootViewController:preloginVIewController];
            self.window.rootViewController=navigationController;
            
        }
        
        
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    
    NSNumber *contentID = userInfo[@"content-id"];
    NSLog(@"contentID %@",contentID);
    // Do something with the content ID
    completionHandler(UIBackgroundFetchResultNewData);
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
    if(self.window.rootViewController){
        UIViewController *presentedViewController = [[(UINavigationController *)self.window.rootViewController viewControllers] lastObject];
        //NSLog(@"view Controller :%@",presentedViewController);
        //NSLog(@"isOrientation %d",self.isOrientation);
        if (self.isOrientation) {
            orientations = [presentedViewController supportedInterfaceOrientations];
        }
    }
    return orientations;
    
}



#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ZLMainScreenViewController *preloginVIewController = [[ZLMainScreenViewController alloc] initWithNibName:@"ZLMainScreenViewController" bundle:nil];
    navigationController=[[UINavigationController alloc]initWithRootViewController:preloginVIewController];
    self.window.rootViewController=navigationController;
    
}

+(ZLAPIWrapper*) getApiWrapper
{
    static dispatch_once_t pred;
    static ZLAPIWrapper *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[ZLAPIWrapper alloc] init];
    });
    return sharedInstance;
}

+(Device*)getDevice
{
    static dispatch_once_t pred;
    static Device *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[Device alloc] init];
    });
    return sharedInstance;
}

+(ZLAppData*)getAppData
{
    static dispatch_once_t pred;
    static ZLAppData *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[ZLAppData alloc] init];
    });
    return sharedInstance;
}

+(ZLPreLoginAPIWrapper*) getPreLoginApiWrapper
{
    static dispatch_once_t onceToken;
    static ZLPreLoginAPIWrapper *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZLPreLoginAPIWrapper alloc] init];
    });
    return sharedInstance;
}

+ (void)showLoadingView
{
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    Device * _device = [ZLAppDelegate getDevice];
    UIView *transparentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0,320.0,_device.screen_height + 20)];
    [transparentView setAlpha:1.0];
    transparentView.tag = 10021;
    [transparentView setBackgroundColor:[UIColor clearColor]];
    
    UIActivityIndicatorView* _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.alpha = 1.0;
    _activityIndicator.center = appDelegate.window.center;
    _activityIndicator.hidesWhenStopped = NO;
    [_activityIndicator startAnimating];
    [transparentView addSubview:_activityIndicator];
    [appDelegate.window addSubview:transparentView];
    [appDelegate.window bringSubviewToFront:transparentView];
}

+(void)hideLoadingView
{
    
    NSLog(@"Inside here");
    ZLAppDelegate* appDelegate = (ZLAppDelegate*)[[UIApplication sharedApplication] delegate];
    UIView* loadingView = [appDelegate.window viewWithTag:10021];
    if( loadingView )
        [loadingView removeFromSuperview];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    if (self.logoutTimer == nil)
    {
        self.logoutTimer = [NSTimer scheduledTimerWithTimeInterval:1200.0 target:self selector:@selector(applicationLogoutService) userInfo:nil repeats:NO];
        NSLog(@"background timer %@",self.logoutTimer);
        
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    NSLog(@"self.logoutTimer %@",self.logoutTimer);
    
    if (self.logoutTimer != nil)
    {
        [self.logoutTimer invalidate];
        self.logoutTimer = nil;
        NSLog(@"applicationWillEnterForeground timer %@",self.logoutTimer);
        
    }
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [GAI sharedInstance].optOut =
    ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    [apiWrapper logoutUserWithParameters:nil success:^(NSDictionary *_userInfo) {
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)applicationLogoutService
{
    //NSLog(@"%s",__func__);
    //NSLog(@"ViewControllers = %@", [self.navigationController viewControllers]);
    // [self.navigationController popToViewController:[self.navigationController viewControllers][0] animated:YES];
    
    ZLAPIWrapper *apiWrapper = [ZLAppDelegate getApiWrapper];
    
    [apiWrapper logoutUserWithParameters:nil success:^(NSDictionary *_userInfo) {
        [self.navigationController popToRootViewControllerAnimated:NO];
        //[self.navigationController popToViewController:[self.navigationController viewControllers][0] animated:NO];
        
    } failure:^(NSError *error) {
        
        
        
    }];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"WarHorse" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WarHorse.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
