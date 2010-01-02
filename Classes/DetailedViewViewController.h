//
//  DetailedViewViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedViewViewController : UITableViewController {
	
}

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
