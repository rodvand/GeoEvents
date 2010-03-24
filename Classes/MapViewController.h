//
//  MapViewController.h
//  GeoEvents
//
//  Created by Martin Rødvand on 24/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "DetailedViewViewController.h"

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	MKMapView * mapView;
	NSArray * arrayWithEvents;
	DetailedViewViewController * detailedView;
}
@property(nonatomic, retain) NSArray * arrayWithEvents;
@property(nonatomic, retain) DetailedViewViewController * detailedView;
@end
