//
//  CodingPhoto.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 24.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingObj.h"


/*
 
 CodingPhoto<->PhotoWidget, 或是IconWidget, 存储photoWidget的信息
 */

@interface CodingPhoto : CodingObj



@property (nonatomic, strong) NSString *imgName;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) float borderWidth;
@property (nonatomic, assign) BOOL croppedFlag;

- (id)initWithPhotoWidget:(id)photoWidget;

@end
