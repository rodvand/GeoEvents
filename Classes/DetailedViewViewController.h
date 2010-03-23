//
//  DetailedViewViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 Redwater Software. All rights reserved.
//
#import "GlobalHeader.h"
#import "Event.h"
#import <UIKit/UIKit.h>

@interface DetailedViewViewController : UITableViewController {
	bool lastfmLoggedIn;
	Event * selectedEvent;
}

@property (nonatomic, retain) Event * selectedEvent;

enum detailedSections {
	eventSection = 0,
	attendanceSection,
	linkSection,
	NUM_DETAILED_SECTIONS
};

enum detailedSectionEvent {
	eventArtist = 0,
	eventVenue,
	eventTime,
	NUM_EVENTS
};

enum detailedSectionAttendance {
	attendanceNumber = 0,
	attendanceButton,
	NUM_ATTENDANCE
};

enum linkSection {
	linkEvent = 0,
	linkWebsite,
	NUM_LINKS
};
@end
