//
//  MomentView.m
//  XappTravelAlbum
//
//  Created by  on 25.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "MomentView.h"
#import <QuartzCore/QuartzCore.h>
#import "EditControlComponent.h"
#import "PhotoWidget.h"
#import "IconWidget.h"
#import "ImageModelView.h"
#import "LabelModelView.h"
#import "UIResponder+MotionRecognizers.h"
#import "FBPhoto.h"
#import "ZDStickerView.h"

NSString *const NotificationChangeCaption = @"ChangeCaption";

@implementation MomentView



@synthesize isShakeLock;

- (void)setMoment:(Moment *)moment{
	

    
	//清除所有old moment的痕迹
	for (UIView *widget in _moment.codingElements) {
		// remove gesture
		NSArray *gestures = widget.gestureRecognizers;
		for (UIGestureRecognizer *gesture in gestures) {
			[widget removeGestureRecognizer:gesture];
		}
		[widget removeFromSuperview];
		
	}
    
	_moment = moment;
	_momentChanged = NO;

//    NSLog(@"bgname # %@, bgurl # %@",_moment.bgImageName,_moment.bgURL);
    if (!ISEMPTY(_moment.bgImageName)) {
         bgV.image = [[UIImage imageWithContentsOfFileUniversal:_moment.bgImageName] imageByScalingAndCroppingForSize:self.bounds.size];
    }
    else if(_moment.bgURL){
        [PhotoAlbumLoader loadUrls:@[_moment.bgURL] withKey:@"BG" delegate:self];
    }
    
//    NSLog(@"_moment.codingElements # %@",_moment.codingElements);
    for (UIView<Widget> *v in _moment.codingElements) {
		
		[self addGestureRecognizers:v];

		[widgetContainer addSubview:v];
	}
    
    if (!ISEMPTY(_moment.captionText)) {
        
        [self addSubview:captionL];
        
        captionL.text = _moment.captionText;
    }
    else{
    
        [captionL removeFromSuperview];
    
    }
    
    
//    UIImageView *imageView = [[UIImageView alloc]
//                              initWithImage:kPlaceholderImage];
//    
//    CGRect gripFrame1 = CGRectMake(50, 50, 140, 140);
//    ZDStickerView *userResizableView1 = [[ZDStickerView alloc] initWithFrame:imageView.frame];
//    userResizableView1.backgroundColor = [UIColor redColor];
//    userResizableView1.contentView = imageView;
//    userResizableView1.preventsPositionOutsideSuperview = NO;
//    [userResizableView1 showEditingHandles];
//    [self addSubview:userResizableView1];
    
//    NSLog(@"moment subview # %@",self.subviews);

}

- (void)setIsShakeLock:(BOOL)_isShakeLock{
	
	isShakeLock = _isShakeLock;
	
	for (UIView<Widget> *v in _moment.codingElements) {
		
		if (isShakeLock == YES) {
			/// 锁上所有的widget
			v.lockFlag = YES;
		}
		else{
			/// 解开所有的widget
			v.lockFlag = NO;
		}
		

	}
}



- (void)setCaptionText:(NSString *)captionText{


    self.momentChanged  = YES;
    
    _moment.captionText = captionText;
   
    captionL.text = captionText;

    if (ISEMPTY(captionL.text)) {
        [captionL removeFromSuperview];
    }
    else{
        [self addSubview:captionL];    
    }
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		[self registerNotifications];
		
		bgV = [[UIImageView alloc] initWithFrame:self.bounds];
		bgV.autoresizingMask = kAutoResize;
		
        widgetContainer = [[UIView alloc] initWithFrame:self.bounds];
		
		controlComp = [[EditControlComponent alloc]initWithFrame:CGRectZero];
		controlComp.momentV = self;
		
        
        captionL = [[UILabel alloc]initWithFrame:CGRectMake(0, _h - (isPad?350:150), 0.6 * _w, isPad?100:50)];
        captionL.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
        captionL.text = @"Today is Monday, our family travel to Shanghai. I love Shanghai!";
        captionL.textColor = [UIColor whiteColor];
        captionL.textAlignment = NSTextAlignmentCenter;
        captionL.font = [UIFont fontWithName:kFontName size:isPad?24:16];
        captionL.userInteractionEnabled = YES;
        captionL.numberOfLines = 0;
        [captionL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        
		
		[self addSubview:bgV];
        [self addSubview:widgetContainer];
        
		/// 如果要显示menu的话，controlComp一定要作为view的subview
		[self addSubview:controlComp];
        
    }
    return self;
}


- (void)dealloc{
//    L();
    // remove all gesture in the moment
    
	for (UIView *widget in _moment.codingElements) {
		
		/// CodingPhoto 没有gestureRecognizers
		
		if ([widget respondsToSelector:@selector(decodedObject)]) {
			return;
		}
		
		// remove gesture
		NSArray *gestures = widget.gestureRecognizers;
		for (UIGestureRecognizer *gesture in gestures) {
			[widget removeGestureRecognizer:gesture];
		}
		
	}
	
	[[NSNotificationCenter defaultCenter]removeObserver:self];
	
	[self removeMotionRecognizer];
}



