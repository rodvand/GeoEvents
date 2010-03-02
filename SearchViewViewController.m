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
#import "MapViewController.h"

@implementation SearchViewViewController
@synthesize detailedViewController,
			mapViewController,
			searchString,
			url,
			apiKey,
			latitude,
			longitude,
			events,
			sections,
			aDates;

- (void)viewDidLoad {
	/* 
	 Initial setup method
	 API key, urls, and longitude/latitude
	 */
	eventCounter = 0;
    [super viewDidLoad];
	UIApplication * appForNetDelegate = [UIApplication sharedApplication];
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	locationBasedSearch = appDelegate.isUsingGps;
	searchString = appDelegate.searchString;
	
	//Initialise our sections array
	sections = [[NSMutableArray alloc] initWithCapacity:10];
	
	// Last.fm API key
	apiKey = @"3c1e7d9edb3eeb785596fc009d5a163b";
	
	latitude = appDelegate.lat;
	longitude = appDelegate.lon;
	
	// Create our last fm url
	url = [self createUrl:apiKey latitude:latitude longitude:longitude searchString:searchString];
	
	self.title = (appDelegate.isUsingGps)? @"GPS search" : [searchString capitalizedString];
	
	//Add a map it button
	UIBarButtonItem * mapBtn = [[UIBarButtonItem alloc] initWithTitle:@"Map 'em!" style:UIBarButtonItemStylePlain target:self action:@selector(loadMap)];
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

- (void)loadMap {
	//Load the mapview
	MapViewController * mapView = [[MapViewController alloc] init];
	self.mapViewController = mapView;
	[mapView release];
	
	[self.navigationController pushViewController:mapViewController animated:YES];
	NSLog(@"Her!");
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [aDates count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(error) {
		return 1;
	}
	NSArray * sectArray = [aDates objectAtIndex:section];
    return [[sectArray objectAtIndex:1]intValue];
}

// Customize the title of each section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSArray * sectArray = [aDates objectAtIndex:section];
	return [sectArray objectAtIndex:0];
	
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
		
		if(eventCounter < [events count]) {
			// Set up the cell...
			Event * event = [events objectAtIndex:eventCounter];
			[cell.textLabel setText:event.artist];
			NSString * detailedText = [[NSString alloc] initWithFormat:@"%@, %@", event.venue, event.location];
			[cell.detailTextLabel setText:detailedText];
			[detailedText release];
			eventCounter++;
		}
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Event * event = [self getEvent:indexPath];
	if (event == nil) { error = YES; }
	if(!error) {
		//Navigation logic
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		
		appDelegate.selectedEvent = event;
	
		DetailedViewViewController * dView = [[DetailedViewViewController alloc] initWithStyle:UITableViewStyleGrouped];
		self.detailedViewController = dView;
	
		[dView release];
		
		[self.navigationController pushViewController:detailedViewController animated:YES];
		[event retain];
	}
}

# pragma mark General methods

- (void)loadXml:(NSString *)address {
	bool debug = NO;
	error = NO;
	events = [[NSMutableArray alloc] initWithCapacity:10];
	aDates = [[NSMutableArray alloc] init];
	
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
			
			[self addDate:anEvent];
			
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
				NSLog(@"Section: %@", [anEvent.section stringValue]);
				NSLog(@"Row: %@", [anEvent.row stringValue]);
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
- (Event*) getEvent:(NSIndexPath*)indexPath {
	/*
	 Find the event with this specific indexPath. (Section and row)
	 */
	for(Event * ev in events) {
		if(indexPath.section == [ev.section intValue] && indexPath.row == [ev.row intValue]) {
			return ev;
		}
	}
	return nil;
}

- (void) addDate:(Event *)event {
	NSString * dateString = [self createDate:event.startDate];
	/*
	 Take the date,
	 check if it is already present in the array/dictionary,
	 if not add it. If already present increment the counter in
	 our dictionary.
	 */
	
	if([aDates count] == 0) {
		/*
		 If we have no elements in the array,
		 we know this is the first run of it,
		 and we can safely add the object to the array.
		 We set the initial value to 1
		 0 - String date
		 1 - Number of entries
		 */
		NSNumber * startValue = [NSNumber numberWithInt:1];
		NSMutableArray * startArray = [NSMutableArray arrayWithCapacity:2];
		
		event.section = [NSNumber numberWithInt:0];
		event.row = [NSNumber numberWithInt:0];
		[startArray insertObject:dateString atIndex:0];
		[startArray insertObject:startValue atIndex:1];
		
		[aDates addObject:startArray];
		
	} else {
		/*
		 There are elements in the array,
		 let us check if our string matches any.
		 */
		bool exists = NO;
		int section = 0;
		
		for (NSMutableArray * mArray in aDates) {
			NSString * date = [mArray objectAtIndex:0];
			NSNumber * number = [mArray objectAtIndex:1];
			
			//Compare our original date with the one we find in the array
			if([date isEqualToString:dateString]) {
				event.section = [NSNumber numberWithInt:section];
				event.row = number;
				int tempValue = [number intValue];
				tempValue++;
				[mArray insertObject:[NSNumber numberWithInt:tempValue] atIndex:1];
				exists = YES;
			}
			
			section++;
		}
		
		/*
		 As we're not allowed to edit the array while we enumerate it,
		 we use a bool to decide if it already exist in the array
		 */
		if(!exists) {
			int rowInt = 0;
			//Set the path
			event.section = [NSNumber numberWithInt:section];
			event.row = [NSNumber numberWithInt:rowInt];
			NSMutableArray * newArray = [NSMutableArray arrayWithCapacity:2];
			[newArray insertObject:dateString atIndex:0];
			[newArray insertObject:[NSNumber numberWithInt:1] atIndex:1];
			[newArray insertObject:[NSNumber numberWithInt:section] atIndex:2];
			[aDates addObject:newArray];
		}
	}
	
	
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
	
	//Get the appDelegate
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	if(!appDelegate.isUsingGps) {
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

