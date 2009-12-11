//
//  RootViewController.h
//  GeoEvents_final
//
//  Created by Martin Roedvand on 07/12/2009.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MyCLController.h"
#import "SearchViewViewController.h"
#import "SettingsViewController.h"

@interface RootViewController : UIViewController <MyCLControllerDelegate>{
	IBOutlet UILabel * latitudeLabel;
	IBOutlet UILabel * longitudeLabel;
	IBOutlet UILabel * statusLabel;
	IBOutlet UITextField * searchField;
	IBOutlet UIActivityIndicatorView * activity;
	MyCLController *locationController;
	SearchViewViewController * searchViewViewController;
	SettingsViewController * settingsViewController;
	NSNumber * latitude;
	NSNumber * longitude;
}
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
- (IBAction)search:(id)sender;
- (IBAction)goToSettings:(id)sender;

@property (nonatomic, retain) SearchViewViewController * searchViewViewController;
@property (nonatomic, retain) SettingsViewController * settingsViewController;
@property (nonatomic, retain) UITextField * searchField;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) UIActivityIndicatorView * activity;
@property (nonatomic, retain) UILabel * latitudeLabel;
@property (nonatomic, retain) UILabel * longitudeLabel;
@property (nonatomic, retain) UILabel * statusLabel;
@end
