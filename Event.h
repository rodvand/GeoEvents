//
//  Event.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Event : NSObject {
	NSString * ident;
	NSString * artist;
	NSString * venue;
	NSString * startDate;
	NSArray * tags;
	NSString * eventUrl;
	NSString * eventStatus;
	NSString * lat;
	NSString * lon;
	NSString * attendance;
	NSString * location;
}

@property (nonatomic, retain) NSString * ident;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * eventUrl;
@property (nonatomic, retain) NSString * eventStatus;
@property (nonatomic, retain) NSString * lat;
@property (nonatomic, retain) NSString * lon;
@property (nonatomic, retain) NSArray * tags;
@property (nonatomic, retain) NSString * attendance;
@property (nonatomic, retain) NSString * location;

@end
