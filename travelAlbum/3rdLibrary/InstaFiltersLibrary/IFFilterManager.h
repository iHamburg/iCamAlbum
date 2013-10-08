//
//  IFFilterManager.h
//  Everalbum
//
//  Created by AppDevelopper on 29.07.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstaFilters.h"

@interface IFFilterManager : NSObject

+(id)sharedInstance;

@property (nonatomic, strong) IFImageFilter *filter;


- (UIImage*)filteredImageWithRaw:(UIImage*)raw filterType:(IFFilterType)filterType;

/// 测试用
- (UIImage*)imageByFiltingImage:(UIImage*)imageToFilter filterType:(IFFilterType)filterType;

@end
