//
//  SearchViewViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 Redwater Software. All rights reserved.
//

#import "SearchViewViewController.h"
#import "Event.h"
#import "TBXML.h"

@implementation SearchViewViewController
@synthesize detailedViewController;
@synthesize searchString;
@synthesize url;
@synthesize apiKey;
@synthesize latitude;
@synthesize longitude;
@synthesize events;

// Initial setup
// API key, urls, and longitude/latitude
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Last.fm API key
	apiKey = @"3c1e7d9edb3eeb785596fc009d5a163b";
	
	if(self.searchString.length > 0) {
		self.title = self.searchString;
		locationBasedSearch = NO;
		url = [[NSString alloc]initWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=geo.getevents&location=%@&api_key=%@", searchString, apiKey];
	} else {
		self.title = @"GPS search";
		locationBasedSearch = YES;
		
		//Sample data for GPS information (It's Glasgow!)
		latitude = [NSNumber numberWithDouble:55.865627];
		longitude = [NSNumber numberWithDouble:-4.257223];
		
		url = [[NSString alloc]initWithFormat:@"http://ws.audioscrobbler.com/2.0/?method=geo.getevents&lat=%f&long=%f&api_key=%@", [latitude doubleValue], [longitude doubleValue], apiKey];
	}
	[self loadXml:url];
	NSLog(@"URL: %@", url);
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
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	[cell.textLabel setText:@"GO to detailed view"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Navigation logic
	if(detailedViewController == nil) {
		DetailedViewViewController * dView = [[DetailedViewViewController alloc] initWithNibName:@"DetailedView" bundle:[NSBundle mainBundle]];
		self.detailedViewController = dView;
		[dView release];
	}
	
	[self.navigationController pushViewController:detailedViewController animated:YES];
}

- (void)loadXml:(NSString *)address {
	
	events = [[NSMutableArray alloc] initWithCapacity:10];
	
	// We load our xml from the url provided
	TBXML * tbXML = [[TBXML alloc] initWithURL:[NSURL URLWithString:address]];
	TBXMLElement * rootXMLElement = tbXML.rootXMLElement;
	
	//NSLog(@"We're in loadXML!");
	if(rootXMLElement) {
		//NSLog(@"We're inside the rootelement");
		TBXMLElement * event_top = [tbXML childElementNamed:@"events" parentElement:rootXMLElement];
		TBXMLElement * event = [tbXML childElementNamed:@"event" parentElement:event_top];
		
		while(event != nil) {
			//NSLog(@"We have event!");
			//Create our event object
			Event * anEvent = [[Event alloc] init];
			
			//Add it to the array
			[events addObject:anEvent];
			TBXMLElement * artists = [tbXML childElementNamed:@"artists" parentElement:event];
			anEvent.artist = [tbXML textForElement:[tbXML childElementNamed:@"artist" parentElement:artists]];
			
			anEvent.ident = [tbXML textForElement:[tbXML childElementNamed:@"id" parentElement:event]];
			anEvent.startDate = [tbXML textForElement:[tbXML childElementNamed:@"startDate" parentElement:event]];
			anEvent.eventUrl = [tbXML textForElement:[tbXML childElementNamed:@"url" parentElement:event]];
			anEvent.eventStatus = [tbXML textForElement:[tbXML childElementNamed:@"cancelled" parentElement:event]];
			
			TBXMLElement * venues = [tbXML childElementNamed:@"venue" parentElement:event];
			
			anEvent.venue = [tbXML textForElement:[tbXML childElementNamed:@"name" parentElement:venues]];
			TBXMLElement * location = [tbXML childElementNamed:@"location" parentElement:venues];
			TBXMLElement * geo = [tbXML childElementNamed:@"geo:point" parentElement:location];
			if(geo != nil) {
				anEvent.lat = [tbXML textForElement:[tbXML childElementNamed:@"geo:lat" parentElement:geo]];
				anEvent.lon = [tbXML textForElement:[tbXML childElementNamed:@"geo:long" parentElement:geo]];
			}
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
			event = [tbXML nextSiblingNamed:@"event" searchFromElement:event];
		}
		
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

