//
//  SACPassAction.m
//  Samba Action Calculator
//
//  Created by danton on 9/7/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACPassAction.h"

@implementation SACPassAction

@synthesize interception, withPro, withCatch, interceptionOdds;

- (id)initWithValues:(NSInteger)at
             minRoll:(NSInteger)mn
           forPlayer:(SACPlayer *)player
             atIndex:(int)index
        canIntercept:(NSInteger)i
              hasPro:(BOOL)p
            hasCatch:(BOOL)c {
    // Call the superclass's initializer
    self = [super initWithValues:at minRoll:mn forPlayer:player atIndex:(int)index];
    
    if(self) {
        // Add the pass params
        interception = i;
        withPro = p;
        withCatch = c;
        
        // calculate the interception odds
        float baseInterceptionOdds;
        
        switch (interception) {
            case 2:
                baseInterceptionOdds = 1.0/6.0;
            break;
            case 3:
                baseInterceptionOdds = 2.0/6.0;
            break;
            case 4:
                baseInterceptionOdds = 3.0/6.0;
            break;
            case 5:
                baseInterceptionOdds = 4.0/6.0;
            break;
            case 6:
                baseInterceptionOdds = 5.0/6.0;
            break;
            default:
                baseInterceptionOdds = 1.0;
            break;
        }
        
        interceptionOdds = baseInterceptionOdds;
        if(withPro) interceptionOdds = baseInterceptionOdds * (1.0/2.0 + baseInterceptionOdds/2.0);
        if(withCatch) interceptionOdds = baseInterceptionOdds * baseInterceptionOdds;
        
    }
    // Return a pointer to the new object
    return self;

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Stored Pass Action of type: %d with a min. roll of %d. Can be intercepted: (%d) with Pro (%s) and Catch (%s)>", [self action_type], [self min_roll], [self interception], [self withPro] ? "true" : "false", [self withCatch] ? "true" : "false"];
}

- (NSMutableString *)interfaceText {
    NSMutableString *desc = [[NSMutableString alloc] init];
    [desc appendFormat:@"%d+ Pass", self.min_roll];
    if(interception > 0) {
        [desc appendFormat:@" (NSInteger %d+", interception];
        if(withPro) [desc appendFormat:@",p"];
        if(withCatch) [desc appendFormat:@",c"];
        [desc appendFormat:@")"];
    }
    if(self.hasPro) [desc appendFormat:@"*"];
    return desc;
}


@end
