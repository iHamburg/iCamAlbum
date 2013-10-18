//
//  ImageModelView.h
//  Everalbum
//
//  Created by AppDevelopper on 30.07.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "Protocols.h"

@interface ImageModelView : UIImageView<Widget, SDWebImageDownloaderDelegate>{

}

@property (nonatomic, strong) NSString *imgName;


///Icon Sticker 初始化
- (id)initWithImageName:(NSString*)imgName;

- (id)initWithFBPhoto:(id)fbPhoto;


@end
