//
//  SACPassAction.h
//  Samba Action Calculator
//
//  Created by danton on 9/7/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACAction.h"

@interface SACPassAction : SACAction

@property (nonatomic, assign) NSInteger interception;
@property BOOL withPro;
@property BOOL withCatch;
@property float interceptionOdds;

- (id)initWithValues:(NSInteger)at
             minRoll:(NSInteger)mn
           forPlayer:(SACPlayer *)player
             atIndex:(NSInteger)index
        canIntercept:(NSInteger)i
              hasPro:(BOOL)p
            hasCatch:(BOOL)c;

@end
