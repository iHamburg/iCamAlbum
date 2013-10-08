//
//  FBAlbumsViewController.m
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FBAlbumsViewController.h"
#import "PhotoTableViewController.h"
#import "ImageConstentWidthCell.h"

@interface FBAlbumsViewController ()


@end

@implementation FBAlbumsViewController

- (void)dealloc{
	L();
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
	
    [super viewDidLoad];

		L();
	self.view.frame = CGRectMake(0, 0, kwSidebar, kSideBarContentHeight);
	
	/**
	
	 要等待fbloading
	 
	 */
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFBAlbums) name:kNotificationFinishRequestAlbums object:nil];
	
	reloadBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(buttonClicked:)];
	self.navigationItem.rightBarButtonItem = reloadBB;
	

	albums = [NSMutableArray array];
	
	// send request for albums
	
	fbManager = [FacebookManager sharedInstance];

	

	if (ISEMPTY(fbManager.fbAlbums)) {
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
		
//		[[LoadingView sharedLoadingView]addInView:self.tableView];
		
		[fbManager requestAlbums];
	}
	// tableVC 如果直接用
	

}

- (void)viewWillAppear:(BOOL)animated{
	L();
	[super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
	L();
	[super viewDidAppear:animated];

	[self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}


#pragma mark - IBAction
- (IBAction)buttonClicked:(id)sender{
	if (sender == reloadBB) {
		
		// 如果没有正在reload albums，那么reload
		if (!reloadingFlag) {
			[self reloadAlbums];
		}
		
	}
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return isPad?57:40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [fbManager.fbAlbums count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";

    ImageConstentWidthCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];


	if (!cell) {
		cell = [[ImageConstentWidthCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont systemFontOfSize:isPad?18:10];
	}

	
	FBAlbum *album = fbManager.fbAlbums[indexPath.row];
	cell.textLabel.text = [album.name stringByAppendingFormat:@" (%d)",album.numberOfPhotos];
	
	if (album.coverImage) {
		[cell.imageView setImage:album.coverImage];
	}
	else{
		cell.imageView.image = kPlaceholderImage;
	}


	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//	
//	FBAlbum *album = fbManager.fbAlbums[indexPath.row];
//
//	photoDisplayVC = [[PhotoTableViewController alloc]init];
//	
//	photoDisplayVC.fbPhotos = album.fbPhotos;
//
//	photoDisplayVC.title = album.name;
//	
//	[self.navigationController pushViewController:photoDisplayVC animated:YES];
}

#pragma mark -
- (void)reloadAlbums{
	reloadingFlag  = YES;
	
//	[[LoadingView sharedLoadingView]addInView:self.tableView];
	
	[fbManager requestAlbums];
}

- (void)updateFBAlbums{
	
	L();
//	[[LoadingView sharedLoadingView]removeView];

	reloadingFlag = NO;
	
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	
	self.title = fbManager.fbUserName;
	
	[self.tableView reloadData];
//	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
//	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:1];
//	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:2];
//	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:3];
}

@end
