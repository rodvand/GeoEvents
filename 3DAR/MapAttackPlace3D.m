//
//  MapattackPlace3D.m
//  GeoEvents
//
//  Created by P. Mark Anderson on 4/22/11.
//  Copyright 2011 Redwater software. All rights reserved.
//

#import "MapAttackPlace3D.h"
//#import "OBJView.h"

@implementation MapAttackPlace3D

@synthesize placeID;
@synthesize points;
@synthesize active;
@synthesize team;
@synthesize coordinate;

- (void) dealloc
{
    [placeID release];
    [team release];
    
    [super dealloc];
}

- (id) initWithProperties:(NSDictionary *)props
{
    CLLocationCoordinate2D c;
    c.longitude = [[props objectForKey:@"longitude"] doubleValue];
    c.latitude = [[props objectForKey:@"latitude"] doubleValue];

    CLLocation *location = [[[CLLocation alloc] initWithLatitude:c.latitude 
                                                  longitude:c.longitude] autorelease];
    
    if (self = [super initWithLocation:location properties:props])
    {
        self.placeID = [props objectForKey:@"place_id"];
        self.points = [[props objectForKey:@"points"] integerValue];

        id value = [props objectForKey:@"team"];
  
        if (value && value != [NSNull null])
            self.team = value;
        else
            self.team = nil;
        
        self.active = [[props objectForKey:@"active"] boolValue];
        self.coordinate = c;

        NSString *objName = @"flag_ufo.obj";
        UIColor *objColor = nil;
        CGFloat sizeScalar = 1.0;

        if ([team length] > 0)
        {
            // red or blue
            
            if ([team isEqualToString:@"blue"])
            {
                objColor = [UIColor blueColor];                
            }
            else
            {
                objColor = [UIColor redColor];
            }
        }
        else
        {
            objColor = [UIColor yellowColor];
        }

        switch (self.points) 
        {
            case 10:
                objName = @"cube.obj";
                sizeScalar = 30.0;
                break;
            case 20:
                objName = @"flag_ufo.obj";
                sizeScalar = 8.0;
                break;
            case 30:
                objName = @"star.obj";
                sizeScalar = 3.5;
                break;
            case 50:
                objName = @"moebius.obj";
                sizeScalar = 1.1;
                break;
            default:
                break;
        }
        
//        OBJView *objView = [[OBJView alloc] initWithOBJ:objName 
//                                           textureNamed:nil];
        TexturedGeometryView *objView = [[TexturedGeometryView alloc] initWithOBJ:objName 
                                           textureNamed:nil];
        
        objView.sizeScalar = sizeScalar;
        objView.color = objColor;
        
        self.view = objView;
        [objView release];  
        

        UIImage *img = [UIImage imageNamed:@"3dar_marker_icon1.png"];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];    
        objView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
        [objView addSubview:iv];
        [iv release];
        
    }
    
    return self;
}

- (NSString *)title
{
    NSString *t = self.team;
    
    if (!t || [t length] == 0)
    {
        t = @"Open";
    }
    
    return t;
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"%i", self.points];
}

@end
