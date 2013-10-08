//
//  PhotoEditRahmenView.h
//  InstaMagazine
//
//  Created by XC  on 10/27/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditPhotoViewController.h"

@interface PhotoEditRahmenView : UIScrollView{
    NSMutableArray *imgVs;
    UIImageView *selectedIcon;
}

@property (nonatomic, unsafe_unretained) EditPhotoViewController *parent;
@property (nonatomic, strong) NSArray *rahmenColors;
- (void)setup;
@end
