//
//  ImageModelView.m
//  Everalbum
//
//  Created by AppDevelopper on 30.07.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "ImageModelView.h"
#import "AlbumManager.h"
#import "FBPhoto.h"

#import "FileManager.h"
#import "PhotoAlbumLoader.h"
#import "UtilLib.h"


@interface ImageModelView()

@end

@implementation ImageModelView

@synthesize lockFlag,menuItems;


static NSArray *lockMenuItems, *unlockMenuItems;  //默认就是类变量，当一个instance初始化了之后，其他instance也能使用items！！


- (CGSize)imvSizeWithPhotoSize:(CGSize)photoSize{
    
    CGFloat w = photoSize.width;
    CGFloat h = photoSize.height;
    
//    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat screenScale = 1.0;
	CGFloat maxLength = isPad?640:320;
	
	CGSize size;
	CGFloat scaleToMaxLength = MAX(w/screenScale, h/screenScale)/maxLength;
	if (scaleToMaxLength<=1) {
		size = CGSizeMake(w/screenScale, h/screenScale);
	}
	else{
		size = CGSizeMake(w/(screenScale*scaleToMaxLength), h/(scaleToMaxLength*screenScale));
	}
    
    NSLog(@"photoSize # %@, size # %@",NSStringFromCGSize(photoSize),NSStringFromCGSize(size));
	
    return size;
}

#pragma mark -


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		[self firstLoad];
		[self load];
    }
    return self;
}

/// Icon Sticker 初始化

- (id)initWithImageName:(NSString*)imgName{
	
    UIImage *img = [UIImage imageWithSystemName:imgName];
	
	if (self = [self initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)]) {
		_imgName = imgName;
		self.image = img;
		
	}
	
	return self;
}

- (id)initWithImage:(UIImage *)image{
    
    CGSize size = [self imvSizeWithPhotoSize:image.size];
    
    if (self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
        self.image = [image imageByScalingAndCroppingForSize:size];
        _imgName = [[AlbumManager sharedInstance] nextPhotoImgName];
        [self saveImageWithName:_imgName];
    }
    
    return self;
}


/*
 在imageDownloader:didFinished: 中 save imgname
 */
- (id)initWithFBPhoto:(FBPhoto*)fbPhoto{


	CGSize size = [self imvSizeWithPhotoSize:CGSizeMake(fbPhoto.width, fbPhoto.height)];
    
    NSLog(@"init fbphoto # %@",NSStringFromCGSize(size));
    
	if (self = [self initWithFrame:CGRectMake(0, 0, size.width, size.height)]) {
		
		NSString *urlStr = fbPhoto.originalURLStr;
		
		//调用 sddownloader
		[SDWebImageDownloader downloaderWithURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] delegate:self];
		
	}
	return self;
}


/// load
- (id)initWithCoder:(NSCoder *)aDecoder{

	CGRect deBounds = [aDecoder decodeCGRectForKey:@"bounds"];
	CGAffineTransform deTransform = [aDecoder decodeCGAffineTransformForKey:@"transform"];
	CGPoint deCenter = [aDecoder decodeCGPointForKey:@"center"];
	
	/// 
	if (self = [self initWithFrame:deBounds]) {
		_imgName = [aDecoder decodeObjectForKey:@"imgName"];
		self.layer.borderWidth = [aDecoder decodeFloatForKey:@"borderWidth"];
		self.layer.borderColor = [[aDecoder decodeObjectForKey:@"borderColor"] CGColor];
		self.lockFlag = [aDecoder decodeBoolForKey:@"lockFlag"];
		
        self.image = [UIImage imageWithCacheName:_imgName];
        if (!self.image) {
          
            self.image = [UIImage imageWithSystemName:_imgName];
        }
        
//        NSLog(@"Error, initCoder image error# %@",_imgName);    
//        NSAssert(self.image, @"initCoder image error # %@",_imgName);
        
//		self.image = [UIImage imageWithSystemName:_imgName];
//		NSLog(@"imgName # %@,img # %@",_imgName,self.image);
		self.transform = deTransform;
		self.center = deCenter;
	
		
		[self load];
	}
	

		
//		NSLog(@"init with coder # %@",self);
	return self;
}

