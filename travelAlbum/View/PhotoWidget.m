//
//  PhotoWidgetView.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 21.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoWidget.h"
#import "CodingPhoto.h"
#import "FBPhoto.h"
#import "ICARootViewController.h"
#import "FileManager.h"

@implementation PhotoWidget

@synthesize imgName,croppedFlag;
@synthesize menuItems;

/*
 
 
 PadRetina: image:640x480x2, frame:640x480
 Pad: image:480x320, frame 480x320
 phoneRetina: image 480x320, frame 240x160
 */



#pragma mark -


- (id)initWithFrame:(CGRect)frame{

	if (self = [super initWithFrame:frame]) {
		[self firstLoad];
		[self load];
	}
	
	return self;
	
}


- (id)initWithAsset:(ALAsset*)asset{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
	
	// ipad 最大1024， ipadretina,最大2048
	CGImageRef iref = [rep fullScreenImage];
	
	UIImage *largeimage = [UIImage imageWithCGImage:iref scale:kRetinaScale orientation:UIImageOrientationUp];

	//640x480
	CGFloat minLength = 480;
	
	if (isPhone) {
		minLength = 240;
	}
    
	
    // 最小边是320,
    UIImage *scaledImage =  [largeimage imageByScaleingWithMinLength:minLength];

	size = scaledImage.size;


    if (self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {

        self.image = scaledImage;
		
        imgName = [[[AlbumManager sharedInstance]currentAlbum] nextPhotoImgName];
       
		[scaledImage saveWithName:imgName];
        
    }
    return self;

}

/*
 在imageDownloader:didFinished: 中 save imgname
 */
- (id)initWithFBPhoto:(FBPhoto*)fbPhoto{
	CGFloat w = fbPhoto.width;
	CGFloat h = fbPhoto.height;
	//	NSLog(@"w # %f,h # %f",w,h); // w # 540.000000,h # 720.000000
	CGFloat screenScale = [UIScreen mainScreen].scale;
	CGFloat maxLength = isPad?640:320;
	
	
	CGFloat scaleToMaxLength = MAX(w/screenScale, h/screenScale)/maxLength;
	if (scaleToMaxLength<=1) {
		size = CGSizeMake(w/screenScale, h/screenScale);
	}
	else{
		size = CGSizeMake(w/(screenScale*scaleToMaxLength), h/(scaleToMaxLength*screenScale));
	}
	
	if (self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {

		NSString *urlStr = fbPhoto.originalURLStr;
		
      //调用 sddownloader
		[SDWebImageDownloader downloaderWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] delegate:self];

	}
	return self;
}

//load from Coding, 可能是cropped
- (id)initWithCodingPhoto:(CodingPhoto*)v{
	
	if (self = [super initWithFrame:v.bounds]) {
		
		// initWithFrame 已经自动load过了，甚至firstload？？？
		[self load];
		
		self.layer.anchorPoint = v.anchorPoint;
		self.transform = v.transform;
		self.center = v.center;
        
		self.imgName = v.imgName;
		self.layer.borderWidth = v.borderWidth;
		self.layer.borderColor = v.borderColor.CGColor;
        self.croppedFlag = v.croppedFlag;
	

	}
	return self;
}

/**
 
 borderwidth 根据图片最短边来定 width*0.02
 
 */

- (void)firstLoad{
	L();
	self.layer.borderColor = [UIColor whiteColor].CGColor;
	
	self.layer.borderWidth = kWPhotoWidgetFrame;
	
    croppedFlag = NO;
    
}
- (void)load{

	self.userInteractionEnabled = YES;

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shouldRasterize = YES;
	self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;


}



- (id)copyWithZone:(NSZone *)zone{
    
	
	PhotoWidget *copy = [[PhotoWidget alloc]initWithFrame:self.bounds];
	
    copy.imgName =  [[[AlbumManager sharedInstance]currentAlbum]nextPhotoImgName];
    copy.layer.anchorPoint = self.layer.anchorPoint;
    copy.transform = self.transform;
    copy.center = self.center;
   
	copy.croppedFlag = self.croppedFlag;
    copy.image = self.image;
    copy.layer.borderColor = self.layer.borderColor;
    
    [FileManager copyFile:[NSString cachesPathForFileName:self.imgName] to:[NSString cachesPathForFileName:copy.imgName]];

    if (copy.croppedFlag){ // cropped状态
        
		[[FileManager sharedInstance]copyFile:[NSString cachesPathForFileName:self.imgName] to:[NSString cachesPathForFileName:copy.imgName]];
          copy.layer.borderWidth = 0;
    }
    

    return copy;
}


#pragma mark - Widget
- (void)loadImage{
	
    if (!croppedFlag) { 
        if (!ISEMPTY(imgName)) {
            UIImage *img = [UIImage imageWithSystemName:imgName];
			self.image = img;
        }
    }
	else{  // image is cropped, load cropped image
        self.image = [UIImage imageWithSystemName:self.croppedImageName];
    }

	
}

- (id)encodedObject{
	
	return [[CodingPhoto alloc]initWithPhotoWidget:self];
}

- (NSArray*)menuItems{

//	if (widgetComp.lockFlag) {
//		menuItems = @[[WidgetComponent unlockItem],[WidgetComponent editItem],[WidgetComponent cropItem]];
//	}
//	else{
//		menuItems = @[[WidgetComponent lockItem],[WidgetComponent editItem],[WidgetComponent cropItem]];
//	}
	return menuItems;

}

- (void)setLockFlag:(BOOL)_lockFlag{
//	widgetComp.lockFlag = _lockFlag;
	
}
- (BOOL)lockFlag{

//	return widgetComp.lockFlag;
	return YES;
}

- (void)deleteDocuments{
    L();
    // delete image and cropped image

    [[FileManager sharedInstance]deleteFile:[NSString cachesPathForFileName:self.imgName]];
    [[FileManager sharedInstance]deleteFile:[NSString cachesPathForFileName:self.croppedImageName]];
    
}

- (void)handleEdit{
	[[NSNotificationCenter defaultCenter]postNotificationName:NotificationEditPhotoWidget object:self];
	
}

#pragma mark - SDDownloader
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image{
	L();

	
	self.image = [image imageByScalingAndCroppingForSize:size];
	
    
    imgName = [[[AlbumManager sharedInstance]currentAlbum]nextPhotoImgName];
  
	[image saveWithName:imgName];
    
}
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error{
	L();
	NSLog(@"error:%@",[error description]);
	[[LoadingView sharedLoadingView]addTitle:@"Download Failed." inView:[[ICARootViewController sharedInstance] view]];
}

#pragma mark -
- (NSString*)croppedImageName{
    return [imgName stringByAppendingString:@"_cropped"];
}
@end
