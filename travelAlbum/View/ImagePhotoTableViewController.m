//
//  ImagePhotoTableViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 11.08.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "ImagePhotoTableViewController.h"
#import "UtilLib.h"

@interface ImagePhotoTableViewController ()

@end

@implementation ImagePhotoTableViewController

- (void)loadView{
    [super loadView];
    
    if (isPad) {
        _numOfColumn = 4;
        _thumbSize = CGSizeMake(75, 75);

    }
    else{
        _numOfColumn = 5;

        _thumbSize = CGSizeMake(108, 108);
    }
}

- (void)layout:(int)index imgV:(UIImageView *)imgV {
    NSString * imgName = _inputs[index];
    imgV.tag = index+1;
    imgV.image = [UIImage imageWithContentsOfFileUniversal:imgName];
}

- (void)handleTap:(UITapGestureRecognizer*)tap{
	
	int index = [[tap view]tag]-1;
	
	if (index <0) {
		NSLog(@"not found");
		return;
	}

    NSString *imgName = _inputs[index];
//    [_vc selectImage:[UIImage imageWithContentsOfFileUniversal:imgName]];
    [_vc selectImgName:imgName];
 
}

@end
