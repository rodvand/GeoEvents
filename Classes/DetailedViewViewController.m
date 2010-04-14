//
//  DetailedViewViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//

#import "DetailedViewViewController.h"
#import "Event.h"
#import "GeoEvents_finalAppDelegate.h"

@implementation DetailedViewViewController

@synthesize selectedEvent;
- (id) initWithEvent:(Event*)event {
	[super initWithStyle:UITableViewStyleGrouped];
	selectedEvent = event;
	
	return self;
}
/*
- (id) initWithStyle:(UITableViewStyle)style {
	[super initWithStyle:style];
	
	return self;
}
 */
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionItems)];
	self.navigationItem.rightBarButtonItem = item;
	
	self.title = selectedEvent.artist;
	
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUM_DETAILED_SECTIONS;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == eventSection) {
		return NUM_EVENTS;
	}
	
	if(section == attendanceSection) {
		/*
		 If we're logged in to last.fm, enable adding attendance to event.
		 In the case we have none attending we don't bother showing it. Looks lame.
		 */
		
		if(lastfmLoggedIn) {
			return NUM_ATTENDANCE;
		} else if([selectedEvent.attendance isEqualToString:@"0"]) {
			return 0;
		} else {
			return NUM_ATTENDANCE -1;
		}
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Get our selected event
	Event * event = selectedEvent;
	
    static NSString *CellIdentifier = @"Event";
	static NSString *AttCellIdentifier = @"Attendance";
	static NSString *AttBtnCellIdentifier = @"Attendance button";
	
    if(indexPath.section == eventSection) {
		UITableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (eventCell == nil) {
			eventCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
		}
		switch(indexPath.row) {
			case eventArtist:
				;
				[eventCell.textLabel setText:@"Artist"];
				[eventCell.detailTextLabel setText:event.artist];
				
				return eventCell;
				break;
			case eventVenue:
				;
				
				[eventCell.textLabel setText:@"Venue"];
				[eventCell.detailTextLabel setText:event.venue];
				
				return eventCell;
				break;
			case eventTime:
				;
				
				[eventCell.textLabel setText:@"Time"];
				[eventCell.detailTextLabel setText:event.startDate];
				
				return eventCell;
				break;
		}
	} else if(indexPath.section == attendanceSection) {
		
		switch(indexPath.row) {
			case attendanceNumber:
				;
				UITableViewCell * attendanceCell = [tableView dequeueReusableCellWithIdentifier:AttCellIdentifier];
				if(attendanceCell == nil) {
					attendanceCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:AttCellIdentifier] autorelease];
				}
				
				[attendanceCell.textLabel setText:@"Last.fm users attending"];
				[attendanceCell.detailTextLabel setText:event.attendance];
				
				return attendanceCell;
				break;
				
			case attendanceButton:
				;
				UITableViewCell * attendanceBtnCell = [tableView dequeueReusableCellWithIdentifier:AttBtnCellIdentifier];
				if(attendanceBtnCell == nil) {
					attendanceBtnCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AttBtnCellIdentifier] autorelease];
				}
				[attendanceBtnCell.textLabel setText:@"Mark me as attending"];
				[attendanceBtnCell.textLabel setTextAlignment:UITextAlignmentCenter];
				
				return attendanceBtnCell;
				break;
		}
	} 
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	if(section == eventSection) {
		return @"Event information";
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void) showActionItems {
	/*
	 Create an ActionSheet and show it
	 */
	
	UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet addButtonWithTitle:@"Mail Event"];
	[actionSheet addButtonWithTitle:@"Open Event Link"];
	actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.delegate = self;
	[actionSheet showInView:self.view];
	[actionSheet showFromToolbar:self.navigationController.toolbar];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch(buttonIndex) {
		case 0:
			/*
			 Mail it!
			 */
			;
			NSString * mail = [NSString stringWithFormat:@"mailto:?subject=Check out %@&body=I'm seeing %@ on %@.\n Check the event out at: %@", 
							   selectedEvent.artist,
							   selectedEvent.artist,
							   selectedEvent.sensibleDate,
								selectedEvent.eventUrl];
			
			NSURL * mailUrl = [NSURL URLWithString:[mail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[[UIApplication sharedApplication] openURL:mailUrl];
			break;
		case 1:
			/*
			 Open event link
			 */
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithString:selectedEvent.eventUrl]]];
			break;
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

