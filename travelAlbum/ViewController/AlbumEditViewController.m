//
//  AlbumEditViewController.m
//  XappTravelAlbum
//
//  Created by  on 16.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AlbumEditViewController.h"
#import "LandScapeNavigationController.h"
#import "MomentView.h"
#import "EditPhotoViewController.h"
#import "PhotoCropViewController.h"
#import "ICATextViewController.h"
#import "MomentShareView.h"
#import "ICAExportController.h"
#import "IAPManager.h"
#import "EAKxMenu.h"
#import "PageManagerViewController.h"
#import "EditSideControlViewController.h"
#import "EALoadingView.h"
//#import "ICAValidator.h"

#define kToolbarInterval 5


@implementation AlbumEditViewController


- (BOOL)isHotkeyBannerShown{
    if (hotkeyBanner.superview) {
        return YES;
    }
    else{
        return NO;
    }
}

- (BOOL)isSideControlOpen{
    if (editSideControlVC.view.superview) {
        return YES;
    }
    else{
        return NO;
    }
}


- (void)setMomentManager:(MomentManager *)momentManager{
    _momentManager = momentManager;
    _album = momentManager.album;
    
    
     [self updateAlbum];
    
    /// send notification
    _momentManager.currentMomentIndex = _momentManager.currentMomentIndex;
}


//
//
//- (NSArray*)kxEditMenuAddCaptionItems{
//	if (!_kxEditMenuAddCaptionItems) {
//		 [KxMenu setTitleFont:[UIFont fontWithName:kFontName size:isPad?20:16]];
//		
//		_kxEditMenuAddCaptionItems =
//		@[
//	
//			[KxMenuItem menuItem:@"Edit Page"
//						   image:nil
//						  target:nil
//						  action:NULL],
//
//		 [KxMenuItem menuItem:kEditMenuPhoto
////						image:[UIImage imageNamed:@"Icon_editPhoto2.png"]
//                        image:nil
//					   target:self
//					   action:@selector(pushMenuItem:)],
// 
//		 [KxMenuItem menuItem:kEditMenuText
////						image:[UIImage imageNamed:@"Icon_edittext.png"]
//           image:nil
//					   target:self
//					   action:@selector(pushMenuItem:)],
//        [KxMenuItem menuItem:kEditMenuBG
//                  image:[UIImage imageNamed:@"Icon_editbg.png"]
//                 target:self
//                 action:@selector(pushMenuItem:)],
//            
//            [KxMenuItem menuItem:kEditMenuAddCaption image:Nil target:self action:@selector(pushMenuItem:)],
//
//		 ];
//		
//		KxMenuItem *first = _kxEditMenuAddCaptionItems[0];
//		first.alignment = NSTextAlignmentCenter;
//
//        
//        for (int i = 0; i<[_kxEditMenuAddCaptionItems count]; i++) {
//            KxMenuItem *item = _kxEditMenuAddCaptionItems[i];
//            item.foreColor = kColorLabelBlue;
//        }
//	}
//	
//	return _kxEditMenuAddCaptionItems;
//
//}
//
//
//- (NSArray*)kxEditMenuRemoveCaptionItems{
//	if (!_kxEditMenuRemoveCaptionItems) {
////        [KxMenu setTitleFont:[UIFont fontWithName:kFontName size:isPad?20:16]];
//		
//		_kxEditMenuRemoveCaptionItems =
//		@[
//          
//          [KxMenuItem menuItem:@"Edit Page"
//                         image:nil
//                        target:nil
//                        action:NULL],
//          
//          [KxMenuItem menuItem:kEditMenuPhoto
//           //						image:[UIImage imageNamed:@"Icon_editPhoto2.png"]
//                         image:nil
//                        target:self
//                        action:@selector(pushMenuItem:)],
//          
//          [KxMenuItem menuItem:kEditMenuText
//           //						image:[UIImage imageNamed:@"Icon_edittext.png"]
//                         image:nil
//                        target:self
//                        action:@selector(pushMenuItem:)],
//          [KxMenuItem menuItem:kEditMenuBG
//                         image:[UIImage imageNamed:@"Icon_editbg.png"]
//                        target:self
//                        action:@selector(pushMenuItem:)],
//          [KxMenuItem menuItem:kEditMenuRemoveCaption image:nil target:self action:@selector(pushMenuItem:)],
//          
//          ];
//		
//		KxMenuItem *first = _kxEditMenuRemoveCaptionItems[0];
//		first.alignment = NSTextAlignmentCenter;
//        
//        
//        for (int i = 0; i<[_kxEditMenuRemoveCaptionItems count]; i++) {
//            KxMenuItem *item = _kxEditMenuRemoveCaptionItems[i];
//            item.foreColor = kColorLabelBlue;
//        }
//	}
//	
//	return _kxEditMenuRemoveCaptionItems;
//    
//}

