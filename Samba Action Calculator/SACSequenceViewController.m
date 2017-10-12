//
//  SACSequenceViewController.m
//  Samba Action Calculator
//
//  Created by danton on 8/31/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACSequenceViewController.h"
#import "SACAppDelegate.h"

@interface SACSequenceViewController ()

@property SACAppDelegate* appDelegate;

@end

@implementation SACSequenceViewController

@synthesize activePlayer, currentPlayerIndex, actionSequence, scrollView, nameLabel, skillsLabel, noRRLabel, yesRRLabel, interceptSeg, usePro, useCatch, blockSeg, skillsView, probaView, phoneBottomContainer, isopen, phoneSlideOutView, phoneActionBtn, phoneSeg, activeButton, prevButton, changePlayerVC;

- (void)activatePlayer:(int)playerIndex {
    _appDelegate = [SACAppDelegate sharedAppDelegate];
    self.activePlayer = [_appDelegate.players objectAtIndex:playerIndex];
    currentPlayerIndex = playerIndex;
    //NSLog(@"Player selected is: %@", self.activePlayer);
    
    if(!self.actionSequence) {
        // no sequence created, so create one
        SACFullSequence *sequence = [[SACFullSequence alloc] init];
        self.actionSequence = sequence;
    }
}

- (void)changeActivePlayer:(int)playerIndex {
    // first we need to check if the player has changed at all
    if(playerIndex != currentPlayerIndex) {
        [self activatePlayer:playerIndex];
    
        // Now we change the player label info
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad specific config.
            self.nameLabel.text = [self.activePlayer showFullTableDesc];
        } else {
            self.nameLabel.text = self.activePlayer.name;
            self.skillsLabel.text = [self.activePlayer showSkills];
            CGRect labelFrame = CGRectMake(81.0, 85.0, 219.0, 31.0);
            [self.skillsLabel setFrame:labelFrame];
            [self.skillsLabel sizeToFit];
        }
    }
    [changePlayerVC dismissModalViewControllerAnimated:YES];
}