#pragma mark - Notification


- (void)registerNotifications{
	
	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationAddWidget:) name:kNotificationAddWidget object:nil];
  	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationChangeBGImage:) name:kNotificationChangeMomentBGImage object:nil];
 	[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleNotificationDeleteWidget:) name:kNotificationDeleteWidget object:nil];
	[self addMotionRecognizerWithAction:@selector(motionWasRecognized:)];
}


/**
 from: sidebarVC, textEditVC
 
 photowidget 已经被scale到66%了！！
 
 
 */

- (void)handleNotificationAddWidget:(NSNotification*)notification{
	
	/// 先要随机定位
	
    _momentChanged = YES;
    
	[self addElementRandomed:[notification object]];
    
    
}

- (void)handleNotificationDeleteWidget:(NSNotification*)notification{
	
    _momentChanged = YES;
    
	[self deleteElement:[notification object]];
}



- (void)handleNotificationChangeBGImage:(NSNotification*)notification{

	self.momentChanged = YES;
	
	id obj = [notification object];
    
	[self changeBackground:obj];
  
}

#pragma mark - AlbumLoader
- (void)didLoadAsset:(ALAsset *)asset withKey:(NSString *)key{
    //	L();
	ALAssetRepresentation *rep = [asset defaultRepresentation];
    
	CGImageRef iref = [rep fullScreenImage];
	
	UIImage *largeimage = [UIImage imageWithCGImage:iref scale:kRetinaScale orientation:UIImageOrientationUp];
	UIImage *newImg = [largeimage imageByScalingAndCroppingForSize:self.bounds.size];
	if ([key isEqualToString:@"BG"]) {
		bgV.image = newImg;
	}
    
}
#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(alertView == captionAlert){
        if (buttonIndex == 1) {
            
           
            [self setCaptionText:[[alertView textFieldAtIndex:0] text]];
        }
    }

}
#pragma mark - IBAction
- (IBAction)handleTap:(UITapGestureRecognizer*)sender{
    L();
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationChangeCaption object:nil];
    UIView *v = [sender view];
//    NSLog(@"v # %@",v);
    if (v == captionL) {
        [self showCaptionAlert];
    }
    
}


