//
//  IndexViewController.m
//  GeoEvents
//
//  Created by Martin Roedvand on 12/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//

#import "IndexViewController.h"
#import "GeoEvents_finalAppDelegate.h"
#import "EditableDetailCell.h"

@implementation IndexViewController

@synthesize searchViewViewController, searchField, latitude, longitude, locationFound, run;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"GeoEvents";
	run = 0;
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;	
	[locationController.locationManager startUpdatingLocation];
}

- (void)dealloc {
    [super dealloc];
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

- (void)search:(NSString *)searchText addToSearchHistory:(bool)addToSearch {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	NSMutableArray * theSearchHistory = appDelegate.searchHistory;
	if(addToSearch) {
		[theSearchHistory addObject:searchText];
	}
	appDelegate.searchString = searchText;
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
	
	SearchViewViewController * searchView = [[SearchViewViewController alloc] initWithStyle:UITableViewStylePlain];
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
				if([theSearchHistory count] > 3) {
					return 3;
				} else {
					return [theSearchHistory count];
				}
			}
		default:
			return 1;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	if(indexPath.section == searchSection) {
		switch(indexPath.row) {
			// Our cell where we fill in text and search
			case searchSectionSearchRow:
				;
				/*UITableViewCell *sectionSearchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (sectionSearchCell == nil) {
					sectionSearchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				}
				sectionSearchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				[sectionSearchCell.textLabel setText:@"Search"];
				 */
				EditableDetailCell *sectionSearchCell = [[[EditableDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				//sectionSearchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				searchField = [sectionSearchCell textField];
				[searchField setClearButtonMode:UITextFieldViewModeNever];
				[searchField setReturnKeyType:UIReturnKeySearch];
				[searchField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[searchField setPlaceholder:@"City, country"];
				searchField.delegate = self;
				return sectionSearchCell; 
				
			// Our cell where we search using the GPS information
			case searchSectionSearchByGpsRow:
				;
				UITableViewCell *gpsSearchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				/*
				CGRect topBounds = [[UIScreen mainScreen] bounds];
				CGRect sectionBounds = [self.tableView rectForSection:searchSection];
				CGRect mainBounds = [self.tableView rectForRowAtIndexPath:indexPath];
				
				CGRect indicatorBounds = CGRectMake((mainBounds.size.width / 8) * 7 - 12, 100, 24, 24);
				UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithFrame:indicatorBounds];
				indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
				indicator.hidesWhenStopped = YES;
				*/
				if (gpsSearchCell == nil) {
					gpsSearchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				}
				
				if(locationFound) {
					/*
					[indicator stopAnimating];
					[indicator removeFromSuperview];
					[indicator setNeedsDisplay];
					indicator.hidden = YES;
					[self.view sendSubviewToBack:indicator];
					 */
					gpsSearchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					[gpsSearchCell.textLabel setText:@"Search using GPS"];
				} else {
					/*
					NSLog(@"mainBounds width: %f", mainBounds.size.width);
					NSLog(@"mainBounds height: %f", mainBounds.size.height);
					NSLog(@"mainBounds height calculated: %f", mainBounds.size.height / 2 - 12);
					NSLog(@"mainBounds width calculated: %f", mainBounds.size.width / 3);
					NSLog(@"topBounds height: %f", topBounds.size.height);
					NSLog(@"sectionBounds height: %f", sectionBounds.size.height);
					NSLog(@"Top - section - row: %f", topBounds.size.height - sectionBounds.size.height - mainBounds.size.height);
					
					[indicator startAnimating];
					[self.view addSubview:indicator];
					 */
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
		[searchHistoryCell.textLabel setText:[theSearchHistory objectAtIndex:[theSearchHistory count] - indexPath.row - 1]];
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
			if([theSearchHistory count] > 0) {
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
				[self search:@"London" addToSearchHistory:YES];
				NSLog(@"Search string: %@", [searchField text]);
				break;
			case searchSectionSearchByGpsRow:
				if(locationFound) {
					[self searchByGps];
				}
				break;
		}
	}
	
	if(indexPath.section == historySection) {
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		NSMutableArray * theSearchHistory = appDelegate.searchHistory;
		
		[self search:[theSearchHistory objectAtIndex:indexPath.row] addToSearchHistory:NO];
				
	}
}

#pragma mark UITextField

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[self search:[textField text] addToSearchHistory:YES];
	return NO;
}

@end

