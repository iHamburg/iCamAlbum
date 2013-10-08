//
//  AlbumCover.h
//  Everalbum
//
//  Created by AppDevelopper on 13-8-22.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumManagerViewController.h"
#import "IndicatorView.h"

#define kwPhotoPreviewImage (isPad?50:40)


@interface AlbumCover : UIView<UIGestureRecognizerDelegate>{

    IndicatorView *coverIndicatorV;
    UIImageView *innenPhotoImgV;
    UIButton *photoPreviewB;
    UIButton *openB;
    UIButton *shareB, *loveB, *playB, *lockB, *deleteB, *cameraB;
    UIView *iconBarContainer;
    UIView *iconBar;
    UILabel *titleL;
    UILabel *dateL;
    
    UILabel *pwLabel;

}


@property (nonatomic, strong) Album* album;
@property (nonatomic, unsafe_unretained) AlbumManagerViewController* managerVC;
@property (nonatomic, readonly, assign) CGRect shareButtonRect;
@property (nonatomic, readonly, assign) CGSize coverPhotoSize; //应该是类变量

- (void)openIconBarCover;
- (void)closeIconBarCover;


@end
