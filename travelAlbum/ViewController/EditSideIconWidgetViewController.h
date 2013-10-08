//
//  EditSideIconWidgetViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 22.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditSidebar.h"
#import "Sticker.h"
#import "IconWidget.h"

@interface EditSideIconWidgetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

	UITableView *tv;

	NSMutableArray *stickerThumbs; // array of imageview in cell
	NSMutableArray *availableStickers; //models

	
	int numOfColumn;
	CGSize thumbSize;
	CGFloat margin,w,h;
}

@property (nonatomic, unsafe_unretained) EditSidebar *sidebar;

@end
