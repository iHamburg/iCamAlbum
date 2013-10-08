//
//  AlbumPreviewView.m
//  XappTravelAlbum
//
//  Created by  on 16.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "TableScrollView.h"




@interface TableScrollView () {
}



- (void) animateToIndex:(int)index  animated:(BOOL)animated;
- (void) load;
//- (void) setup;
- (void) newrange;
//- (void) setupTransforms;
//- (void) adjustViewHeirarchy;
- (void) deplaceAlbumsFrom:(int)start to:(int)end;
- (void) deplaceAlbumsAtIndex:(int)cnt;
- (BOOL) placeAlbumsFrom:(int)start to:(int)end;
- (void) placeAlbumAtIndex:(int)cnt;
//- (void) snapToAlbum:(BOOL)animated;

@end

#pragma mark - Implementation

@implementation TableScrollView

@synthesize previewViewDelegate,dataSource;

@synthesize numberOfCovers,currentIndex,coverSize;

//- (id)initWithFrame:(CGRect)frame mode:(AlbumPreviewViewMode)_mode{
//	if (self = [self initWithFrame:frame]) {
//		mode = _mode;
//		[self load];
//		[self setup];
//		
//	}
//	return self;
//}

- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		mode = AlbumPreviewViewModeHorizontal;
		[self load];
		[self setup];
	}
	return self;
}

- (void)dealloc{
    L();
}

#pragma mark - Setup

//初始化设置 ，只有一次，以后就用setup
- (void) load{
	self.backgroundColor = [UIColor clearColor];
	self.autoresizingMask = kAutoResize;
	self.pagingEnabled = YES;
	
	numberOfCovers = 0;
	
	
	self.showsHorizontalScrollIndicator = NO;
	super.delegate = self;
	origin = self.contentOffset.x;
	
	yard = [[NSMutableArray alloc] init];
	views = [[NSMutableArray alloc] init];
	
	coverSize = self.bounds.size;
	numberOfCoverInView = 1;
	
	currentIndex = -1;
	
	
}


//当设定cover数量和coversize的时候会调用
- (void) setup{
	

	if (numberOfCoverInView == 2) { // if == 2 => pagingEnabled
		self.pagingEnabled = YES;
	}
	else{
		self.pagingEnabled = NO;
	}
	
	for(UIView *v in views) [v removeFromSuperview];
	[yard removeAllObjects];
	[views removeAllObjects];
	coverViews = nil;
	
	if(numberOfCovers < 1){
		self.contentOffset = CGPointZero;
		return;
	} 
	
	
	coverViews = [[NSMutableArray alloc] initWithCapacity:numberOfCovers];
	for (unsigned i = 0; i < numberOfCovers; i++) [coverViews addObject:[NSNull null]];
	
	
	currentIndex = 0;
	if (mode == AlbumPreviewViewModeHorizontal) {
		self.contentSize = CGSizeMake(coverSize.width*numberOfCovers, 0);
	}
	else{
		self.contentSize = CGSizeMake(0,coverSize.height*(numberOfCovers+0.5));
	}
	self.contentOffset = CGPointZero;
	
	//	NSLog(@"currentIndex:%d",currentIndex);
	[self newrange];
	
	//	NSLog(@"currentIndex:%d",currentIndex);
	[self animateToIndex:currentIndex animated:NO];
	
	//	NSLog(@"contentSize:%f,numberOfCover:%d",self.contentSize.width,numberOfCovers);
}
//


#pragma mark Manage Range and Animations
- (void) newrange{

	
	//range currentIndex -1 -> currentIndex+numberOfCoverInView+1
	
//	NSLog(@"numberOfCoverinview:%d",numberOfCoverInView);
	
	[self placeAlbumsFrom:currentIndex-1 to:currentIndex+ numberOfCoverInView];
	[self deplaceAlbumsFrom:0 to:currentIndex-2];
	[self deplaceAlbumsFrom:currentIndex+ numberOfCoverInView+1 to:numberOfCovers];
	
}

- (void) animateToIndex:(int)index animated:(BOOL)animated{
	
//	NSLog(@"animat to:%d",index);
	
	currentIndex = index;
	
	if (mode == AlbumPreviewViewModeHorizontal) {
		[self setContentOffset:CGPointMake(index * coverSize.width, 0) animated:NO ];
	}
	else{
		[self setContentOffset:CGPointMake(0, index * coverSize.height) animated:NO ];
	}
	
	
	if ([previewViewDelegate respondsToSelector:@selector(tableScrollView:coverAtIndexWasBroughtToFront:)]) {
		[previewViewDelegate tableScrollView:self coverAtIndexWasBroughtToFront:currentIndex];
		
	}
}
//
//- (void) snapToAlbum:(BOOL)animated{
//	
//	L();
//	UIView *v = [coverViews objectAtIndex:currentIndex];
//	
//	if((NSObject*)v!=[NSNull null]){
//		
//		[self setContentOffset:CGPointMake(coverSize.width * currentIndex, 0) animated:YES];
//	}
//	
//}

#pragma mark Manage Visible Covers