#pragma mark - Life cycle
- (void)loadMomentContainer{
    

	CGFloat wMomentV = _w;
	CGFloat hMomentV = _h;
    
//    _pageContainerRect = isPad?CGRectMake((_w-wMomentV)/2,64, wMomentV, hMomentV):CGRectMake((_w-wMomentV)/2, 0, wMomentV, hMomentV);
    
	momentContainer = [[UIView alloc]initWithFrame:_r];
	momentContainer.layer.masksToBounds = YES;
	momentContainer.backgroundColor = [UIColor clearColor];
	
	momentView = [[MomentView alloc]initWithFrame:CGRectMake(0, 0, wMomentV, hMomentV)];
	momentView.layer.masksToBounds = YES;
	[momentView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
    
	[momentContainer addSubview:momentView];
	[self.view addSubview:momentContainer];
	
}


- (void)loadBottomBanner{
    
    bottomBanner = [[UIView alloc]initWithFrame:CGRectMake(0, 0.88*_h, _w, 0.12 * _h)];
    bottomBanner.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    bottomBanner.layer.borderColor = [UIColor colorWithHEX:@"C7BAC2"].CGColor;
    [bottomBanner applyBorder:kCALayerTopEdge indent:1];
    
    titleL = [[UILabel alloc]initWithFrame:CGRectMake(0.1*_w, 12, 0.8*_w, bottomBanner.height-10)];

    titleL.backgroundColor = [UIColor clearColor];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = [UIColor whiteColor];
    titleL.font = [UIFont fontWithName:kFontName size:isPad?30:16];
    titleL.userInteractionEnabled = YES;

   
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, _w, kIsPad2*20)];
    pageControl.userInteractionEnabled = NO;
//    [pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    CGFloat wB = (isPad?0.6:0.8)* 0.12 * _h;
    previewB =  [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_preview.png" target:self action:@selector(buttonClicked:)];
    previewB.center = CGPointMake((1 - 0.056)*_w, bottomBanner.height/2);
    
    [bottomBanner addSubview:titleL];
    [bottomBanner addSubview:previewB];
    [bottomBanner addSubview:pageControl];


//    titleL.backgroundColor = [UIColor redColor];
//    bottomBanner.backgroundColor  = [UIColor redColor];
}

