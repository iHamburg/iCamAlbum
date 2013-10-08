//
//  AlbumLoader.h
//  XappCard
//
//  Created by  on 01.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


// url ->asset
@protocol PhotoAlbumLoaderDelegate;

@interface PhotoAlbumLoader : NSObject{
	NSString* loadKey;
	ALAssetsLibrary* assetslibrary;
}


@property (nonatomic, unsafe_unretained)  id<PhotoAlbumLoaderDelegate> delegate;

+(id)sharedInstance;

- (void)loadURL:(NSURL*)url delegate:(id<PhotoAlbumLoaderDelegate>)delegate;
+ (void)loadUrls:(NSArray*)array withKey:(NSString*)key delegate:(id<PhotoAlbumLoaderDelegate>)delegate;

@end

@protocol PhotoAlbumLoaderDelegate <NSObject>

@optional
- (void)didLoadAsset:(ALAsset*)asset withKey:(NSString*)key;
- (void)albumLoaderDidLoadAsset:(ALAsset*)asset;


@end