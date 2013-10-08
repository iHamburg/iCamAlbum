//
//  ExportController.h
//  FirstThings_Uni
//
//  Created by  on 12.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "Flurry.h"


@interface ExportController : NSObject<MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UIDocumentInteractionControllerDelegate>{
	MFMailComposeViewController *mailPicker;
	TWTweetComposeViewController *tweetViewController;
	UIDocumentInteractionController *documentController;
	
	int numOfPhotosToSave;
}

+(id)sharedInstance;

- (void)didReceiveMemoryWarning;


- (void)sendEmail:(NSDictionary *)info;
- (void)sendTweetWithText:(NSString*)text image:(UIImage*)image;

- (void)shareImage:(UIImage*)image type:(ShareType)type;
- (void)saveImageInAlbum:(UIImage*)img;

// pdf

- (void)sharePDFWithOtherApp:(NSString*)fileName inRect:(CGRect)rect;
- (void)sendPDFwithName:(NSString*)pdfName;

- (void)sendEmailWithImages:(NSArray*)images;

- (void)exportImages:(NSArray*)imgs toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

- (void)toRate;
- (void)linkToAppStoreWithID:(NSString*)appID;
- (NSString*)stringFromShareType:(ShareType)type;
@end