- (void)loadHotkeyBanner{
    hotkeyBanner = [[UIView alloc]initWithFrame:CGRectMake((1-0.1)*_w, 0, 0.1*_w, _h)];
    hotkeyBanner.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    CGFloat wB = isPad?56:32;
    addB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_editNewPage.png" target:self action:@selector(buttonClicked:)];
    addB.center = CGPointMake(hotkeyBanner.width/2, 0.2 *_h);
    
    deleteB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_editDeletePage.png" target:self action:@selector(buttonClicked:)];
    deleteB.center = CGPointMake(hotkeyBanner.width/2, 0.4*_h);
    
    shareB = [UIButton buttonWithFrame:CGRectMake(0, 0, wB, wB) title:nil imageName:@"icon_editSharePage.png" target:self action:@selector(buttonClicked:)];
    shareB.center = CGPointMake(hotkeyBanner.width/2, 0.6*_h);
    
    [hotkeyBanner addSubview:addB];
    [hotkeyBanner addSubview:deleteB];
    [hotkeyBanner addSubview:shareB];
    
    
    
}
- (void)loadView{
	[super loadView];

    [self registerNotifications];

    self.view.backgroundColor = [UIColor whiteColor];
	
	//44->64
	[self loadMomentContainer];


//    backB = [UIButton buttonWithFrame:isPad?CGRectMake(10, 0, 40, 40):CGRectMake(0, 0, 32, 32) title:nil imageName:@"icon_blueBack.png"  target:self action:@selector(buttonClicked:)];

    
	[self loadBottomBanner];
    [self loadHotkeyBanner];
    
    hotkeyB = [UIButton buttonWithFrame:isPad?CGRectMake(0, 0, 48, 48):CGRectMake(0, 0, 32, 32) title:nil imageName:@"icon_pageControl3.png" target:self action:@selector(buttonClicked:)];
    hotkeyB.center = CGPointMake(_w - hotkeyB.width/2 - 5, hotkeyB.height/2+5);
    
    sideControlB = [UIButton buttonWithFrame:isPad?CGRectMake(0, 0, 48, 48):CGRectMake(0, 0, 40, 40) title:nil imageName:@"icon_editHotkey.png" target:self action:@selector(buttonClicked:)];
    
    [self.view addSubview:bottomBanner];
    [self.view addSubview:hotkeyB];
    [self.view addSubview:sideControlB];

    
	
    
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	
//	[root updateSaveWhenUsing];
}

- (void)viewDidAppear:(BOOL)animated{
//	L();
	[super viewDidAppear:animated];

	[self test];
    
//    NSLog(@"coding element # %@",_momentManager.currentMoment.codingElements);

}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	
//	[root cancelUpdateSave];
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
	
	L();

	textVC = nil;

	
}


- (void)dealloc{

//    L();
	[self unregisterNotifications];

//    [editSideControlVC.view removeFromSuperview];
}


#pragma mark - Notification


- (void)registerNotifications{
	
	[super registerNotifications];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyEditPhoto:) name:NotificationEditPhotoWidget object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCropPhoto:) name:NotificationCropPhotoWidget object:nil];
    
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyEditLMV:) name:NotificationEditLabelModelView object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePage) name:NotificationCurrentMomentIndexChanged object:nil];
 
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCaptionAlert) name:NotificationChangeCaption object:nil];
}

- (void)notifyEditLMV:(NSNotification*)notification{
     [self popTextEdit:[notification object]];
}

- (void)notifyEditPhoto:(NSNotification*)notification{
    [self openPhotoEdit:[notification object]];

}
- (void)notifyCropPhoto:(NSNotification*)notification{
     [self openPhotoCrop:[notification object]];
}
- (void)unregisterNotifications{
	[super unregisterNotifications];
    
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	
	id newObject = [change objectForKey:NSKeyValueChangeNewKey];
	
	if ([NSNull null] == (NSNull*)newObject)
		newObject = nil;
    
    //	if ([keyPath isEqualToString:kKeyPathMomentIndex]) {
    //		[self updatePage];
    //	}
	
}


#pragma mark - TextVC
- (void)textVCDidCancel:(TextViewController *)textVC{
    [self closeTextEdit];
}

- (void)textVCDidChangeLabel:(LabelModelView *)label{
    [self finishTextEdit:label];
}

#pragma mark - AlertView