- (IBAction)addPlayerAction:(UIButton*)sender {
    NSInteger action_type;
    NSInteger min_roll;
    NSInteger intercept;
    BOOL pro;
    BOOL catch;
    // first we need to find out which button was pressed
    if(sender.tag < 10 || activeButton == 71) {
        // this is a dodge
        action_type = 1;
        if (activeButton == 71) {
            min_roll = self.phoneSeg.selectedSegmentIndex + 2;
        }
        else min_roll = sender.tag;
        //NSLog(@"Add new dodge action with min roll of %d", min_roll);
    }
    else if(sender.tag < 20 || activeButton == 72) {
        // this is a pick-up
        action_type = 2;
        if (activeButton == 72) {
            min_roll = self.phoneSeg.selectedSegmentIndex + 2;
        }
        else min_roll = sender.tag-10;
        //NSLog(@"Add new pick up action with min roll of %d", min_roll);
    }
    else if(sender.tag < 30 || activeButton == 73) {
        // this is a GFI
        action_type = 3;
        if (activeButton == 73) {
            min_roll = self.phoneSeg.selectedSegmentIndex + 2;
        }
        else min_roll = sender.tag-20;
        //NSLog(@"Add new GFI action with min roll of %d", min_roll);
    }
    else if(sender.tag < 40 || activeButton == 74) {
        // this is a Pass
        action_type = 4;
        if (activeButton == 74) {
            min_roll = self.phoneSeg.selectedSegmentIndex + 2;
        }
        else min_roll = sender.tag-30;
        switch (self.interceptSeg.selectedSegmentIndex) {
            case 0:
                intercept = 0;
            break;
            case 1:
                intercept = 2;
            break;
            case 2:
                intercept = 3;
            break;
            case 3:
                intercept = 4;
            break;
            case 4:
                intercept = 5;
            break;
            case 5:
                intercept = 6;
            break;
            default:
                intercept = 0;
            break;
        }
        pro = self.usePro.on;
        catch = self.useCatch.on;
        //NSLog(@"Add new Pass action with min roll of %d", min_roll);
    }
    else if(sender.tag < 50 || activeButton == 75) {
        // this is a Catch
        action_type = 5;
        if (activeButton == 75) {
            min_roll = self.phoneSeg.selectedSegmentIndex + 2;
        }
        else min_roll = sender.tag-40;
        //NSLog(@"Add new Catch action with min roll of %d", min_roll);
    }
    else if(sender.tag < 60 || activeButton == 77) {
        // this is a Generic action
        action_type = 7;
        if (activeButton == 77) {
            min_roll = self.phoneSeg.selectedSegmentIndex + 2;
        }
        else min_roll = sender.tag-50;
        //NSLog(@"Add new Generic action with min roll of %d", min_roll);
    }
    else {
        // this is a Block
        action_type = 6;
        NSInteger segIndex;
        if (activeButton == 76) {
            segIndex = self.phoneSeg.selectedSegmentIndex;
        }
        else segIndex = self.blockSeg.selectedSegmentIndex;
        switch (segIndex) {
            case 0:
                min_roll = 2;
            break;
            case 1:
                min_roll = 3;
            break;
            case 2:
                min_roll = 4;
            break;
            case 3:
                min_roll = 5;
            break;
            case 4:
                min_roll = 6;
            break;
            default:
                min_roll = 4;
            break;
        }

    }
    
    // create a new Action object
    SACAction *action;
    if(action_type == 4) {
        action = [[SACPassAction alloc] initWithValues:action_type
                                               minRoll:min_roll
                                             forPlayer:self.activePlayer
                                               atIndex:self.currentPlayerIndex
                                          canIntercept:intercept
                                                hasPro:pro
                                              hasCatch:catch];
        
    } else if(action_type == 6) {
        // Block action so we need to find out what Block dice are successful
        UISwitch *skullSwitch = (UISwitch *)[self.view viewWithTag:62];
        NSNumber *skullDie = [[NSNumber alloc] initWithBool:(skullSwitch.on) ? 1:0];
        UISwitch *powSkullSwitch = (UISwitch *)[self.view viewWithTag:63];
        NSNumber *powSkullDie = [[NSNumber alloc] initWithBool:(powSkullSwitch.on) ? 1:0];
        UISwitch *pushSwitch = (UISwitch *)[self.view viewWithTag:64];
        NSNumber *pushDie = [[NSNumber alloc] initWithBool:(pushSwitch.on) ? 1:0];
        UISwitch *dodgePowSwitch = (UISwitch *)[self.view viewWithTag:65];
        NSNumber *dodgePowDie = [[NSNumber alloc] initWithBool:(dodgePowSwitch.on) ? 1:0];
        UISwitch *powSwitch = (UISwitch *)[self.view viewWithTag:66];
        NSNumber *powDie = [[NSNumber alloc] initWithBool:(powSwitch.on) ? 1:0];
        NSArray *dice = [[NSArray alloc] initWithObjects: skullDie, powSkullDie, pushDie, dodgePowDie, powDie, nil];
        
        action = [[SACBlockAction alloc] initWithValues:action_type
                                                minRoll:min_roll
                                              forPlayer:self.activePlayer
                                                atIndex:self.currentPlayerIndex
                                             successArr:dice];
    }
    else {
        action = [[SACAction alloc] initWithValues:action_type
                                           minRoll:min_roll
                                         forPlayer:self.activePlayer
                                           atIndex:self.currentPlayerIndex];
    }
    
    // is this the first Action? If so then add the player info.
    NSInteger total_actions = [self.actionSequence.sequence count];
    if(!total_actions) {
        SACAction *newPlayer = [[SACAction alloc] initWithValues:0
                                                         minRoll:0
                                                       forPlayer:self.activePlayer
                                                         atIndex:self.currentPlayerIndex];
        newPlayer.isNewPlayer = YES;
        [self.actionSequence addAction:newPlayer];
        [self showAction:newPlayer atPosition:0];
    }
    else {
        // not the first one, but let's check to see if the previous action was done by the same player
        // this is to prevent a player being deleted from the sequence and then having new actions attributed to a previous player instead
        NSInteger last_action_index = [self.actionSequence.sequence count]-1;
        SACAction *lastAction = [self.actionSequence.sequence objectAtIndex:last_action_index];
        if(lastAction.playerIndex != currentPlayerIndex) {
            // add the current player as an Action
            SACAction *newPlayer = [[SACAction alloc] initWithValues:0
                                                             minRoll:0
                                                           forPlayer:self.activePlayer
                                                             atIndex:self.currentPlayerIndex];
            newPlayer.isNewPlayer = YES;
            [self.actionSequence addAction:newPlayer];
            [self showAction:newPlayer atPosition:last_action_index+1];
        }
    }
    
    [self.actionSequence addAction:action];
    // how many actions are there?
    NSInteger num_actions = [self.actionSequence.sequence count]-1;
    [self showAction:action atPosition:num_actions];
    [self showOdds];
}

