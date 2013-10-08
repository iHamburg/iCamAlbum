//
//  EditSideBGViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 18.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditSidebar.h"


@interface EditSideBGViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

	UITableView *tv;
	UIButton *startSlideB;

	NSArray *bgImgNames;
	NSMutableArray *thumbVs; // array of imageview in cell

	UIPopoverController *pop;
    
	int numOfColumn;
	CGSize thumbSize;
	CGFloat margin,w,h;
}

@property (nonatomic, unsafe_unretained) EditSidebar *sidebar;

@end