- (void)showDeleteAlert{
    if (!deleteAlert) {
        deleteAlert = [[UIAlertView alloc]initWithTitle:@"Delete this Page?" message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        
    }
    [deleteAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	NSLog(@"button:%d",buttonIndex);
    if (alertView == deleteAlert) {
        if (buttonIndex == 1) {
            [self deletePage];
        }
    }
//    else if(alertView == captionAlert){
//        if (buttonIndex == 1) {
//
//            [momentView setCaptionText:[[alertView textFieldAtIndex:0] text]];
//        }
//        
//    }
}





#pragma mark - MomentShare
- (void)momentShareView:(MomentShareView *)view didShareWithType:(int)type{
    
    [self shareMomentWithType:type];
    
    [[SlideViewController sharedInstance] hideContainer];
        
	
}

#pragma mark - ADView

- (void)layoutADBanner:(AdView *)banner{
    
//    L();
//    NSLog(@"banner # %@,isdisplay # %d",banner, banner.isAdDisplaying);
  
  
    [UIView animateWithDuration:0.25 animations:^{
		
		if (banner.isAdDisplaying) { // 从不显示到显示banner
            
			[banner setOrigin:CGPointMake(0, _h- banner.height)];
            [bottomBanner setOrigin:CGPointMake(0, _h -bottomBanner.height - banner.height)];
			[root.view addSubview:banner];
		}
		else{
             [bottomBanner setOrigin:CGPointMake(0, _h -bottomBanner.height)];
			[banner setOrigin:CGPointMake(0, _h)];
		}
		
    }];
	
    
}

#pragma mark - IBOutlet

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	
	if ([touch.view isKindOfClass:[UIButton class]]) {
		return NO;
	}
	
	return YES;
}

- (void)buttonClicked:(id)sender{

	L();
//	if (sender == backB ) {
//
//		[self back];
//	}
    
    if(sender == hotkeyB){

        
        [self showPageManagerVC];
//        [self showEditSideControl];
    }
    else if(sender == sideControlB){
        [self toggleSideControl:sender];
    }
	else if(sender == addB ){

		[self addPage];
		
	}
	else if(sender == shareB ){
		[self popShare:sender];
		
	}
	else if(sender == deleteB){
		
		// 如果album有超过1个moment，能删除
		if (_momentManager.numberOfMoments>1) {
            [self showDeleteAlert];
		}
		
	}
    else if(sender == previewB){
        [self toPreview];
    }

}


//
//- (void) pushMenuItem:(KxMenuItem*)sender
//{
//    NSLog(@"%@", sender);
//	NSString *title = sender.title;
//	if ([title isEqualToString:kEditMenuBG]) {
////		[self openSidebarWithType:SidebarTypeBG];
//	}
//	else if([title isEqualToString:kEditMenuPage]){
////		[self openSidebarWithType:SidebarTypePage];
//	}
//	else if([title isEqualToString:kEditMenuPhoto]){
////		[self openSidebarWithType:SidebarTypePhoto];
//		
//	}
//	else if([title isEqualToString:kEditMenuSticker]){
////		[self openSidebarWithType:SidebarTypeWidget];
//	}
//	else if([title isEqualToString:kEditMenuText]){
//        
//		[self popTextEdit:[LabelModelView defaultInstance]];
//	}
//    else if([title isEqualToString:kEditMenuAddCaption]){
//        [self setCaptionText:SDefaultCaptionText];
//    }
//    else if([title isEqualToString:kEditMenuRemoveCaption]){
//        [self setCaptionText:nil];
//    }
//}
//
//


- (void)handleTap:(UITapGestureRecognizer*)tap{
	L();
	
//	UIView *v = [tap view];
//	if (v == momentView) {
//		
//		CGPoint point = [tap locationInView:self.view];
//		
//        if (_momentManager.isCurrentMomentHasCaption) {
//            [self showRemoveCaptionMenu:point];
//        }
//        else{
//            [self showAddCaptionMenu:point];
//        }
//		
//        
//	}
//	else if (isPad || isPhone5) {
//		
//		CGPoint point = [tap locationInView:self.view];
//		
//		if (point.x< CGRectGetMinX(momentContainer.frame)) { // preview moment
//			[self toPreviousPage:nil];
//		}
//		else if(point.x> CGRectGetMaxX(momentContainer.frame)){
//		
//			[self toNextPage:nil];
//		}
//
//	}

}

- (IBAction)toggleSideControl:(id)sender{
    if(self.isSideControlOpen){
        [self closeEditSideControl];
    }
    else{
        [self openEditSideControl];
    }
}


- (void)openEditSideControl{
    
    if (!editSideControlVC) {
        editSideControlVC = [[EditSideControlViewController alloc] init];
        editSideControlVC.view.alpha = 1;
        editSideControlVC.vc = self;
        editSideControlVC.momentV = momentView;
    }
    

    editSideNav = [[UINavigationController alloc] initWithRootViewController:editSideControlVC];
    editSideNav.view.frame = CGRectMake(0, 0, editSideControlVC.view.width, editSideControlVC.view.height + kHNavigationbar);

    [self.view insertSubview:editSideNav.view belowSubview:momentContainer];

    
    CGFloat w = editSideControlVC.view.width;
    [UIView animateWithDuration:.3 animations:^{
        [momentContainer setOrigin:CGPointMake(w, 0)];
        [sideControlB moveOrigin:CGPointMake(w, 0)];
        [hotkeyB moveOrigin:CGPointMake(w, 0)];
      
    } completion:^(BOOL finished) {
    
        [UIView animateWithDuration:.3 animations:^{
            sideControlB.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
        }];
    }];
}
- (void)closeEditSideControl{
    
    [UIView animateWithDuration:.3 animations:^{
        [momentContainer setOrigin:CGPointMake(0, 0)];
        [sideControlB moveOrigin:CGPointMake(-editSideControlVC.view.width, 0)];
        [hotkeyB moveOrigin:CGPointMake(-editSideControlVC.view.width, 0)];
       
    } completion:^(BOOL finished) {
        [editSideControlVC.navigationController.view removeFromSuperview];
        editSideControlVC = nil;
        [UIView animateWithDuration:.3 animations:^{
            sideControlB.transform = CGAffineTransformIdentity;
        }];
    }];
}




- (IBAction)toggleHotkey:(id)sender{
    if (self.isHotkeyBannerShown) {
        [self hideHotkeyBanner];
    }
    else{
        [self showHotkeyBanner];
    }
}

- (void)showHotkeyBanner{
    [self.view insertSubview:hotkeyBanner belowSubview:bottomBanner];
}
- (void)hideHotkeyBanner{
    [hotkeyBanner removeFromSuperview];
}

- (IBAction)openPhotoEdit:(UIView*)v{
    
	//如果没有v，就不弹出photoVC
	if (!v) {
		return;
	}
    
		photoVC = [[EditPhotoViewController alloc]init];
		photoVC.vc = self;
        photoVC.view.alpha = 1;
    
//	}
    
	[photoVC addNewPiece:v];
    
	
	[self fadeMomentViewForWidget:v];
    
//    [self.view addSubview:photoVC.view];
    [root.view addSubview:photoVC.view];
    
}



- (void)closePhotoEdit{
	
    [self unfadeMomentView];
	
	[photoVC.view removeFromSuperview];
	
    
}

/**

 因为cropVC需要addSubview：widget，所以就不再mv上了。
 
 其实也可以设计，在原本的mv上进行crop！
 */
- (IBAction)openPhotoCrop:(UIImageView*)widget{
    
	if (!widget) {
		return;
	}
    
    if (!photoCropVC) {
        photoCropVC = [[PhotoCropViewController alloc]init];
        photoCropVC.view.alpha = 1;
        photoCropVC.vc = self;
       
        
    }
    
    photoCropVC.piece = widget;
	
    [self.view addSubview:photoCropVC.view];
	
	
    
}
- (void)closePhotoCrop:(UIView*)widget{
	
	[momentView addElement:widget];
	
    [photoCropVC.view removeFromSuperview];
}


/*
 不用popVC的原因是inputAccssory弹出的view不能在popup的情况下正确event，点击就退出
 
 textWidget 是过去的用法，现在是LabelModelView
 */
- (IBAction)popTextEdit:(LabelModelView*)textWidget{
	L();
	if (!textVC) {
		textVC = [[ICATextViewController alloc]init];
		textVC.view.alpha = 1;
        textVC.delegate = self;
	}
    
    textVC.label = textWidget;


   UINavigationController *nav = [[LandScapeNavigationController alloc]initWithRootViewController:textVC];
    nav.view.frame = CGRectMake(0, 0, textVC.view.width, textVC.view.height + kHPopNavigationbar);
    if (isPad) {
        
        pop = [[UIPopoverController alloc] initWithContentViewController:nav];

        pop.popoverContentSize = nav.view.size;
        if (isIOS6) {
            [pop presentPopoverFromRect:CGRectMake(_w/2, isIOS7?_h/2:5, 2, 2) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
 
        }
        else{
            
            /// patch bug for ios5
             [pop presentPopoverFromRect:CGRectMake(_w/2, 20, 2, 2) inView:self.view permittedArrowDirections:0 animated:YES];
        }

    }
	else{
		[root presentModalViewController:nav animated:YES];

	}
	
    
	
}

- (void)closeTextEdit{
	
	if (isPad) {

        [pop dismissPopoverAnimated:YES];
	}
	else{
        
		[root dismissModalViewControllerAnimated:YES];
	}
    
}


- (void)finishTextEdit:(LabelModelView*)textWidget{
    
	[momentView addTextWidget:textWidget];
    
    [self closeTextEdit];
}



- (IBAction)popShare:(UIButton*)sender{
    
    CGRect buttonRect = [hotkeyBanner convertRect:sender.frame toView:self.view];
    NSLog(@"buttonRect # %@",NSStringFromCGRect(buttonRect));
 
    if (isIOS6) {
        [self showActivityVC];
    }   
    else{
        [self showMomentShareV:buttonRect];

    }
}


- (void)showActivityVC{
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[[UIImage imageWithView:momentView],SHARE_MSG] applicationActivities:nil];
    
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact,UIActivityTypeCopyToPasteboard];
    activityViewController.completionHandler = ^(NSString *activityType, BOOL complete){
        NSLog(@"completeHandler # %@ %d",activityType,complete);
        if (complete) {
            if (activityType == UIActivityTypeSaveToCameraRoll) {
                [[EALoadingView sharedLoadingView] addTitle:@"Saved Successfully!"];
            }
        }
        
    };

    [root presentViewController:activityViewController animated:YES completion:^{
        
    }];
    
    
}


