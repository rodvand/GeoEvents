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
@synthesize searchViewViewController, searchField, latitude, longitude, settingsViewController, 
			activity, latitudeLabel, longitudeLabel, statusLabel, searchButton;

- (void)viewDidLoad {
	self.title = @"GeoEvents";
	locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	statusLabel.text = @"Acquiring GPS info...";
	// We disable textfield and searchButton until GPS info is aquired
	searchField.enabled = NO;
	searchButton.enabled = NO;
	
	[locationController.locationManager startUpdatingLocation];
}

- (void)locationUpdate:(CLLocation *)location {
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	latitude = [NSNumber numberWithDouble:[location coordinate].latitude];
	longitude = [NSNumber numberWithDouble:[location coordinate].longitude];
	
	appDelegate.lat = latitude;
	appDelegate.lon = longitude;
	searchField.enabled = YES;
	searchButton.enabled = YES;
	
	NSLog(@"Location: %f", [location coordinate].latitude);
	NSLog(@"Location: %f", [longitude doubleValue]);
	latitudeLabel.text = [latitude stringValue];
	longitudeLabel.text = [longitude stringValue];
	statusLabel.text = @"GPS info aquired";
}

- (void)locationError:(NSError *)error {
    //locationLabel.text = [error description];
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
