//
//  SM3DARMapView.m
//
//  Created by P. Mark Anderson on 3/8/11.
//  Copyright 2011 Spot Metrix, Inc. All rights reserved.
//

#import "SM3DARMapView.h"
#import "PushpinView.h"
#import "SphereBackgroundView.h"

@implementation SM3DARMapView

@synthesize containerView;
@synthesize calloutView;
@synthesize hudView;

- (void) dealloc 
{

    [overlayView release];
    overlayView = nil;
    
    self.hudView = nil;
    self.containerView = nil;
    self.calloutView = nil;
    
    [sm3dar release];
    [pointAnnotations release];

    [super dealloc];
}


// TODO: Figure out how to know when this view is added as a subview
// so that the 3DAR view(s) can added too.

// Or add the 3DAR views as subviews.

- (void) init3DAR
{
    // Self will be the delegate until 3DAR is done initializing.

    sm3dar = [[SM3DAR_Controller alloc] initWithDelegate:self];
    
    pointAnnotations = [[NSMutableDictionary alloc] init];
}

- (void) add3darContainer:(SM3DAR_Controller *)_sm3dar
{
    if (!_sm3dar.view)
    {
        NSLog(@"\n\nWARNING: SM3DARMapView could not init 3DAR.\n\n");
        return;
    }
    else if (!self.superview)
    {
        NSLog(@"\n\nWARNING: SM3DARMapView could not init 3DAR because there is no superview.\n\n");
        return;
    }
    
    // Setup.
    
    [_sm3dar setFrame:self.bounds];
    _sm3dar.view.backgroundColor = [UIColor clearColor];
    _sm3dar.map = self;
    _sm3dar.map.alpha = 1.0;
    
//    _sm3dar.markerViewClass = [PushpinView class];    
    
    if (!hudView)
    {
        self.hudView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    }
    
    _sm3dar.hudView = hudView;
    
    if (!hudView.superview)
    {
        [_sm3dar.view addSubview:hudView];
    }

    
    self.calloutView = [[[MarkerCalloutView alloc] 
                        initWithFrame:CGRectMake(10, 178, 300, 60)] autorelease];
    calloutView.delegate = self;
    calloutView.hidden = YES;
    [hudView addSubview:calloutView];

    _sm3dar.focusView = calloutView;
    


    // Add 3DAR view to parent view.
    
    self.containerView = [[[UIView alloc] initWithFrame:self.frame] autorelease];        
    NSLog(@"Inserting 3DAR view into container view.");
    [containerView addSubview:_sm3dar.view];


    NSLog(@"Inserting map view container into superview.");    
    [self.superview insertSubview:containerView atIndex:0];        
    
    
    // Add this map view to the container.
    
    NSLog(@"Inserting map view (self) into container view.");
    self.frame = self.bounds;
    [containerView addSubview:self];
    
    [containerView addSubview:_sm3dar.iconLogo];
    
    
    // TODO: Add the overlay view.
        
}


- (id) initWithFrame:(CGRect)frame  
{
    if (self = [super initWithFrame:frame]);
    {
        // When no NIB is used, init3DAR must be called manually 
        // after the map view is added to its superview.        
    }
    
    return self;
}

- (void) awakeFromNib
{
    [super awakeFromNib];

    [self init3DAR];
}

- (void) addUserLocationDot
{
    NSLog(@"Adding user location dot.");
    
    SM3DAR_Fixture *f = [[SM3DAR_Fixture alloc] init];
    
    UIImageView *iv = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_dot.png"]] autorelease];    
    f.view = iv;
    
    Coord3D coord = {
        0, 0, 0
    };
    
    f.worldPoint = coord;
    
    [sm3dar addPoint:f];
    [f release];
}

- (void) sm3darLoadPoints:(SM3DAR_Controller *)_sm3dar
{        
    if (self.showsUserLocation)
    {
        [self addUserLocationDot];
    }
    
    [self addBackground];
    
    if (self.delegate && [self.delegate isKindOfClass:[NSObject class]] && 
        [self.delegate conformsToProtocol:@protocol(SM3DAR_Delegate)])
    {
         NSObject<SM3DAR_Delegate> *delegateAsObject = (NSObject<SM3DAR_Delegate> *)self.delegate;
        
        if (delegateAsObject == self)
        {
            // Bad.
            
            NSLog(@"SM3DARMapView delegate should not be itself.");
        }
        else
        {
            sm3dar.delegate = delegateAsObject;

            // Send the call to the new delegate.
            
            if ([sm3dar.delegate respondsToSelector:@selector(sm3darLoadPoints:)])
            {
                [sm3dar.delegate sm3darLoadPoints:sm3dar];
            }
            

            // This map view will pass MKMapViewDelegate calls to the sm3dar.delegate.
            
            self.delegate = self;
            
        }
    }
    else
    {
        NSLog(@"3DAR points will not be automatically loaded because an SM3DAR_Delegate has not been set.");
    }
}

