//
//  PhotoDisplayViewController.m
//  travelAlbum
//
//  Created by XC on 7/19/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoTableViewController.h"
#import "AlbumEditViewController.h"

#import "UIImageView+WebCache.h"
#import "ImageModelView.h"

@interface PhotoTableViewController ()


@end

@implementation PhotoTableViewController

static CGFloat margin = 4;;

- (void)loadView{
    [super loadView];
    
    

	thumbsInRow = [NSMutableArray array];

	_numOfColumn = 4;
	_thumbSize = isPad?CGSizeMake(75, 75):CGSizeMake(48, 48);

	
	self.view.backgroundColor = [UIColor blackColor];

    tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.backgroundColor = [UIColor whiteColor];
	tableView.autoresizingMask = kAutoResize;
    [self.view addSubview:tableView];
    
    
    /// 这里控制pop+nav 的size！！
    self.contentSizeForViewInPopover = CGSizeMake(self.view.width, self.view.height);

}

- (void)viewDidAppear:(BOOL)animated{
	L();
	[super viewDidAppear:animated];

	[tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
	
}



#pragma mark -
#pragma mark UITableViewDataSource Delegate Methods




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	int num = 1;
	int allCount = [_inputs count];
    
	if (section == 0) {
		num = ceil((float)allCount/_numOfColumn);
	}

	return num + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  
	return _thumbSize.height + margin;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier1 = @"Cell1";

	UITableViewCell *cell;
	
		
	cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
	[thumbsInRow removeAllObjects];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier1];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
		for (int i = 0; i<_numOfColumn; i++) {
			
			UIImageView *v = [[UIImageView alloc]initWithFrame:CGRectMake(margin+(_thumbSize.width+margin)*i, margin, _thumbSize.width, _thumbSize.height)];
			v.userInteractionEnabled = YES;
			v.contentMode = UIViewContentModeScaleAspectFit;
			[v addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			[thumbsInRow addObject:v];
			[cell.contentView addSubview:v];
		}
	}
	else{
		
		[thumbsInRow addObjectsFromArray:cell.contentView.subviews];
		
	}

		
    [self layoutCellAt:indexPath];

	return cell;
	
}


#pragma mark - IBAction
- (void)layout:(int)index imgV:(UIImageView *)imgV {
    NSString * imgName = _inputs[index];
    imgV.tag = index+1;
    imgV.image = [UIImage imageWithContentsOfFileUniversal:imgName];
}

- (void)layoutCellAt:(NSIndexPath *)indexPath{
    for (int i = 0; i< _numOfColumn ; i++) {
		int index = indexPath.row * _numOfColumn +i;
		
		UIImageView *imgV = thumbsInRow[i];
		
		if (index<[_inputs count]) {
			
			[self layout:index imgV:imgV];
		}
		else{
			// 防止最后一行多出的thumb被点击
			imgV.tag = 0;
			imgV.image = nil;
		}
		
	}

}
//
- (void)handleTap:(UITapGestureRecognizer*)tap{
	

}


#pragma mark -

- (void)reloadTableView{
    [tableView reloadData];
}

@end
