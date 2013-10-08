//
//  ContentViewController.m
//  XappCard
//
//  Created by  on 30.11.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "ContentViewController.h"
#import "PhotoEditableView.h"
//#import "EditableDelegate.h"
#import "TextEditableView.h"
#import "ArchivedImageView.h"
#import "CardSetting.h"


@implementation ContentViewController



- (int)picNum{
	int picNum=0;
	NSArray *array = controllView.subviews;
	
	for (UIView *v in array) {
		if ([v isKindOfClass:[PhotoEditableView class]]) {
			picNum++;
		}
	}
	
	return picNum;
}
#pragma mark - View lifecycle

- (id)initWithCard:(Card *)_card{
	
	if (self = [super initWithCard:_card]) {
//		[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(handleNotificationAddPicture:)
//													 name:NotifiAddPicture object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(handleNotificationAddZettel:)
//													 name:NotifiContentAddZettel object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self
//												 selector:@selector(handleNotificationLoadEditView:)
//													 name:NotifiContentLoadEditView object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleProfileEnable:)
//													 name:NotifiPictureSetProfileEnabled object:nil];
		
	}
	return self;
}

- (void)loadView{
	L();
	
//	self.view = [[UIView alloc] initWithFrame:kUIContainerFrame];

	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 960, 640)];

	[self initSubViews];
	


	[self.view addSubview:bgV];
	[self.view addSubview:controllView];


}

- (void)viewDidLoad
{
    [super viewDidLoad];

    L();

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[self.view addGestureRecognizer:tap];


	if (!ISEMPTY(card.contentBGURL)) {
		[self loadBG:card.contentBGURL];
	}
	else{
		//TODO

//		[self changeBG:[[SpriteManager sharedInstance] cardBGImageWithIndex:0]];
	}
	
	[self loadElements:card.elements];
	
	


}

- (void)viewDidUnload
{
	L();
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	picArr = nil;
//	portfolioView = nil;
//	step2IV = nil;
//	step3IV = nil;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    L();
    // Release any cached data, images, etc that aren't in use.
	picArr = nil;
}


