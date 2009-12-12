//
//  IndexViewController.m
//  GeoEvents
//
//  Created by Martin Roedvand on 12/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//

#import "IndexViewController.h"
#import "GeoEvents_finalAppDelegate.h"

@implementation IndexViewController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"GeoEvents";
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	NSMutableArray * theSearchHistory = appDelegate.searchHistory;
	
	switch(section) {
		case searchSection:
			return NUM_HEADER_SECTION_ROWS;
		case historySection:
			return [theSearchHistory count];
		default:
			return 1;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	if(indexPath.section == searchSection) {
		//TODO: Do the cell initialisation
		switch(indexPath.row) {
			// Our cell where we fill in text and search
			case searchSectionSearchRow:
				;
				UITableViewCell *sectionSearchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (sectionSearchCell == nil) {
					sectionSearchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				}
				sectionSearchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				[sectionSearchCell.textLabel setText:@"Search"];
				return sectionSearchCell; 
			// Our cell where we search using the GPS information
			case searchSectionSearchByGpsRow:
				;
				UITableViewCell *gpsSearchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (gpsSearchCell == nil) {
					gpsSearchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				}
				gpsSearchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				[gpsSearchCell.textLabel setText:@"Search using GPS"];
				return gpsSearchCell;
			default:
				NSAssert(NO, @"Unhandled value in searchSection cellForRowAtIndexPath");
		}
	}
	
	if(indexPath.section == historySection) {
		// Get appDelegate and the array where we keep our search history
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		NSMutableArray * theSearchHistory = appDelegate.searchHistory;
		
		UITableViewCell * searchHistoryCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (searchHistoryCell == nil) {
			searchHistoryCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		searchHistoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[searchHistoryCell.textLabel setText:[theSearchHistory objectAtIndex:indexPath]];
		return searchHistoryCell;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	NSMutableArray * theSearchHistory = appDelegate.searchHistory;
	
	switch(section) {
		case searchSection:
			return @"Search";
		case historySection:
			if(theSearchHistory != nil) {
				return @"Search history";
			}
		default:
			return nil;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


- (void)dealloc {
    [super dealloc];
}


@end

