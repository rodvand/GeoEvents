//
//  LastfmViewController.h
//  GeoEvents
//
//  Created by Martin Rødvand on 10/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import <UIKit/UIKit.h>

/* letter-prefix: l */

@interface LastfmViewController : UITableViewController {

}

enum {
	lCredentials = 0,
	lNUM_SECTIONS
};

enum {
	lUsername = 0,
	lPassword,
	lNUM_LOGIN_ROWS
};

@end