- (void) loadPointsOfInterest
{
    [self sm3darLoadPoints:sm3dar];
}

- (void) zoomMapToFitPointsIncludingUserLocation:(BOOL)includeUser 
{
	if ([self.annotations count] == 0)
		return;
    
    if ([self.annotations count] == 1) 
    {
        id<MKAnnotation> annotation = [self.annotations objectAtIndex:0];

        NSLog(@"[SM3DARMapView] zooming map on single point: %@", annotation.title);

        [self setCenterCoordinate:annotation.coordinate animated:YES];
        
        return;    
    }
    
    NSLog(@"[SM3DARMapView] zoomMapToFit %i markers", [self.annotations count]);
    
	CLLocationCoordinate2D topLeftCoord;
	topLeftCoord.latitude = -90.0;
	topLeftCoord.longitude = 180.0;
	
	CLLocationCoordinate2D bottomRightCoord;
	bottomRightCoord.latitude = 90.0;
	bottomRightCoord.longitude = -180.0;
	
	for (id<MKAnnotation>annotation in self.annotations) 
    {
        if (!includeUser && annotation == self.userLocation)
            continue;
        
        if (![annotation conformsToProtocol:@protocol(MKAnnotation)])
            continue;
        
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
		
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
	}
	
	MKCoordinateRegion region;
	region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
	region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
	region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * mapZoomPadding; // Add a little extra space on the sides
	region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * mapZoomPadding; // Add a little extra space on the sides
	
	region = [self regionThatFits:region];
    
    if (abs(region.center.latitude) > 90.0) 
    {    
        if (abs(region.center.longitude) > 90.0) 
        {
            NSLog(@"[SM3DARMapView] Warning: Could not zoom map to fit point.  Invalid map region.");
            return;
            
        } 
        else 
        {
            NSLog(@"[SM3DARMapView] Warning: Invalid map region. \n\nSwitching map region's latitude and longitude.");
            CLLocationDegrees oldLatitude = region.center.latitude;
            region.center.latitude = region.center.longitude;
            region.center.longitude = oldLatitude;
        }
    }
    
	[self setRegion:region animated:YES];
}

- (void) zoomMapToFit 
{
    [self zoomMapToFitPointsIncludingUserLocation:YES];
}

#pragma mark Annotations

- (NSUInteger) nextPointIndentifier
{
    return ++currentPointIdentifier;    
}

- (SM3DAR_Point*) poiFromAnnotation:(id)object
{
    SM3DAR_Point *point = nil;

    if ([object conformsToProtocol:@protocol(SM3DAR_PointProtocol)])
    {
        // The object is a 3DAR point.
        
        point = object;
    }
    else
    {
        // Create a 3DAR POI from the object.
        
        if ([object conformsToProtocol:@protocol(MKAnnotation)])
        {
            // The object is an annotation so add it to the map.
            
            NSObject<MKAnnotation> *annotation = (NSObject<MKAnnotation>*)object;            
            NSString *title = nil;
            NSString *subtitle = nil;        
            CLLocationCoordinate2D coord;
            coord.latitude = annotation.coordinate.latitude;
            coord.longitude = annotation.coordinate.longitude;
            CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord 
                                                                 altitude:0.0
                                                       horizontalAccuracy:-1
                                                         verticalAccuracy:-1 
                                                                timestamp:nil];
            
            if ([annotation respondsToSelector:@selector(title)])
                title = [annotation title];
            
            if ([annotation respondsToSelector:@selector(subtitle)])
                subtitle = [annotation subtitle];
            
            SM3DAR_PointOfInterest *poi = [[[SM3DAR_PointOfInterest alloc] initWithLocation:location 
                                                             title:title
                                                          subtitle:subtitle
                                                               url:nil] autorelease];
            
            if ([annotation respondsToSelector:@selector(imageName)])
                poi.mapAnnotationImageName = [annotation performSelector:@selector(imageName)];
            
            point = poi;
            [location release];
        }
    }
    
    point.identifier = [self nextPointIndentifier];
    
    return point;
}

- (void) mapAnnotation:(id)object toPoint:(SM3DAR_Point*)point
{
    [pointAnnotations setObject:object
                         forKey:[NSString stringWithFormat:@"%u", point.identifier]];
}

