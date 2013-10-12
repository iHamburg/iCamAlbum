//
//  Protocols.h
//  MyPhotoAlbum
//
//  Created by  on 07.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//




typedef enum{
	ShareToAlbum,
	ShareToFacebook,
	ShareToTwitter,
	ShareToEmail,
    ShareInstagram,
	ShareAlbumToFacebook,
	ShareAlbumSendPDF,
	ShareAlbumSavePDF,
	ShareAlbumSaveImages,
    ShareAlbumSendImages,
	ShareMax
}ShareType;


@protocol Widget <NSObject>

@property (nonatomic, assign) BOOL lockFlag;
@property (nonatomic, strong) NSArray* menuItems;

- (void)handleEdit;

@optional
- (id)encodedObject __deprecated;
- (void)loadImage;  //only for imageview
- (void)deleteDocuments;

/** 以下不会调用, 是为了避免Undeclared selector warning的*/
- (IBAction)menuCropPiece:(id)sender;
- (IBAction)menuLockPiece:(id)sender;
- (IBAction)menuUnlockPiece:(id)sender;
- (IBAction)menuEditPiece:(id)sender;
@end


//@protocol CodingDelegate <NSObject>
//
//- (id)decodedObject __deprecated; // load
//
//@end


