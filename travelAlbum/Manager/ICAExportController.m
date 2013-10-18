//
//  ExportController.m
//  FirstThings_Uni
//
//  Created by  on 12.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ICAExportController.h"
#import "ICARootViewController.h"

#import "EALoadingView.h"

@implementation ICAExportController


- (id)init{
	if (self = [super init]) {
		
		_root = [ICARootViewController sharedInstance];
        tweetInitText = UPLOAD_IMAGE_MSG;
        tweetDefaultImg = nil;
//        appIDStr = kAppID;
	}
	return self;
}



- (NSString*)stringFromShareType:(ShareType)type{
	
	NSString *typeName;
	switch (type) {
		case ShareToAlbum:
			typeName = @"Photo2Album";
			break;
		case ShareToEmail:
			typeName = @"Photo2Email";
			break;
		case ShareToFacebook:
			typeName = @"Photo2Facebook";
			break;
		case ShareToTwitter:
			typeName = @"Photo2Twitter";
			break;
		case ShareInstagram:
			typeName = @"Photo2Instagram";
			break;
		case ShareAlbumSaveImages:
			typeName = @"Album2Images";
			break;
		case ShareAlbumSavePDF:case ShareAlbumSendPDF:
			typeName = @"Album2PDF";
			break;
		case ShareAlbumToFacebook:
			typeName = @"Album2Facebook";
			break;

		default:
			typeName = @"Unknown Share";
			break;
	}
	
	return typeName;
}





#pragma mark - Tweet




#pragma mark - PDF

- (void)sharePDFWithOtherApp:(NSString*)fileName inRect:(CGRect)rect{
	
	
	NSString *filePath = [NSString cachesPathForFileName:fileName];
    documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentController.delegate = self;
	
	[[LoadingView sharedLoadingView]removeView];
	
	/*
	 Other common UTIs are "com.apple.quicktime-movie" (QuickTime movies), "public.html" (HTML documents), and "public.jpeg" (JPEG files).
	 */
    documentController.UTI = @"com.adobe.pdf";
	
    [documentController presentOpenInMenuFromRect:rect
										   inView:[[ICARootViewController sharedInstance]view]
										 animated:YES];
	
}

- (void)sendPDFwithName:(NSString*)pdfName{
	NSData *pdfData = [NSData dataWithContentsOfFile:[NSString cachesPathForFileName:pdfName]];
	
	NSDictionary *pdfMailInfo = @{
	@"subject":SSharePDFEmailSubject,
	@"emailBody":UPLOAD_IMAGE_MSG,
	@"attachment":@[pdfData, @"application/pdf",pdfName],
	};
	
	[self sendEmail:pdfMailInfo];
    

}

- (void)sendPDFWithFilePath:(NSString*)filePath{
	NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
	
	NSDictionary *pdfMailInfo = @{
                                  @"subject":SSharePDFEmailSubject,
                                  @"emailBody":UPLOAD_IMAGE_MSG,
                                  @"attachment":@[pdfData, @"application/pdf",[NSString stringWithFormat:@"%@.pdf",APPNAME]],
                                  };
	
	[self sendEmail:pdfMailInfo];
    
    
}

#pragma mark - Share

- (void)shareImage:(UIImage*)img type:(ShareType)type{

	if (type == ShareToAlbum) {

		[self saveImageInAlbum:img];
	}
	else if (type == ShareToFacebook){
		
		// 不发到墙上而是直接发到照片中
		[[FacebookManager sharedInstance]postImage:img];
		
	}
	else if (type == ShareToTwitter){
		
		[self sendTweetWithText:SHARE_MSG image:img];
	}
	else if (type == ShareToEmail){
		
		NSData *contentData = UIImageJPEGRepresentation(img , kJPEGCompressionQuality);
	
		NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
							  SShareImageEmailSubject, @"subject",
							  SHARE_MSG,@"emailBody",
							  [NSArray arrayWithObjects:contentData,@"image/jpeg",[NSString stringWithFormat:@"%@.jpg",APPNAME], nil], @"attachment",
							  nil];
		
		[[ICAExportController sharedInstance] sendEmail:info];
	}
    else if (type == ShareInstagram){
        
        NSString *instagramName = [@"Photo" stringByAppendingPathExtension:@"igo"];
        [img saveWithName:instagramName];
        [self sharePhotoWithInstagram:instagramName];
    
    }
	
    
	NSDictionary *dict = @{
        @"ShareTo": [self stringFromShareType:type],
	};
	
    
	[Flurry logEvent:@"Share Photo" withParameters:dict];
	
    
}



