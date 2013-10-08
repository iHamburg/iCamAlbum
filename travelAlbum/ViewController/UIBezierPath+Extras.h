//
//  UIBezierPath+Extras.h
//  CropImageTest
//
//  Created by  on 02.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Extras)

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity;

@end
