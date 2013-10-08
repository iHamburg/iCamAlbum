//
//  PathImageView.h
//  CropImageTest
//
//  Created by  on 02.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PathImageViewDelegate;

@interface PathImageView : UIView{

	UIImageView *imgV; // 画红线用
	
	UIBezierPath *newPath;
	
	CGPoint firstPoint,currentPoint,lastPoint;
    
}

@property (nonatomic, unsafe_unretained) id<PathImageViewDelegate> delegate;

@end

@protocol PathImageViewDelegate <NSObject>

- (void)pathImageViewDidBeginDraw:(PathImageView*)pathV;
- (void)pathImageView:(PathImageView*)pathV didFinishDrawWithPath:(UIBezierPath*)path;

@end