- (void)dealloc{

	[[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - Gesture


- (void)handleLongPress:(UIGestureRecognizer*)gesture{
	L();

	 if (gesture.state == UIGestureRecognizerStateBegan && card.contentBGURL!=nil) {
		UIMenuController *menuController = [UIMenuController sharedMenuController];
		UIMenuItem *bgMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Default Background", nil) action:@selector(changeDefaultBG)];
		
		CGPoint location = [gesture locationInView:[gesture view]];
		
//		[self.view becomeFirstResponder];
		[menuController setMenuItems:[NSArray arrayWithObjects:bgMenuItem,nil]];
		[menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gesture view]];
		[menuController setMenuVisible:YES animated:YES];
	
	
	 }
}





- (void)handleTap:(UITapGestureRecognizer*)gesture{


	UIMenuController *menuController = [UIMenuController sharedMenuController];
	[menuController setMenuVisible:NO animated:YES];
}


#pragma mark - Notification
- (void)handleNotificationAddPicture: (NSNotification*)notification{
	L();
	NSArray *imgs = [notification object];
	
	for (UIView *imgV in imgs) {

		if (!isPad) {
			imgV.transform = CGAffineTransformScale(TRANSFORM(arc4random()%360), 0.5, 0.5);
		}
		else{
			imgV.transform = CGAffineTransformScale(TRANSFORM(arc4random()%360), 1, 1);
		}

		
		[self addElement:imgV center:isPad?CGPointMake(250, 350):CGPointMake(120, 140) style:0];
	}

	
}


- (void)handleNotificationAddZettel: (NSNotification*)notification{
	L();
	NSArray *imgs = [notification object];

	// add pictureVs to rightTextV;
	for (int i = 0; i<[imgs count]; i++) {
        
        UIView *cardTextView = [imgs objectAtIndex:i];
//		NSLog(@"cardTextView:%@",cardTextView);
		
		[self addElement:cardTextView center:isPad?CGPointMake(750+10*i, 350+10*i):CGPointMake(360+5*i, 140+5*i) style:0];
    }
	
}



- (void)handleNotificationLoadEditView: (NSNotification*)notification{
	L();
	NSArray *imgs = [notification object];
		
	// add pictureVs to rightTextV;
	for (int i = 0; i<[imgs count]; i++) {
        
        UIView *v = [imgs objectAtIndex:i];
		[controllView addGestureRecognizersToPiece:v];
		[controllView addSubview:v];
    }
	

}


#pragma mark - AlbumLoader

- (void)didLoadAsset:(ALAsset *)asset withKey:(NSString *)key{
	L();
	
	ALAssetRepresentation *rep = [asset defaultRepresentation];

	NSURL *url = rep.url;
	
	CGFloat scale = kRetinaPadScale;

	
	if ([key isEqualToString:@"contentElements"]) {

		CGImageRef iref = [rep fullScreenImage];
		
		UIImage *largeimage = [UIImage imageWithCGImage:iref];

		
		for (PhotoEditableView *v in picArr) {
			
			if ([v.url isEqual:url]) {
				CGSize newSize = [UIView sizeForImage:largeimage withMinSide:320];
				
				largeimage = [largeimage imageByScalingAndCroppingForSize:CGSizeMake(newSize.width*scale, newSize.height*scale)];
				
				[v setImage:largeimage];
			}
		}
		
//		L();

//		CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
//		NSLog(@"location:%@",location);
//		NSLog(@"URLs:%@",[asset valueForProperty:ALAssetPropertyURLs]);
//		NSLog(@"time:%@",[asset valueForProperty:ALAssetPropertyDate]);

		
	}
	else if([key isEqualToString:@"loadBG"]){
		CGImageRef iref = [rep fullResolutionImage];
		
		UIImage *largeimage = [UIImage imageWithCGImage:iref];
		CGFloat width = 960*scale;
		CGFloat height = 640*scale;

		largeimage = [largeimage imageByScalingAndCroppingForSize:CGSizeMake(width, height)];
		
//		NSLog(@"bgImage:%@",NSStringFromCGSize(largeimage.size));
		[self changeBG:largeimage];
		card.contentBGURL = url;
		
	}
}

#pragma mark - GestureController
- (void)willPanPiece:(UIPanGestureRecognizer *)gestureRecognizer inView:(ControlView *)myView{
//	L();
	EditableView *piece = (EditableView*)[gestureRecognizer view];
	if (piece.locked) {
		return;
	}	
  	
	CGPoint point = [gestureRecognizer locationInView:myView];
	CGRect innenRect = isPad?CGRectMake(10,10,940,620):CGRectMake(5, 5, 470, 310);
	
	
	if (!CGRectContainsPoint(innenRect, point)) {
		[piece removeGestureRecognizer:gestureRecognizer];
		[piece removeFromSuperview];
		return;
	}

}


- (void)handleMenuAction:(MenuAction)menuAction withPiece:(EditableView *)piece{
	L();
	switch (menuAction) {
		case MA_Lock:
			piece.locked = YES;
			break;
		case MA_Unlock:
			piece.locked = NO;
			break;
		case MA_SetBG:
//			NSLog(@"set bg:%@",piece);
//			[self changeBGWithURL:[(PictureWithFrameView*)piece url]];
			[self loadBG:[(PhotoEditableView*)piece url]];
			break;
			
		case MA_Edit:
//			NSLog(@"edit:%@",piece);
//			[[NSNotificationCenter defaultCenter]
//			 postNotificationName:NotifiRootOpenTextLabelVC object:[NSArray arrayWithObject:piece]];
			break;
		default:
			break;
	}
}

#pragma mark - CardVC

- (void)loadElements:(NSMutableArray*)array{
	
	if (ISEMPTY(array)) {
		return;
	}
	
//	AlbumLoader *albumLoader = [[AlbumLoader alloc] init];
//	albumLoader.delegate = self;
//	picArr = [NSMutableArray array];
//	
//	NSMutableArray *urls = [NSMutableArray array];
//	
//	for(int i = 0; i<[array count];i++) {
//		
//		UIView *v = [array objectAtIndex:i];
//		if ([v isKindOfClass:[ArchivedImageView class]]) {
//			
//			NSURL *url = [(ArchivedImageView*)v url];
//			if (ISEMPTY(url)) {
//				break;
//			}
//			PhotoEditableView *pic = v;
//			[picArr addObject:pic];
//			[array replaceObjectAtIndex:i withObject:pic];
//			if ([urls indexOfObject:url]==NSNotFound) {
//				
//				[urls addObject:url];
//			}
//		}
//	}
//	
//	[albumLoader loadUrls:urls withKey:@"contentElements"];
	//	NSLog(@"elemetns:%@",array);
	
//	[[NSNotificationCenter defaultCenter] postNotificationName:NotifiContentLoadEditView object:array];
}






#pragma mark - Intern



- (void)changeDefaultBG{
	//TODO

//	bgV.image = [[SpriteManager sharedInstance] cardBGImageWithIndex:0];
//	rootVC.card.contentBGURL = nil;
}



- (void)newCardVC{
	[super newCardVC];
	[self changeDefaultBG];
	

}

@end
