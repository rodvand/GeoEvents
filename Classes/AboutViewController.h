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
	tNUM_SECTIONS
};

enum {
	tAboutRow = 0,
	tWebsiteRow,
	tIconThanks,
	tOtherThanks,
	tNUM_ROWS
};

@end
