//
//  SearchSettingsViewController.h
//  GeoEvents
//
//  Created by Martin Rødvand on 15/03/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchSettingsViewController : UITableViewController {
	NSNumber * searchRadius;
	NSNumber * eventsToBeFetched;
	NSString * viewToBeDisplayed;
	NSMutableArray * searchRadiusArray;
	NSMutableArray * noOfEventsArray;
}
- (void)setViewToBeDisplayed:(NSString*)view;
- (void)saveSettings;
@property(nonatomic, retain) NSNumber * searchRadius;
@property(nonatomic, retain) NSNumber * eventsToBeFetched;
@property(nonatomic, retain) NSString * viewToBeDisplayed;
@property(nonatomic, retain) NSMutableArray * searchRadiusArray;
@property(nonatomic, retain) NSMutableArray * noOfEventsArray;
@end
