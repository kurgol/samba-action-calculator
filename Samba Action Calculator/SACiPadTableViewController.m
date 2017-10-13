//
//  SACiPadTableViewController.m
//  Samba Action Calculator
//
//  Created by danton on 9/3/12.
//  Copyright (c) 2012 Freelancer. All rights reserved.
//

#import "SACiPadTableViewController.h"
#import "SACAppDelegate.h"
#import "SACSequenceViewController.h"


@interface SACiPadTableViewController ()

@property SACAppDelegate* appDelegate;

@end

@implementation SACiPadTableViewController

@synthesize playerTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     _appDelegate = [SACAppDelegate sharedAppDelegate];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"Number of players is %d", [_appDelegate.players count]);
    return [_appDelegate.players count]+1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 1) {
        // dequeue and configure my static cell for indexPath.row
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addPlayerCell"];
        return cell;
    } else {
        // normal dynamic logic here
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        NSInteger arrIndex = indexPath.row - 1;
        [cell.textLabel setText:[[_appDelegate.players objectAtIndex:arrIndex] showFullTableDesc]];
        return cell;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
    /* for(SACPlayer *player in _appDelegate.players) {
     NSLog(@"%@", [player name]);
     } */
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // first row should not be editable
    if(indexPath.row == 0) return NO;
    else return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSInteger arrIndex = indexPath.row - 1;
        [_appDelegate deletePlayer:arrIndex];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[SACSequenceViewController class]]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSInteger arrIndex = path.row - 1;
        //NSLog(@"player index: %d", arrIndex);
        [segue.destinationViewController activatePlayer:arrIndex];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
