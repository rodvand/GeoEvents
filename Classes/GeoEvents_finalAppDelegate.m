//
//  GeoEvents_finalAppDelegate.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GeoEvents_finalAppDelegate.h"
#import "RootViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation GeoEvents_finalAppDelegate

@synthesize window, navigationController, selectedEvent, lat, lon, settingsViewController, settingsButton, searchHistory, isUsingGps, searchString;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	searchHistory = [[NSMutableArray alloc] initWithCapacity:5];
	NSLog(@"Size: %d", [searchHistory count]);
	// Create a location manager instance to determine if location services are enabled. This manager instance will be
    // immediately released afterwards.
    CLLocationManager *manager = [[CLLocationManager alloc] init];
	
    if (manager.locationServicesEnabled == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" 
																message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
    }
    [manager release]; 
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}

- (IBAction)goToSettings:(id)sender {
	//Go to settings view
	if(settingsViewController == nil) {
		SettingsViewController * settings = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
		self.settingsViewController = settings;
		[settings release];
	}
	
	[self.navigationController pushViewController:self.settingsViewController animated:YES];
	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

