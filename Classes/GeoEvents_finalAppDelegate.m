//
//  GeoEvents_finalAppDelegate.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright Redwater Software 2009. All rights reserved.
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
			lastfmstatus,
			searchSuggestions,
			range,
			numberOfEventsToBeFetched;

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	//Get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	/*
	 Make a file name to write the data to using the
	 documents directory.
	 */
	NSString *fullFileName = [NSString stringWithFormat:@"%@/searchHistory", documentsDirectory];
	
	NSArray * savedSearches = [[NSArray alloc]initWithContentsOfFile:fullFileName];
	
	range = [[NSNumber alloc]initWithInt:50];
	NSLog(@"Range: %@", range);
	numberOfEventsToBeFetched = [[NSNumber alloc] initWithInt:40];
	/*
	 If we have nothing in our search file, we populate it with some searches
	 If we have stuff in our search file, we fill the array with these searches
	 */
	NSArray * testArray;
	if([savedSearches count] == 0) {
		searchSuggestions = YES;
		// Three working searches - must include events
		NSString * strings[3];
		strings[0] = @"Tokyo";
		strings[1] = @"Oslo";
		strings[2] = @"Glasgow";
		
		testArray = [NSArray arrayWithObjects:strings count:3];
	} else {
		searchSuggestions = NO;
		testArray = [[NSArray alloc] initWithArray:savedSearches];
	}
	//Set our last.fm status
	//TODO: Implement real login
	lastfmstatus = NO;
	
	//Initiate the searchHistory array
	searchHistory = [[NSMutableArray alloc]initWithArray:testArray];
	
	/*
	 Create a location manager instance to determine if location services are enabled. This manager instance will be
     immediately released afterwards.
	 */
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
	/*
	 Save data if appropriate
	 Write the searchArray to file.
	 */
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	NSString *fullFileName = [NSString stringWithFormat:@"%@/searchHistory", documentsDirectory];
	
	[searchHistory writeToFile:fullFileName atomically:NO];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

