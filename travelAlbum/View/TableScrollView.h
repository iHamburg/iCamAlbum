//
//  AlbumPreviewView.h
//  XappTravelAlbum
//
//  Created by  on 16.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"


/*
 
 横版的tableview，
 
 需要设置 numberOfCovers, coverSize;
 
 */

@protocol TableScrollViewDataSource;
@protocol TableScrollViewDelegate;

typedef enum{
	
	AlbumPreviewViewModeHorizontal,
	AlbumPreviewViewModeVertical
	
}AlbumPreviewViewMode;

@interface TableScrollView : UIScrollView<UIScrollViewDelegate>{
		
	
	NSMutableArray *coverViews;  // sequential covers , [NSNull null]
	NSMutableArray *views;		// only covers view, (no nulls)
	NSMutableArray *yard;	   // covers ready for reuse (ie. graveyard), only one object
		
	float origin;
	
	CGSize coverSize;
	UIView *currentTouch;
	NSInteger currentIndex;
	
	int numberOfCoverInView; //1000：500-》3，400-》4 同时出现在屏幕上的cover数量 
	
	AlbumPreviewViewMode mode;
	
}


@property (nonatomic, assign) int numberOfCovers;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGSize coverSize;

@property (nonatomic, unsafe_unretained) id<TableScrollViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id<TableScrollViewDelegate> previewViewDelegate;

//- (id)initWithFrame:(CGRect)frame mode:(AlbumPreviewViewMode)mode;

- (void)setup;

- (UIView*) dequeueReusableCoverView;
- (void) bringCoverAtIndexToFront:(int)index animated:(BOOL)animated;
- (UIView*)viewAtIndex:(int)index; //uiview or null


@end

@protocol TableScrollViewDelegate <NSObject>

@optional

- (void) tableScrollView:(TableScrollView*)scrollView coverAtIndexWasBroughtToFront:(int)index;


@end

@protocol TableScrollViewDataSource <NSObject>

- (UIView*)tableScrollView:(TableScrollView*)scrollView viewAtIndex:(int)index;

@end