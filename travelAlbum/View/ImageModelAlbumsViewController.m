//
//  ImageModelViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 13-9-4.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "ImageModelAlbumsViewController.h"
#import "ImagePhotoTableViewController.h"
#import "AlbumPhotoTableViewController.h"
#import "FBAlbum.h"
#import "UIImageView+WebCache.h"

@implementation ImageModelAlbumsViewController




#pragma mark -
#pragma mark Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	int num = 1;

    if (section == 1) { // photo album
        num = [assetGroups count] + 2;
    }
    else if(section == 2 && isFBAlbumOpen){ // fb album
        num = [fbAlbums count] + 1;
    }
    
    return num;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    //	return isPad?100:60;
	return isPad?55:35;
}

- (void)layoutCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
	if (indexPath.section == 0) { //imagePhotoAlbum
		cell.imageView.image = [UIImage imageWithSystemName:@"Sticker_Tag_9.png"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
		cell.textLabel.text = @"Stickers";
//        cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
        //        cell.backgroundColor = [UIColor clearColor];
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

    }
//    else if(indexPath.section == 2){ //facebook
//        if (indexPath.row == 0) {
//            cell.imageView.image = kPlaceholderIcon;
//            cell.textLabel.text = @"Facebook";
//            cell.contentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
//        }
//        else{
//            
//            cell.contentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
//            //            NSLog(@"assetGroups # %@",assetGroups);
//            FBAlbum *album = [fbAlbums objectAtIndex:indexPath.row - 1];
//            
//            
//         	cell.textLabel.text = [album.name stringByAppendingFormat:@" (%d)",album.numberOfPhotos];
//            
//            if (album.coverImage) {
//                [cell.imageView setImage:album.coverImage];
//            }
//            else{
////                cell.imageView.image = kPlaceholderImage;]
//                NSLog(@"album.coverlink # %@",album.coverLink);
//                [cell.imageView setImageWithURL:[NSURL URLWithString:[album.coverLink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:kPlaceholderImage];
//            }
//        }
//
//    }
}


- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0) {
        _numOfColumn = 3;
        _thumbSize = isPad?CGSizeMake(75, 75):CGSizeMake(50, 50);
        [self pushPhotoTableVCWithImgNames:_imgNames];
    }
	else if (indexPath.section == 1) {
		
//        if (indexPath.row == 0) {
//            
//            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[assetGroups count]];
//            for (int i = 0; i<[assetGroups count]; i++) {
//                NSIndexPath *path = [NSIndexPath indexPathForRow:[indexPath row]+1+i inSection:[indexPath section]];
//                [indexPaths addObject:path];
//            }
//            
//            if (!isAlbumOpened) {
//                isAlbumOpened = YES;
//                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                
//            }
//            else{
//                isAlbumOpened = NO;
//                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                
//            }
//            
//        }
//        else{
//            ALAssetsGroup *group = assetGroups[indexPath.row - 1];
//            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
//            
//            _numOfColumn = 3;
//            _thumbSize = isPad?CGSizeMake(75, 75):CGSizeMake(50, 50);
//            
//            [self pushPhotoTableVCWithAssetsGroup:group];
//            
//        }
        
        if(indexPath.row<[assetGroups count]){
            ALAssetsGroup *group = assetGroups[indexPath.row];
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            _numOfColumn = 3;
            _thumbSize = isPad?CGSizeMake(75, 75):CGSizeMake(48, 48);
            
            [self pushPhotoTableVCWithAssetsGroup:group];
        }
      
    }
    /// Facebook
    else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[fbAlbums count]];
            for (int i = 0; i<[fbAlbums count]; i++) {
                NSIndexPath *path = [NSIndexPath indexPathForRow:[indexPath row]+1+i inSection:[indexPath section]];
                [indexPaths addObject:path];
            }
            
            if (!isFBAlbumOpen) {
                [self loadFBAlbums];
                isFBAlbumOpen = YES;
                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
            }
            else{
                isFBAlbumOpen = NO;
                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
                
            }

        }
        else{
            NSLog(@"push fb album");
            FBAlbum *album = [fbAlbums objectAtIndex:indexPath.row - 1];
            _numOfColumn = 3;
            _thumbSize = isPad?CGSizeMake(75, 75):CGSizeMake(50, 50);
            
            [self pushFBPhotoTableVCWithFBAlbum:album];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
