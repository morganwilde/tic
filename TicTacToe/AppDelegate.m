//
//  AppDelegate.m
//  TicTacToe
//
//  Created by Morgan Wilde on 10/07/2014.
//  Copyright (c) 2014 Zzish. All rights reserved.
//

#import "AppDelegate.h"
#import <PlatformSDK/PlatformSDK.h>

@interface AppDelegate()
@property (nonatomic, strong) AnalyticsService *sdk;
@end

@implementation AppDelegate

- (void)initServer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"platformsettings" ofType:@"plist"];
    NSDictionary *settings = [[NSDictionary alloc] initWithContentsOfFile:path];
    if (settings) {
        NSString* applicationId = [settings objectForKey:@"APPLICATION_ID"];
        if (applicationId && ![applicationId isEqualToString:@"NOT SET"]) {
            self.sdk = [AnalyticsService initWithApplicationId:applicationId];
            [self.sdk generate];
        }
        else {
            NSLog(@"Application ID must be set in settings.plist if you would like to use PlatformViewController");
        }
    }
    else {
        NSLog(@"Missing Settings Files");
    }
}

- (void)loginToServer
{
    if (!self.sdk) {
        [self initServer];
    }
    [self.sdk loginToServer];
}
- (void)logoutFromServer
{
    if (!self.sdk) {
        [self initServer];
    }
    [self.sdk logoutFromServer];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [DAO open];
    [self loginToServer];
    User *newUser = [self.sdk createUser];
    newUser.name = @"PLAYER";
    newUser.avatar = @"jaguar";
    [self.sdk updateUser:newUser];
    [self.sdk setCurrentUser:newUser];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.sdk logoutFromServer];
}

@end
