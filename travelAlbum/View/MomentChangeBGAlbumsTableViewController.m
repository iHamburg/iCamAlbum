//
//  MomentChangeBGAlbumsTableViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "MomentChangeBGAlbumsTableViewController.h"


@implementation MomentChangeBGAlbumsTableViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	
	if (section == 0) {
            return 1;
	}
	else if(section == 1){
        
		return [assetGroups count]+3;
	}
	
    return 1;
}


- (void)layoutCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) { //imagePhotoAlbum
		cell.imageView.image = [UIImage imageWithSystemName:@"MusterBG5.jpg"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
		cell.textLabel.text = @"iCamAlbum";

	}
  	else if (indexPath.section == 1){ //photoalbum
		
        if (indexPath.row < [assetGroups count]) {

            ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
            NSInteger gCount = [g numberOfAssets];
            
            cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
            [cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
            

        }
        else{
            cell.textLabel.text = nil;
            cell.imageView.image = nil;
        }
            
//            ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
//            NSInteger gCount = [g numberOfAssets];
//            
//            cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
//            [cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
//            
        
        }
    
    
}


- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0) {
        _numOfColumn = 3;
        _thumbSize = isPad?CGSizeMake(75, 50):CGSizeMake(48, 32);
        [self pushPhotoTableVCWithImgNames:_imgNames];
    }
	else if (indexPath.section == 1) {
		
        if (indexPath.row<[assetGroups count]) {
            ALAssetsGroup *group = assetGroups[indexPath.row ];
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            _numOfColumn = 3;
            _thumbSize = isPad?CGSizeMake(75, 75):CGSizeMake(50, 50);
            
            [self pushPhotoTableVCWithAssetsGroup:group];
            
        }
      
    }
    
    
   

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
