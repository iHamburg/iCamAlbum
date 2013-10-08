//
//  EditSidePageViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 20.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EditSidebar.h"

@interface EditSidePageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
	AlbumManager *manager;
	
	UITableView *tv;
    UIBarButtonItem *editBB, *doneBB, *addBB;
    UIImageView *selected;
	CAGradientLayer *gradientLayer;
	
	
	CGSize thumbSize;
	CGFloat margin;

}

@property (nonatomic, unsafe_unretained) EditSidebar *sidebar;
//@property (nonatomic, strong) Album *album;
@property (nonatomic, readonly, strong) MomentManager *momentManager;

- (void)setup;

- (void)addPage; //增加在最后
- (void)deletePage:(int)index;
- (void)movePage:(int)indexA toPage:(int)indexB;
- (void)updatePage;
@end