- (void)showMomentShareV:(CGRect)buttonRect {
    if(!momentShareV){
        CGFloat wShareV = isPad?320:280;
        CGFloat hShareV = isPad?80:60;
        momentShareV = [[MomentShareView alloc]initWithFrame:CGRectMake(buttonRect.origin.x - wShareV/2 - 10, buttonRect.origin.y -10, wShareV, hShareV)];
        
        momentShareV.delegate = self;
    }
    
    [self.view addSubview:[[SlideViewController sharedInstance] view]];
	[[SlideViewController sharedInstance] slideInView:momentShareV from:SlideDirectionFromRight];
}

//- (IBAction)showAddCaptionMenu:(CGPoint)point {
//    [EAKxMenu showMenuInView:self.view fromRect:CGRectMake(point.x, point.y, 10, 10) menuItems:self.kxEditMenuAddCaptionItems];
//}
//
//- (IBAction)showRemoveCaptionMenu:(CGPoint)point{
//    [EAKxMenu showMenuInView:self.view fromRect:CGRectMake(point.x, point.y, 10, 10) menuItems:self.kxEditMenuRemoveCaptionItems];
//}
//


- (void)showPageManagerVC{
    
    if (!pageManagerVC) {
        pageManagerVC = [[PageManagerViewController alloc]init];
        pageManagerVC.view.alpha = 1;
        pageManagerVC.vc = self;
    }
  
    [self saveCurrentAlbum];


    previewB.hidden = YES;
    
    [pageManagerVC switchToIndex:_momentManager.currentMomentIndex];

    pageManagerVC.view.transform = CGAffineTransformMakeScale(2, 2);
    
    [self.view addSubview:pageManagerVC.view];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        pageManagerVC.view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
//    L();
//    [_momentManager displayElment];
}

