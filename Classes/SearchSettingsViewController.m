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
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = ([viewToBeDisplayed isEqualToString:@"Radius"]) ? @"Search radius" : @"Number of events" ;
	
	//Get our default values from the appdelegate
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	eventsToBeFetched = appDelegate.numberOfEventsToBeFetched;
	searchRadius = appDelegate.range;
	
	noOfEventsArray = [[NSMutableArray alloc]init];
	[noOfEventsArray addObject:[NSNumber numberWithInt:10]];
	[noOfEventsArray addObject:[NSNumber numberWithInt:20]];
	[noOfEventsArray addObject:[NSNumber numberWithInt:30]];
	[noOfEventsArray addObject:[NSNumber numberWithInt:40]];
	[noOfEventsArray addObject:[NSNumber numberWithInt:50]];
	
	searchRadiusArray = [[NSMutableArray alloc]init];
	[searchRadiusArray addObject:[NSNumber numberWithInt:0]];
	[searchRadiusArray addObject:[NSNumber numberWithInt:10]];
	[searchRadiusArray addObject:[NSNumber numberWithInt:20]];
	[searchRadiusArray addObject:[NSNumber numberWithInt:30]];
	[searchRadiusArray addObject:[NSNumber numberWithInt:40]];
	[searchRadiusArray addObject:[NSNumber numberWithInt:50]];
	
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	//UIBarButtonItem * doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSettings)];
    //self.navigationItem.rightBarButtonItem = doneBtn;
}


- (void)setViewToBeDisplayed:(NSString *)view {
	viewToBeDisplayed = view;
}

- (void) saveSettings {
	/*
	 Write the settings to file and send the user back one level.
	 */
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.numberOfEventsToBeFetched = eventsToBeFetched;
	appDelegate.range = searchRadius;
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
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    if([viewToBeDisplayed isEqualToString:@"Radius"]) {
		NSNumber * number = [searchRadiusArray objectAtIndex:indexPath.row];
		
		if(indexPath.row == 0) {
			[cell.textLabel setText:@"Not defined"];
		} else {
			
			NSString * textLabel = [NSString stringWithFormat:@"%@ kilometre", number];
			[cell.textLabel setText:textLabel];
			
		}
		
		if([searchRadius isEqualToNumber:number]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
		
	} else if([viewToBeDisplayed isEqualToString:@"Events"]) {
		NSNumber * number = [noOfEventsArray objectAtIndex:indexPath.row];
		NSString * textLabel = [NSString stringWithFormat:@"%@ events", number];
		[cell.textLabel setText:textLabel];
		
		if([eventsToBeFetched isEqualToNumber:number]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	
	cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    // Configure the cell...
    
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
    if([viewToBeDisplayed isEqualToString:@"Radius"]) {
		searchRadius = [searchRadiusArray objectAtIndex:indexPath.row];
		UITableViewCell * searchCell = [self.tableView cellForRowAtIndexPath:indexPath];
		searchCell.accessoryType = UITableViewCellAccessoryCheckmark;
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
		appDelegate.range = searchRadius;
	} else if([viewToBeDisplayed isEqualToString:@"Events"]) {
		eventsToBeFetched = [noOfEventsArray objectAtIndex:indexPath.row];
		UITableViewCell * eventCell = [self.tableView cellForRowAtIndexPath:indexPath];
		eventCell.accessoryType = UITableViewCellAccessoryCheckmark;
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
		appDelegate.numberOfEventsToBeFetched = eventsToBeFetched;
	}
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

