//
//  FBAlbumsViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FacebookManager.h"



/**

 placeholder : ipad: 57x57 iphone: 30

 */


@class PhotoTableViewController;

@interface FBAlbumsViewController : UITableViewController<FBRequestDelegate>{
	NSMutableArray *albums; // fb
	PhotoTableViewController *photoDisplayVC;
	
	UIBarButtonItem *reloadBB;
	FacebookManager *fbManager;
	
	BOOL reloadingFlag;

}

- (void)updateFBAlbums;
- (void)reloadAlbums;
@end