- (void)hidePageManagerVC{
    
    
//    self.view.transform = CGAffineTransformMakeScale(2, 2);
//    [pageManagerVC.view removeFromSuperview];
    
    previewB.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        //        self.view.transform = CGAffineTransformIdentity;
      pageManagerVC.view.transform = CGAffineTransformMakeScale(1.7, 1.7);

        
    } completion:^(BOOL finished) {


        [pageManagerVC.view removeFromSuperview];
        pageManagerVC = nil;
    }];
    
    
}




//
//#pragma mark - Intern Fcn
//
//- (id)firstWidgetInPoint:(CGPoint)point{
//	id firstWidget;
//    
//    // subviews 最后的object才是view最上层的那个
//	
//	for (int i = [currentMomentV.subviews count]-1; i>=0 ;i--) {
//		UIView *v =currentMomentV.subviews[i];
//		// 遍历currentMomentV中所有的PhotoWidget
//		if ([v isKindOfClass:[PhotoWidget class]]) {
//			
//			//把point转换成photoWidget的坐标系，主要是为了point能够旋转导致frame变大，放大和缩小？
//			CGPoint point2 = [v convertPoint:point fromView:momentContainer];
//			
//			if (CGRectContainsPoint(v.bounds, point2)) {
//				
//				firstWidget = v;
//				break;
//			}
//			
//			
//		}
//	}
//    
//	
//	return firstWidget;
//}


