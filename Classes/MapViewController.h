//
//  MapViewController.h
//  GeoEvents
//
//  Created by Martin Rødvand on 24/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "SM3DARMapView.h"

@interface MapViewController : UIViewController <MKMapViewDelegate, SM3DAR_Delegate> {
	SM3DARMapView *mapView;
    NSArray *events;
}

@property (nonatomic, retain) SM3DARMapView *mapView;
@property (nonatomic, retain) NSArray *events;

-(void)loadEvents;

@end
