//
//  SACFullSequence.h
//  Samba Action Calculator
//
//  Created by David Dawnay on 7/19/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SACPassAction.h"
#import "SACBlockAction.h"

@interface SACFullSequence : NSObject

@property float proba;
@property (nonatomic, strong) NSMutableArray *sequence;

- (id)init;

- (void) addAction:(SACAction *) action;

- (void) removeAction:(int) index;

- (void) clearActions;

- (float) getProbaReroll:(BOOL)teamRerollLeft;

- (float) getProbaAction:(int)n
                  teamRR:(BOOL)trLeft
                 dodgeRR:(BOOL)drLeft
                    sfRR:(BOOL)sfrLeft
                   proRR:(BOOL)pLeft;

@end
