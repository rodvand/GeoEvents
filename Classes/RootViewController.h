//
//  RootViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MyCLController.h"
#import "SearchViewViewController.h";

@interface RootViewController : UITableViewController <MyCLControllerDelegate>{
	IBOutlet UILabel *locationLabel;
	MyCLController *locationController;
	SearchViewViewController * searchViewViewController;
}
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@property (nonatomic, retain) SearchViewViewController * searchViewViewController;

@end
