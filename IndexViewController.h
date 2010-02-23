//
//  IndexViewController.h
//  GeoEvents
//
//  Created by Martin Roedvand on 12/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//
#import "GlobalHeader.h"

#import <UIKit/UIKit.h>
#import "MyCLController.h"
#import "SearchViewViewController.h"
#import "SettingsViewController.h"

@interface IndexViewController : UITableViewController <MyCLControllerDelegate, UITextFieldDelegate> {
	UITextField * searchField;
	MyCLController *locationController;
	SearchViewViewController * searchViewViewController;
	SettingsViewController * settingsViewController;
	NSNumber * latitude;
	NSNumber * longitude;
	int run;
	bool locationFound;
	
}
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (void)search:(NSString *)searchText addToSearchHistory:(bool)addToSearch;
- (void)searchByGps;
- (void)loadSearchView:(bool)isUsingGps;
- (void)goToSettings:(id)sender;
@property (nonatomic, retain) SearchViewViewController * searchViewViewController;
@property (nonatomic, retain) SettingsViewController * settingsViewController;
@property (nonatomic, retain) UITextField * searchField;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property bool locationFound;
@property int run;

enum Sections {
	searchSection = 0,
	historySection,
	NUM_SECTIONS
};

enum SearchSectionRows {
	searchSectionSearchRow = 0,
	searchSectionSearchByGpsRow,
	NUM_HEADER_SECTION_ROWS
};

@end