- (void) deplaceAlbumsFrom:(int)start to:(int)end{
	if(start >= end) return;
	
	for(int cnt=start;cnt<end;cnt++)
		[self deplaceAlbumsAtIndex:cnt];
}

- (void) deplaceAlbumsAtIndex:(int)cnt{
	
//	NSLog(@"deplaceAlbumsAt:%d",cnt);
	
	if(cnt >= [coverViews count] || cnt < 0) return;
	
//	NSLog(@"coverViews:%@coverView[%d]:%@",coverViews,cnt,[coverViews objectAtIndex:cnt]);
	
	if([coverViews objectAtIndex:cnt] != [NSNull null]){
		
		//		NSLog(@"deplace:%d",cnt);
		
		UIView *v = [coverViews objectAtIndex:cnt];
		[v removeFromSuperview];
		[views removeObject:v];
		
		[yard addObject:v];
		[coverViews replaceObjectAtIndex:cnt withObject:[NSNull null]];
		
		
		//		NSLog(@"deplace :%d Done",cnt);
	}
}


- (BOOL) placeAlbumsFrom:(int)start to:(int)end{
//	NSLog(@"placeAlbumfrom:%d,to%d",start,end);
	
	if(start >= end) return NO;
	for(int cnt=start;cnt<= end;cnt++) 
		[self placeAlbumAtIndex:cnt];
	return YES;
}

- (void) placeAlbumAtIndex:(int)cnt{
	if(cnt >= [coverViews count] ||cnt<0) return;
	
	if([coverViews objectAtIndex:cnt] == [NSNull null]){
		
		//		NSLog(@"place:%d",cnt);
		
		UIView *v = [dataSource tableScrollView:self viewAtIndex:cnt];
		[coverViews replaceObjectAtIndex:cnt withObject:v];
		
		[views addObject:v];
		
		if (v.superview == nil)
		{
			
			if (mode == AlbumPreviewViewModeHorizontal) {
//				[v setOrigin:CGPointMake(cnt*coverSize.width, 0)];
				// center 到中央？
				
				CGPoint center =CGPointMake((cnt+0.5)*coverSize.width, 0.5*coverSize.height);
				v.center = center;
			}
			else{
				[v setOrigin:CGPointMake(0, cnt*coverSize.height)];
			}
			
			[self addSubview:v];		
		}
		
		
	}
}

#pragma mark - Scrollview

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
	
	int page;
	if (mode == AlbumPreviewViewModeHorizontal) {
		CGFloat pageWidth = coverSize.width;
		
		page = floor((self.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		
	}
	else{
		CGFloat pageHeight = coverSize.height;
		
		page = floor((self.contentOffset.y - pageHeight / 2) / pageHeight) + 1;
	}
	
	//		NSLog(@"page:%d",page);
	
	if (page==currentIndex) {
		return;
		
	}
	
	
	currentIndex = page;
	
	
	[self newrange];
	
	
	if ([previewViewDelegate respondsToSelector:@selector(tableScrollView:coverAtIndexWasBroughtToFront:)]) {
		[previewViewDelegate tableScrollView:self coverAtIndexWasBroughtToFront:currentIndex];
		
	}
	
}


#pragma mark - Properties

- (void)setNumberOfCovers:(int)cov{
	numberOfCovers = cov;
	//	NSLog(@"numberOFCovers:%d",cov);
	[self setup];
}


- (void)setCurrentIndex:(NSInteger)_currentIndex{
	currentIndex = _currentIndex;
	
	[self setup];
	[self animateToIndex:_currentIndex animated:NO];
}

- (void)setCoverSize:(CGSize)_coverSize{
	
	coverSize = _coverSize;
	
	if (mode == AlbumPreviewViewModeHorizontal) {
		float width = self.bounds.size.width;
		float coverWidth = coverSize.width;
		
		numberOfCoverInView = ceil(width/coverWidth)+1;
		
	}
	else{
		float height = self.bounds.size.height;
		float coverHeight = coverSize.height;
		
		numberOfCoverInView = ceil(height/coverHeight)+1;
	}
	
	
	
	[self setup];
}

#pragma mark - Public Methode
- (UIView*) dequeueReusableCoverView{
	
//	NSMutableArray *coverViews;  // sequential covers , [NSNull null]
//	NSMutableArray *views;		// only covers view, (no nulls)
//	NSMutableArray *yard;
	
//	NSLog(@"coverViews:%@,views:%@,yard:%@",coverViews,views,yard);
	
	if([yard count] < 1)  return nil;
	
	UIView *v = [yard lastObject];
	//	v.layer.transform = CATransform3DIdentity;
	[yard removeLastObject];
	
	return v;
}



- (void) bringCoverAtIndexToFront:(int)index animated:(BOOL)animated{
	if(index == currentIndex) return;
	
    currentIndex = index;
	
//	NSLog(@"currentIndex:%d",currentIndex);
	//    [self snapToAlbum:animated];
	[self newrange];
	[self animateToIndex:index animated:animated];
	
}

- (UIView*)viewAtIndex:(int)index{ //uiview or null
	
	return [coverViews objectAtIndex:index];
}
@end
