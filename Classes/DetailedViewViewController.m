//
//  DetailedViewViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DetailedViewViewController.h"
#import "Event.h"
#import "GeoEvents_finalAppDelegate.h"

@implementation DetailedViewViewController

@synthesize selectedEvent;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//We create our link to the appDelegate
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	//Get our selected event from the delegate
	selectedEvent = appDelegate.selectedEvent;
	
	//Get our logged in status Last.fm/Facebook/Twitter/Etc
	lastfmLoggedIn = appDelegate.lastfmstatus;
	
	self.title = selectedEvent.artist;
	
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
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
		//If we're logged in to last.fm, enable adding attendance to event
		//return (lastfmLoggedIn) ? NUM_ATTENDANCE : NUM_ATTENDANCE -1;
		if(lastfmLoggedIn) {
			return NUM_ATTENDANCE;
		} else {
			return NUM_ATTENDANCE -1;
		}
	}
    
	if(section == linkSection) {
		return (selectedEvent.websiteUrl == nil) ? NUM_LINKS - 1 : NUM_LINKS;
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //We create our link to the appDelegate
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	//Get our selected event from the delegate
	Event * event = appDelegate.selectedEvent;
	
    static NSString *CellIdentifier = @"Event";
	static NSString *AttCellIdentifier = @"Attendance";
	static NSString *AttBtnCellIdentifier = @"Attendance button";
	static NSString *LinkCellIdentifier = @"Link";
	
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
					attendanceCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:AttCellIdentifier] autorelease];
				}
				
				[attendanceCell.textLabel setText:@"Attendance"];
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
	
	else if(indexPath.section == linkSection) {
		switch(indexPath.row) {
			case linkEvent:
				;
				UITableViewCell * eventLinkCell = [tableView dequeueReusableCellWithIdentifier:LinkCellIdentifier];
				if(eventLinkCell == nil) {
					eventLinkCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LinkCellIdentifier] autorelease];
				}
				
				[eventLinkCell.textLabel setText:@"Event (opens in Safari)"];
				eventLinkCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
				[eventLinkCell.textLabel setTextAlignment:UITextAlignmentCenter];
				
				return eventLinkCell;
				break;
			case linkWebsite:
				;
				if(selectedEvent.websiteUrl != nil) {
					UITableViewCell * websiteLinkCell = [tableView dequeueReusableCellWithIdentifier:LinkCellIdentifier];
					if(websiteLinkCell == nil) {
						websiteLinkCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LinkCellIdentifier] autorelease];
					}
					[websiteLinkCell.textLabel setText:@"Website (opens in Safari)"];
					websiteLinkCell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					[websiteLinkCell.textLabel setTextAlignment:UITextAlignmentCenter];
					
					return websiteLinkCell;
					break;
				}
		}
		
	}
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
	}
	
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//We create our link to the appDelegate
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	//Get our selected event from the delegate
	Event * event = appDelegate.selectedEvent;
	
	if(section == eventSection) {
		return @"Event information";
	}
	
	if(section == attendanceSection) {
		return @"Attendance";
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)dealloc {
    [super dealloc];
}


@end

