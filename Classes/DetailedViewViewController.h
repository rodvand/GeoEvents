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

@interface DetailedViewViewController : UITableViewController <UIActionSheetDelegate> {
	bool lastfmLoggedIn;
	Event * selectedEvent;
}
- (void) showActionItems;
- (id) initWithEvent:(Event*)event;
@property (nonatomic, retain) Event * selectedEvent;

enum detailedSections {
	eventSection = 0,
	attendanceSection,
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
@end
