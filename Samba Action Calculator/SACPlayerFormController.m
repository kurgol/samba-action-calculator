//
//  SACFirstViewController.m
//  Samba Action Calculator
//
//  Created by David Dawnay on 7/19/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACPlayerFormController.h"
#import "SACAppDelegate.h"

@interface SACPlayerFormController ()

@end

@implementation SACPlayerFormController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)accionBotonFondo:(id)sender {
    //NSLog(@"Accion boton");
    
    // Reassign the first responder of any field
    for(int i=0; i<[[self.view subviews] count]; i++) {
        id elemento = [[self.view subviews] objectAtIndex:i];
        if([elemento respondsToSelector:@selector(resignFirstResponder)]) {
            [elemento resignFirstResponder];
        }
    }
    
}

- (IBAction)cancelPlayerSave:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)savePlayer:(id)sender {
    // Does the player have a name?
    UITextField *playerTextField = (UITextField *)[self.view viewWithTag:10];
    NSString *playerName = [playerTextField text];
    //NSLog(@"Player name is %@", playerName);
    if([playerName length] == 0) {
        // Name is a compulsory field
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You must specify a name for the player"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        // Create a player object and give it a name
        SACPlayer *newPlayer = [[SACPlayer alloc] init];
        newPlayer.name = playerName;
        
        // we need to collect the skills data for this user
        UISwitch *dodgeSwitch = (UISwitch *)[self.view viewWithTag:20];
        newPlayer.dodgeSkill = (dodgeSwitch.on) ? 1:0;
        UISwitch *sureHandsSwitch = (UISwitch *)[self.view viewWithTag:21];
        newPlayer.sureHandsSkill = (sureHandsSwitch.on) ? 1:0;
        UISwitch *passSwitch = (UISwitch *)[self.view viewWithTag:22];
        newPlayer.passSkill = (passSwitch.on) ? 1:0;
        UISwitch *sureFeetSwitch = (UISwitch *)[self.view viewWithTag:23];
        newPlayer.sureFeetSkill = (sureFeetSwitch.on) ? 1:0;
        UISwitch *catchSwitch = (UISwitch *)[self.view viewWithTag:24];
        newPlayer.catchSkill = (catchSwitch.on) ? 1:0;
        UISwitch *proSwitch = (UISwitch *)[self.view viewWithTag:25];
        newPlayer.proSkill = (proSwitch.on) ? 1:0;
        UISwitch *lonerSwitch = (UISwitch *)[self.view viewWithTag:26];
        newPlayer.loner = (lonerSwitch.on) ? 1:0;
        //NSLog(@"New player to add: %@", newPlayer);
        
        // save to the players array
        SACAppDelegate* appDelegate = [SACAppDelegate sharedAppDelegate];
        [appDelegate savePlayer:newPlayer];
        
        // Reset the form fields
        [playerTextField setText:@""];
        [dodgeSwitch setOn:0];
        [sureHandsSwitch setOn:0];
        [passSwitch setOn:0];
        [sureFeetSwitch setOn:0];
        [catchSwitch setOn:0];
        [proSwitch setOn:0];
        [lonerSwitch setOn:0];
        
        // Close the view
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
