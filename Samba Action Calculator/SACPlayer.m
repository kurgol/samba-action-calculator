//
//  SACPlayer.m
//  Samba Action Calculator
//
//  Created by danton on 8/29/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACPlayer.h"

@implementation SACPlayer

@synthesize name, dodgeSkill, sureHandsSkill, sureFeetSkill, passSkill, catchSkill, proSkill, loner;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self != nil) {
        name = [decoder decodeObjectForKey:@"name"];
        dodgeSkill = [decoder decodeBoolForKey:@"dodgeSkill"];
        sureHandsSkill = [decoder decodeBoolForKey:@"sureHandsSkill"];
        sureFeetSkill = [decoder decodeBoolForKey:@"sureFeetSkill"];
        passSkill = [decoder decodeBoolForKey:@"passSkill"];
        catchSkill = [decoder decodeBoolForKey:@"catchSkill"];
        proSkill = [decoder decodeBoolForKey:@"proSkill"];
        loner = [decoder decodeBoolForKey:@"loner"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeBool:dodgeSkill forKey:@"dodgeSkill"];
    [encoder encodeBool:sureHandsSkill forKey:@"sureHandsSkill"];
    [encoder encodeBool:sureFeetSkill forKey:@"sureFeetSkill"];
    [encoder encodeBool:passSkill forKey:@"passSkill"];
    [encoder encodeBool:catchSkill forKey:@"catchSkill"];
    [encoder encodeBool:proSkill forKey:@"proSkill"];
    [encoder encodeBool:loner forKey:@"loner"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Player %@\nDodge (%s)\nSure Hands (%s)\nSure Feet (%s)\nPass (%s) \nCatch (%s)\nPro (%s)\nLoner (%s)>", [self name], [self dodgeSkill] ? "true" : "false", [self sureHandsSkill] ? "true" : "false", [self sureFeetSkill] ? "true" : "false", [self passSkill] ? "true" : "false", [self catchSkill] ? "true" : "false", [self proSkill] ? "true" : "false", [self loner] ? "true" : "false"];
}

- (NSMutableString *) showSkills {
    NSMutableString *skills = [[NSMutableString alloc] init];
    BOOL hasSkills = 0;
    BOOL isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 1:0;
    if([self dodgeSkill]) {
        [skills appendString:@"Dodge"];
        hasSkills = 1;
    }
    if([self sureHandsSkill]) {
        NSString *sh = (isiPad) ? @"Sure Hands":@"SH";
        hasSkills ? [skills appendFormat:@", %@", sh]:[skills appendFormat:@"%@", sh];
        hasSkills = 1;
    }
    if([self sureFeetSkill]) {
        NSString *sf = (isiPad) ? @"Sure Feet":@"SF";
        hasSkills ? [skills appendFormat:@", %@", sf]:[skills appendFormat:@"%@", sf];
        hasSkills = 1;
    }
    if([self passSkill]) {
        hasSkills ? [skills appendString:@", Pass"]:[skills appendString:@"Pass"];
        hasSkills = 1;
    }
    if([self catchSkill]) {
        hasSkills ? [skills appendString:@", Catch"]:[skills appendString:@"Catch"];
        hasSkills = 1;
    }
    if([self proSkill]) {
        hasSkills ? [skills appendString:@", Pro"]:[skills appendString:@"Pro"];
        hasSkills = 1;
    }
    if([self loner]) {
        hasSkills ? [skills appendString:@", Loner"]:[skills appendString:@"Loner"];
        hasSkills = 1;
    }
    if(!hasSkills) [skills appendString:@"No Re-roll Skills"];
        
    return skills;
}

- (NSMutableString *) showFullTableDesc {
    NSMutableString *fullDesc = [[NSMutableString alloc] init];
    [fullDesc appendString:[self name]];
    [fullDesc appendString:@" ("];
    [fullDesc appendString:[self showSkills]];
    [fullDesc appendString:@" )"];
    return fullDesc;
}

@end
