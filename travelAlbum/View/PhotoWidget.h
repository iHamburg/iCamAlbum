//
//  PhotoWidgetView.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 21.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAlbumLoader.h"
#import "AlbumManager.h"
#import "SDWebImageDownloader.h"




@interface PhotoWidget : UIImageView<Widget, SDWebImageDownloaderDelegate, NSCopying>{

	CGSize size;
}

@property (nonatomic, assign) BOOL croppedFlag;   //表示显示的是cropped的image
@property (nonatomic, strong) NSString *imgName;  //完整的图片

- (NSString*)croppedImageName;                    // cropped的图片，png


- (id)initWithAsset:(ALAsset*)asset;
- (id)initWithFBPhoto:(id)fbPhoto;
- (id)initWithCodingPhoto:(id)codingPhoto; // load

- (void)firstLoad;
- (void)load;




@end
