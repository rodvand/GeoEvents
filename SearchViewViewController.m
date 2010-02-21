//
//  SearchViewViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 Redwater Software. All rights reserved.
//

#import "SearchViewViewController.h"
#import "GeoEvents_finalAppDelegate.h"
#import "Event.h"
#import "TBXML.h"

@implementation SearchViewViewController
@synthesize detailedViewController, searchString, url, apiKey, latitude, longitude, events, sections;

- (void)viewDidLoad {
	/* 
	 Initial setup method
	 API key, urls, and longitude/latitude
	 */
    [super viewDidLoad];
	UIApplication * appForNetDelegate = [UIApplication sharedApplication];
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	locationBasedSearch = appDelegate.isUsingGps;
	searchString = appDelegate.searchString;
	
	//Initialise our sections array
	sections = [[NSMutableArray alloc] initWithCapacity:10];
	
	// Last.fm API key
	apiKey = @"3c1e7d9edb3eeb785596fc009d5a163b";
	
	// Create our last fm url
	
	latitude = appDelegate.lat;
	longitude = appDelegate.lon;
	
	url = [self createUrl:apiKey latitude:latitude longitude:longitude searchString:searchString];
	
	self.title = (latitude != nil && longitude != nil)? @"GPS search" : [searchString capitalizedString];
	
	//Add a map it button
	UIBarButtonItem * mapBtn = [[UIBarButtonItem alloc] initWithTitle:@"Map 'em!" style:UIBarButtonItemStylePlain target:self action:nil];
	[self.navigationItem setRightBarButtonItem:mapBtn];
	[mapBtn release];
	
	appForNetDelegate.networkActivityIndicatorVisible = YES;
	
	[self loadXml:url];
	
	appForNetDelegate.networkActivityIndicatorVisible = NO;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.searchString = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(error) {
		return 1;
	}
	
    return [events count];
}

// Customize the title of each section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Section";
	
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(error) {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		[cell.textLabel setText:@"No results"];
	} else {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		// Set up the cell...
		Event * event = [events objectAtIndex:indexPath.row];
		[cell.textLabel setText:event.artist];
		NSString * detailedText = [[NSString alloc] initWithFormat:@"%@, %@", event.venue, event.location];
		[cell.detailTextLabel setText:detailedText];
		[detailedText release];
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(!error) {
		//Navigation logic
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		appDelegate.selectedEvent = [events objectAtIndex:indexPath.row];
	
		DetailedViewViewController * dView = [[DetailedViewViewController alloc] initWithStyle:UITableViewStyleGrouped];
		self.detailedViewController = dView;
	
		[dView release];
		
		[self.navigationController pushViewController:detailedViewController animated:YES];
	}
}

# pragma mark General methods

