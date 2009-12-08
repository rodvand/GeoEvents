//
//  SearchViewViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 08/12/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailedViewViewController.h"

@interface SearchViewViewController : UITableViewController {
	DetailedViewViewController * detailedViewController;
}

@property (nonatomic, retain) DetailedViewViewController * detailedViewController;
@end