- (void) showAction:(SACAction *) action atPosition:(int)pos {
    // show the action in the interface
    NSInteger row;
    NSInteger col;
    float y;
    float x;
    float btnWidth;
    float containerWidth;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad specific config.
        btnWidth = 90.0;
        containerWidth = 100.0;
        
        // calculate the y position of the subview
        row = (pos < 7) ? 0:roundf(pos/7);
        y = 3.0 + (row*47);
    
        // calculate the x position of the subview
        col = (pos < 7) ? pos:pos-(row*7);
        x = 5.0 + (col*103);
    } else {
        // iPhone and iPod Touch view config
        btnWidth = 86.0;
        containerWidth = 96.0;
        
        // calculate the y position of the subview
        row = (pos < 3) ? 0:roundf(pos/3);
        y = 3.0 + (row*47);
        
        // calculate the x position of the subview
        col = (pos < 3) ? pos:pos-(row*3);
        x = 3.0 + (col*99);
    }
    // if there are more than 2 rows then we need to adjust the height of the container
    if(row > 1 && col == 0) {
        [self adjustViewHeight:row];
    }
    
    // configure the Action button
    CGRect btnFrame = CGRectMake(5.0, 5.0, btnWidth, 34.0);
    UIButton *myBtn = [[UIButton alloc] initWithFrame:btnFrame];
    if(action.action_type == 4) {
        // Pass action needs a smaller font size if can be intercepted
        SACPassAction *pass = (SACPassAction *)action;
        if(pass.interception > 0) {
            myBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    
    UIColor *myColor;
    
    if(action.isNewPlayer) {
        // new player so show player name and different colour
        myBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [myBtn setTitle:action.playerName forState:UIControlStateNormal];
        myColor = [UIColor colorWithRed:((float) 66 / 255.0f)
                                  green:((float) 105 / 255.0f)
                                   blue:((float) 255 / 255.0f)
                                  alpha:1.0f];
    }
    else {
        // normal action
        [myBtn setTitle:[action interfaceText] forState:UIControlStateNormal];
        myColor = [UIColor colorWithRed:((float) 66 / 255.0f)
                                  green:((float) 209 / 255.0f)
                                   blue:((float) 255 / 255.0f)
                                  alpha:1.0f];
    }
    
    [myBtn setBackgroundColor:myColor];
    NSInteger tag = pos+1;
    [myBtn setTag:tag];
    
    UIGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(removePlayerAction:)];
    
    [myBtn addGestureRecognizer:longPress];
    longPress.delegate = self;
    
    [myBtn addTarget:self
              action:@selector(togglePro:)
    forControlEvents:UIControlEventTouchUpInside];

    // configure the button container
    CGRect myFrame = CGRectMake(x, y, containerWidth, 44.0);
    UIView *myView = [[UIView alloc] initWithFrame:myFrame];
    [myView setBackgroundColor:myColor];
    [myView addSubview:myBtn];
    
    [skillsView addSubview:myView];
}

- (IBAction)removePlayerAction:(UITapGestureRecognizer*)recognizer {
    if(UIGestureRecognizerStateBegan == recognizer.state) {
        NSInteger aIndex = recognizer.view.tag-1;
        [self removePlayer:aIndex];
    }
}