- (void) addAnnotation:(id)object
{
    NSObject<MKAnnotation> *annotation = nil;

    SM3DAR_Point *point = [self poiFromAnnotation:object];

    if ([object conformsToProtocol:@protocol(MKAnnotation)])
    {
        // The object is an annotation so add it to the map.
        
        annotation = (NSObject<MKAnnotation>*)object;
        [super addAnnotation:annotation];
        
        [self mapAnnotation:annotation toPoint:point];
    }
    
    [sm3dar addPoint:point];    
}

- (void) addPoints:(NSArray *)points
{
    NSMutableArray *tmpPoints = [NSMutableArray arrayWithCapacity:[points count]];
    
    for (id object in points)
    {
        SM3DAR_Point *point = [self poiFromAnnotation:object];
        [self mapAnnotation:object toPoint:point];
        [tmpPoints addObject:point];
    }
    
    [sm3dar addPointsOfInterest:tmpPoints addToMap:NO];
}

- (void) addAnnotations:(NSArray *)annotations
{
    [super addAnnotations:annotations];
    
    [self performSelectorOnMainThread:@selector(addPoints:) withObject:annotations waitUntilDone:NO];
}

- (void) startCamera
{
    [sm3dar startCamera];
}

- (void) stopCamera
{
    [sm3dar stopCamera];
}

- (void) moveToLocation:(CLLocation *)newLocation
{
    if (newLocation)
    {
        [sm3dar changeCurrentLocation:newLocation];
        
        [self zoomMapToFitPointsIncludingUserLocation:NO];
    }
}

- (void) sm3darViewDidLoad:(SM3DAR_Controller *)_sm3dar
{
    [self add3darContainer:_sm3dar];
}

- (SM3DAR_Fixture*) addFixtureWithView:(SM3DAR_PointView*)pointView
{
    SM3DAR_Fixture *point = [[[SM3DAR_Fixture alloc] init] autorelease];
    point.view = pointView;  
    [sm3dar addPoint:point];

    return point;
}

- (void) addBackground
{
    SphereBackgroundView *sphereView = [[SphereBackgroundView alloc] initWithTextureNamed:@"pano_bg.png"];
    sm3dar.backgroundPoint = [self addFixtureWithView:sphereView];
    [sphereView release];
}


#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:viewForAnnotation:)])
    {
        return [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView viewForAnnotation:annotation];
    }
    else
    {
        return [sm3dar mapView:mapView viewForAnnotation:annotation];
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:regionWillChangeAnimated:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView regionWillChangeAnimated:animated];
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:regionDidChangeAnimated:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView regionDidChangeAnimated:animated];
    }
}


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapViewWillStartLoadingMap:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapViewWillStartLoadingMap:mapView];
    }
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapViewDidFinishLoadingMap:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapViewDidFinishLoadingMap:mapView];
    }
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapViewDidFailLoadingMap:withError:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapViewDidFailLoadingMap:mapView withError:error];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:didAddAnnotationViews:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView didAddAnnotationViews:views];
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:didSelectAnnotationView:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView didSelectAnnotationView:view];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:didDeselectAnnotationView:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView didDeselectAnnotationView:view];
    }
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapViewWillStartLocatingUser:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapViewWillStartLocatingUser:mapView];
    }
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapViewDidStopLocatingUser:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapViewDidStopLocatingUser:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)_userLocation
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:didUpdateUserLocation:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView didUpdateUserLocation:_userLocation];
    }
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:didFailToLocateUserWithError:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView didFailToLocateUserWithError:error];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState 
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:annotationView:didChangeDragState:fromOldState:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView annotationView:view didChangeDragState:newState fromOldState:oldState];
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:viewForOverlay:)])
    {
        return [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView viewForOverlay:overlay];
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews
{
    if ([sm3dar.delegate respondsToSelector:@selector(mapView:didAddOverlayViews:)])
    {
        [(id<MKMapViewDelegate>)sm3dar.delegate mapView:mapView didAddOverlayViews:overlayViews];
    }
}

- (id) annotationForPoint:(SM3DAR_Point *)point
{
    NSLog(@"Digging up annotation for point: %u", point.identifier);
    return [pointAnnotations objectForKey:[NSString stringWithFormat:@"%u", point.identifier]];
}

- (void) calloutViewWasTappedForPoint:(SM3DAR_Point *)point
{    
    id<MKAnnotation> annotation = [self annotationForPoint:point];
    MKAnnotationView *annView = [self mapView:self viewForAnnotation:annotation];    
    [self mapView:self annotationView:annView calloutAccessoryControlTapped:nil];
}

@end
