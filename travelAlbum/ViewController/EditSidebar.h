//
//  EditSidebar.h
//  MyPhotoAlbum
//
//  Created by XC on 9/7/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlbumEditViewController.h"
//#import "PhotoAlbumViewController.h"
#import "AlbumsTableViewController.h"

/**

 作为一个容器，包含了Nav+vc
 
 自带navibar
 sidebar 可以做为一个navigationcontroller

 */
typedef enum {

	SidebarTypeNone,
	SidebarTypePhoto,
	SidebarTypeBG,
	SidebarTypeWidget,
	SidebarTypePage,
	SidebarTypeTemplate

}SidebarType;

@class PhotoAlbumViewController;
@class EditSideBGViewController, EditSidePageViewController, EditSideIconWidgetViewController;

@interface EditSidebar : UIView{
  
    AlbumsTableViewController *photoAlbumVC;
	EditSideBGViewController *bgVC;
	EditSidePageViewController *pageVC;
	EditSideIconWidgetViewController *iconWidgetVC;
	UINavigationController *bgNav,*widgetNav, *photoNav, *pageNav;
   
	
	
}

@property (nonatomic, unsafe_unretained) AlbumEditViewController *vc;
@property (nonatomic, assign) SidebarType type;

- (void)didReceiveMemoryWarning;

//- (void)reset; // reset all subNav,

- (BOOL)isOpen;
- (void)open;
- (void)close;

- (void)toPhotoNav;
//- (void)toIconWidgetView;
- (void)toBGView;
- (void)toPage;


@end
