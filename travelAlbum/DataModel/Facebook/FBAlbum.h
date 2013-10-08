//
//  FBAlbum.h
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookManager.h"
#import "SDWebImageDownloader.h"



@interface FBAlbum : NSObject<FBRequestDelegate,SDWebImageDownloaderDelegate>{
    FBRequest *albumCoverRequest;
    FBRequest *photoInAlbumRequest;
}

@property (nonatomic, strong) NSString *albumID;
@property (nonatomic, strong) NSString *coverID;
@property (nonatomic, strong) NSString *coverLink;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int numberOfPhotos;
@property (nonatomic, strong) UIImage *coverImage;
@property (nonatomic, strong) NSMutableArray *fbPhotos; // array of FBPhotos


- (id)initWithDictionary:(NSDictionary*)dict;

@end
