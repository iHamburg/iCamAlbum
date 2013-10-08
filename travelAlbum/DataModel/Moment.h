//
//  Moment.h
//  XappTravelAlbum
//
//  Created by  on 21.01.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//


@interface Moment : NSObject{

}

@property (nonatomic, strong) NSString *name; // albumfilename_234
@property (nonatomic, strong) NSString *bgImageName;
@property (nonatomic, strong) NSURL *bgURL;
@property (nonatomic, strong) NSMutableArray *codingElements; // saved free style elements: codingPhoto
@property (nonatomic, strong) NSString *captionText;

/// 以下不用保存 
@property (nonatomic, strong) NSArray *codingObjkeys;   // 包括了需要encode/decode 的NSObject
@property (nonatomic) UIImage *previewImage;

@property (nonatomic, readonly, assign) BOOL isEmptyMoment;
@property (nonatomic, readonly, strong) NSString *previewImgName; // 默认是name_previewImage， size：scaled的momentView的size(960x640)


- (id)initWithName:(NSString*)aName;

- (void)addWidget:(UIView*)widget;
- (void)deleteWidget:(UIView*)widget;

- (void)deleteDocuments;

@end
