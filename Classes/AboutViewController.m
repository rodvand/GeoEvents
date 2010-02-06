//
//  AboutViewController.m
//  GeoEvents
//
//  Created by Martin Rødvand on 05/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tNUM_SECTIONS;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
		case tAbout:
			return tNUM_ROWS;
			break;
	}
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"tAbout";
	static NSString *WebCellIdentifier = @"tWebsite";
	
    switch(indexPath.section) {
		case tAbout:
			switch(indexPath.row) {
				case tAboutRow:
					;
					UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (cell == nil) {
						cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
					}
					[cell.textLabel setLineBreakMode:UILineBreakModeWordWrap];
					[cell.textLabel setTextAlignment:UITextAlignmentCenter];
					cell.textLabel.numberOfLines = 6;
					[cell.textLabel setText:@"GeoEvents is a part of my Bachelor with Honors degree, taken by the University of Stirling in Scotland.The complete source code can be found at the github address listed below."];
					
					return cell;
				case tWebsiteRow:
					;
					UITableViewCell *webCell = [tableView dequeueReusableCellWithIdentifier:WebCellIdentifier];
					if (webCell == nil) {
						webCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:WebCellIdentifier] autorelease];
					}
					[webCell.textLabel setText:@"WWW"];
					[webCell.detailTextLabel setText:@"github.com/rodvand/GeoEvents/"];
					webCell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
					
					return webCell;
			}
			break;
	}
	
	
	static NSString *NCellIdentifier = @"NCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NCellIdentifier] autorelease];
    }
    
    // Set up the cell...
    
    return cell;
}

#pragma mark TableViewDelegate method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Change the height of our row if its necessary
    return (indexPath.section == tAbout && indexPath.row == tAboutRow) ? (44.0 + (6 - 1) * 19.0) : 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == tAbout && indexPath.row == tWebsiteRow) {
		// Launch mobilesafari with link. Doesn't seem to work in 3.2 iPhone simulator
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://github.com/rodvand/GeoEvents"]];
	}
}

- (void)dealloc {
    [super dealloc];
}


@end

