//
//  MapViewController.m
//  GeoEvents
//
//  Created by Martin Rødvand on 24/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import "MapViewController.h"
#import "GeoEvents_finalAppDelegate.h"

@implementation MapViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	//mapView.delegate = self;
	mapView.mapType = MKMapTypeStandard;
	
	//Get the appDelegate for the latitude and longitude of the user.
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	
	//Only if we're on a GPS search will we show the user's location
	if(appDelegate.isUsingGps) {
		mapView.showsUserLocation = YES;
	}
	CLLocationCoordinate2D location;
	
	if(appDelegate.isUsingGps) {
		location.latitude = [appDelegate.lat doubleValue];
		location.longitude = [appDelegate.lon doubleValue];
	} else {
		//Fetch an event and set it as center
		NSArray * eventArray = appDelegate.events;
		int max = [eventArray count];
		int ranNo = arc4random() % max;
		Event * luckyEvent = [eventArray objectAtIndex:ranNo];
		
		location.latitude = [luckyEvent.lat doubleValue];
		location.longitude = [luckyEvent.lon doubleValue];
		[luckyEvent release];
		
	}
	MKCoordinateSpan span;
	span.latitudeDelta = 0.1;
	span.longitudeDelta = 0.1;

	MKCoordinateRegion region;
	region.center = location;
	region.span = span;
	[mapView addAnnotations:appDelegate.events];

	[mapView setRegion:region animated:YES];
	
	[self.view insertSubview:mapView atIndex:0];
	
}

- (MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKAnnotationView * mkView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapAnnotation"];
	
	if(mkView == nil) {
		mkView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapAnnotation"];
	}
	mkView.enabled = YES;
	mkView.canShowCallout = YES;
	mkView.leftCalloutAccessoryView = nil;
	mkView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	
	return mkView;
}

@end
