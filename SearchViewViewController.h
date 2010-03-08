//
//  SearchViewViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 Redwater Software. All rights reserved.
//
#import "GlobalHeader.h"

#import <UIKit/UIKit.h>
#import "DetailedViewViewController.h"
#import "MapViewController.h"
#import "Event.h"

@interface SearchViewViewController : UITableViewController {
	DetailedViewViewController * detailedViewController;
	MapViewController * mapViewController;
	NSString * searchString;
	bool locationBasedSearch;
	NSString * url;
	NSString * apiKey;
	NSNumber * latitude;
	NSNumber * longitude;
	NSMutableArray * events;
	NSMutableArray * sections;
	NSMutableArray * aDates;
	NSNumber * currentPage;
	int sectionCounter;
	int eventCounter;
	bool error;
	bool more; // if there is more pages to be fetched
}
- (void) loadMap;
- (void) loadXml:(bool)increment;
- (NSString*) createUrl:(NSString*)api latitude:(NSNumber*)lat longitude:(NSNumber*)lang searchString:(NSString*)searchQuery page:(NSNumber*)pageNumber;
- (NSString*) createDate:(NSString*)rawDate;
- (void) addDate:(Event*)event;
- (Event*) getEvent:(NSIndexPath *)indexPath;
@property (nonatomic, retain) NSMutableArray * aDates;
@property (nonatomic, retain) NSMutableArray * sections;
@property (nonatomic, retain) DetailedViewViewController * detailedViewController;
@property (nonatomic, retain) MapViewController * mapViewController;
@property (nonatomic, retain) NSString *  searchString;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSMutableArray * events;
@property (nonatomic, retain) NSNumber * currentPage;
@end
