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
	location.latitude = [appDelegate.lat doubleValue];
	location.longitude = [appDelegate.lon doubleValue];
	
	/*
	NSLog(@"Latitude: %@", [location.latitude doubleValue]);
	NSLog(@"Longitude: %@", [location.longitude doubleValue]);
	*/
	MKCoordinateRegion region;
	region.center = location;
	[mapView addAnnotations:appDelegate.events];

	//[mapView setRegion:region animated:YES];
	
	[self.view insertSubview:mapView atIndex:0];
	
}

- (MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKAnnotationView * mkView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapAnnotation"];
	mkView.enabled = YES;
	mkView.canShowCallout = YES;
	
	return mkView;
}

@end
