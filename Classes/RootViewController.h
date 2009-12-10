//
//  RootViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MyCLController.h"
#import "SearchViewViewController.h";

@interface RootViewController : UIViewController <MyCLControllerDelegate>{
	IBOutlet UILabel * locationLabel;
	IBOutlet UITextField * searchField;
	MyCLController *locationController;
	SearchViewViewController * searchViewViewController;
}
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (IBAction)search:(id)sender;

@property (nonatomic, retain) SearchViewViewController * searchViewViewController;
@property (nonatomic, retain) UITextField * searchField;

@end
