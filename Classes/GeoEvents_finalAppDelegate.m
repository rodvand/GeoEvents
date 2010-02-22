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

@synthesize window, 
			navigationController,
			selectedEvent,
			lat,
			lon,
			settingsViewController,
			settingsButton,
			searchHistory,
			isUsingGps,
			searchString,
			lastfmstatus;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	//Set our last.fm status
	//TODO: Implement real login
	lastfmstatus = NO;
	NSString * strings[3];
	strings[0] = @"Tokyo";
	strings[1] = @"Oslo";
	strings[2] = @"Glasgow";
	NSArray * testArray = [NSArray arrayWithObjects:strings count:3];
	//Initiate the searchHistory array
	searchHistory = [[NSMutableArray alloc]initWithArray:testArray];
	
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
	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

