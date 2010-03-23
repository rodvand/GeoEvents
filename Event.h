//
//  Event.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Event : NSObject <MKAnnotation>{
	NSString * ident;
	NSString * artist;
	NSString * venue;
	NSString * startDate;
	NSArray * tags;
	NSString * eventUrl;
	NSString * websiteUrl;
	NSString *canceled;
	NSString * lat;
	NSString * lon;
	NSString * attendance;
	NSString * location;
	NSNumber * section;
	NSNumber * row;
	
	//MKAnnotation properties
	CLLocationCoordinate2D coordinate;
	NSString * title;
	NSString * subtitle;
}
-(void) setForMapKit;
@property (nonatomic, retain) NSString * ident;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * eventUrl;
@property (nonatomic, retain) NSString * websiteUrl;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSArray * tags;
@property (nonatomic, retain) NSString * attendance;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * section;
@property (nonatomic, retain) NSNumber * row;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * canceled;
@end
