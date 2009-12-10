//
//  RootViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright Redwater Software 2009. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController
@synthesize searchViewViewController;
@synthesize searchField;
@synthesize latitude;
@synthesize longitude;

- (void)viewDidLoad {
	self.title = @"Starting point";
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	 
    [locationController.locationManager startUpdatingLocation];
}

- (void)locationUpdate:(CLLocation *)location {
	latitude = [NSNumber numberWithDouble:[location coordinate].latitude];
	longitude = [NSNumber numberWithDouble:[location coordinate].longitude];
	
	NSLog(@"Location: %f", [location coordinate].latitude);
	NSLog(@"Location: %f", [longitude doubleValue]);
	
	self.searchViewViewController.latitude = latitude;
	self.searchViewViewController.longitude = longitude;
	//[latitude release];
	//[longitude release];
}

- (void)locationError:(NSError *)error {
    locationLabel.text = [error description];
}

- (IBAction)search:(id)sender {
	NSString * searchText = [searchField text];
	
	SearchViewViewController * searchView = [[SearchViewViewController alloc] initWithNibName:@"SearchView" bundle:[NSBundle mainBundle]];
	self.searchViewViewController = searchView;
	self.searchViewViewController.searchString = searchText;
	[searchView release];
	
	[self.navigationController pushViewController:self.searchViewViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[locationController release];
    [super dealloc];
}

@end
