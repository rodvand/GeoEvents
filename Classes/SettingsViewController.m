//
//  SettingsViewController.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 11/12/2009.
//  Copyright 2009 Redwater Software. All rights reserved.
//

#import "SettingsViewController.h"
#import "AboutViewController.h"
#import "AccountsViewController.h"
#import "SearchSettingsViewController.h"
#import "GeoEvents_finalAppDelegate.h"

@implementation SettingsViewController

@synthesize aboutView,
			accountsView,
			searchView;
- (void) viewDidLoad {
	[self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:UITableViewStyleGrouped]) {
	}
	self.title = @"Settings";
	return self;
}

- (void)dealloc {
    [super dealloc];
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

- (void)viewWillAppear:(BOOL)animated {
	[self.tableView reloadData];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return sNUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch(section) {
		//case sAccountSettings:
		//	return sNUM_ACCOUNT_ROWS;
		case sSearchSettings:
			return sNUM_SEARCH_ROWS;
		case sAboutSection:
			return sNUM_ABOUT_ROWS;
	}
	
	return 1;
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	static NSString *CellIdentifier = @"General";
	
	// For our account cells
	/*
	if(indexPath.section == sAccountSettings) {
		UITableViewCell *accountCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		//Code for our different account cells
		if(accountCell == nil) {
			accountCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		
		switch(indexPath.row) {
			case sLastfmRow:
				[accountCell.textLabel setText:@"Last.fm"];
				break;
			case sFacebookRow:
				[accountCell.textLabel setText:@"Facebook"];
				break;
			case sTwitterRow:
				[accountCell.textLabel setText:@"Twitter"];
				break;
		}
		
		return accountCell;
	}
	 */
	
	// For our search setting cell
	if(indexPath.section == sSearchSettings) {
		UITableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if(searchCell == nil) {
			searchCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		searchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		switch(indexPath.row) {
			case sKilometersRangeRow:
				;
				[searchCell.textLabel setText:@"Search radius"];
				if([appDelegate.range intValue] != 0) {
					NSString * distanceText = [NSString stringWithFormat:@"%@ km", appDelegate.range];
					[searchCell.detailTextLabel setText:distanceText];
				} else {
					[searchCell.detailTextLabel setText:@"Not defined"];
				}
				break;
			case sNumberOfResultsRow:
				;
				NSString * eventText = [NSString stringWithFormat:@"%@", appDelegate.numberOfEventsToBeFetched];
				[searchCell.textLabel setText:@"Max events shown"];
				[searchCell.detailTextLabel setText:eventText];
				break;
		}
		
		return searchCell;
	}
	
	// For our about cells
	if(indexPath.section == sAboutSection) {
		UITableViewCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		if(aboutCell == nil) {
				aboutCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}
		aboutCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[aboutCell.textLabel setText:@"About"];
		return aboutCell;
		
	}
	
	return nil;
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch(section) {
		//case sAccountSettings:
		//	return @"Account Settings";
		case sSearchSettings:
			return @"Search Settings";
		case sAboutSection:
			return @"About this app";
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch(indexPath.section) {
		/*
		case sAccountSettings:
			switch(indexPath.row) {
				case sFacebookRow:
					
					break;
				case sLastfmRow:
					
					break;
				case sTwitterRow:
					
					break;
			}
			break;
		 */
		case sSearchSettings:
			;
			SearchSettingsViewController * searchV = [[SearchSettingsViewController alloc]initWithStyle:UITableViewStyleGrouped];
			searchView = searchV;
			
			switch(indexPath.row) {
				case sKilometersRangeRow:
					[searchView setViewToBeDisplayed:@"Radius"];
					break;
				case sNumberOfResultsRow:
					[searchView setViewToBeDisplayed:@"Events"];
					break;
			}
			[self.navigationController pushViewController:searchView animated:YES];
			[searchV release];
			break;
		case sAboutSection:
			switch(indexPath.row) {
				case sAboutRow:
					;
					AboutViewController * aboutV = [[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped];
					aboutView = aboutV;
					[self.navigationController pushViewController:aboutV animated:YES];
					[aboutV release];
					break;
			}
			break;
	}
}

@end
