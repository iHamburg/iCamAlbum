//
//  PhotoDisplayViewController.h
//  travelAlbum
//
//  Created by XC on 7/19/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlbumsTableViewController.h"

typedef enum {
	PhotoSourceNone,
	PhotoSourceSystem,
	PhotoSourceAlbum,
	PhotoSourceFacebook
}PhotoSource;


@interface PhotoTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

	UITableView *tableView;
	

	NSMutableArray *thumbsInRow; //
	NSMutableArray *_inputs;
	

	CGSize _thumbSize;
    int _numOfColumn;

    __unsafe_unretained AlbumsTableViewController *_vc;
}

@property (nonatomic, unsafe_unretained) AlbumsTableViewController *vc;
@property (nonatomic, assign) int numOfColumn;
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, strong) NSArray *inputs;

- (void)reloadTableView;

- (void)layout:(int)index imgV:(UIImageView *)imgV;
- (void)layoutCellAt:(NSIndexPath*)indexPath;

@end
