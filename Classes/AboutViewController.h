//
//  AboutViewController.h
//  GeoEvents
//
//  Created by Martin Rødvand on 05/02/2010.
//  Copyright 2010 Redwater software. All rights reserved.
//

#import <UIKit/UIKit.h>
/* t-letter prefix */

@interface AboutViewController : UITableViewController {

}

enum {
	tAbout = 0,
	tIcon,
	tNUM_SECTIONS
};

enum {
	tAboutRow = 0,
	tWebsiteRow,
	tNUM_ROWS
};

enum {
	tIconThanks = 0,
	tNUM_ICON_ROWS
};

@end
