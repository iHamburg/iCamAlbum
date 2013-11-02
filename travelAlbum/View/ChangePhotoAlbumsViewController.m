//
//  ChangePhotoAlbumsViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-30.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "ChangePhotoAlbumsViewController.h"

@interface ChangePhotoAlbumsViewController ()

@end

@implementation ChangePhotoAlbumsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    

    if (isPhone) {
        UIBarButtonItem *backBB = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];
        self.navigationItem.rightBarButtonItem = backBB;
        
    }

    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, self.view.frame.size.width, tableView.bounds.size.height)];
		view.delegate = self;
		[tableView addSubview:view];
		_refreshHeaderView = view;
		
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (section == 0) {
        
            return 1;
      	}
	else if(section == 1){

        return [assetGroups count] + 2;
    }
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //	return isPad?100:60;
	return 55;
}

// 30/16
- (void)layoutCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) { //system
        cell.imageView.image = [[UIImage imageWithSystemName:@"AlbumBG_13.jpg"] imageByScalingAndCroppingForSize:CGSizeMake(55, 55)];
		cell.textLabel.text = [NSString stringWithFormat:@"%@ Photos",APPNAME];


	}
  	else if (indexPath.section == 1){ //photoalbum


        int row = indexPath.row;
        if (row < [assetGroups count]) {
            ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row ];
            NSInteger gCount = [g numberOfAssets];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
            [cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
            
        }
        else{
            cell.textLabel.text = nil;
            cell.imageView.image = nil;
        }

    }
}


- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
	if (indexPath.section == 0) {

        if (isPhone5) {
            _numOfColumn = 5;
        }
        else if(isPhone4){
            _numOfColumn = 4;
        }
        else
            _numOfColumn = 3;
        
        _thumbSize = CGSizeMake(108, 72);
        [self pushPhotoTableVCWithImgNames:_imgNames];
  
    }
	else if (indexPath.section == 1) {
            ALAssetsGroup *group = assetGroups[indexPath.row ];
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            if (isPhone4) {
                _numOfColumn = 6;
                _thumbSize = CGSizeMake(75, 75);
            }
            else if(isPhone5){
                _numOfColumn = 7;
                _thumbSize = CGSizeMake(75, 75);
            }
            else if(isPad){
                _numOfColumn = 4;
                _thumbSize = CGSizeMake(75, 75);
            }
            [self pushPhotoTableVCWithAssetsGroup:group];

        }
        

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}



@end