- (void)removePlayer:(int)actionIndex {
    //NSInteger actionIndex = sender.tag-1;
    NSInteger rows;
    //NSLog(@"Remove action at index %d", actionIndex);
    
    SACAction *removedAction = [self.actionSequence.sequence objectAtIndex:actionIndex];
    if(removedAction.isNewPlayer) {
        // this is a new player, so we need to remove all of the subsequent associated Actions
        NSInteger nextIndex = actionIndex+1;
        NSInteger pIndex = removedAction.playerIndex;
        
        while(nextIndex < [self.actionSequence.sequence count]) {
            SACAction *deletedAction = [self.actionSequence.sequence objectAtIndex:nextIndex];
            NSInteger p2Index = deletedAction.playerIndex;
            if(pIndex == p2Index) {
                //delete as this belongs to the same player
                [self.actionSequence removeAction:nextIndex];
                deletedAction = nil;
            }
            else {
                //not the same player, so stop here
                deletedAction = nil;
                break;
            }
        }
    }
    
    [self.actionSequence removeAction:actionIndex];
    removedAction = nil;
    NSInteger num_actions = [self.actionSequence.sequence count];
    
    // remove all of the action views
    for(UIView *subview in [skillsView subviews]) {
        [subview removeFromSuperview];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad specific config.
        rows = (num_actions < 8) ? 0:roundf(num_actions/8);
    } else {
        // iPhone and iPod Touch view config
        rows = (num_actions < 4) ? 0:roundf(num_actions/4);
    }
    [self adjustViewHeight:rows];
    
    // add the action views back again
    for(NSInteger i = 0; i < num_actions; i++) {
        SACAction *action = [self.actionSequence.sequence objectAtIndex:i];
        [self showAction:action atPosition:i];
    }
    
    [self showOdds];
}

- (IBAction)togglePro:(UIButton*)sender {
    // switches Pro on or Off for an Action
    NSInteger actionIndex = sender.tag-1;
    SACAction *selAction = [self.actionSequence.sequence objectAtIndex:actionIndex];
    if(selAction.hasPro && !selAction.isNewPlayer) {
        // Pro is available for this Action
        UIColor *myColor;
        if(selAction.usePro) {
            // Use Pro is on, so switch it off
            selAction.usePro = NO;
           myColor = [UIColor colorWithRed:((float) 66 / 255.0f)
                                     green:((float) 209 / 255.0f)
                                      blue:((float) 255 / 255.0f)
                                     alpha:1.0f];
        }
        else {
            // switch Pro on
            selAction.usePro = YES;
            myColor = [UIColor colorWithRed:((float) 0 / 255.0f)
                                      green:((float) 255 / 255.0f)
                                       blue:((float) 130 / 255.0f)
                                      alpha:1.0f];
        }
        [sender setBackgroundColor:myColor];
        [self showOdds];
    }
}

- (IBAction)removeAllActions:(id)sender {
    // remove all of the Actions from the array
    [self.actionSequence clearActions];
    
    //Clean up the View
    for(UIView *subview in [skillsView subviews]) {
        [subview removeFromSuperview];
    }
    
    // reset the skills view container and the view below if necessary
    CGRect frame = [skillsView frame];
    NSInteger curr_height = frame.size.height;
    if(curr_height > 97) {
        [self adjustViewHeight:0];
    }
    
    [self showOdds];
}

- (void)showOdds {
    // get Sequence Odds
    float probaNorr = roundf([self.actionSequence getProbaReroll:NO] * 100000)/1000;
    float probYesrr = roundf([self.actionSequence getProbaReroll:YES] * 100000)/1000;
    
    // show the Odds in the interface
    self.noRRLabel.text = [NSString stringWithFormat:@"%.3f%%", probaNorr];
    self.yesRRLabel.text = [NSString stringWithFormat:@"%.3f%%", probYesrr];
}

