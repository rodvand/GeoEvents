//
//  Event.m
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright 2009 Redwater software. All rights reserved.
//

#import "Event.h"


@implementation Event

@synthesize ident,
			artist,
			venue,
			startDate,
			eventUrl,
			eventStatus,
			lat,
			lon,
			tags,
			attendance,
			location,
			section,
			row,
			coordinate,
			title,
			subtitle;

-(void)setForMapKit {
	//Should only be runa after we've set values for lat and lon
	coordinate.latitude = [lat doubleValue];
	coordinate.longitude = [lon doubleValue];
	
	NSLog(@"Latitude: %@", [lat description]);
	NSLog(@"Longitude: %@", [lon description]);
	
	title = artist;
	subtitle = [[NSString alloc]initWithFormat:@"%@, %@", venue, location];
	
	NSLog(@"Title: %@", title);
	NSLog(@"Subtitle: %@", subtitle);
	
}

@end
