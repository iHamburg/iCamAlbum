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
        
//        if (isAlbumOpened) {
//            return [assetGroups count] + 1;
//        }
//        else
//            return 1;

        return [assetGroups count];
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
//		if (indexPath.row == 0) {
//            cell.imageView.image = [UIImage imageNamed:@"icon_AlbumVC_photoalbum.png"];
//            cell.textLabel.text = @"Photo Album";
//            
//        }
//        else{
//
//            
//            ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row - 1];
//            NSInteger gCount = [g numberOfAssets];
//
//            cell.textLabel.font = [UIFont fontWithName:kFontName size:isPad?28:14];
//            cell.textLabel.text = [NSString stringWithFormat:@"       %@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
//            [cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
//            
//
//        }

        ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row ];
        NSInteger gCount = [g numberOfAssets];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
        [cell.imageView setImage:[UIImage imageWithCGImage:[g posterImage]]];
        

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
		
//        if (indexPath.row == 0) {
//            
//            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[assetGroups count]];
//            for (int i = 0; i<[assetGroups count]; i++) {
//                 NSIndexPath *path = [NSIndexPath indexPathForRow:[indexPath row]+1+i inSection:[indexPath section]];
//                [indexPaths addObject:path];
//            }
//
//            if (!isAlbumOpened) {
//                isAlbumOpened = YES;
//                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//            }
//            else{
//                isAlbumOpened = NO;
//                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//                
//            }
//            
//        }
//        else{
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
        
//        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
