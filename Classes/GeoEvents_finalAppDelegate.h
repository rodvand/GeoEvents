//
//  GeoEvents_finalAppDelegate.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

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
}
- (IBAction)goToSettings:(id)sender;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * settingsButton;
@property (nonatomic, retain) SettingsViewController * settingsViewController;
@property (nonatomic, retain) Event * selectedEvent;
@property (nonatomic, retain) NSNumber * lat;
@property (nonatomic, retain) NSNumber * lon;
@property (nonatomic, retain) NSMutableArray * searchHistory;
@end

