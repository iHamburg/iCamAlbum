//
//  PhotoAlbumViewController.h
//  travelAlbum
//
//  Created by XC on 7/19/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "FBPhoto.h"

/**
 最上有searchbar，可以搜索web content
 
 1. 显示我们的图片 row ：1
 
 2. 显示所有的 photo album groups，row; numOfGroups
 
 3.1 如果facebook没有登陆，row ：1 =》From Facebook
 
 3.2 如果facebook登陆， row ：num Of facebook album
  
 */

@class FBAlbumsViewController,PhotoTableViewController;

@interface PhotoAlbumViewController : UITableViewController{

	FBAlbumsViewController *fbVC;
	PhotoTableViewController *photoDisplayVC;
	
	NSMutableArray *assetGroups;
    ALAssetsLibrary *library;


}


@end