- (void) adjustViewHeight:(int)actionRows {
    // adjust the view port height
    CGRect frame = [skillsView frame];
    CGRect probaFrame = [probaView frame];
    NSInteger extra_height;
    //NSLog(@"Adjust view for %d rows", actionRows);
    
    if(actionRows > 1) {
        // calculate the View settings
        NSInteger extra_rows = actionRows-1;
        extra_height = (50*extra_rows);
    } else {
        // set the View to the default size and position
        extra_height = 0;
    }
    
    frame.size.height = 97 + extra_height;
    [skillsView setFrame:frame];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad specific config.
        probaFrame.origin.y = 1020 + extra_height;
        [probaView setFrame:probaFrame];
        
        NSInteger scroll_height = 1500 + extra_height;
        self.scrollView.contentSize = CGSizeMake(768, scroll_height);
    }
    else {
        // iPhone and iPod Touch config.
        CGRect phoneBottomFrame = [phoneBottomContainer frame];
        phoneBottomFrame.size.height = 400 + extra_height;
        [phoneBottomContainer setFrame:phoneBottomFrame];
        
        probaFrame.origin.y = 150 + extra_height;
        [probaView setFrame:probaFrame];
        
        NSInteger panelHeight = 0;
        if(isopen) {
            // Action Panel is Open, so we need to factor in the extra height
            switch (activeButton) {
                case 74:
                    // Pass Action
                    panelHeight = 170;
                break;
                case 76:
                    //Block Action
                    panelHeight = 270;
                break;
                default:
                    // Rest of the Actions
                    panelHeight = 70;
                break;
            }
        }
        NSInteger scroll_height = 1000 + extra_height + panelHeight;
        self.scrollView.contentSize = CGSizeMake(320, scroll_height);
    }

}

- (IBAction)slidePhoneInterface:(UIButton*)sender {
    // check if the iPhone Action panel is open
    if(isopen) {
       // the panel is open, so we toggle it closed
        prevButton = activeButton;
        activeButton = sender.tag;
        [self closePanel];
    }
    
    // panel is closed so we open it
    else {
        isopen = YES;
        prevButton = activeButton;
        activeButton = sender.tag;
        [self openPanel];
    }
    
}

- (void)closePanel {
    if(phoneSlideOutView!=nil) {
        [UIView beginAnimations:@"quitar" context:nil];
        [UIView setAnimationDuration:0.3];
        [phoneSlideOutView setAlpha:0.0];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"quitar2" context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(removePhoneSlideOut)];
        CGRect newFrame = phoneBottomContainer.frame;
        newFrame.origin.y = 280.0;
        [phoneBottomContainer setFrame:newFrame];
        [UIView commitAnimations];
    }
}

