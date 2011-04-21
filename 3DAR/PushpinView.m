//
//  PushpinView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "PushpinView.h"

#import "Pushpin.h"  // Statically stored pushpin geometry.

#define PPV_SHADOW_VERTEX_COUNT 16

@implementation PushpinView

static float ppvShadowVerts[PPV_SHADOW_VERTEX_COUNT][3];
static unsigned short ppvShadowIndexes[PPV_SHADOW_VERTEX_COUNT];
static Geometry *pushpinGeometry;
static Texture *pushpinTexture;

//@synthesize label;


- (void) dealloc
{
    [label release];
    
    [super dealloc];
}

- (void) buildView 
{
	self.frame = CGRectZero;
    self.color = [UIColor redColor];
    self.hidden = NO;    
    self.zrot = 0.0;    

    self.sizeScalar = 20.0;  // for pushpin_1.0
    
//    self.sizeScalar = 5.0;  // for pushpin_textured
    
    NSLog(@"[PushpinView] buildView");
    
    if (!pushpinGeometry)
    {
        // Works
        NSString *path = [[NSBundle mainBundle] pathForResource:@"pushpin_1.0" ofType:@"obj"];
        
        // Experimental
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"pushpin_textured" ofType:@"obj"];
        
        pushpinGeometry = [[Geometry newOBJFromResource:path] autorelease];
    }
    
    self.geometry = pushpinGeometry;
    self.geometry.cullFace = YES;
    
    // Shadow    
    
    CGFloat radius = 2.5;
	
	for (int i=0; i < PPV_SHADOW_VERTEX_COUNT; i++)
	{
		float theta = 2 * M_PI * i / PPV_SHADOW_VERTEX_COUNT;
		
		ppvShadowVerts[i][0] = radius * cos(theta);
		ppvShadowVerts[i][1] = radius * sin(theta);
		ppvShadowVerts[i][2] = 0.0; //GROUNDPLANE_ALTITUDE_METERS - POI_ALTITUDE_METERS;
		
		ppvShadowIndexes[i] = i;
	}

    
//    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
//    label.font = [UIFont fontWithName:@"Courier" size:14];    
//    [self addSubview:label];    
    
}

/*
static float rlLineVertex[2][3] =
{
    // x y z 
    { 0, 0, (POI_ALTITUDE_METERS-5.0) },
    { 0, 0, (GROUNDPLANE_ALTITUDE_METERS-POI_ALTITUDE_METERS) }
};

static unsigned short rlLineIndex[2] = 
{
    0, 1
};
*/

- (void) displayGeometry 
{
    /*
    if ([label.text length] == 0)
    {
        SM3DAR_PointOfInterest *poi = (SM3DAR_PointOfInterest *)self.point;

        if (poi)
        {
            label.text = [[poi formattedDistanceInMilesFromCurrentLocation] stringByAppendingString:@" mi"];
            [label sizeToFit];
        }
    }
     */
    
    if (!texture)
    {
//        textureName = @"pushpin_textured2.jpg";
        textureName = @"red.png";
    }
    
    if (!texture && [textureName length] > 0) 
    {
        if (!pushpinTexture)
        {
            NSLog(@"Loading texture named %@", textureName);

            NSString *textureExtension = [[textureName componentsSeparatedByString:@"."] objectAtIndex:1];
            NSString *textureBaseName = [textureName stringByDeletingPathExtension];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:textureBaseName ofType:textureExtension];
            NSData *imageData = [[NSData alloc] initWithContentsOfFile:imagePath]; 
            UIImage *textureImage =  [[UIImage alloc] initWithData:imageData];
            CGImageRef cgi = textureImage.CGImage;
            
            pushpinTexture = [Texture newTextureFromImage:cgi];
            
            [imageData release];
            [textureImage release];
            
        }

        self.texture = pushpinTexture;        
    }

    

    // Scale last.
    
//    glTranslatef(0, 0, -100);    
    
    glScalef(sizeScalar, sizeScalar, sizeScalar); //*0.85);
        

    // Shadow
    
    glLineWidth(1.0);
    glColor4f(.2, .2, .2, 0.6);
	glVertexPointer(3, GL_FLOAT, 0, ppvShadowVerts);
	glDrawElements(GL_TRIANGLE_FAN, PPV_SHADOW_VERTEX_COUNT, GL_UNSIGNED_SHORT, ppvShadowIndexes);

//    [self.geometry displayShaded:self.color];
    [self.geometry displayFilledWithTexture:texture];
    
    

    
    /////////
/*
//    glTranslatef(0, 0, -100);
    glRotatef(90.0, 1.0, 0, 0);

    glScalef(100, 100, 100);

    glColor4f(1.0, 0, 0, 1.0);
    glVertexPointer(3, GL_FLOAT, 0, pushpinVerts);
    glTexCoordPointer(2, GL_FLOAT, 0, pushpinTexCoords);
//    glNormalPointer(GL_FLOAT, 0, pushpinNormals);
    glDrawArrays(GL_TRIANGLES, 0, pushpinNumVerts);
    
*/

}

- (void) didReceiveFocus
{
//    self.color = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.25];
}

- (void) didLoseFocus
{
//    self.color = [UIColor redColor];
}


@end
