//
//  AlbumManager.h
//  TravelAlbum_1_0
//
//  Created by  on 25.04.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//


#import "Album.h"
#import "Protocols.h"

@interface AlbumManager : NSObject{
	
	NSMutableArray *_albumFileNames;
    NSMutableArray *_allAlbums;

}

+(id)sharedInstance;
+(void)releaseSharedInstance;


@property (nonatomic, assign) int currentAlbumIndex;

@property (nonatomic, strong) NSString *titleOfCurrentAlbum;
@property (nonatomic, assign) AlbumStatus currentAlbumStatus;
@property (nonatomic, assign) BOOL isFavoriteListed;

@property (nonatomic, readonly, assign) BOOL isThereFavoritedAlbum;
@property (nonatomic, readonly, strong) NSArray *displayedAlbums;
@property (nonatomic, readonly, strong) Album *currentAlbum;  //根据currentalbumIndex自动生成
@property (nonatomic, readonly, strong) NSString *nextPhotoImgName; // 其实可以按照时间生成的
@property (nonatomic, readonly, assign) int numberOfDisplayedAlbums;
@property (nonatomic, readonly, assign) int numberOfAllAlbums;
@property (nonatomic, readonly, assign) int maxNumOfAlbums;
@property (nonatomic, readonly, assign) BOOL isCurrentAlbumLoved;
@property (nonatomic, readonly, assign) BOOL isCurrentAlbumLocked;
@property (nonatomic, readonly, assign) BOOL isCurrentAlbumEmpty;
- (Album*)musterAlbum;
- (Album*)newAlbum;


- (Album*)addAlbumWithTitle:(NSString*)title;
- (int)albumIndexOfAlbum:(Album*)album;

- (BOOL)deleteCurrentAlbum;

/**

 保存albumName到albumFileNames
 
 */
- (void)saveAlbumNamePlist;
- (void)saveCurrentAlbum;

- (void)loveAlbum;
- (void)setupAlbumPassword:(NSString*)password;
- (void)unlockAlbumPassword;
- (BOOL)isPasswordCorrect:(NSString*)password;

/**
 change cover image
 */
- (void)setCoverImageOfCurrentAlbum:(UIImage*)image;

- (void)shareCurrentAlbumWithType:(ShareType)type;

- (void)createPDFForCurrentAlbum;

- (void)getSizeOfAlbum:(Album*)album;

@end