- (void)openPanel {
    // animate the bottom container to move down
    [UIView beginAnimations:@"agrega" context:nil];
    [UIView setAnimationDuration:0.5];
    CGRect newFrame = phoneBottomContainer.frame;
    if(activeButton == 74) {
        // Pass Action require more space
        newFrame.origin.y = 450.0;
    }
    else if(activeButton == 76) {
        // Block Action requires even more space
        newFrame.origin.y = 550.0;
    }
    else newFrame.origin.y = 350.0;
    [phoneBottomContainer setFrame:newFrame];
    [UIView commitAnimations];
    
    // create slide out container
    CGRect area;
    if(activeButton == 74) {
        // Pass Action require a bigger panel
        area = CGRectMake(10.0, 280.0, 300.0, 164.0);
    }
    else if(activeButton == 76) {
        // Block Action requires an even bigger panel
        area = CGRectMake(10.0, 280.0, 300.0, 264.0);
    }
    else area = CGRectMake(10.0, 280.0, 300.0, 64.0);
    phoneSlideOutView = [[UIView alloc] initWithFrame:area];
    [phoneSlideOutView setBackgroundColor:[UIColor lightGrayColor]];
    [phoneSlideOutView setAlpha:0.0];
    [scrollView addSubview:phoneSlideOutView];
    
    // Create the new Action button
    phoneActionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    phoneActionBtn.frame = CGRectMake(10.0, 10.0, 70.0, 44.0);
    [phoneActionBtn addTarget:self
               action:@selector(addPlayerAction:)
     forControlEvents:UIControlEventTouchUpInside];
    phoneActionBtn.tag = 70;
    [phoneSlideOutView addSubview:phoneActionBtn];
    
    // Array for the options segment
    NSArray *itemsArr;
    
    // depending on the type of Action create corresponding interface
    switch (activeButton) {
        case 71:
            // Dodge Action
            [phoneActionBtn setTitle:@"Dodge" forState:UIControlStateNormal];
            itemsArr = [[NSArray alloc] initWithObjects:@"2+", @"3+", @"4+", @"5+", @"6", nil];
        break;
        case 72:
            // Pick-up Action
            [phoneActionBtn setTitle:@"Pick-up" forState:UIControlStateNormal];
            itemsArr = [[NSArray alloc] initWithObjects:@"2+", @"3+", @"4+", @"5+", @"6", nil];
        break;
        case 73:
            // Go For It Action
            [phoneActionBtn setTitle:@"GFI" forState:UIControlStateNormal];
            itemsArr = [[NSArray alloc] initWithObjects:@"2+", @"3+ (blizz.)", nil];
        break;
        case 74:
            // Pass Action
            [phoneActionBtn setTitle:@"Pass" forState:UIControlStateNormal];
            itemsArr = [[NSArray alloc] initWithObjects:@"2+", @"3+", @"4+", @"5+", @"6", nil];
        break;
        case 75:
            // Catch Action
            [phoneActionBtn setTitle:@"Catch" forState:UIControlStateNormal];
            itemsArr = [[NSArray alloc] initWithObjects:@"2+", @"3+", @"4+", @"5+", @"6", nil];
        break;
        case 76:
            // Block Action
            [phoneActionBtn setTitle:@"Block" forState:UIControlStateNormal];
            itemsArr = [[NSArray alloc] initWithObjects:@"-3D", @"-2D", @"1D", @"2D", @"3D", nil];
        break;
        default:
            // Other Action
            [phoneActionBtn setTitle:@"Action" forState:UIControlStateNormal];
            itemsArr = [[NSArray alloc] initWithObjects:@"2+", @"3+", @"4+", @"5+", @"6", nil];
        break;
    }
    
    // create the appropriate Segment Control
    phoneSeg = [[UISegmentedControl alloc] initWithItems:itemsArr];
    phoneSeg.frame = CGRectMake(90.0, 10.0, 200.0, 44.0);
    if(activeButton == 76) phoneSeg.selectedSegmentIndex = 2;
    else phoneSeg.selectedSegmentIndex = 0;
    [phoneSlideOutView addSubview:phoneSeg];
    
    // Create extra interface elements for Pass and Block Actions
    if(activeButton == 74) {
        // Pass
        CGRect titleFrame = CGRectMake(10.0, 60.0, 80.0, 44.0);
        UILabel *interceptTitle = [[UILabel alloc] initWithFrame:titleFrame];
        [interceptTitle setText:@"Intercept:"];
        [interceptTitle setBackgroundColor:[UIColor lightGrayColor]];
        [phoneSlideOutView addSubview:interceptTitle];
        
        NSArray *intArr = [[NSArray alloc] initWithObjects:@"No", @"2+", @"3+", @"4+", @"5+", @"6", nil];
        interceptSeg = [[UISegmentedControl alloc] initWithItems:intArr];
        interceptSeg.frame = CGRectMake(90.0, 60.0, 200.0, 44.0);
        interceptSeg.selectedSegmentIndex = 0;
        [phoneSlideOutView addSubview:interceptSeg];
        
        CGRect proFrame = CGRectMake(10.0, 110.0, 40.0, 44.0);
        UILabel *proTitle = [[UILabel alloc] initWithFrame:proFrame];
        [proTitle setText:@"Pro:"];
        [proTitle setBackgroundColor:[UIColor lightGrayColor]];
        [phoneSlideOutView addSubview:proTitle];
        
        CGRect proSwitchFrame = CGRectMake(55.0, 120.0, 70.0, 44.0);
        usePro = [[UISwitch alloc] initWithFrame:proSwitchFrame];
        [phoneSlideOutView addSubview:usePro];
        
        CGRect catchFrame = CGRectMake(150.0, 110.0, 55.0, 44.0);
        UILabel *catchTitle = [[UILabel alloc] initWithFrame:catchFrame];
        [catchTitle setText:@"Catch:"];
        [catchTitle setBackgroundColor:[UIColor lightGrayColor]];
        [phoneSlideOutView addSubview:catchTitle];
        
        CGRect catchSwitchFrame = CGRectMake(210.0, 120.0, 70.0, 44.0);
        useCatch = [[UISwitch alloc] initWithFrame:catchSwitchFrame];
        [phoneSlideOutView addSubview:useCatch];
    }
    else if(activeButton == 76) {
        // Block
        UIImageView* skullImage = [self myLoadImage:@"skull.png" at:CGPointMake(10,60)];
        [phoneSlideOutView addSubview:skullImage];
        CGRect skullSwitchFrame = CGRectMake(5, 135.0, 70.0, 44.0);
        UISwitch *skullSwitch = [[UISwitch alloc] initWithFrame:skullSwitchFrame];
        skullSwitch.tag = 62;
        [phoneSlideOutView addSubview:skullSwitch];
        
        UIImageView* powSkullImage = [self myLoadImage:@"powskull.png" at:CGPointMake(115,60)];
        [phoneSlideOutView addSubview:powSkullImage];
        CGRect powSkullSwitchFrame = CGRectMake(110, 135.0, 70.0, 44.0);
        UISwitch *powSkullSwitch = [[UISwitch alloc] initWithFrame:powSkullSwitchFrame];
        powSkullSwitch.tag = 63;
        [phoneSlideOutView addSubview:powSkullSwitch];
        
        UIImageView* pushImage = [self myLoadImage:@"push.png" at:CGPointMake(220,60)];
        [phoneSlideOutView addSubview:pushImage];
        CGRect pushSwitchFrame = CGRectMake(215, 135.0, 70.0, 44.0);
        UISwitch *pushSwitch = [[UISwitch alloc] initWithFrame:pushSwitchFrame];
        pushSwitch.tag = 64;
        [phoneSlideOutView addSubview:pushSwitch];
        
        UIImageView* stumblesImage = [self myLoadImage:@"stumbles.png" at:CGPointMake(2,180)];
        [phoneSlideOutView addSubview:stumblesImage];
        CGRect stumblesSwitchFrame = CGRectMake(70, 200.0, 70.0, 44.0);
        UISwitch *stumblesSwitch = [[UISwitch alloc] initWithFrame:stumblesSwitchFrame];
        stumblesSwitch.tag = 65;
        stumblesSwitch.on = YES;
        [phoneSlideOutView addSubview:stumblesSwitch];
        
        UIImageView* powImage = [self myLoadImage:@"pow.png" at:CGPointMake(152,180)];
        [phoneSlideOutView addSubview:powImage];
        CGRect powSwitchFrame = CGRectMake(220, 200.0, 70.0, 44.0);
        UISwitch *powSwitch = [[UISwitch alloc] initWithFrame:powSwitchFrame];
        powSwitch.tag = 66;
        powSwitch.on = YES;
        [phoneSlideOutView addSubview:powSwitch];
    }
    
    // animate the new interface into view
    [UIView beginAnimations:@"agrega2" context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(adjustPhoneHeight)];
    [phoneSlideOutView setAlpha:1.0];
    [UIView commitAnimations];

}

