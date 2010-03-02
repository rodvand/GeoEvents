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
	int sectionCounter;
	int eventCounter;
	bool error;
}
- (void) loadMap;
- (void) loadXml:(NSString *)address;
- (NSString*) createUrl:(NSString*)api latitude:(NSNumber*)lat longitude:(NSNumber*)lang searchString:(NSString*)searchQuery;
- (NSString*) createDate:(NSString*)rawDate;
- (void) addDate:(NSString*)dateString;
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
@end
