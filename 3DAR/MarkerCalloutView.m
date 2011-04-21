//
//  MarkerCalloutView.m
//
//  Created by P. Mark Anderson on 4/21/11.
//  Copyright 2011 Spot Metrix, Inc. All rights reserved.
//

#import "MarkerCalloutView.h"
#import <QuartzCore/QuartzCore.h>


@interface MarkerCalloutView (Private)
- (void) stylizeLabel:(UILabel *)label fontSize:(CGFloat)fontSize;
@end

@implementation MarkerCalloutView

@synthesize delegate;
@synthesize titleLabel;
@synthesize subtitleLabel;
@synthesize distanceLabel;
@synthesize disclosureButton;

- (void) dealloc 
{
    self.titleLabel = nil;
    self.subtitleLabel = nil;
    self.distanceLabel = nil;
    self.disclosureButton = nil;
    [focusedPoint release];
    
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 300, 66)];  // 44 for single line mode

    if (self) 
    {
        self.backgroundColor = [UIColor clearColor];
        
        CALayer *l = self.layer;
        [l setMasksToBounds:YES];
        [l setCornerRadius:12.0];
        [l setBorderWidth:1.0];
        [l setBorderColor:[[UIColor darkGrayColor] CGColor]];
        
        UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = [UIColor darkTextColor];
        bg.alpha = 0.5;
        [self addSubview:bg];
        [bg release];
        
        
        // Add gloss effect.
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
//        [gradient setCornerRadius:6.0];

        CGFloat padding = 0.0;
//        CGFloat halfHeight = self.bounds.size.height/2.0 - padding;
        CGFloat thirdHeight = self.bounds.size.height/3.0 - padding;

//        gradient.frame = CGRectMake(padding, 
//                                    padding, 
//                                    self.bounds.size.width-(2.0*padding), 
//                                    halfHeight);

        gradient.frame = CGRectMake(padding, 
                                    thirdHeight+padding, 
                                    self.bounds.size.width-(2.0*padding), 
                                    thirdHeight*2.0);
        
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
//        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];

        [l insertSublayer:gradient atIndex:0];
        
        
        
        // W 300: 10 _45_ 10 _LABEL_ 10 _25_ 10: 100 + LABEL
        // H  66: 10 22 _8_ 16 10
        
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(65, 10, 190, 22)] autorelease];
        [self stylizeLabel:titleLabel fontSize:22];

        self.subtitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(65, 34, 190, 16)] autorelease];
        [self stylizeLabel:subtitleLabel fontSize:16];
        
        self.distanceLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 45, 46)] autorelease];
        [self stylizeLabel:distanceLabel fontSize:12];
        distanceLabel.lineBreakMode = UILineBreakModeWordWrap;
        distanceLabel.textColor = [UIColor lightGrayColor];
        distanceLabel.textAlignment = UITextAlignmentCenter;
        
        self.disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [disclosureButton addTarget:self action:@selector(disclosureButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        disclosureButton.center = CGPointMake(300-23, 33);

        [self addSubview:titleLabel];
        [self addSubview:subtitleLabel];
        [self addSubview:distanceLabel];
        [self addSubview:disclosureButton];
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)pointDidGainFocus:(SM3DAR_Point*)point
{
    focusedPoint = [point retain];
    
    NSString *titleText = nil;
    NSString *subtitleText = nil;
    NSString *distanceText = nil;

    SEL sel = @selector(title);
    if ([point respondsToSelector:sel])
        titleText = [point performSelector:sel];
    if (!titleText)
        titleText = @"";

    sel = @selector(subtitle);
    if ([point respondsToSelector:sel])
        subtitleText = [point performSelector:sel];
    if (!subtitleText)
        subtitleText = @"";
        
    sel = @selector(formattedDistanceFromCurrentLocationWithUnits);
    if ([point respondsToSelector:sel])
        distanceText = [point performSelector:sel];
    if (!distanceText)
        distanceText = @"";
    
    
    // TODO: Switch display modes based on available text.
    
    titleLabel.text = titleText;
    subtitleLabel.text = subtitleText;
    distanceLabel.text = distanceText;

    self.hidden = NO;
    [self.superview.superview bringSubviewToFront:self.superview];
    [self.superview bringSubviewToFront:self];
}

-(void)pointDidLoseFocus:(SM3DAR_Point*)point
{
    [focusedPoint release];
    self.hidden = YES;
}

- (void) stylizeLabel:(UILabel *)label fontSize:(CGFloat)fontSize
{
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor blackColor];        
    label.shadowOffset = CGSizeMake(1, 1);
    label.font = [UIFont systemFontOfSize:fontSize];
    label.adjustsFontSizeToFitWidth = YES;
    label.lineBreakMode = UILineBreakModeTailTruncation;
}

- (void) disclosureButtonTapped
{
    [delegate calloutViewWasTappedForPoint:focusedPoint];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    [self disclosureButtonTapped];
}

@end
