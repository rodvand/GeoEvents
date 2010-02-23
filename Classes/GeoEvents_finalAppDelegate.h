//
//  GeoEvents_finalAppDelegate.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "GlobalHeader.h"

#import <CoreLocation/CoreLocation.h>
#import "Event.h"
#import "SettingsViewController.h"

@interface GeoEvents_finalAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIBarButtonItem * settingsButton;
    UINavigationController *navigationController;
	SettingsViewController * settingsViewController;
	Event * selectedEvent;
	NSMutableArray * searchHistory;
	NSNumber * lat;
	NSNumber * lon;
	bool isUsingGps;
	NSString * searchString;
	bool lastfmstatus;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIBarButtonItem * settingsButton;
@property (nonatomic, retain) SettingsViewController * settingsViewController;
@property (nonatomic, retain) Event * selectedEvent;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSMutableArray * searchHistory;
@property (nonatomic, retain) NSString * searchString;
@property bool isUsingGps;
@property bool lastfmstatus;
@end

