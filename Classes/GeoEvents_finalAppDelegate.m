//
//  GeoEvents_finalAppDelegate.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "GeoEvents_finalAppDelegate.h"
#import "IndexViewController.h"
#import <CoreLocation/CoreLocation.h>

@implementation GeoEvents_finalAppDelegate

@synthesize window, navigationController, selectedEvent, lat, lon, settingsViewController, settingsButton, searchHistory, isUsingGps, searchString, lastfmstatus;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	/*
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the
	//documents directory:
	NSString *fullFileName = [NSString stringWithFormat:@"%@/arraySaveFile", documentsDirectory];
	
	searchHistory = [[NSMutableArray alloc] initWithCapacity:5];
	
	
	NSLog(@"FULL FILE NAME: %@", fullFileName);
	NSLog(@"COUNT: %@", [searchHistory count]);
	*/
	
	//Set our last.fm status
	//TODO: Implement real login
	lastfmstatus = NO;
	
	// Create a location manager instance to determine if location services are enabled. This manager instance will be
    // immediately released afterwards.
    CLLocationManager *manager = [[CLLocationManager alloc] init];
	
    if (manager.locationServicesEnabled == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" 
																message:@"You currently have all location services for this device disabled. If you proceed, you will be asked to confirm whether location services should be reenabled." 
																	   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [servicesDisabledAlert show];
        [servicesDisabledAlert release];
    }
    [manager release]; 
	/*
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	 */
	
	// Create the window
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    // Create the navigation and view controllers
    IndexViewController *rootViewController = [[IndexViewController alloc] initWithStyle:UITableViewStyleGrouped];
    navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [rootViewController release];
	
    // Configure and show the window
    [window addSubview:[navigationController view]];
    [window makeKeyAndVisible];

}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	/*
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the
	//documents directory:
	NSString *fullFileName = [NSString stringWithFormat:@"%@/arraySaveFile", documentsDirectory];
	
	[searchHistory writeToFile:fullFileName atomically:NO];
	NSLog(@"Writing to file: %@", fullFileName);
	*/
}

- (IBAction)goToSettings:(id)sender {
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

