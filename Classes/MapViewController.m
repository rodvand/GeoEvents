//
//  MapViewController.m
//  GeoEvents
//
//  Created by Martin Rødvand on 24/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import "MapViewController.h"
#import "GeoEvents_finalAppDelegate.h"
#import "DetailedViewViewController.h"

@implementation MapViewController

@synthesize arrayWithEvents,
			detailedView;

-(void)viewDidLoad {
	[super viewDidLoad];
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	//Get the appDelegate for the latitude and longitude of the user.
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	arrayWithEvents = appDelegate.events;
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
	[mapView addAnnotations:arrayWithEvents];

	[mapView setRegion:region animated:YES];
	
	[self.view insertSubview:mapView atIndex:0];
	
}

- (MKAnnotationView *)mapView:(MKMapView *)lmapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
	/*
	 We show the standard blue pin on our Current Location
	 */
	if([annotation.title isEqualToString:@"Current Location"]) {
		return nil;
	}
	   
	MKPinAnnotationView * mkView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapAnnotation"];
	if(mkView == nil) {
		mkView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapAnnotation"];
	}
	mkView.enabled = YES;
	mkView.canShowCallout = YES;
	
	UIButton * accBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	
	mkView.rightCalloutAccessoryView = accBtn;
	
	return mkView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	Event * ourEvent;
	for(Event * curEvent in arrayWithEvents) {
		NSString * comparableVenueString = [NSString stringWithFormat:@"%@, %@", curEvent.venue, curEvent.location];
		
		if([curEvent isThisIt:view.annotation.title venue:comparableVenueString]) {
			ourEvent = curEvent;
		}
			
	}
	GeoEvents_finalAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
	appDelegate.selectedEvent = ourEvent;
	
	DetailedViewViewController * dView = [[DetailedViewViewController alloc] initWithStyle:UITableViewStyleGrouped];
	self.detailedView = dView;
	
	[dView release];
	
	[self.navigationController pushViewController:detailedView animated:YES];
	
	
}


@end
