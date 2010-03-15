//
//  AccountsViewController.h
//  GeoEvents
//
//  Created by Martin Rødvand on 12/03/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AccountsViewController : UITableViewController {
	

}

enum GEAccountSettings {
	GEAccountFacebook = 0,
	GEAccountTwitter,
	GEAccountLastFM
};

@end
