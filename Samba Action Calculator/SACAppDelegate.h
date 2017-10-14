//
//  SACAppDelegate.h
//  Samba Action Calculator
//
//  Created by David Dawnay on 7/19/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACPlayer.h"

@interface SACAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *players;

+ (SACAppDelegate *)sharedAppDelegate;

- (void)savePlayer:(SACPlayer *)player;
- (void)deletePlayer:(NSInteger)playerIndex;

@end
