//
//  TexturedGeometryView.h
//
//

#import <UIKit/UIKit.h>
#import "SM3DAR.h"


@interface TexturedGeometryView : SM3DAR_PointView {
  double zrot;
  UIColor *color;
  Geometry *geometry;
  Texture *texture;
  NSString *textureName;
  NSURL *textureURL;
    CGFloat sizeScalar;
}

@property (nonatomic) double zrot;
@property (nonatomic, retain) UIColor *color;
@property (nonatomic, retain) Geometry *geometry;
@property (nonatomic, retain) Texture *texture;
@property (nonatomic, retain) NSString *textureName;
@property (nonatomic, retain) NSURL *textureURL;
@property (nonatomic, assign) CGFloat sizeScalar;

- (id) initWithTextureNamed:(NSString*)name;
- (id) initWithTextureURL:(NSURL*)url;
- (void) drawInGLContext;
- (void) updateTexture:(UIImage*)textureImage;
- (void) updateImage:(UIImage*)newImage;
- (UIImage*) resizeImage:(UIImage*)originalImage;
- (void) displayGeometry;

@end
