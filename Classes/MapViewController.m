//
//  MapViewController.m
//  GeoEvents
//
//  Created by Martin Rødvand on 24/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

-(void)viewDidLoad {
	[super viewDidLoad];
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.mapType = MKMapTypeStandard;
	mapView.showsUserLocation = YES;
	
	[self.view insertSubview:mapView atIndex:0];
	
}
@end
