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
			numberOfEventsToBeFetched,
			events;

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
	NSString * fullFileName = [NSString stringWithFormat:@"%@/searchHistory.plist", documentsDirectory];
	NSString * settingsFileName = [NSString stringWithFormat:@"%@/searchSettings.plist", documentsDirectory];
	
	NSArray * savedSearches = [[NSArray alloc]initWithContentsOfFile:fullFileName];
	NSArray * savedSettings = [[NSArray alloc]initWithContentsOfFile:settingsFileName];
	
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
	
	/*
	 We check if there's anything in our settings file.
	 If not, let's make some default values for
	 search radius and no of events to fetch
	 */
	NSArray * defaultSettings;
	if([savedSettings count] == 0) {
		NSNumber * numbers[2];
		numbers[0] = [[NSNumber alloc]initWithInt:0];
		numbers[1] = [[NSNumber alloc]initWithInt:40];
		
		defaultSettings = [NSArray arrayWithObjects:numbers count:2];
	} else {
		defaultSettings = [[NSArray alloc]initWithArray:savedSettings];
	}
	range = [defaultSettings objectAtIndex:0];
	numberOfEventsToBeFetched = [defaultSettings objectAtIndex:1];
	
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
	/* Toolbar inits
	UIToolbar * toolbar = navigationController.toolbar;
	toolbar.barStyle = UIBarStyleBlack;
	[navigationController setToolbarHidden:NO];
	 */
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
	
	/*
	 Save the search history
	 */
	NSString *fullFileName = [NSString stringWithFormat:@"%@/searchHistory.plist", documentsDirectory];
	
	[searchHistory writeToFile:fullFileName atomically:NO];
	
	/*
	 Save the search settings
	 */
	NSString *settingsFileName = [NSString stringWithFormat:@"%@/searchSettings.plist", documentsDirectory];
	
	NSMutableArray * searchSettings = [[NSMutableArray alloc] init];
	[searchSettings insertObject:range atIndex:0];
	[searchSettings insertObject:numberOfEventsToBeFetched atIndex:1];
	
	[searchSettings writeToFile:settingsFileName atomically:YES];
	
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

