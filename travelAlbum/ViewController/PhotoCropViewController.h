//
//  PhotoCropViewController.h
//  InstaMagazine
//
//  Created by XC  on 11/7/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumEditViewController.h"

#import "PathImageView.h"

@interface PhotoCropViewController : UIViewController<PathImageViewDelegate>{
    
    UIView *pageContainer;
    UIButton *cancelB, *doneB;
	
    PathImageView *pathV;
	UIImageView *bgImgV;           //作为对比用的显示originalImage
	
	UIImage *originalImage;        //piece正方形的原始照片,cancel,try 时复原
	UIImage *originalCroppedImage; //进入cropVC的piece的被crop的图片,cancel 时复原
	CGRect originalBounds;         //开始时piece的bounds,cancel 时复原
	CGAffineTransform originalTransform;  //开始时piece的transform
	CGFloat originalWBorder;       //开始时piece的边框宽度，cancel 时复原
	CGRect identityFrame;           // piece(恢复原图时的，不一定等于property)frame， retry 复用用
	
	BOOL croppedFlag;
	
    
}

@property (nonatomic, strong) UIImageView *piece;
@property (nonatomic, unsafe_unretained) AlbumEditViewController *vc;

@end
