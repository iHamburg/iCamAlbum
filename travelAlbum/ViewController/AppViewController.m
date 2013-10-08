//
//  AppViewController.m
//  XappTravelAlbum_0_2
//
//  Created by  on 28.03.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AppViewController.h"

@implementation AppViewController



- (Album*)album{
    return manager.currentAlbum;
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{

	root = [ViewController sharedInstance];
	
	
	self.view = [[UIView alloc] initWithFrame:_r];

	bgV = [[UIImageView alloc] initWithFrame:self.view.bounds];

	
	[self.view addSubview:bgV];
	
	manager = [AlbumManager sharedInstance];

}



- (void)setup{

}


- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self layoutADBanner:[AdView sharedInstance]];
}

//- (void)dealloc{
//    L();
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (NSUInteger)supportedInterfaceOrientations{
//	L();
	return  UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;

}

#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
//	NSLog(@"button:%d",buttonIndex);
}




#pragma mark -
- (IBAction)buttonClicked:(id)sender{
	
}

- (IBAction)handleTap:(id)sender{
//	L();

}


///监听Adview的banner的display状态
- (void)registerNotifications{

//    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleAdviewNotification:) name:NotificationAdChanged object:nil];
    
}

- (void)unregisterNotifications{

	
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//	L();
	id newObject = [change objectForKey:NSKeyValueChangeNewKey];
	
	if ([NSNull null] == (NSNull*)newObject)
		newObject = nil;
	
	/// 加入了对adview的observer
//	if([keyPath isEqualToString:kKeyPathAdDisplaying]){ // target： AlbumManager.currentMomentIndex
//		
//		NSLog(@"isAdDisplaying # %@",newObject);
//
//        AdView *adview = [AdView sharedInstance];
//		[self layoutBanner:adview loaded:adview.isAdDisplaying];
//	} /5
}

- (void)handleAdviewNotification:(NSNotification*)notification{
    [self layoutADBanner:notification.object];

}

- (void)layoutADBanner:(UIView*)banner{
    
}

//- (void)layoutBanner:(UIView*)banner loaded:(BOOL)loaded{
//	
//}


- (void)test{}

@end
