//
//  MapViewController.m
//  GeoEvents
//
//  Created by Martin Rødvand on 24/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import "MapViewController.h"
#import "MapMarker.h"
#import "GeoEvents_finalAppDelegate.h"
#import "DetailedViewViewController.h"

@implementation MapViewController

@synthesize mapView, events;

-(void)viewDidLoad {
	[super viewDidLoad];

	self.mapView = [[[SM3DARMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)] autorelease];
    
    NSLog(@"mapView: %@", mapView);
    
	mapView.mapType = MKMapTypeStandard;
	mapView.showsUserLocation = YES;
    mapView.delegate = self;
    mapView.scrollEnabled = YES;
	
	[self.view addSubview:mapView];    
    
    [mapView init3DAR];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    [mapView startCamera];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [mapView stopCamera];
}

- (void)zoomMapToFit {
	if ([mapView.annotations count] == 0)
		return;

	CLLocationCoordinate2D topLeftCoord;
	topLeftCoord.latitude = -90;
	topLeftCoord.longitude = 180;
	
	CLLocationCoordinate2D bottomRightCoord;
	bottomRightCoord.latitude = 90;
	bottomRightCoord.longitude = -180;
	
	for (MapMarker* annotation in mapView.annotations) {
        CLLocation *loc = (CLLocation*)annotation;
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, loc.coordinate.longitude);
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, loc.coordinate.latitude);
		
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, loc.coordinate.longitude);
		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, loc.coordinate.latitude);
	}
	
	MKCoordinateRegion region;
	region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
	region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
	region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
	region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
	
	region = [mapView regionThatFits:region];
	[mapView setRegion:region animated:YES];
}

-(void)loadEvents {
    for (Event *event in events) {
        
        CLLocationDegrees latitude = [event.lat doubleValue];
        CLLocationDegrees longitude = [event.lon doubleValue];        

        if (latitude == 0 && longitude == 0) 
            continue;

        CLLocation *markerLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];        
        
        MapMarker *marker = [[MapMarker alloc] initWithLocation:markerLocation];
        marker.title = event.artist;
        marker.subtitle = [NSString stringWithFormat:@"At %@ on %@", event.venue, event.startDate];
        marker.imageName = @"music_icon.png";
        marker.event = event;
        
        [mapView addAnnotation:marker]; 
        
        [marker release];    
    }

    [self zoomMapToFit];
}

- (void) sm3darLoadPoints:(SM3DAR_Controller *)sm3dar
{
    [self loadEvents];
}

-(void)mapViewDidFinishLoadingMap:(SM3DARMapView *)mapView {
	NSLog(@"Map view did finish loading");
}

-(void)mapViewDidFailLoadingMap:(SM3DARMapView *)mapView withError:(NSError *)error {
	NSLog(@"ERROR: Map view failed to load. %@", error);
}

-(void)setCurrentMapLocation:(CLLocation *)loc {
	MKCoordinateRegion region = {{0.0f, 0.0f}, {0.0f, 0.0f}};
	region.center = loc.coordinate;
	region.span.longitudeDelta = 0.1f;
	region.span.latitudeDelta = 0.1f;
	[mapView setRegion:region animated:YES];
}

-(void)dealloc {
    [mapView release];
    [events release];
    [super dealloc];
}


#pragma mark -

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annView calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"mapView:annotationView:calloutAccessoryControlTapped:");
    
    MapMarker *marker = (MapMarker*)(annView.annotation);

    for (Event *event in events)
    {
        if ([event.ident isEqualToString:marker.event.ident])
        {
            GeoEvents_finalAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;            
            appDelegate.selectedEvent = event;            
            DetailedViewViewController *dView = [[DetailedViewViewController alloc] initWithStyle:UITableViewStyleGrouped];            
            [self.navigationController pushViewController:dView animated:YES];
            [dView release];    
            break;
        }
    }
}

- (void) sm3darDidShowMap:(SM3DAR_Controller *)sm3dar
{
    
}

@end
