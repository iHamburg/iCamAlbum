//
//  FBPhotoTableViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 11.08.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "FBPhotoTableViewController.h"
#import "UIImageView+WebCache.h"
#import "FBPhoto.h"

@interface FBPhotoTableViewController ()

@end

@implementation FBPhotoTableViewController






- (void)layout:(int)index imgV:(UIImageView *)imgV {
    
    FBPhoto *photo = _inputs[index];
    //            NSLog(@"photo.url # %@",photo.thumbURLStr);
    imgV.tag = index+1;
    [imgV setImageWithURL:[NSURL URLWithString:photo.thumbURLStr] placeholderImage:kPlaceholderIcon];
    
}
- (void)handleTap:(UITapGestureRecognizer*)tap{
	
	int index = [[tap view]tag]-1;
	
	if (index <0) {
		NSLog(@"not found");
		return;
	}
    
			///TODO: FB photo
    FBPhoto *fbPhoto = _inputs[index];
    [_vc selectFBPhoto:fbPhoto];
}


@end
