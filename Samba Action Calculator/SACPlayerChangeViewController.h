//
//  SACPlayerChangeViewController.h
//  Samba Action Calculator
//
//  Created by danton on 10/24/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACPlayer.h"

@protocol sendNewActivePlayer <NSObject>
@required

- (void)changeActivePlayer:(int)playerIndex;

@end

@interface SACPlayerChangeViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIPickerView *playerPicker;
@property (nonatomic, strong) id <sendNewActivePlayer> delegate;

- (IBAction)cancelPlayerChange:(id)sender;

- (IBAction)changePlayer:(id)sender;

@end
