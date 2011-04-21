//
//  MapMarker.h
//
//  Created by P. Mark Anderson on 2/26/10.
//  Copyright 2010 Bordertown Labs, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mapkit/Mapkit.h"

@interface MapMarker : CLLocation <MKAnnotation> 
{
	NSString* title;
	NSString* subtitle;
    NSString* imageName;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) NSString* imageName;

- (id)initWithLocation:(CLLocation*)loc;

@end
