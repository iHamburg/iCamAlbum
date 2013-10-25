//
//  AlbumTableViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 13-8-27.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "AlbumPhotoTableViewController.h"

@interface AlbumPhotoTableViewController ()

@end

@implementation AlbumPhotoTableViewController

- (void)loadView{
    [super loadView];
    
    _thumbSize = CGSizeMake(75, 75);
    
    if (isPad) {
        _numOfColumn = 4;
    }
    else if(isPhone4){
        _numOfColumn = 6;
        
    }
    else{
        _numOfColumn = 7;
    }
}



- (void)layout:(int)index imgV:(UIImageView *)imgV {
    // 反向image
    
    ALAsset *asset = _inputs[index];
    imgV.image = [UIImage imageWithCGImage:asset.thumbnail];
    imgV.tag = index+1;

}

- (void)handleTap:(UITapGestureRecognizer*)tap{
	
	int index = [[tap view]tag]-1;
	
	if (index <0) {
		NSLog(@"not found");
		return;
	}
    ALAsset *asset = [_inputs objectAtIndex:index];


    [_vc selectALAsset:asset];
    
}


@end
