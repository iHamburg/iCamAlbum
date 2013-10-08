//
//  FontScrollView.h
//  MyeCard
//
//  Created by AppDevelopper on 02.11.12.
//
//

#import <UIKit/UIKit.h>
#import "Utilities.h"

#define FontDisplayString @"Xapp"
#define NumLabelInRow 3
#define NumLabelInColumn 5

@protocol FontScrollViewDelegate;

@interface FontScrollView : UIView<UIScrollViewDelegate>{
	UIScrollView *scrollView;
	UIPageControl *pageControl; //scrollview 带动pagecontrol
	UIImageView *selected;

	NSMutableArray *fontNames;
    NSMutableArray *fontLabels;
    
	CGFloat w,h,margin,wLabel,hLabel;
	int numLabelInPage,numPages;
}

@property (nonatomic, unsafe_unretained) id<FontScrollViewDelegate>delegate;
//@property (nonatomic, strong) NSMutableArray *fontNames;
@property (nonatomic, assign) int selectedIndex;

@end

@protocol FontScrollViewDelegate <NSObject>

@optional
- (void)fontScrollViewDidSelectedIndexOfFont:(int)index;
- (void)fontScrollViewDidSelectedFontName:(NSString*)fontName;

@end