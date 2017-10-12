//
//  SACAction.m
//  Samba Action Calculator
//
//  Created by David Dawnay on 7/20/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACAction.h"

@implementation SACAction

@synthesize action_type, min_roll, probaNoReroll, probaYesReroll, hasSkill, hasPro, usePro, isLoner, isNewPlayer, playerName, playerIndex;

- (id)initWithValues:(NSInteger)at
             minRoll:(NSInteger)mn
           forPlayer:(SACPlayer *)player
             atIndex:(int)index {
    // Call the NSObject's init method
    self = [super init];
    
    // Did it return somethine non-nil?
    if(self) {
        // Set the action type
        action_type = at;
        
        // Set the minumum roll needed for succeeding the action
        min_roll = mn;
        
        // Store the player's index in the Player Array
        playerIndex = index;
        
        // calculate odds with and without reroll
        probaNoReroll = (7.0-min_roll)/6.0;
        probaYesReroll = ((min_roll-1.0)/6.0) * ((7.0-min_roll)/6.0);
        
        // see if the player has relevant skills
        switch (action_type) {
            case 1:
                // Dodge Action
                if(player.dodgeSkill) hasSkill = YES;
                else hasSkill = NO;
            break;
            case 2:
                // Pick up Action
                if(player.sureHandsSkill) hasSkill = YES;
                else hasSkill = NO;
            break;
            case 3:
                // GFI Action
                if(player.sureFeetSkill) hasSkill = YES;
                else hasSkill = NO;
            break;
            case 4:
                // Pass Action
                if(player.passSkill) hasSkill = YES;
                else hasSkill = NO;
            break;
            case 5:
                // Catch Action
                if(player.catchSkill) hasSkill = YES;
                else hasSkill = NO;
            break;
            default:
                // Generic Action
                hasSkill = NO;
            break;
        }
    }
    
    // does the player have Pro?
    if(player.proSkill) hasPro = YES;
    else hasPro = NO;
    
    usePro = NO; // default is to use team reroll instead of Pro
    
    // is the player a Loner?
    if(player.loner) isLoner = YES;
    else isLoner = NO;
    
    // only used for New Player place holder
    isNewPlayer = NO;
    playerName = player.name;
    
    // Return a pointer to the new object
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Stored Action of type: %d with a min. roll of %d>", action_type, min_roll];
}

- (NSMutableString *)interfaceText {
    NSMutableString *desc = [[NSMutableString alloc] init];
    switch (action_type) {
        case 1:
            // Dodge Action
            [desc appendFormat:@"%d+ Dodge", min_roll];
        break;
        case 2:
            // Pick up Action
            [desc appendFormat:@"%d+ Pick up", min_roll];
        break;
        case 3:
            // GFI Action
            [desc appendFormat:@"%d+ GFI", min_roll];
        break;
        case 4:
            // Pass Action
            [desc appendFormat:@"%d+ Pass", min_roll];
        break;
        case 5:
            // Catch Action
            [desc appendFormat:@"%d+ Catch", min_roll];
        break;
        case 6:
            // Block Action
            [desc appendString:@"Block"];
        break;
        default:
            // Generic Action
            [desc appendFormat:@"%d+ Action", min_roll];
        break;
    }
    if(hasPro) [desc appendFormat:@"*"];
    return desc;
}

@end
