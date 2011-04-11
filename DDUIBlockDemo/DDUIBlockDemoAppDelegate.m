//
//  DDUIBlockDemoAppDelegate.m
//  DDUIBlockDemo
//
//  Created by Daniel Dickison on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DDUIBlockDemoAppDelegate.h"

@implementation DDUIBlockDemoAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
