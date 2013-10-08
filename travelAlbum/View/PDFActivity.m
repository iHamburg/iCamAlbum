//
//  PDFActivity.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-9-22.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "PDFActivity.h"
#import "ExportController.h"
#import "AlbumManager.h"
#import "EALoadingView.h"

@implementation PDFActivity


- (NSString *)activityType
{
	return NSStringFromClass([self class]);
}

- (NSString *)activityTitle
{
	return NSLocalizedString(@"PDF", @"");
}

- (UIImage *)activityImage
{
    
    return [UIImage imageNamed:@"icon_pdf.png"];
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			return YES;
		}
	}
	
	return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
	for (id activityItem in activityItems) {
		if ([activityItem isKindOfClass:[NSURL class]]) {
			fileURL = activityItem;
		}
	}
}

- (void)performActivity
{

    NSLog(@"ready to perform pdf # %@",fileURL.path);
//    [[EALoadingView sharedLoadingView]add];
    
    AlbumManager *manager = [AlbumManager sharedInstance];
    generatePDFWithImages(manager.currentAlbum.momentPreviewImages, [NSString cachesPathForFileName:manager.currentAlbum.pdfName]);
    [[ExportController sharedInstance]sendPDFwithName:manager.currentAlbum.pdfName];
    
    [self activityDidFinish:YES];
    
}

@end
