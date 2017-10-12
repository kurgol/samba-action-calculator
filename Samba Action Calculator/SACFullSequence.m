//
//  SACFullSequence.m
//  Samba Action Calculator
//
//  Created by David Dawnay on 7/19/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACFullSequence.h"

@implementation SACFullSequence

@synthesize proba, sequence;

- (id)init
{
    // Call the NSObject's init method
    self = [super init];
    
    // Did it return somethine non-nil?
    if(self) {
        // initialize the array
        sequence = [[NSMutableArray alloc] init];
        proba = 1;
    }
    
    // Return a pointer to the new object
    return self;

}

- (void) addAction:(SACAction *) action {
    // add the action to the array
    [sequence addObject:action];
    
    /*
    for(SACAction *storedAction in sequence) {
        NSLog(@"%@\n", storedAction);
    }
     */
}

- (void) removeAction:(int) index {
    // remove the action from the array
    [sequence removeObjectAtIndex:index];
}

- (void) clearActions {
    [sequence removeAllObjects];
}

- (float) getProbaReroll:(BOOL)teamRerollLeft {
    return [self getProbaAction:0 teamRR:teamRerollLeft dodgeRR:YES sfRR:YES proRR:YES];
}

- (float) getProbaAction:(int)n
                  teamRR:(BOOL)trLeft
                 dodgeRR:(BOOL)drLeft
                    sfRR:(BOOL)sfrLeft
                   proRR:(BOOL)pLeft {
    
    // check to see if we have reached the end of the array in order to break recursion
    if(n >= [sequence count]) return 1;
    
    SACAction *currentAction = [sequence objectAtIndex:n];
    float p1; // stores the odds for an action with reroll
    float p2; // stores the odds for an action without reroll
    
    //NSLog(@"%@ with no reroll = %f",currentAction, currentAction.probaNoReroll);
    //NSLog(@"%@ with reroll = %f",currentAction, currentAction.probaYesReroll);
    
    // if this is a new player then skip to the next Action
    if (currentAction.isNewPlayer) {
        return [self getProbaAction:n+1
                             teamRR:trLeft
                            dodgeRR:YES
                               sfRR:YES
                              proRR:YES];
    }
    
    // get the odds for this Action without reroll
    p1 = currentAction.probaNoReroll * [self getProbaAction:n+1
                                                     teamRR:trLeft
                                                    dodgeRR:drLeft
                                                       sfRR:sfrLeft
                                                      proRR:pLeft];
    //NSLog(@"p1 = %f",p1);
    
    // get the odds for this action with a reroll
    p2 = 0;
    
    if(drLeft && currentAction.action_type == 1 && currentAction.hasSkill) {
        // this is a dodge with the Dodge skill?
        p2 = currentAction.probaYesReroll * [self getProbaAction:n+1
                                                         teamRR:trLeft
                                                        dodgeRR:NO
                                                           sfRR:sfrLeft
                                                          proRR:pLeft];
    }
    else if(currentAction.action_type == 4 && currentAction.hasSkill) {
        // this is a pass with the Pass skill
        p2 = currentAction.probaYesReroll * [self getProbaAction:n+1
                                                          teamRR:trLeft
                                                         dodgeRR:drLeft
                                                            sfRR:sfrLeft
                                                           proRR:pLeft];
    }
    else if(currentAction.action_type == 5 && currentAction.hasSkill) {
        // this is a catch with the Catch skill
        p2 = currentAction.probaYesReroll * [self getProbaAction:n+1
                                                          teamRR:trLeft
                                                         dodgeRR:drLeft
                                                            sfRR:sfrLeft
                                                           proRR:pLeft];
    }
    else if(currentAction.action_type == 2 && currentAction.hasSkill) {
        // this is a pick up with the Sure Hands skill
        p2 = currentAction.probaYesReroll * [self getProbaAction:n+1
                                                          teamRR:trLeft
                                                         dodgeRR:drLeft
                                                            sfRR:sfrLeft
                                                           proRR:pLeft];
    }
    else if(sfrLeft && currentAction.action_type == 3 && currentAction.hasSkill) {
        // this is a GFI with the Sure Feet skill
        p2 = currentAction.probaYesReroll * [self getProbaAction:n+1
                                                          teamRR:trLeft
                                                         dodgeRR:drLeft
                                                            sfRR:NO
                                                           proRR:pLeft];
    }
    else if(trLeft) {
        // The team re-roll is available
        if(pLeft && currentAction.hasPro && currentAction.usePro) {
            // use Pro before team reroll
            // Pro Success: (roll fail) * (pro succeed) * (roll succeed) * (rest of sequence)
            float pPro = (1.0-currentAction.probaNoReroll) *
                        (1.0/2.0) * currentAction.probaNoReroll *
                        [self getProbaAction:n+1
                                      teamRR:trLeft
                                     dodgeRR:drLeft
                                        sfRR:sfrLeft
                                       proRR:NO];
            
            // Pro roll fails but use Team reroll for it
            // (roll fail) * (pro fail) * (pro succeed) * (roll succeed) * (rest of sequence)
            float pPro2 = (1.0-currentAction.probaNoReroll) *
                        (1.0/2.0) * (1.0/2.0) * currentAction.probaNoReroll *
                        [self getProbaAction:n+1
                          teamRR:NO
                         dodgeRR:drLeft
                            sfRR:sfrLeft
                           proRR:NO];
            
            p2 = pPro + pPro2;
        }
        else {
            // do not use Pro unless there is no reroll
            p2 = currentAction.probaYesReroll * [self getProbaAction:n+1
                                                              teamRR:NO
                                                             dodgeRR:drLeft
                                                                sfRR:sfrLeft
                                                               proRR:pLeft];
            if(currentAction.isLoner) p2 = p2/2.0;
        }
    }
    else if(pLeft && currentAction.hasPro) {
        // team reroll has been used but can still use Pro
        p2 = (1.0/2.0) * currentAction.probaYesReroll * [self getProbaAction:n+1
                                                                  teamRR:trLeft
                                                                 dodgeRR:drLeft
                                                                    sfRR:sfrLeft
                                                                   proRR:NO];
    }
    //NSLog(@"p2 = %f",p2);
    
    float result = p1 + p2;
    
    // is there the chance of an interception in the sequence?
    if(currentAction.action_type == 4) {
        // this is a pass action so we need to cast it
        SACPassAction *pass = (SACPassAction *)currentAction;
        if(pass.interceptionOdds < 1.0) {
            // factor in the chance of interception
            result = (p1 + p2) * pass.interceptionOdds;
        }
    }
    
    //NSLog(@"result = %f",result);
    
    return result;
}


@end
