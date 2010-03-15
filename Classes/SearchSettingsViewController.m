//
//  SearchSettingsViewController.m
//  GeoEvents
//
//  Created by Martin Rødvand on 15/03/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import "SearchSettingsViewController.h"
#import "GeoEvents_finalAppDelegate.h"

@implementation SearchSettingsViewController
@synthesize searchRadius,
			eventsToBeFetched,
			viewToBeDisplayed,
			searchRadiusArray,
			noOfEventsArray;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if ((self = [super initWithStyle:style])) {
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Get our default values from the appdelegate
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	eventsToBeFetched = appDelegate.numberOfEventsToBeFetched;
	searchRadius = appDelegate.range;
	
	noOfEventsArray = [[NSMutableArray alloc]init];
	[noOfEventsArray addObject:[NSString stringWithString:@"10"]];
	[noOfEventsArray addObject:[NSString stringWithString:@"20"]];
	[noOfEventsArray addObject:[NSString stringWithString:@"30"]];
	[noOfEventsArray addObject:[NSString stringWithString:@"40"]];
	[noOfEventsArray addObject:[NSString stringWithString:@"50"]];
	
	searchRadiusArray = [[NSMutableArray alloc]init];
	[searchRadiusArray addObject:[NSString stringWithString:@"10"]];
	[searchRadiusArray addObject:[NSString stringWithString:@"20"]];
	[searchRadiusArray addObject:[NSString stringWithString:@"30"]];
	[searchRadiusArray addObject:[NSString stringWithString:@"40"]];
	[searchRadiusArray addObject:[NSString stringWithString:@"50"]];
	
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSettings)];
    self.navigationItem.rightBarButtonItem = doneBtn;
}


- (void)setViewToBeDisplayed:(NSString *)view {
	viewToBeDisplayed = view;
}

- (void) saveSettings {
	/*
	 Write the settings to file and send the user back one level.
	 */
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([viewToBeDisplayed isEqualToString:@"Radius"]) {
		return 1;
	} else if([viewToBeDisplayed isEqualToString:@"Events"]) {
		return 1;
	} else {
		return 1;
	}
 
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([viewToBeDisplayed isEqualToString:@"Radius"]) {
		return [searchRadiusArray count];
	} else if([viewToBeDisplayed isEqualToString:@"Events"]) {
		return [noOfEventsArray count];
	} else {
		return 1;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	
    if([viewToBeDisplayed isEqualToString:@"Radius"]) {
		NSString * textLabel = [NSString stringWithFormat:@"%@ km", [searchRadiusArray objectAtIndex:indexPath.row]];
		[cell.textLabel setText:textLabel];
	} else if([viewToBeDisplayed isEqualToString:@"Events"]) {
		NSString * textLabel = [NSString stringWithFormat:@"%@ events", [noOfEventsArray objectAtIndex:indexPath.row]];
		[cell.textLabel setText:textLabel];
	}
	
	cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    // Configure the cell...
    
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

