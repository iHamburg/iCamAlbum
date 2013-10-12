//
//  ExportController.h
//  FirstThings_Uni
//
//  Created by  on 12.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//


#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "ExportController.h"

@interface ICAExportController : ExportController< UIAlertViewDelegate, UIDocumentInteractionControllerDelegate>{
	UIDocumentInteractionController *documentController;
	
	int numOfPhotosToSave;
}

- (void)shareImage:(UIImage*)image type:(ShareType)type;
- (void)sharePDFWithOtherApp:(NSString*)fileName inRect:(CGRect)rect;
- (void)sendPDFwithName:(NSString*)pdfName;
- (void)saveImageInAlbum:(UIImage*)img;


- (NSString*)stringFromShareType:(ShareType)type;

@end


