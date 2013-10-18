//
//  FontScrollView.m
//  MyeCard
//
//  Created by AppDevelopper on 02.11.12.
//
//

#import "FontScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FontScrollView

@synthesize delegate,selectedIndex;

- (void)setSelectedIndex:(int)_selectedIndex{
	selectedIndex = _selectedIndex;
	
	int page = selectedIndex/numLabelInPage;
	[scrollView setContentOffset:CGPointMake(w*page, 0)];
	pageControl.currentPage = page;
	
	UILabel *l = (UILabel*)[scrollView viewWithTag:selectedIndex+1];
	[selected setOrigin:CGPointMake(CGRectGetMaxX(l.frame)-15,CGRectGetMinY(l.frame) -5)];
	[scrollView addSubview:selected];
	
}

- (NSMutableArray*)createFontNames{
    NSArray *array = [UIFont familyNames];
    NSMutableArray* fontNames_ = [NSMutableArray array];
    
    for(NSString *familyName in array)
    {
        [fontNames_ addObject:familyName];
    }
    [fontNames_ sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return fontNames_;
   
}

- (NSMutableArray*)createFontLabels:(NSArray*)fontNames_{
    
    NSMutableArray *fontLabels_ = [NSMutableArray arrayWithCapacity:[fontNames_ count]];
    
    for (int i = 0; i<[fontNames_ count]; i++) {
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectZero];
        l.backgroundColor = [UIColor whiteColor];
        l.userInteractionEnabled = YES;
        l.tag = i+1;
        l.text = @"Xapp";
        l.textAlignment = NSTextAlignmentCenter;
        l.textColor = [UIColor orangeColor];
        l.layer.cornerRadius = 3;
        l.shadowColor = [UIColor colorWithWhite:0 alpha:0.44];
        l.shadowOffset = CGSizeMake(0, 1);
        
        [fontLabels_ addObject:l];
    }

    return fontLabels_;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		// 每一页25个label
		w = frame.size.width;
		h = frame.size.height-10;
		margin = 6;
		wLabel = (w-margin*(NumLabelInRow+1))/(NumLabelInRow);
		hLabel = (h-margin*(NumLabelInColumn+1))/(NumLabelInColumn);

		scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, w, h)];
		pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, h-3, w, 10)];
	
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.delegate = self;
		
        fontNames = [self createFontNames];
        
		numLabelInPage = NumLabelInRow *NumLabelInColumn;
		numPages = [fontNames count]/numLabelInPage +1;
		pageControl.numberOfPages = numPages;
//        fontLabels = [[SpriteManager sharedInstance]fontLabels];
		fontLabels = [self createFontLabels:fontNames];
        
		for (int i = 0; i<[fontNames count]; i++) {
			
			int page = i/numLabelInPage;
			int indexOfPage = i%numLabelInPage;
			UILabel *l = fontLabels[i];
			l.frame = CGRectMake(w*page + margin+(indexOfPage%NumLabelInRow)*(wLabel+margin), margin+(indexOfPage/NumLabelInRow)*(hLabel+margin), wLabel, hLabel);
			l.font = [UIFont fontWithName:fontNames[i] size:hLabel/2.2];
			[l addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			[scrollView addSubview:l];
		
		}
		
		scrollView.contentSize = CGSizeMake(w*numPages, 0);

		selected = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
		selected.image = [UIImage imageNamed:@"icon_selected.png"];
		
		self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBGPattern1.png"]];
		self.layer.cornerRadius = 5;
		
		[self addSubview:scrollView];
		[self addSubview:pageControl];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer*)tap{
	
	
	UILabel *l = (UILabel*)[tap view];
	int index = l.tag-1;
	
	
	[selected setOrigin:CGPointMake(CGRectGetMaxX(l.frame)-15,CGRectGetMinY(l.frame) -5)];
	[scrollView addSubview:selected];

	if ([delegate respondsToSelector:@selector(fontScrollViewDidSelectedFontName:)]) {
		
		[delegate fontScrollViewDidSelectedFontName:fontNames[index]];
	}

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView{
	L();
	CGFloat xOffset = scrollView.contentOffset.x;
	int pageNum = xOffset/w;
//	NSLog(@"xOffset:%f",xOffset);
	pageControl.currentPage = pageNum;
}
@end