- (void)saveImageInAlbum:(UIImage*)img{
	numOfPhotosToSave = 1;

	ALAssetsLibrary* library  = [[ALAssetsLibrary alloc] init];
    
	[library saveImage:img toAlbum:APPNAME withCompletionBlock:^(NSError *error){
		//            NSLog(@"saved!");
		if (!error) {
			[[LoadingView sharedLoadingView]addTitle:@"Saved!"];
		}else{
			NSLog(@"error # %@",[error description]);
			[[LoadingView sharedLoadingView]addTitle:@"Please try it again later."];
		}
	}];

	
}

//- (void)exportImages:(NSArray*)imgs toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock{
//    
//    ALAssetsLibrary* library  = [[ALAssetsLibrary alloc] init];
//    for (UIImage *image in imgs) {
//        [library saveImage:image toAlbum:albumName withCompletionBlock:completionBlock];
//    }
//    
//}
//
//
//- (void)shareImages:(NSArray*)photos type:(ShareType)type{
//	AlbumManager *manager = [AlbumManager sharedInstance];
//	[[LoadingView sharedLoadingView]add];
//
//	if (type == ShareAlbumSavePDF) {  // save pdf
//		NSString *pdfName = manager.currentAlbum.pdfName;
//		[[ExportController sharedInstance] generatePDF:photos pdfName:pdfName];
//        
//        AlbumManagerViewController *vc = (AlbumManagerViewController*)[[ViewController sharedInstance]managerVC];
//		[self sharePDFWithOtherApp:pdfName inRect:vc.exportAlbumB.frame];
//		
//	}
//	
//	else if(type == ShareAlbumSendPDF){ // send pdf as email
//		
//		NSString *pdfName = manager.currentAlbum.pdfName;
//		[[ExportController sharedInstance] generatePDF:photos pdfName:pdfName];
//		[[ExportController sharedInstance] sendPDFwithName:pdfName];
//	}
//	else if(type == ShareAlbumSaveImages){
//		
//		numOfPhotosToSave = [photos count];
//		for (int i = 0; i<[photos count]; i++) {
//			UIImage *img = photos[i];
//			UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
//		
//		}
//	}
//	else if(type == ShareAlbumToFacebook){
//
//		[[FacebookManager sharedInstance]uploadNewAlbum:manager.currentAlbum.title imgs:photos];
//	}
//	
//	NSDictionary *dict = @{
//	
//	   @"ShareTo": [self stringFromShareType:type],
//	
//	};
//
//	[Flurry logEvent:@"Share Album" withParameters:dict];
//}
//
//
//- (void)shareImages:(NSArray*)photos type:(ShareType)type withName:(NSString*)albumName{
//    if (type == ShareAlbumSavePDF) {  // save pdf
//	
//		[self generatePDF:photos pdfName:albumName];
//        
//        AlbumManagerViewController *vc = (AlbumManagerViewController*)[[ViewController sharedInstance]managerVC];
//		[self sharePDFWithOtherApp:albumName inRect:vc.exportAlbumB.frame];
//		
//	}
//	
//	else if(type == ShareAlbumSendPDF){ // send pdf as email
//		
//		NSString *pdfName = albumName;
//		[[ExportController sharedInstance] generatePDF:photos pdfName:pdfName];
//		[[ExportController sharedInstance] sendPDFwithName:pdfName];
//	}
//	else if(type == ShareAlbumSaveImages){
//		
//		numOfPhotosToSave = [photos count];
//		for (int i = 0; i<[photos count]; i++) {
//			UIImage *img = photos[i];
//			UIImageWriteToSavedPhotosAlbum(img,self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
//            
//		}
//	}
//	else if(type == ShareAlbumToFacebook){
//        
//		[[FacebookManager sharedInstance]uploadNewAlbum:albumName imgs:photos];
//	}
//	
//	NSDictionary *dict = @{
//                        
//                        @"ShareTo": [self stringFromShareType:type],
//                        
//                        };
//    
//	[Flurry logEvent:@"Share Album" withParameters:dict];
//}
- (void)sharePhotoWithInstagram:(NSString*)imgName{
	
	NSString *filePath = [NSString cachesPathForFileName:imgName];
	
    documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentController.delegate = self;
	
	[[LoadingView sharedLoadingView]removeView];
	
	/*
	 Other common UTIs are "com.apple.quicktime-movie" (QuickTime movies), "public.html" (HTML documents), and "public.jpeg" (JPEG files).
	 */
    documentController.UTI = @"com.instagram.exclusivegram";

	documentController.annotation = [NSDictionary dictionaryWithObject:@"my caption" forKey:@"InstagramCaption"];
	
	
    [documentController presentOpenInMenuFromRect:CGRectZero
										   inView:[[ICARootViewController sharedInstance]view]
										 animated:YES];
	
	
}


- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
	L();
	numOfPhotosToSave--;
	
	if (numOfPhotosToSave <= 0) {
		[[LoadingView sharedLoadingView]addTitle:SSaveAlbumAlert];
	}
	
}


@end
