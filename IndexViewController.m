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

@synthesize searchViewViewController, searchField, latitude, longitude, activity, locationFound;

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
	
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;	
	[locationController.locationManager startUpdatingLocation];
}

- (void)locationUpdate:(CLLocation *)location {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	latitude = [NSNumber numberWithDouble:[location coordinate].latitude];
	longitude = [NSNumber numberWithDouble:[location coordinate].longitude];
	
	appDelegate.lat = latitude;
	appDelegate.lon = longitude;
	
	locationFound = YES;
	[self.tableView reloadData];
	
	NSLog(@"Location: %f", [location coordinate].latitude);
	NSLog(@"Location: %f", [longitude doubleValue]);
}

- (void)locationError:(NSError *)error {
    //locationLabel.text = [error description];
}

- (void)search:(NSString *)searchText {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	NSMutableArray * theSearchHistory = appDelegate.searchHistory;
	[theSearchHistory addObject:searchText];
	[self loadSearchView:NO];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
}

- (void)searchByGps {
	[self loadSearchView:YES];
}

-(void)loadSearchView:(bool)isUsingGps {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.isUsingGps = isUsingGps;
	
	SearchViewViewController * searchView = [[SearchViewViewController alloc] initWithNibName:@"SearchView" bundle:[NSBundle mainBundle]];
	self.searchViewViewController = searchView;
	[self.navigationController pushViewController:searchViewViewController animated:YES];
	[searchView release];
	
	
}

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
			if(theSearchHistory != nil) {
				return [theSearchHistory count];
			}
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
				
				if(locationFound) {
					gpsSearchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					[gpsSearchCell.textLabel setText:@"Search using GPS"];
				} else {
					[gpsSearchCell.textLabel setText:@"Aquiring GPS data"];
				}
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
		[searchHistoryCell.textLabel setText:[theSearchHistory objectAtIndex:indexPath.row]];
		return searchHistoryCell;
	}
	
	return nil;
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
	if(indexPath.section == searchSection) {
		switch (indexPath.row) {
			case searchSectionSearchRow:
				[self search:@"String"];
				break;
			case searchSectionSearchByGpsRow:
				[self searchByGps];
				break;
			
		}
	}
}


- (void)dealloc {
    [super dealloc];
}


@end

