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
@synthesize detailedViewController, searchString, url, apiKey, latitude, longitude, events;

/* 
 Initial setup method
 API key, urls, and longitude/latitude
*/
- (void)viewDidLoad {
    [super viewDidLoad];
	
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	locationBasedSearch = appDelegate.isUsingGps;
	searchString = appDelegate.searchString;
	
	// Last.fm API key
	apiKey = @"3c1e7d9edb3eeb785596fc009d5a163b";
	
	if(!locationBasedSearch) {
		self.title = [self.searchString capitalizedString];
		
		// We need to change our spaces to suit our url
		NSString * searching = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		url = [[NSString alloc]initWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=%@&api_key=%@", searching, apiKey];
	} else {
		self.title = @"GPS search";
		
		latitude = appDelegate.lat;
		longitude = appDelegate.lon;
		
		url = [[NSString alloc]initWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=geo.getevents&lat=%f&long=%f&api_key=%@", [latitude doubleValue], [longitude doubleValue], apiKey];
	}
	[self loadXml:url];
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
		[cell.detailTextLabel setText:event.venue];
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(!error) {
		//Navigation logic
		GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
		appDelegate.selectedEvent = [events objectAtIndex:indexPath.row];
	
		DetailedViewViewController * dView = [[DetailedViewViewController alloc] initWithNibName:@"DetailedView" bundle:[NSBundle mainBundle]];
		self.detailedViewController = dView;
	
		[dView release];
		
	
		[self.navigationController pushViewController:detailedViewController animated:YES];
	}
}

- (void)loadXml:(NSString *)address {
	bool debug = NO;
	error = NO;
	events = [[NSMutableArray alloc] initWithCapacity:10];
	
	UIApplication * appDelegate = [UIApplication sharedApplication];
	appDelegate.networkActivityIndicatorVisible = YES;
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
			anEvent.eventUrl = [tbXML textForElement:[tbXML childElementNamed:@"url" parentElement:event]];
			anEvent.eventStatus = [tbXML textForElement:[tbXML childElementNamed:@"cancelled" parentElement:event]];
			anEvent.attendance = [tbXML textForElement:[tbXML childElementNamed:@"attendance" parentElement:event]];
			TBXMLElement * venues = [tbXML childElementNamed:@"venue" parentElement:event];
			
			anEvent.venue = [tbXML textForElement:[tbXML childElementNamed:@"name" parentElement:venues]];
			TBXMLElement * location = [tbXML childElementNamed:@"location" parentElement:venues];
			TBXMLElement * geo = [tbXML childElementNamed:@"geo:point" parentElement:location];
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
			[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
			NSDate *date = [dateFormatter dateFromString:anEvent.startDate];
			
			NSLog(@"Date from string: %@", anEvent.startDate);
			
			if(geo != nil) {
				anEvent.lat = [tbXML textForElement:[tbXML childElementNamed:@"geo:lat" parentElement:geo]];
				anEvent.lon = [tbXML textForElement:[tbXML childElementNamed:@"geo:long" parentElement:geo]];
			}
			
			if(debug) {
				NSLog(@"**********************************");
				NSLog(@"Event id:%@", anEvent.ident);
				NSLog(@"Start date: %@", anEvent.startDate);
				NSLog(@"Artist: %@", anEvent.artist);
				NSLog(@"Venue: %@", anEvent.venue);
				NSLog(@"URL: %@", anEvent.eventUrl);
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
	appDelegate.networkActivityIndicatorVisible = NO;
}

- (void)dealloc {
    [super dealloc];
}


@end

