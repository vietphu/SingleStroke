//
//  SingleStrokeAppDelegate.m
//  SingleStroke
//
//  Created by Taka Okunishi on 9/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SingleStrokeAppDelegate.h"
#import "PlayController.h"
#define BestScoreKey @"bestScore"

/*********************************************************************/
/*  private interface                                                */
/*********************************************************************/
@interface SingleStrokeAppDelegate(private)
@property(nonatomic, retain, readonly)UIWindow *window;
@property(nonatomic, retain)PlayController *playController;
@end

/*********************************************************************/
/* implementation                                                    */
/*********************************************************************/
@implementation SingleStrokeAppDelegate
#pragma mark -
- (void)dealloc {
    [window release];
    [playController release];
    [super dealloc];
}
- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.playController.bestScore = [userDefaults integerForKey:BestScoreKey];

    [self.window setRootViewController:self.playController];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:self.playController.bestScore
                      forKey:BestScoreKey];

    [playController release];
    playController = nil;
}

@end

/*********************************************************************/
/*  private implementation                                           */
/*********************************************************************/
@implementation SingleStrokeAppDelegate(private)
@dynamic window;
@dynamic playController;
- (UIWindow *)window {
    if (window) return window;
    window = [[UIWindow alloc] init];
    [window setFrame:[UIScreen mainScreen].bounds];

    return window;
}
- (PlayController *)playController {
    if (playController) return playController;
    playController = [[PlayController alloc] init];
    return playController;
}



@end