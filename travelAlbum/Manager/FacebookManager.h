//
//  FacebookManager.h
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "FBAlbum.h"
#import "FBPhoto.h"

//#define FBAppID @"371156869589289" //Everalbum
#define FBAppID @"213853645405469"   //iCA

@interface FacebookManager : NSObject<FBSessionDelegate, FBRequestDelegate, FBDialogDelegate>{
	Facebook *facebook;
	
    FBRequest *allAlbumsRequest;
    FBRequest *requestFBAlbumToUpload;
    
	NSArray *imgs;  // for upload images
	
	int numOfPhotsToUpload;
	
}

@property (nonatomic, strong) NSString *fbUserName;
@property (nonatomic, strong) NSMutableArray *fbAlbums;
@property (nonatomic, strong) NSMutableDictionary *fbPhotoDict; //photoid - fbphoto


+ (id)sharedInstance;


- (void)feed;
- (void)postImage:(UIImage*)img;


- (void)requestAlbums;
- (FBRequest*)requestAlbumPhotos:(NSString*)albumID withDelegate:(id)delegate;
- (FBRequest*)requestPhoto:(NSString*)photoID withDelegate:(id)delegate;

- (void)reloadAlbums;

- (void)uploadNewAlbum:(NSString*)albumName imgs:(NSArray*)imgs;
@end
