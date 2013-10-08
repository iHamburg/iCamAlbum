//
//  AlbumLoader.m
//  XappCard
//
//  Created by  on 01.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "PhotoAlbumLoader.h"
#import "UtilLib.h"

@implementation PhotoAlbumLoader

@synthesize delegate;

+(id)sharedInstance{
	
	static id sharedInstance;
	
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (id)init{
	if (self = [super init]) {
		assetslibrary = [[ALAssetsLibrary alloc] init];

	}
	
	return self;
}


- (void)loadURL:(NSURL*)url delegate:(id<PhotoAlbumLoaderDelegate>)_delegate{
	if (!url) {
		NSLog(@"load null url");
		return;
	}
	
	ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
	{
//			NSLog(@"resultblock");
		[_delegate albumLoaderDidLoadAsset:myasset];
		
	};
	
	ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
	{
		
		NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
	};
	
	[assetslibrary assetForURL:url
				   resultBlock:resultblock
				  failureBlock:failureblock];
}

+ (void)loadUrls:(NSArray*)array withKey:(NSString*)key delegate:(id<PhotoAlbumLoaderDelegate>)delegate{
	if (ISEMPTY(array)) {
		return;
	}

	ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
	
	for(int i = 0; i<[array count];i++) {
		
		NSURL *url = [array objectAtIndex:i];
		ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
		{
//			NSLog(@"resultblock");
			[delegate didLoadAsset:myasset withKey:key];
			
		};
		
		ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
		{
			
			NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
		};
		
		[assetslibrary assetForURL:url 
					   resultBlock:resultblock
					  failureBlock:failureblock];
	}

}

@end
