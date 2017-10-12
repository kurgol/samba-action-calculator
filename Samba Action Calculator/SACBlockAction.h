//
//  SACBlockAction.h
//  Samba Action Calculator
//
//  Created by danton on 10/1/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACAction.h"

@interface SACBlockAction : SACAction

@property (nonatomic, assign) NSInteger numDice;
@property (nonatomic, strong) NSArray *numSuccess;
@property (nonatomic, strong) NSArray *blockDice;

- (id)initWithValues:(NSInteger)at
             minRoll:(NSInteger)mn
           forPlayer:(SACPlayer *)player
             atIndex:(int)index
        successArr:(NSArray*)sa;

- (NSMutableString*) getDiceDescription;

@end
