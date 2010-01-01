//
//  SearchViewViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 Redwater Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedViewViewController.h"

@interface SearchViewViewController : UITableViewController {
	DetailedViewViewController * detailedViewController;
	NSString * searchString;
	bool locationBasedSearch;
	NSString * url;
	NSString * apiKey;
	NSNumber * latitude;
	NSNumber * longitude;
	NSMutableArray * events;
	bool error;
}
- (void) loadXml:(NSString *)address;
//- (void) createUrl:(NSString *)location;
@property (nonatomic, retain) DetailedViewViewController * detailedViewController;
@property (nonatomic, retain) NSString *  searchString;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSMutableArray * events;
@end
