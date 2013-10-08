//
//  Album.h
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#define kMusterAlbumName (isPad?@"20130930083734.alb":@"20131001103230.alb")
#define kKeyPathMomentIndex @"momentIndex"


typedef enum {
	AlbumStatusChanged =12,
	AlbumStatusUnChanged
}AlbumStatus;

@class Moment;

@interface Album : NSObject{
	

}

@property (nonatomic, strong) NSString *fileName;  // 20130403090938.alb, date string stored in the app,
@property (nonatomic, strong) NSString *title;     // 取代albumName 作为在app内显示的album名字
@property (nonatomic, strong) NSMutableArray *moments; //all moments
@property (nonatomic, assign) BOOL loved;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage *photoPreviewImage;
@property (nonatomic, assign) int lastMomentIndex;  //永远递增的index，为moment命名用，最后一个moment的index,新的moment的index是maxMomentIndex+1, moments的index的排序因为有不是顺序的
@property (nonatomic, assign) int lastPhotoIndex;



/// 以下不用保存 
@property (nonatomic, strong) NSArray *codingObjKeys;
@property (nonatomic, assign) AlbumStatus status;
@property (nonatomic, strong) UIImage *coverPhotoImage;

@property (nonatomic, assign) BOOL isIconBarOpened;

@property (nonatomic, readonly, assign) BOOL isNewAlbum;
@property (nonatomic, readonly, strong) NSString *coverBgImgName;
@property (nonatomic, readonly, strong) NSString *coverPhotoImgName;
@property (nonatomic, readonly, strong) NSString *pdfName;
@property (nonatomic, readonly, assign) int numberOfMoments;
@property (nonatomic, readonly, strong) NSMutableArray *momentPreviewImages;
@property (nonatomic, readonly, strong) NSString *nextPhotoImgName;
@property (nonatomic, readonly, assign) int locked;
@property (nonatomic, readonly, strong) NSString *createdDatum;

- (NSComparisonResult)compare:(Album*)otherAlbum;

- (Moment*)addMoment; // add moment in the end
- (Moment*)insertMomentAtIndex:(int)index;

- (void)addMoment:(Moment*)moment;
- (void)deleteMomentAtIndex:(int)index;
- (void)moveMomentFrom:(int)indexFrom to:(int)indexTo;
- (Moment*)momentAtIndex:(int)index;
- (int)indexOfMoment:(Moment*)moment;

- (void)save; // EditVC或是ManageVC会调用save，来保存document，preview image？preview是momentView和coverView生成的，所以独立于album
- (void)deleteDocuments;


@end
