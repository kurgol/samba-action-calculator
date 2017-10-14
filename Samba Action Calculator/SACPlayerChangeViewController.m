//
//  SACPlayerChangeViewController.m
//  Samba Action Calculator
//
//  Created by danton on 10/24/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACPlayerChangeViewController.h"
#import "SACAppDelegate.h"

@interface SACPlayerChangeViewController ()

@property SACAppDelegate* appDelegate;

@end

@implementation SACPlayerChangeViewController

@synthesize playerPicker, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_appDelegate.players count];
}



-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    
    if(pickerView==playerPicker && component==0) {
        SACPlayer *player = [_appDelegate.players objectAtIndex:row];
        return player.name;
    }
    return @"";
}


- (IBAction)cancelPlayerChange:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)changePlayer:(id)sender {
    [[self delegate] changeActivePlayer:[playerPicker selectedRowInComponent:0]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _appDelegate = [SACAppDelegate sharedAppDelegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
