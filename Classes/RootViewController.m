//
//  RootViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright Redwater Software 2009. All rights reserved.
//

#import "RootViewController.h"
#import "GeoEvents_finalAppDelegate.h"

@implementation RootViewController
@synthesize searchViewViewController;
@synthesize searchField;
@synthesize latitude;
@synthesize longitude;
@synthesize settingsViewController;
@synthesize activity;

- (void)viewDidLoad {
	self.title = @"Starting point";
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	
	/*UIActivityIndicatorView *waitView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	activity = waitView;
	[self.view addSubview: activity];
	[activity startAnimating];
    
	[activity stopAnimating];
	[waitView release];
	*/
	[locationController.locationManager startUpdatingLocation];
}

- (void)locationUpdate:(CLLocation *)location {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	latitude = [NSNumber numberWithDouble:[location coordinate].latitude];
	longitude = [NSNumber numberWithDouble:[location coordinate].longitude];
	
	appDelegate.lat = latitude;
	appDelegate.lon = longitude;
	
	NSLog(@"Location: %f", [location coordinate].latitude);
	NSLog(@"Location: %f", [longitude doubleValue]);
}

- (void)locationError:(NSError *)error {
    locationLabel.text = [error description];
}

- (IBAction)search:(id)sender {
	NSString * searchText = [searchField text];
	SearchViewViewController * searchView = [[SearchViewViewController alloc] initWithNibName:@"SearchView" bundle:[NSBundle mainBundle]];
	self.searchViewViewController = searchView;
	self.searchViewViewController.searchString = searchText;
	[self.navigationController pushViewController:self.searchViewViewController animated:YES];
	[searchView release];
	[searchText release];
}

- (IBAction)goToSettings:(id)sender {
	//Go to settings view
	if(settingsViewController == nil) {
		SettingsViewController * settings = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:[NSBundle mainBundle]];
		self.settingsViewController = settings;
		[self.navigationController pushViewController:self.settingsViewController animated:YES];
		[settings release];
	}
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
