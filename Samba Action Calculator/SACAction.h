//
//  SACAction.h
//  Samba Action Calculator
//
//  Created by David Dawnay on 7/20/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACPlayer.h"

@interface SACAction : NSObject
    
@property (nonatomic, assign) NSInteger action_type;
@property (nonatomic, assign) NSInteger min_roll;
@property float probaNoReroll;
@property float probaYesReroll;
@property BOOL hasSkill;
@property BOOL hasPro;
@property BOOL usePro; // use Pro before team reroll
@property BOOL isLoner;
@property BOOL isNewPlayer;
@property (nonatomic, weak) NSString *playerName;
@property NSInteger playerIndex;

- (id)initWithValues:(NSInteger)at
             minRoll:(NSInteger)mn
           forPlayer:(SACPlayer *)player
             atIndex:(int)index;

- (NSMutableString *)interfaceText;

@end
