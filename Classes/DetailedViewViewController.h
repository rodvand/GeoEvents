//
//  DetailedViewViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailedViewViewController : UIViewController {
	NSMutableArray * events;
}

@property (nonatomic, retain) NSMutableArray * events;

@end
