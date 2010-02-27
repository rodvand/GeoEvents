//
//  MapViewController.h
//  GeoEvents
//
//  Created by Martin Rødvand on 24/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
	MKMapView * mapView;
    NSArray * events;
}

@property (nonatomic, retain) MKMapView * mapView;
@property (nonatomic, retain) NSArray * events;

-(void)loadEvents;

@end
