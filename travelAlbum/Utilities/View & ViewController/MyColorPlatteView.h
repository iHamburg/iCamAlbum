//
//  ColorPlatteView.h
//  XappCard
//
//  Created by  on 06.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyColorPlatteDelegate;

@interface MyColorPlatteView : UIView<UITableViewDataSource, UITableViewDelegate>{
	
	UITableView *tv;
	
	CGFloat w,h;

	NSMutableArray *thumbImgVs;
	int selectedIndex;
	int numOfThumbsInRow;
	CGSize thumbSize;
	CGFloat margin;
	UIView *selected;
}


@property (nonatomic, unsafe_unretained) id<MyColorPlatteDelegate> delegate;
@property (nonatomic, assign) int selectedIndex;



@end

@protocol MyColorPlatteDelegate <NSObject>

- (void)colorPlatte:(MyColorPlatteView*)v didTapColor:(UIColor*)color;

@end