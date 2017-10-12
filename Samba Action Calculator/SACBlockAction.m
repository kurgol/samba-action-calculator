//
//  SACBlockAction.m
//  Samba Action Calculator
//
//  Created by danton on 10/1/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACBlockAction.h"

@implementation SACBlockAction

@synthesize numDice, numSuccess, blockDice;

- (id)initWithValues:(NSInteger)at
             minRoll:(NSInteger)mn
           forPlayer:(SACPlayer *)player
             atIndex:(int)index
          successArr:(NSArray*)sa {
    // Call the superclass's initializer
    self = [super initWithValues:at minRoll:mn forPlayer:player atIndex:(int)index];
    
    if(self) {
        numSuccess = sa;
        // how many block dice are successful results?
        int numSuccDice = 0;
        for (int i=0; i<5; i++) {
            //NSLog(@"Dice %d: %@", i, numSuccess[i]);
            BOOL isSuccess = [numSuccess[i] boolValue];
            if (i == 2 && isSuccess) {
                numSuccDice = numSuccDice + 2; // Pushes count for 2 face on the die
            }
            else if(isSuccess) numSuccDice++;
        }
        //NSLog(@"Num successful dice: %d", numSuccDice);
        
        // Add the number of successful dice array
        switch (self.min_roll) {
            case 2:
                numDice = -3;
                self.probaNoReroll = numSuccDice * numSuccDice * numSuccDice / 216.0;
            break;
            case 3:
                numDice = -2;
                self.probaNoReroll = numSuccDice * numSuccDice / 36.0;
                break;
            case 4:
                numDice = 1;
                self.probaNoReroll = numSuccDice / 6.0;
                break;
            case 5:
                numDice = 2;
                self.probaNoReroll = ((12 * numSuccDice) - (numSuccDice * numSuccDice)) / 36.0;
                break;
            case 6:
                numDice = 3;
                self.probaNoReroll = ((108.0 * numSuccDice) - (18.0 * numSuccDice * numSuccDice) + (numSuccDice * numSuccDice * numSuccDice)) / 216.0;
            break;
            default:
                numDice = 1;
                self.probaNoReroll = numSuccDice / 6.0;
            break;
        }
        self.probaYesReroll = (1.0-self.probaNoReroll) * self.probaNoReroll;
        
        blockDice = [[NSArray alloc] initWithObjects:@"Skull", @"Pow Skull", @"Push", @"Dodge Pow", @"Pow", nil];
        
        //NSLog(@"Block with no reroll = %f",self.probaNoReroll);
        //NSLog(@"Block with reroll = %f", self.probaYesReroll);
        
    }
    // Return a pointer to the new object
    return self;
}

- (NSMutableString*) getDiceDescription {
    NSMutableString *diceDesc = [[NSMutableString alloc] init];
    BOOL haveDice = 0;
    for(int i=0; i < [numSuccess count]; i++) {
        BOOL isActive = [numSuccess[i] boolValue];
        if(isActive) {
            haveDice ? [diceDesc appendFormat:@", %@", blockDice[i]]:[diceDesc appendFormat:@"%@", blockDice[i]];
            haveDice = 1;
        }
        
    }
    return diceDesc;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Stored Block Action of type: %d with %d dice. Successful with %@>", [self action_type], [self numDice], [self getDiceDescription]];
}

- (NSMutableString *)interfaceText {
    NSMutableString *desc = [[NSMutableString alloc] init];
    [desc appendFormat:@"%dd Block", self.numDice];
    if(self.hasPro) [desc appendFormat:@"*"];
    return desc;
}


@end
