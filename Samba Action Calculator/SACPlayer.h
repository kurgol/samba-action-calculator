//
//  SACPlayer.h
//  Samba Action Calculator
//
//  Created by danton on 8/29/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SACPlayer : NSObject  <NSCoding>

@property (nonatomic, strong) NSString *name;
@property BOOL dodgeSkill;
@property BOOL sureHandsSkill;
@property BOOL sureFeetSkill;
@property BOOL passSkill;
@property BOOL catchSkill;
@property BOOL proSkill;
@property BOOL loner;

- (NSMutableString *) showSkills;

- (NSMutableString *) showFullTableDesc;

@end
