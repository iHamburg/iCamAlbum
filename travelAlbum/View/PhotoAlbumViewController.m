//
//  PhotoAlbumViewController.m
//  travelAlbum
//
//  Created by XC on 7/19/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoAlbumViewController.h"
#import "PhotoTableViewController.h"
#import "FBAlbumsViewController.h"

@interface PhotoAlbumViewController ()

- (void)pushPhotoAlbum:(ALAssetsGroup*)group;
- (void)pushFBAlbums;
@end

@implementation PhotoAlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.view.frame = CGRectMake(0, 0, kwSidebar, kSideBarContentHeight);
	
	self.title = @"Photos";
	
	assetGroups = [NSMutableArray array];

	
    /// 这里Library一定要存在，在load完之后可以设为nil
    library = [[ALAssetsLibrary alloc] init];      
	

	void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) 
	{
		if (group == nil) 
		{
			return;
		}
	
		[assetGroups addObject:group];
		
		// Reload albums

		[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
		
	};
	
	// Group Enumerator Failure Block
	void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
		NSLog(@"A problem occured %@", [error description]);	                                 
	};	
	
	// Enumerate Albums， asyn
	[library enumerateGroupsWithTypes:ALAssetsGroupAll
						   usingBlock:assetGroupEnumerator 
						 failureBlock:assetGroupEnumberatorFailure];

}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
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
		return [assetGroups count];
	}
	else if(section == 1){
		return 1;
	}
	
    return 1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	NSString *header;
	if (section == 0) {
		header =  @"Photo Album";
	}
	else if(section == 1){
		header =  @"Facebook";
	}
	
	return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return isPad?100:60;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont systemFontOfSize:isPad?20:12];
		cell.textLabel.backgroundColor = [UIColor clearColor];

    }
    
	if (indexPath.section == 0) {
		ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
		[g setAssetsFilter:[ALAssetsFilter allPhotos]];
		NSInteger gCount = [g numberOfAssets];
		
		cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
		[cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
	}
  	else if (indexPath.section == 1){ //facebook
		cell.imageView.image = [UIImage imageNamed:@"icon_shareFB2.png"];
		cell.textLabel.text = @"From Facebook";
		
	}

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {

		ALAssetsGroup *group = assetGroups[indexPath.row];
		[group setAssetsFilter:[ALAssetsFilter allPhotos]];
		[self pushPhotoAlbum:group];
	}
	else if(indexPath.section == 1){

		
		[self pushFBAlbums];
	}
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Push

- (void)pushPhotoAlbum:(ALAssetsGroup*)group{
	if (!photoDisplayVC) {
		photoDisplayVC= [[PhotoTableViewController alloc]init];
		photoDisplayVC.view.alpha = 1;
	}
	
//	photoDisplayVC.assetGroup = group;
//	photoDisplayVC.title = [group valueForProperty:ALAssetsGroupPropertyName];
//	
//	[self.navigationController pushViewController:photoDisplayVC animated:YES];
}
- (void)pushFBAlbums{
	if (!fbVC) {
		fbVC = [[FBAlbumsViewController alloc]initWithStyle:UITableViewStylePlain];
		fbVC.view.alpha = 1;
	}
	
	[self.navigationController pushViewController:fbVC animated:YES];

}


@end
