//
//  ExportController.m
//  FirstThings_Uni
//
//  Created by  on 12.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ExportController.h"
#import "ICARootViewController.h"

#import "EALoadingView.h"

@interface ExportController ()

- (void)sharePhotoWithInstagram:(NSString*)imgName; //xx.igo

//- (void)showRateAlert;
//- (void)toRate;
@end

@implementation ExportController

+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (id)init{
	if (self = [super init]) {
		
		
	}
	return self;
}

/**
 
 当tweet和mail在启动的时候警告？
 */
- (void)didReceiveMemoryWarning{
	L();
	mailPicker = nil;
	tweetViewController = nil;
	documentController = nil;
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


#pragma mark - Email


- (void)sendEmail:(NSDictionary *)info{
	[[LoadingView sharedLoadingView] removeView];
	
	mailPicker = [[MFMailComposeViewController alloc] init];
	mailPicker.mailComposeDelegate = self;
	
	NSString *emailBody = [info objectForKey:@"emailBody"];
	NSString *subject = [info objectForKey:@"subject"];
	NSArray *toRecipients = [info objectForKey:@"toRecipients"];
	NSArray *ccRecipients = [info objectForKey:@"ccRecipients"];
	NSArray *bccRecipients = [info objectForKey:@"bccRecipients"];
	NSArray *attachment = [info objectForKey:@"attachment"]; //0: nsdata, 1: mimetype, 2: filename
	
	[mailPicker setMessageBody:emailBody isHTML:YES];
	[mailPicker setSubject:subject];
    [mailPicker setToRecipients:toRecipients];
	[mailPicker setCcRecipients:ccRecipients];
	[mailPicker setBccRecipients:bccRecipients];
	
	
	if (!ISEMPTY(attachment)) {
		
		[mailPicker addAttachmentData:[attachment objectAtIndex:0] mimeType:[attachment objectAtIndex:1] fileName:[attachment objectAtIndex:2]];
	}
	
	
	[[ICARootViewController sharedInstance] presentModalViewController:mailPicker animated:NO];
}


- (void)sendEmailWithImages:(NSArray*)images{
    mailPicker = [[MFMailComposeViewController alloc] init];
	mailPicker.mailComposeDelegate = self;
	
    NSString *subject = @"Subject Test";
	
	[mailPicker setSubject:subject];
    
    for (int i = 0; i<[images count]; i++) {
        NSString *fileName = [NSString stringWithFormat:@"%d.jpg",i+1];
        [mailPicker addAttachmentData:UIImageJPEGRepresentation(images[i], 0.8) mimeType:@"image/jpg" fileName:fileName];
        
    }
    
	[[ICARootViewController sharedInstance] presentModalViewController:mailPicker animated:NO];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller

		  didFinishWithResult:(MFMailComposeResult)result

						error:(NSError *)error

{
	
	L();
	
    [controller dismissModalViewControllerAnimated:NO];

	if (result == MFMailComposeResultSent) {
			
	}
	
}

#pragma mark - Tweet

- (void)sendTweetWithText:(NSString*)text image:(UIImage*)image{
	[[LoadingView sharedLoadingView]removeView];
	
	// Set up the built-in twitter composition view controller.
	if (!tweetViewController) {
		tweetViewController = [[TWTweetComposeViewController alloc] init];
	}
    
    
	// 如果没有image
	if (!image) {
        image = kQRImage;
    }

	[tweetViewController addImage:image];
	if (!ISEMPTY(text)) {
		[tweetViewController setInitialText:text];

	}
	else{
		[tweetViewController setInitialText:STwitterPostImageMsg];

	}
	    
    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
//        NSString *output;
//        
//        switch (result) {
//            case TWTweetComposeViewControllerResultCancelled:
//                // The cancel button was tapped.
//                output = @"Tweet cancelled.";
//                break;
//            case TWTweetComposeViewControllerResultDone:
//                // The tweet was sent.
//                output = @"Tweet done.";
//				//				[FlurryAnalytics logEvent:@"Tweet sent"];
//                break;
//            default:
//                break;
//        }
		
        [[ICARootViewController sharedInstance] dismissModalViewControllerAnimated:YES];
    }];
    
    // Present the tweet composition view controller modally.
    [[ICARootViewController sharedInstance] presentModalViewController:tweetViewController animated:YES];
	
}
//
- (void)toRate{
	
	
	NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",  
					 kAppID ];   

	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
}



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
	@"emailBody":SSharePDFEmailBody,
	@"attachment":@[pdfData, @"application/pdf",pdfName],
	};
	
	[self sendEmail:pdfMailInfo];
    

}

- (void)sendPDFWithFilePath:(NSString*)filePath{
	NSData *pdfData = [NSData dataWithContentsOfFile:filePath];
	
	NSDictionary *pdfMailInfo = @{
                                  @"subject":SSharePDFEmailSubject,
                                  @"emailBody":SSharePDFEmailBody,
                                  @"attachment":@[pdfData, @"application/pdf",@"iCamAlbum.pdf"],
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
		
		[self sendTweetWithText:SShareText image:img];
	}
	else if (type == ShareToEmail){
		
		NSData *contentData = UIImageJPEGRepresentation(img , kJPEGCompressionQuality);
	
		NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
							  SShareImageEmailSubject, @"subject",
							  SShareText,@"emailBody",
							  [NSArray arrayWithObjects:contentData,@"image/jpeg",@"iCamAlbum.jpg", nil], @"attachment",
							  nil];
		
		[[ExportController sharedInstance] sendEmail:info];
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
    
	[library saveImage:img toAlbum:kAppName withCompletionBlock:^(NSError *error){
		//            NSLog(@"saved!");
		if (!error) {
			[[LoadingView sharedLoadingView]addTitle:@"Saved!"];
		}else{
			NSLog(@"error # %@",[error description]);
			[[LoadingView sharedLoadingView]addTitle:@"Please try it again later."];
		}
	}];

	
}

- (void)exportImages:(NSArray*)imgs toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock{
    
    ALAssetsLibrary* library  = [[ALAssetsLibrary alloc] init];
    for (UIImage *image in imgs) {
        [library saveImage:image toAlbum:albumName withCompletionBlock:completionBlock];
    }
    
}
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


- (void)linkToAppStoreWithID:(NSString*)appID{
    NSURL *url = [NSURL urlWithAppID:appID];
    
    [[UIApplication sharedApplication]openURL:url];
}
@end
