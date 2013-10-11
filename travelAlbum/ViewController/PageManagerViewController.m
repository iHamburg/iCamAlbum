//
//  PageManagerViewController.m
//  Everalbum
//
//  Created by AppDevelopper on 13-9-6.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "PageManagerViewController.h"


@implementation PageManagerViewController


#define coverSize CGSizeMake(_w/1.75,_h/1.75)
#define itemSpace (isPad?700:300)

- (MomentManager*)momentManager{
    return _vc.momentManager;
//    return nil;
    //
}



- (void)loadBottomBanner{
    
    bottomBanner = [[UIView alloc]initWithFrame:CGRectMake(0, 0.88*_h, _w, 0.12 * _h)];
//    bottomBanner.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    bottomBanner.layer.borderColor = [UIColor colorWithHEX:@"C7BAC2"].CGColor;
    [bottomBanner applyBorder:kCALayerTopEdge indent:1];
    
    
    //    titleL = [[UILabel alloc]initWithFrame:CGRectMake(0.1*_w, 0, 0.8*_w, bottomBanner.height)];
    titleL = [[UILabel alloc]initWithFrame:CGRectMake(0.1*_w, 12, 0.8*_w, bottomBanner.height-10)];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont fontWithName:@"Hero" size:isPad?30:16];
    titleL.userInteractionEnabled = YES;

    
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, bottomBanner.width, 20)];
    pageControl.userInteractionEnabled = NO;
    
    CGFloat wB = (isPad?0.6:0.8)* 0.12 * _h;
    doneB =  [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_Edit_Done.png" target:self action:@selector(buttonClicked:)];
    doneB.center = CGPointMake((1 - 0.056)*_w, bottomBanner.height/2);
    
    [bottomBanner addSubview:titleL];
//    [bottomBanner addSubview:favoriteListB];
    [bottomBanner addSubview:pageControl];
    [bottomBanner addSubview:doneB];
}
- (void)loadControlBanner {
    CGFloat hBanner = isPad?60:35;
    controlBanner = [[UIView alloc] initWithFrame:CGRectMake(0, coverSize.height - hBanner, coverSize.width, hBanner)];
    controlBanner.backgroundColor = [kColorLabelBlue colorWithAlpha:0.8];
    
    CGFloat wB = isPad?56:32;
   
    addB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_pagemanager_add_page.png" target:self action:@selector(buttonClicked:)];
    addB.center = CGPointMake(controlBanner.width/2, controlBanner.height/2);
    
    deleteB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_pagemanager_delete_page.png" target:self action:@selector(buttonClicked:)];
    
    deleteB.center = CGPointMake(50, controlBanner.height/2);
    
    shareB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_pagemanager_share_page.png" target:self action:@selector(buttonClicked:)];
    
    shareB.center = CGPointMake(controlBanner.width - 50, controlBanner.height/2);
    
    [controlBanner addSubview:addB];
    [controlBanner addSubview:shareB];
    [controlBanner addSubview:deleteB];
}

- (void)loadView{
    self.view = [[UIView alloc]initWithFrame:_r];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
 

    [self registerNotifications];
    
    [self loadBottomBanner];

        carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,0, _w, _h)];
//    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,0, _w, _h - CGRectGetMaxY(topBanner.frame) - bottomBanner.height)];
//    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, _w, _h- 3* bottomBanner.height ) ];
	carousel.delegate = self;
	carousel.dataSource = self;
    //	carousel.contentOffset = itemOffset;
	carousel.autoresizingMask = kAutoResize;
	[carousel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
    carousel.type = iCarouselTypeCoverFlow2;
//    carousel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    [self loadControlBanner];

    
    [self.view addSubview:carousel];

    
    [self.view addSubview:bottomBanner];
  
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [carousel reloadData];
    
    [self switchToIndex:self.momentManager.currentMomentIndex];
    
    [[carousel currentItemView] addSubview:controlBanner];
//     NSLog(@"coding element # %@",self.momentManager.currentMoment.codingElements);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)registerNotifications{
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyAdChanged:) name:NotificationAdChanged object:nil];
}


- (void)notifyAdChanged:(NSNotification*)notification{
    [self layoutADBanner:notification.object];
}
#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return self.momentManager.numberOfMoments;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
	
    return 5;
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIImageView *)view
{
    
	if (!view) {
        view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, coverSize.width, coverSize.height)];
        view.layer.borderWidth = isPad?5:2;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
//        view.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    //    NSLog(@"index # %d, albumcover # %@",index,view);

    
    Moment *moment = [self.momentManager momentAtIndex:index];
    view.image = moment.previewImage;
	return view;
}


- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    //    L();
	return itemSpace;
}

- (CGFloat)carousel:(iCarousel *)carousel iteAlphaForOffset:(CGFloat)offset
{
	//set opacity based on distance from camera
    return 1.0f - fminf(fmaxf(offset, 0.0f), 1.0f);
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return NO;
}


- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel_{
    L();
    //    NSLog(@")
    NSLog(@"carouselDidEndScrollingAnimation index # %d",carousel.currentItemIndex);
	
 
//    int index = carousel.currentItemIndex;
    [[carousel currentItemView] addSubview:controlBanner];
    
    [_vc toPageAtIndex:carousel.currentItemIndex];
    

}


// 当drag过新的view的中线的时候，会调用该updated， 用来对该index两边的view做清理工作, stop Video
- (void)carouselCurrentItemIndexUpdated:(iCarousel *)carous{
    //	NSLog(@"view # %d updated",carousel.currentItemIndex);
	
}

#pragma mark - Adview

- (void)layoutADBanner:(AdView *)banner{
    

	[UIView animateWithDuration:0.25 animations:^{
		
		if (banner.isAdDisplaying) { // 从不显示到显示banner
			
            
            //            NSLog(@"svContainer # %@",svContainer);
            [banner setOrigin:CGPointMake(0, _h- banner.height)];
            
		}
		else{
			
			[banner setOrigin:CGPointMake(0, _h)];
		}
		
    }];
    
    
    
}


#pragma mark - IBAction

- (IBAction)handleTap:(UITapGestureRecognizer*)sender{
    
    [_vc hidePageManagerVC];
}

- (IBAction)buttonClicked:(id)sender{
    
    if (sender == addB) {
        [self addPage:sender];
    }
    else if(sender == deleteB){
        [self deletePage:sender];
    }
    else if(sender == shareB){
        [self sharePage:sender];
    }
    else if(sender == doneB){
         [_vc hidePageManagerVC];
    }
}

- (IBAction)addPage:(id)sender{
//    NSLog(@"momentIndex # %d",self.momentManager.currentMomentIndex);
    [_vc addPage];
}
- (IBAction)deletePage:(id)sender{

    [_vc showDeleteAlert];
}
- (IBAction)sharePage:(UIButton*)sender{

    [_vc popShare:sender];
}

#pragma mark - Function
- (void)switchToIndex:(int)index{
    [carousel scrollToItemAtIndex:index animated:NO];
}

#pragma mark - Intern Fcn


- (void)reloadCarousel{
    [carousel reloadData];
    [carousel scrollToItemAtIndex:self.momentManager.currentMomentIndex animated:YES];
}


@end
