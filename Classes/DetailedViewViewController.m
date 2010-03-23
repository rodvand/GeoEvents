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
- (id) initWithStyle:(UITableViewStyle)style {
	[super initWithStyle:style];
	
	// Create a UIToolbar
	/*
	UIToolbar * toolBar = [[UIToolbar alloc] init];
	toolBar.barStyle = UIBarStyleBlack;
	NSLog(@"Her!");
	[self.navigationController.view addSubview:toolBar]; 
	 */
	
	return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
	//Toolbar setup
	UIToolbar * toolBar = self.navigationController.toolbar;
	toolBar.barStyle = UIBarStyleBlack;
	[self.navigationController setToolbarHidden:NO];
	UIBarButtonItem * flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionItems)];
	NSArray * buttonArray = [NSArray arrayWithObjects:flexibleSpace, item, nil];
	
	[self setToolbarItems:buttonArray];
	
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
	
	else if(indexPath.section == linkSection) {
		switch(indexPath.row) {
			case linkEvent:
				;
				UITableViewCell * eventLinkCell = [tableView dequeueReusableCellWithIdentifier:LinkCellIdentifier];
				if(eventLinkCell == nil) {
					eventLinkCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LinkCellIdentifier] autorelease];
				}
				
				[eventLinkCell.textLabel setText:@"Event"];
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
					[websiteLinkCell.textLabel setText:@"Website"];
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
	
	if(section == linkSection) {
		return @"Links";
	}
	return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == linkSection) {
		switch (indexPath.row) {
			case linkEvent:
				;
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithString:selectedEvent.eventUrl]]];
				break;
				
			case linkWebsite:
				;
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithString:selectedEvent.websiteUrl]]];
				break;
		}
	}
}

- (void) showActionItems {
	/*
	 Create an ActionSheet and show it
	 */
	
	UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
	[actionSheet addButtonWithTitle:@"Mail this event"];
	[actionSheet addButtonWithTitle:@"Tweet it"];
	[actionSheet addButtonWithTitle:@"Add to favourites"];
	actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.delegate = self;
	[actionSheet showInView:self.view];
	[actionSheet showFromToolbar:self.navigationController.toolbar];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Button clicked: %d", buttonIndex );
	
	switch(buttonIndex) {
		case 0:
			NSLog(@"Mail it!");
			NSString * mail = [NSString stringWithFormat:@"mailto:?subject=Check out %@&body=I'm seeing %@ on %@.\n Check the event out at: %@", 
							   selectedEvent.artist,
							   selectedEvent.artist,
							   selectedEvent.sensibleDate,
								selectedEvent.eventUrl];
			
			NSURL * mailUrl = [NSURL URLWithString:[mail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[[UIApplication sharedApplication] openURL:mailUrl];
			break;
		case 1:
			NSLog(@"Tweet it!");
			break;
		case 2:
			NSLog(@"Favourite it!");
			break;
		case 3:
			NSLog(@"Cancel it");
			break;
		default:
			break;
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