#pragma mark - Navigation
- (void)toPreview{
    
    [self saveCurrentAlbum];
    
    [root editToPreview];
}



#pragma mark - Function


//
//- (void)toPreviousMoment {
//    [self saveCurrentAlbum];
//    
//    [_momentManager toPreviousMoment];
//}
//- (void)toNextMoment {
//    [self saveCurrentAlbum];
//    
//    [_momentManager toNextMoment];
//}
//
//
- (void)toPageAtIndex:(int)index{
    
//    NSLog(@"element # %@",_momentManager.currentMoment.codingElements);
    
    [_momentManager toMomentAtIndex:index];


}

- (void)addPage{
	
    L();
	
     [self saveCurrentAlbum];
    
     Moment *newMoment = [_momentManager addMoment];
    
    if (newMoment) {
        [_momentManager toMoment:newMoment];
       
        [self updatePageControl];
        [pageManagerVC reloadCarousel];
    }

}

- (void)deletePage{
    
    if ([_momentManager deleteMoment]) {
    
        if (_momentManager.currentMomentIndex > 0) {
            _momentManager.currentMomentIndex --;
        }
        else{
            _momentManager.currentMomentIndex = 0;
        }
        
        [self updatePageControl];
        
        [pageManagerVC reloadCarousel];
    }
    
    
}

- (void)shareMomentWithType:(int)type{
	
	[[LoadingView sharedLoadingView]addInView:self.view];
    
	UIImage *img = [UIImage imageWithView:momentView];
    
	///momentView 恢复IMV
	[[ICAExportController sharedInstance]shareImage:img type:type];
    
}




/**
 1. 当back回managerVC
 2. 当切换moment时
 4. 当app quit时， RootVC会调用
 
 
 5. 当SidebarPage open的时候会保存album，更新preview image (应该只调用momentView.willsave)
 */
- (void)saveCurrentAlbum{
	L();
 
	/// 保存当前页面的preview
	[momentView savePreviewImage];
//    NSLog(@"before save current album");
//    [_momentManager displayElment];
    /// 这里的album是无论如何都会被save的，可以加一个判断！
    [manager.currentAlbum save];

}

#pragma mark - Intern Fcn

///// 当load新的album时调用
- (void)updateAlbum{
    
	titleL.text = _album.title;
    
}

/// 当同一album调用新的moment时调用, update momentV
- (void)updatePage{
    
//    NSLog(@"coding element # %@",)
    NSLog(@"update moment # %d",_momentManager.currentMomentIndex);
    
	momentView.moment = [_momentManager currentMoment];
    
	[self updatePageControl];
	
}

- (void)updatePageControl{
	
	pageControl.numberOfPages = _momentManager.numberOfMoments;
	pageControl.currentPage = _momentManager.currentMomentIndex;
    
}


- (void)fadeMomentViewForWidget:(id)v {
    backB.hidden = YES;
    hotkeyB.hidden = YES;
    sideControlB.hidden = YES;
    [momentView fadeSubviewsExcept:v];
}

- (void)unfadeMomentView {
    backB.hidden = NO;
    hotkeyB.hidden = NO;
    sideControlB.hidden = NO;
    [momentView unfadeSubviews];
}

#pragma mark -

- (void)test{
//  NSLog(@"self.album # %@, _album # %@",self.album,_album);
    
//    [self popTextEdit:[LabelModelView defaultInstance]];
    
    L();
//    validator = [[Validator alloc] initWithViewController:self];
//    
////    Validator.i = 12;
//    validator.completionHandler = ^(BOOL completed){
//        NSLog(@"do complete;");
//        [self showDeleteAlert];
//    };
//    
//    [validator validate];
//
  
}
@end
