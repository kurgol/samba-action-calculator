//
//  SACAppDelegate.m
//  Samba Action Calculator
//
//  Created by David Dawnay on 7/19/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACAppDelegate.h"

@implementation SACAppDelegate

@synthesize window = _window, players;

+ (SACAppDelegate *)sharedAppDelegate
{
    return (SACAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)savePlayer:(SACPlayer *)player {
    // save the player to the array
    [[self players] addObject:player];
}

-(void)deletePlayer:(int)playerIndex {
    // remove the player from the array
    [[self players] removeObjectAtIndex:playerIndex];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Attempt to load an existing players dataset from an array stored to disk
   /*
    NSArray *plist = [NSArray arrayWithContentsOfFile:docPath()];
    if(plist) {
        // If there was a dataset available, copy it into our instance variable
        self.players = [plist mutableCopy];
    } else {
        // Otherwise just create an empty one to get us started
        self.players = [[NSMutableArray alloc] init];
    }
    */
    
    NSData *playersData = [[NSUserDefaults standardUserDefaults] objectForKey:@"players"];
    if(playersData == nil) {
        self.players = [[NSMutableArray alloc] init];
        //NSLog(@"No saved players found!");
    }
    else self.players = [NSKeyedUnarchiver unarchiveObjectWithData:playersData];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Save our players to disk
    //[self.players writeToFile:docPath() atomically:YES];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.players];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"players"];
    //NSLog(@"The App entered the background!");
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
    // Save our players to disk
    //[self.players writeToFile:docPath() atomically:YES];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.players];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"players"];
    //NSLog(@"The App is about to terminate!");
}

@end