- (void)loadXml:(NSString *)address {
	bool debug = NO;
	error = NO;
	events = [[NSMutableArray alloc] initWithCapacity:10];
	
	
	// We load our xml from the url provided
	TBXML * tbXML = [[TBXML alloc] initWithURL:[NSURL URLWithString:address]];
	TBXMLElement * rootXMLElement = tbXML.rootXMLElement;
	

	if(rootXMLElement) {
		TBXMLElement * event_top = [tbXML childElementNamed:@"events" parentElement:rootXMLElement];
		TBXMLElement * event = [tbXML childElementNamed:@"event" parentElement:event_top];
		
		while(event != nil) {
			//Create our event object
			Event * anEvent = [[Event alloc] init];
			
			//Add it to the array
			[events addObject:anEvent];
			
			TBXMLElement * artists = [tbXML childElementNamed:@"artists" parentElement:event];
			anEvent.artist = [tbXML textForElement:[tbXML childElementNamed:@"headliner" parentElement:artists]];
			
			anEvent.ident = [tbXML textForElement:[tbXML childElementNamed:@"id" parentElement:event]];
			anEvent.startDate = [tbXML textForElement:[tbXML childElementNamed:@"startDate" parentElement:event]];
			
			//NSLog(@"1: %@, 2: %@, 3: %@", chunks[0], chunks[1], chunks[2]);
			anEvent.eventUrl = [tbXML textForElement:[tbXML childElementNamed:@"url" parentElement:event]];
			anEvent.eventStatus = [tbXML textForElement:[tbXML childElementNamed:@"cancelled" parentElement:event]];
			anEvent.attendance = [tbXML textForElement:[tbXML childElementNamed:@"attendance" parentElement:event]];
			TBXMLElement * venues = [tbXML childElementNamed:@"venue" parentElement:event];
			
			anEvent.venue = [tbXML textForElement:[tbXML childElementNamed:@"name" parentElement:venues]];
			TBXMLElement * location = [tbXML childElementNamed:@"location" parentElement:venues];
			anEvent.location = [tbXML textForElement:[tbXML childElementNamed:@"city" parentElement:location]];
			TBXMLElement * geo = [tbXML childElementNamed:@"geo:point" parentElement:location];
			
			if(geo != nil) {
				anEvent.lat = [tbXML textForElement:[tbXML childElementNamed:@"geo:lat" parentElement:geo]];
				anEvent.lon = [tbXML textForElement:[tbXML childElementNamed:@"geo:long" parentElement:geo]];
			}
			
			if(debug) {
				NSLog(@"**********************************");
				NSLog(@"St: %@", [self createDate:anEvent.startDate]);
				NSLog(@"Event id:%@", anEvent.ident);
				NSLog(@"Start date: %@", anEvent.startDate);
				NSLog(@"Artist: %@", anEvent.artist);
				NSLog(@"Venue: %@", anEvent.venue);
				NSLog(@"URL: %@", anEvent.eventUrl);
				NSLog(@"City: %@", anEvent.location);
				if(geo != nil) {
					NSLog(@"Latitude: %@", anEvent.lat);
					NSLog(@"Longitude: %@", anEvent.lon);
				}
				
			}
			event = [tbXML nextSiblingNamed:@"event" searchFromElement:event];
		}
	} else {
		NSLog(@"Something went wrong with our parsing.");
		error = YES;
	}
	[events retain];
	[tbXML release];
}

- (NSString*) createDate:(NSString*)rawDate {
	/*
	 Takes in the raw date from last.fm's API 
	 and removes the time and return a readable 
	 and simple date.
	 Very basic atm.
	 */
	NSArray * chunks = [rawDate componentsSeparatedByString:@" "];
	NSString * formattedDate = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@", 
								[chunks objectAtIndex:0], [chunks objectAtIndex:1], [chunks objectAtIndex:2],[chunks objectAtIndex:3]];
	
	return formattedDate;
}

- (NSString*) createUrl:(NSString*)api latitude:(NSNumber*)lat longitude:(NSNumber*)lon searchString:(NSString*)searchQuery {
	/*
	 We create our URL here.
	 URL output depends on if it's location based or purely based on search string.
	 Require apiKey to work.
	 TODO: Implement range and pagenumber.
	 TODO: Clean String. Replace space and various other entitities with respective html entitities.
	 */
	
	//Our base URL
	NSMutableString * baseUrl = [[NSMutableString alloc] initWithString:@"http://ws.audioscrobbler.com/2.0/?method=geo.getevents"];
	
	
	if(lat == nil && lon == nil) {
		//The search is based on a string
		//We replace space with %20
		NSString * modifiedSearch = [searchQuery stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		[baseUrl appendFormat:@"&location=%@&api_key=%@", modifiedSearch, api];
	} else {
		[baseUrl appendFormat:@"&lat=%f&long=%f&api_key=%@", [lat doubleValue], [lon doubleValue], api];
	}
	return baseUrl;
}

- (void)dealloc {
    [super dealloc];
}


@end

