//
//  EditSideControlViewController.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumEditViewController.h"
#import "AlbumsTableViewController.h"
#import "MomentView.h"

@class AlbumsTableViewController;
@interface EditSideControlViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AlbumsTableViewControllerDelegate>{
    UITableView *tv;
    
    AlbumsTableViewController *changeBGATVC;
    AlbumsTableViewController *addPhotoATVC;
    
    NSArray *tableKeys;
 
}

@property (nonatomic, unsafe_unretained) AlbumEditViewController *vc;
@property (nonatomic, unsafe_unretained) MomentView *momentV;
@property (nonatomic, assign) BOOL hasCaption;

@end
