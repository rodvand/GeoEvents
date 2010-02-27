//
//  MapMarker.m
//
//  Created by P. Mark Anderson on 2/26/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import "MapMarker.h"


@implementation MapMarker

@synthesize title, subtitle;
@dynamic coordinate;

- (id)initWithLocation:(CLLocation*)loc 
{
	[super initWithLatitude:loc.coordinate.latitude longitude:loc.coordinate.longitude];
	return self;
}

- (void) dealloc {
  [title release];
  [subtitle release];
  [super dealloc];
}

@end
