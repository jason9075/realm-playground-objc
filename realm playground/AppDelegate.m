//
//  AppDelegate.m
//  realm playground
//
//  Created by jason9075 on 2016/2/15.
//  Copyright (c) 2016 jason9075. All rights reserved.
//


#import <Realm/Realm/RLMMigration.h>
#import "AppDelegate.h"
#import "ViewController.h"
#import "Realm/RLMRealmConfiguration.h"
#import "ArticleData.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    // Set the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    config.schemaVersion = 1;

    // Set the block which will be called automatically when opening a Realm with a
    // schema version lower than the one set above
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion < 1) {
            [migration enumerateObjects:ArticleData.className block:^(RLMObject *oldObject, RLMObject *newObject) {

            }];
        }
    };

    // Tell Realm to use this new configuration object for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];

    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    [RLMRealm defaultRealm];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = UIColor.whiteColor;

    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end