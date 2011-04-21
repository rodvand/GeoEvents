//
//  TexturedGeometryView.m
//
//

#import <OpenGLES/ES1/gl.h>
#import "TexturedGeometryView.h"

@implementation TexturedGeometryView

@synthesize zrot, color, geometry, texture, textureName, textureURL, sizeScalar;

- (id) initWithPointOfInterest:(SM3DAR_PointOfInterest*)poi {
    if (self = [self initWithTextureNamed:nil]) {    
        self.point = poi;
    }
    return self;
}

- (id) initWithTextureNamed:(NSString*)name {
  self.textureName = name;
  if (self = [super initWithFrame:CGRectZero]) {    
  }
  return self;
}

- (id) initWithTextureURL:(NSURL*)url {
  self.textureURL = url;
  if (self = [super initWithFrame:CGRectZero]) {    
  }
  return self;
}

- (void) dealloc {
    NSLog(@"\n\n[TexturedGeometryView] dealloc\n\n");
    [color release];
    [geometry release];
    [texture release];
    [textureName release];
    [textureURL release];
    [super dealloc];
}


#pragma mark -
/*
// Subclasses should implement didReceiveFocus
- (void) didReceiveFocus {
}
*/

#pragma mark -
- (void) updateTexture:(UIImage*)textureImage {
  if (textureImage) {
    NSLog(@"[TexturedGeometryView] updating texture with %@", textureImage);
    [texture replaceTextureWithImage:textureImage.CGImage];
  }
}

- (void) updateImage:(UIImage*)img {
  NSLog(@"[TexturedGeometryView] resizing image from original: %f, %f", img.size.width, img.size.height);
  img = [self resizeImage:img];
  //NSLog(@"[TexturedGeometryView] DONE: %f, %f", img.size.width, img.size.height);
  [self updateTexture:img];
}

- (UIImage*) resizeImage:(UIImage*)originalImage {
	//CGPoint topCorner = CGPointMake(0, 0);
	CGSize targetSize = CGSizeMake(512, 256);	
	
	UIGraphicsBeginImageContext(targetSize);	
	[originalImage drawInRect:CGRectMake(0, 0, 512, 256)];	
	UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();	
	
	return result;	
}

// Subclasses should implement displayGeometry
- (void) displayGeometry {
}

- (void) drawInGLContext {
  [self displayGeometry];
}

@end
