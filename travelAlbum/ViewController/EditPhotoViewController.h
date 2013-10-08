//
//  EditPhotoViewController.h
//  MyPhotoAlbum
//
//  Created by  on 08.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlbumEditViewController.h"
#import "IFFilterManager.h"

@class PhotoEditFunctionScrollView, PhotoEditRahmenView;


@interface EditPhotoViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource, UITableViewDelegate>{

    PhotoEditRahmenView *rahmenSV;
	
    UIButton *fxB,*frameB, *cancelB, *doneB;
    UIView *svContainer;    // 容纳sv
	UIView *pageContainer;  // 和editVC的momentV一样
	
	UITableView *filterTableView;
	UITableView *rahmenTableView;
    CGFloat hSvContainer,wLeft,wScroll;
    NSMutableArray *pieces, *originalImages,*originalBorderWidths,*originalBorderColors;
   
	CGFloat wFXBorder;
}

@property (nonatomic, unsafe_unretained) AlbumEditViewController *vc;

@property (nonatomic, assign) CGFloat hSvContainer;
@property (nonatomic, strong) UIImageView *blueDotImageView;


- (void)addNewPiece:(id)newPiece;

- (void)cancel;
- (void)done;

- (void)toFilterTable;
- (void)toFrame;

- (void)applyImageFilter:(IFFilterType)filterType;
- (void)applyRahmenColor:(UIColor*)color;


@end
