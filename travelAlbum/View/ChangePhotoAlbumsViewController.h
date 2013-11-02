//
//  ChangePhotoAlbumsViewController.h
//  Everalbum
//
//  Created by AppDevelopper on 13-8-30.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "AlbumsTableViewController.h"
#import "EGORefreshTableHeaderView.h"
@interface ChangePhotoAlbumsViewController : AlbumsTableViewController<EGORefreshTableHeaderDelegate>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

@end
