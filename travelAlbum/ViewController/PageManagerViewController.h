//
//  PageManagerViewController.h
//  Everalbum
//
//  Created by AppDevelopper on 13-9-6.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumEditViewController.h"
#import "iCarousel.h"

@interface PageManagerViewController : UIViewController<iCarouselDataSource,iCarouselDelegate>{


    UIView *bottomBanner;
    UIView *controlBanner;
    UILabel *titleL;
    UIButton *doneB;
//    UILabel *hintLabel;
    
    iCarousel *carousel;
    UIPageControl *pageControl;
    
    UIButton *addB, *deleteB, *shareB;
    
}

@property (nonatomic, unsafe_unretained) AlbumEditViewController *vc;
@property (nonatomic, readonly) MomentManager *momentManager;

- (IBAction)addPage:(id)sender;
- (IBAction)deletePage:(id)sender;
- (IBAction)sharePage:(id)sender;
- (void)switchToIndex:(int)index;

- (void)reloadCarousel;


- (void)layoutADBanner:(AdView *)banner;
@end
