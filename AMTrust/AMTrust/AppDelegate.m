//
//  AppDelegate.m
//  AMTrust
//
//  Created by kishore kumar on 23/05/17.
//  Copyright © 2017 kishore kumar. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[[Crashlytics class]]];

    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //SVProgressHUD
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[Helper colorWithHexString:@"FD334F"]];
    
    //Notification Settings
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //Google Analytics
    
    GAI *gai = [GAI sharedInstance];
    [gai trackerWithTrackingId:@"UA-106477121-1"];
    gai.trackUncaughtExceptions = YES;
  

    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"deviceToken"];
    
    NSLog(@"deviceToken: %@", token);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
    
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"token error = : %@", err];
    
    NSLog(@"%@",str);
    
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"this is user info  = %@",userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"Application will resign active.");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"Application did enter background.");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SplashViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"SplashViewController"];
    vc1.isFromBackground = YES;
    
    [self.window.rootViewController presentViewController:vc1 animated:true completion:nil];
    NSLog(@"Application did enter foreground.");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[[Helper sharedInstance] getTokenString];

    
    NSLog(@"Application did become active.");
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSLog(@"url = %@",url);
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"this is user info =%@",userInfo);
    NSString *alertInfo = (NSString *) userInfo[@"aps"][@"alert"];
    NSLog(@"alert info = %@",alertInfo);
    
    //NSString *alertID = [userInfo valueForKey:@"alertid"];
    
    if (application.applicationState == UIApplicationStateInactive) {
       // [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
//Good news! Your screen photo has been accepted and approved.
    if([alertInfo isEqualToString:@"Foto bagian layar Anda kurang jelas. Mohon mengambil foto lain dan unggah pada bagian proteksi. Terimakasih. "]||[alertInfo isEqualToString:@"Foto layar Anda tidak dapat digunakan. Kami akan menghubungi Anda segera, atau Anda bisa menghubungi (1800-132-001-08)"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"retake" forKey:@"Notification"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"approve" forKey:@"Notification"];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"NotificationCame"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NSDictionary *personal = [[NSUserDefaults standardUserDefaults] objectForKey:@"profile"];
    
    if(personal!=nil)
    {
        UITabBarController *homeTab = [storyBoard instantiateViewControllerWithIdentifier:@"CustomTabBarController"];
        [self.window makeKeyAndVisible];
        [[self window].rootViewController presentViewController:homeTab animated:YES completion:nil];
    }
    else{
        
        BOOL walkthrough = [[[NSUserDefaults standardUserDefaults] objectForKey:@"WALKTHROUGH"] boolValue];
        
        if(walkthrough)
        {
            UINavigationController *navigation = [storyBoard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
            [self.window makeKeyAndVisible];
            [[self window].rootViewController presentViewController:navigation animated:YES completion:nil];
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
            [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"BundlePath"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"AMTrust"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