#pragma mark -

/// save
- (void) encodeWithCoder: (NSCoder *)coder
{

	[self resetAnchorPoint];

	/// super 会自动保存图片，所以不能调用
//	[super encodeWithCoder:coder];
	
	
	[coder encodeCGRect:self.bounds forKey:@"bounds"];
	[coder encodeCGAffineTransform:self.transform forKey:@"transform"];
	[coder encodeCGPoint:self.center forKey:@"center"];
	
	[coder encodeObject:_imgName forKey:@"imgName"];
	[coder encodeFloat:self.layer.borderWidth forKey:@"borderWidth"];
	[coder encodeObject:[UIColor colorWithCGColor:self.layer.borderColor] forKey:@"borderColor"];
	[coder encodeBool:lockFlag forKey:@"lockFlag"];

}

- (id)copyWithZone:(NSZone *)zone{
	
	ImageModelView *copy = [[ImageModelView alloc]initWithFrame:self.bounds];
	copy.imgName =  [[[AlbumManager sharedInstance]currentAlbum]nextPhotoImgName];
    copy.image = self.image;
    copy.layer.borderColor = self.layer.borderColor;
	copy.layer.borderWidth = self.layer.borderWidth;
	
    /// 防止system图片被复制！
    [FileManager copyFile:[NSString cachesPathForFileName:self.imgName] to:[NSString cachesPathForFileName:copy.imgName]];
	
    
	
    return copy;
}


/// 需要初始化或会保存的属性
- (void)firstLoad{
//	L();
	self.layer.borderColor = [UIColor whiteColor].CGColor;
	self.layer.borderWidth = kWPhotoWidgetFrame;
	
	lockFlag = NO;
    
}

/// 不会保存,每次都需要设定的属性
- (void)load{

	self.userInteractionEnabled = YES;
		
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shouldRasterize = YES;
	self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
	
}





#pragma mark - Widget


- (NSArray*)menuItems{
	
	if (!lockMenuItems) {
		lockMenuItems = @[[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Unlock", nil) action:@selector(menuUnlockPiece:)],
				[[UIMenuItem alloc]initWithTitle:@"Edit" action:@selector(menuEditPiece:)],
				[[UIMenuItem alloc]initWithTitle:@"Crop" action:@selector(menuCropPiece:)]];
	}
	
	if (!unlockMenuItems) {
		unlockMenuItems = @[[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Lock", nil) action:@selector(menuLockPiece:)],
				[[UIMenuItem alloc]initWithTitle:@"Edit" action:@selector(menuEditPiece:)],
				[[UIMenuItem alloc]initWithTitle:@"Crop" action:@selector(menuCropPiece:)]];
	}
//
	if (lockFlag) {
		return lockMenuItems;
	}
	else
		return unlockMenuItems;
	
}


- (void)deleteDocuments{
//    L();
	
    // delete image and cropped image
    [[FileManager sharedInstance]deleteFile:[NSString cachesPathForFileName:self.imgName]];
    
}


- (void)handleEdit{
	[[NSNotificationCenter defaultCenter]postNotificationName:NotificationEditPhotoWidget object:self];
	
}


#pragma mark - SDDownloader
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image{
//	L();
    
    /// 还是应该是bounds.size?
	self.image = [image imageByScalingAndCroppingForSize:self.frame.size];

	 _imgName = [[AlbumManager sharedInstance]nextPhotoImgName];
	
    [self saveImageWithName:_imgName];
    
}
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error{
	L();
	NSLog(@"error:%@",[error description]);
	[[LoadingView sharedLoadingView]addTitle:@"Download Failed."];
}

#pragma mark -

- (void)saveImageWithName:(NSString*)name{
    
    [self.image saveWithName:name];
    
}

@end