- (void)showCaptionAlert{
    if (!captionAlert) {
        captionAlert = [[UIAlertView alloc] initWithTitle:SEnterCaption message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        captionAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
    }
    
    [[captionAlert textFieldAtIndex:0] setText:self.moment.captionText];
    [captionAlert show];
    
}

#pragma mark - Motion (Shake)

- (void)motionWasRecognized:(NSNotification*)notif{
	
	L();
	
	[self lockUnlockAllWidgets];
	
}
#pragma mark - Function



/// addElement 在初始化的和时候moment不应该change
- (void)addElement:(UIView*)v{
	
	if (!v) {
		NSLog(@"add nil element # %@",v);
        return;
	}
	
    
	[self addInMoment:v];
	
	[self addGestureRecognizers:v];

	v.transform = CGAffineTransformScale(v.transform, 0.33, 0.33);
	
	v.alpha = 0.3;
//	[self addSubview:v];
    [widgetContainer addSubview:v];
    
	[UIView animateWithDuration:0.3 animations:^{
		v.transform = CGAffineTransformScale(v.transform, 3.0, 3.0);
		v.alpha = 1;
	}];

}

- (BOOL)addTextWidget:(id)textWidget{
    if (![self containElement:textWidget]) {
        
		/// 初始化 widget 放大2被
        
		if (isPad) {
			[textWidget applyScale:2];
		}
        
        [self addElementRandomed:textWidget];
        
        return YES;
	}
    else{
        return NO;
    }

}

- (void)setWidgetLocationRandom:(UIView *)widget {
    _momentChanged = YES;
	/**
     自动旋转！ -30 ～ 30
     */
	CGFloat x = arc4random()%(int)(0.6* self.width) + 0.1* (self.width);
    
	CGFloat y = arc4random()%(int)(0.8* self.height) + 0.1* (self.height);
	
    widget.center = CGPointMake(x,y);
	
	//旋转：-30 ~ 30
	int degree = arc4random()%60-30;
	float radian = degreesToRadians(degree);
    
	widget.transform = CGAffineTransformRotate(widget.transform, radian);
}



- (void)addElementRandomed:(UIView*)widget{
	
	[self setWidgetLocationRandom:widget];
	
	[self addElement:widget];
}
- (void)changeBackground:(id)obj {
 
    if ([obj isKindOfClass:[NSString class]]) {
		_moment.bgImageName = obj;
        _moment.bgURL = nil;
		UIImage *img = [UIImage imageWithContentsOfFileUniversal:_moment.bgImageName];
        bgV.image = [img imageByScalingAndCroppingForSize:self.bounds.size];
	}
	else if([obj isKindOfClass:[NSURL class]]){
		_moment.bgURL = obj;
        _moment.bgImageName = nil;
		[PhotoAlbumLoader loadUrls:@[_moment.bgURL] withKey:@"BG" delegate:self];
	}
    else if([obj isKindOfClass:[ALAsset class]]){
        ALAsset *asset = obj;
        NSURL *url = [[asset defaultRepresentation] url];
        _moment.bgURL = url;
        _moment.bgImageName = nil;
		[PhotoAlbumLoader loadUrls:@[_moment.bgURL] withKey:@"BG" delegate:self];
    }
    
    
}


- (void)deleteElement:(UIView<Widget>*)element{

	_momentChanged = YES;
	
	[_moment deleteWidget:element];
	
	[element removeFromSuperview];


}
- (void)copyElement:(UIView*)piece{

//	L();
		
	UIView* copy = [piece copy];
	
	// 先获得原本的旋转角度
	CGAffineTransform transform = copy.transform;
	float originalradians =  atan2(transform.b, transform.a);
	
	// 在获得新的角度
	int degree = arc4random()%60-30;  //-30-30
	float radian = degreesToRadians(degree);
	
	// 最后是两者的和
	copy.transform = CGAffineTransformRotate(copy.transform, radian-originalradians);
	
	[self addElement:copy];
	
}


- (void)lockUnlockAllWidgets{

    _momentChanged = YES;
    
    self.isShakeLock = !self.isShakeLock;

}



- (void)fadeSubviewsExcept:(UIView*)v{
    
	//所有的widget都变淡,包括背景
	for (UIView *widget in widgetContainer.subviews) {
		if (v!=widget && v!= bgV) {
			widget.alpha = 0.3;
		}
        
	}
}

- (void)unfadeSubviews{
    for (UIView *v in widgetContainer.subviews) {
		v.alpha = 1.0;
	}
}


- (void)savePreviewImage{
    
    
	if (self.isMomentChanged) {
    
        _moment.previewImage = [UIImage imageWithView:self];
        
//        NSLog(@"preview image size # %@, scale # %f",NSStringFromCGSize(_moment.previewImage.size), _moment.previewImage.scale); // 512,384 ?
	}
    else{
        NSLog(@"Warning: moment isn't saved!");
    }
}



#pragma mark - Intern Fcn

//
//- (void)addGestureToView:(UIView*)v{
//	
//	if (!ISEMPTY(v.gestureRecognizers)) {
//		
//		NSLog(@" widget has already gestures");
//		return;
//	}
//	
//	[controlComp addGestureRecognizersToPiece:v];
//	
//}

- (void)addInMoment:(UIView *)v {
    if (![self containElement:v]) {
		[_moment.codingElements addObject:v];
		
	}
}

- (void)addGestureRecognizers:(UIView *)v {
    if (ISEMPTY(v.gestureRecognizers)) {
		[controlComp addGestureRecognizersToPiece:v];
	}
}
- (ImageModelView*)convertPhotoElementToImv:(id)element{
    ImageModelView *imv;
    
    if ([element isKindOfClass:[NSString class]]) { // imgName ->imv
        UIImage *image = [UIImage imageWithSystemName:element];
        
        
        if (isPhone) {
            CGSize size = image.size;
            image = [image imageByScalingAndCroppingForSize:CGSizeMake(size.width/2, size.height/2)];
        }
        
        imv = [[ImageModelView alloc] initWithImage:image];
        
        if ([image hasAlpha]) {
            imv.layer.borderWidth = 0.0;
        }
    }
    else if([element isKindOfClass:[ALAsset class]]){// asset ->imv
        ALAsset *asset = element;
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        
        CGImageRef iref = [rep fullScreenImage];
        
        UIImage *image = [UIImage imageWithCGImage:iref scale:kRetinaScale orientation:UIImageOrientationUp];
        if (isPhone) {
            CGSize size = image.size;
            image = [image imageByScalingAndCroppingForSize:CGSizeMake(size.width/2, size.height/2)];
        }
        imv = [[ImageModelView alloc] initWithImage:image];
    }
    else if([element isKindOfClass:[FBPhoto class]]){
        
    }
    
    return imv;
}

- (void)bringWidgetToFront:(UIView*)widget{
    NSAssert([widgetContainer.subviews containsObject:widget], @"self.subview should contain widget");
    
    //    [self addSubview:widget];
    [widgetContainer addSubview:widget];
    
    
    [_moment.codingElements removeObject:widget];
    [_moment.codingElements addObject:widget];
}

#pragma mark -


- (BOOL)containElement:(UIView*)v{
//	return [moment.elements containsObject:v];
	
	return [_moment.codingElements containsObject:v];
}

@end
