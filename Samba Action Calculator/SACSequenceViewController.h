//
//  SACSequenceViewController.h
//  Samba Action Calculator
//
//  Created by danton on 8/31/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SACPlayer.h"
#import "SACFullSequence.h"
#import "SACPlayerChangeViewController.h"

@interface SACSequenceViewController : UIViewController <sendNewActivePlayer, UIGestureRecognizerDelegate>

// Data Objects
@property (nonatomic, weak) SACPlayer *activePlayer;
@property NSInteger currentPlayerIndex;
@property (nonatomic, strong) SACFullSequence *actionSequence;

// Views
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *skillsView;
@property (nonatomic, strong) IBOutlet UIView *probaView;
@property (nonatomic, strong) IBOutlet UIView *phoneBottomContainer;
@property (nonatomic, strong) UIView *phoneSlideOutView;

// Labels
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *skillsLabel;
@property (nonatomic, strong) IBOutlet UILabel *noRRLabel;
@property (nonatomic, strong) IBOutlet UILabel *yesRRLabel;

// Interface elements
@property (nonatomic, strong) IBOutlet UISegmentedControl *interceptSeg;
@property (nonatomic, strong) IBOutlet UISwitch *usePro;
@property (nonatomic, strong) IBOutlet UISwitch *useCatch;
@property (nonatomic, strong) IBOutlet UISegmentedControl *blockSeg;
@property (nonatomic, strong) UIButton *phoneActionBtn;
@property (nonatomic, strong) UISegmentedControl *phoneSeg;

// Misc properties
@property BOOL isopen;
@property NSInteger activeButton;
@property NSInteger prevButton;
@property (nonatomic, strong) UIViewController *changePlayerVC;

- (void)activatePlayer:(NSInteger)playerIndex;

- (IBAction)addPlayerAction:(UIButton*)sender;

- (void)showAction:(SACAction *)action atPosition:(NSInteger)pos;

- (IBAction)removePlayerAction:(UITapGestureRecognizer*)recognizer;

- (void)removePlayer:(NSInteger)actionIndex;

- (IBAction)togglePro:(UIButton*)sender;

- (IBAction)removeAllActions:(id)sender;

- (void)showOdds;

- (void)adjustViewHeight:(NSInteger)actionRows;

- (IBAction)slidePhoneInterface:(UIButton*)sender;

- (void)closePanel;

- (void)openPanel;

- (void)removePhoneSlideOut;

- (void)adjustPhoneHeight;

- (UIImageView*)myLoadImage:(NSString*)named at:(CGPoint)location;

@end
