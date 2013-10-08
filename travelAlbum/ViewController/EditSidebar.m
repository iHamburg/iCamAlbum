//
//  EditSidebar.m
//  MyPhotoAlbum
//
//  Created by XC on 9/7/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "EditSidebar.h"
#import "PhotoWidget.h"
#import "EditSideBGViewController.h"
#import "EditSidePageViewController.h"
#import "EditSideIconWidgetViewController.h"
#import "AlbumsTableViewController.h"
#import "ImageModelAlbumsViewController.h"

@implementation EditSidebar

@synthesize vc,type;



- (void)setType:(SidebarType)_type{
	type = _type;
	if (type == SidebarTypePhoto) {
		
		[self toPhotoNav];
	}
//	else if(type == SidebarTypeWidget){
//		[self toIconWidgetView];
//	}
	else if(type == SidebarTypeBG){
		[self toBGView];
	}
	else if(type == SidebarTypePage){
		[self toPage];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code


        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
        swipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipe];

		
    }
    return self;
}




- (void)didReceiveMemoryWarning{
	
	L();
	
	if (!bgNav.view.superview) {
		bgNav = nil;
		bgVC  = nil;
	}
	
	if (!photoNav.view.superview) {
		photoNav = nil;
		photoAlbumVC = nil;
	}
	
	if (!widgetNav.view.superview) {
		widgetNav = nil;
		iconWidgetVC = nil;
	}
	
	if (!pageNav.view.superview) {
		pageNav = nil;
		pageVC = nil;

	}
	
}

#pragma mark - IBAction
- (void)handleSwipe:(UISwipeGestureRecognizer*)gesture{
    L();
	[self close];
}


#pragma mark -
- (BOOL)isOpen{
	
    if (self.frame.origin.x<-5) {
        return NO;
    }
    else {
        return YES;
    }
}


- (void)open{
	if (![self isOpen]) {
		
		// 如果是page，save current moment
		if (type == SidebarTypePage) {
			[vc saveCurrentAlbum];
		}
		
		[UIView animateWithDuration:0.3 animations:^{
			[self setOrigin:CGPointMake(0, 0)];
		}];
		
		
	}
}
- (void)close{
	
	if ([self isOpen]) {
		type = SidebarTypeNone;
		[UIView animateWithDuration:0.3 animations:^{
			CGFloat w = self.width;
			[self setOrigin:CGPointMake(-1 * w -10, 0)];
			
		}];
	}
}


#pragma mark -


- (void)toPhotoNav{
	L();

	if (!photoNav) {

		photoAlbumVC = [[ImageModelAlbumsViewController alloc]init];

        photoAlbumVC.view.frame = CGRectMake(0, 0, self.width, self.height - kHNavigationbar);
//        photoAlbumVC.delegate = vc;
		photoNav = [[UINavigationController alloc]initWithRootViewController:photoAlbumVC];
        
        photoAlbumVC.title = @"Add Photos";

        
	}
    
 
    
	photoAlbumVC.imgNames = [self createStickerNames];

	[self removeAllSubviews];
    
	bgNav = nil;
	bgVC  = nil;

	widgetNav = nil;
	iconWidgetVC = nil;
	
	pageNav = nil;
	pageVC = nil;

    [self addSubview:photoAlbumVC.nav.view];
	
}
- (void)toBGView{

	if (!bgVC) {
		bgVC = [[EditSideBGViewController alloc]init];
		bgVC.view.alpha = 1;
		bgVC.sidebar = self;
		bgNav = [[UINavigationController alloc]initWithRootViewController:bgVC];
		bgNav.navigationBar.barStyle = UIBarStyleBlack;
		bgNav.navigationBar.tintColor = kColorGreen;
	}

	bgNav.view.frame = self.bounds;
	[self removeAllSubviews];
	
	photoNav = nil;
	photoAlbumVC = nil;
	
	widgetNav = nil;
	iconWidgetVC = nil;
	
	pageNav = nil;
	pageVC = nil;

	
	[self addSubview:bgNav.view];
}


- (void)toPage{
	if(!pageVC){
		pageVC = [[EditSidePageViewController alloc]init];
		pageVC.view.alpha = 1;
		pageVC.sidebar = self;
		pageNav = [[UINavigationController alloc]initWithRootViewController:pageVC];
		pageNav.navigationBar.barStyle = UIBarStyleBlack;
		pageNav.navigationBar.tintColor = kColorGreen;
	}
	
	pageNav.view.frame = self.bounds;

//	pageVC.album = [vc album];

	[self removeAllSubviews];
	
	bgNav = nil;
	bgVC  = nil;
	
	photoNav = nil;
	photoAlbumVC = nil;
	
	widgetNav = nil;
	iconWidgetVC = nil;

	
	[self addSubview:pageNav.view];
}

- (NSMutableArray*)createStickers{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
    NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *iconWidgetNames = materialDict[@"IconWidgets"];
    NSMutableArray* allStickers = [NSMutableArray array];
    for (int i = 0; i< [iconWidgetNames count]; i++) {
        Sticker *sticker = [[Sticker alloc]initWithDictionary:iconWidgetNames[i]];
        [allStickers addObject:sticker];
    }
    
    return allStickers;
}

- (NSArray*)createStickerNames{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Material" ofType:@"plist"];
    NSDictionary *materialDict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *iconWidgetNames = materialDict[@"IconWidgets"];
   
    NSMutableArray* stickerNames = [NSMutableArray array];
    for (int i = 0; i< [iconWidgetNames count]; i++) {
        Sticker *sticker = [[Sticker alloc]initWithDictionary:iconWidgetNames[i]];
        [stickerNames addObject:sticker.imgName];
    }
    
    return stickerNames;

}

@end