- (void)removePhoneSlideOut {
    [phoneSlideOutView removeFromSuperview];
    phoneSlideOutView = nil;
    if(prevButton != activeButton) {
        // a different button was pressed, so we open the panel again
        [self openPanel];
    }
    else {
        // Panel stays closed
        isopen = NO;
        NSInteger num_actions = [self.actionSequence.sequence count];
        NSInteger rows = (num_actions < 4) ? 0:roundf(num_actions/3);
        [self adjustViewHeight:rows];
    }
}

- (void)adjustPhoneHeight {
    NSInteger num_actions = [self.actionSequence.sequence count];
    NSInteger rows = (num_actions < 4) ? 0:roundf(num_actions/3);
    [self adjustViewHeight:rows];
}

-(UIImageView*)myLoadImage:(NSString*)named at:(CGPoint)location
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:named]];
    CGRect frame = imgView.frame;
    frame.origin.x = location.x;
    frame.origin.y = location.y;
    [imgView setFrame:frame];
    return imgView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SACPlayerChangeViewController class]]) {
        [segue.destinationViewController setDelegate:self];
        changePlayerVC = segue.destinationViewController;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	/* for(SACPlayer *player in _appDelegate.players) {
        NSLog(@"%@", [player name]);
    } */
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // iPad specific config.
        self.scrollView.contentSize = CGSizeMake(768, 1500);
        self.nameLabel.text = [self.activePlayer showFullTableDesc];
    } else {
        self.scrollView.contentSize = CGSizeMake(320, 1000);
        self.nameLabel.text = self.activePlayer.name;
        self.skillsLabel.text = [self.activePlayer showSkills];
        [self.skillsLabel sizeToFit];
    }
    isopen = NO;
    activeButton = 0;
    prevButton = 0;
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
