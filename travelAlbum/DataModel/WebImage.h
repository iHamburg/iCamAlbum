//
//  WebImage.h
//  Everalbum
//
//  Created by AppDevelopper on 13-8-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
@interface WebImage : UIImage<SDWebImageDownloaderDelegate>

- (id)initWithURL:(NSString*)urlStr;

@end
