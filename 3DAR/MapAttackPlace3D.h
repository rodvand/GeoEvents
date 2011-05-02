//
//  MapattackPlace3D.h
//  GeoEvents
//
//  Created by P. Mark Anderson on 4/22/11.
//  Copyright 2011 Redwater software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SM3DAR.h"

@interface MapAttackPlace3D : SM3DAR_PointOfInterest 
{
    NSString *identifier;
    NSString *team;
    NSInteger points;
    BOOL active;
//    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, retain) NSString *placeID;
@property (nonatomic, retain) NSString *team;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id) initWithProperties:(NSDictionary *)properties;

@end
