//
//  MarkerCalloutView.h
//
//  Created by P. Mark Anderson on 4/21/11.
//  Copyright 2011 Spot Metrix, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SM3DAR.h"

@protocol MarkerCalloutViewDelegate
- (void) calloutViewWasTappedForPoint:(SM3DAR_Point *)point;
@end

@interface MarkerCalloutView : UIView <SM3DAR_FocusDelegate>
{
    UILabel *titleLabel;
    UILabel *subtitleLabel;
    UILabel *distanceLabel;
    UIButton *disclosureButton;    
    SM3DAR_Point *focusedPoint;
    id<MarkerCalloutViewDelegate> delegate;
}

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *subtitleLabel;
@property (nonatomic, retain) UILabel *distanceLabel;
@property (nonatomic, retain) UIButton *disclosureButton;    
@property (nonatomic, assign) id<MarkerCalloutViewDelegate> delegate;

@end
