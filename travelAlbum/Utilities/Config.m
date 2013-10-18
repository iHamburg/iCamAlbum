//
//  Config.m
//  Everalbum
//
//  Created by AppDevelopper on 30.07.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import "Config.h"
#import "mach/mach.h"





NSString* const NotificationEditPhotoWidget = @"NotificationEditPhotoWidget";
NSString* const NotificationCropPhotoWidget = @"NotificationCropPhotoWidget";
NSString* const NotificationEditLabelModelView = @"NotificationEditLabelModelView";

int PhotoNum = 12;

BOOL isPaid(void){
	
	BOOL flag;
	
#ifdef FREE
	flag = NO;
#else
	flag= YES;
#endif
	
	return flag;
}


void generatePDFWithImages(NSArray* imgs ,NSString* filePath){
    
	//	 Create the PDF context using the default page size of 612 x 792.
	UIGraphicsBeginPDFContextToFile(filePath, CGRectZero, nil);
	
    //	CGSize imgSize = CGSizeMake(960, 640);
	CGSize pdfSize = CGSizeMake(960, 640);
    //
	if (isPad) {
		pdfSize = CGSizeMake(1024, 768);
    }
	else if(isPhone5){
		pdfSize = CGSizeMake(1136, 640);
	}
    
    //	NSLog(@"imgRect # %@",NSStringFromCGRect(imgRect));
	for (UIImage *img in imgs) {
		UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pdfSize.width, pdfSize.height), nil);
        
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
		CGContextFillRect(context, CGRectMake(0, 0, pdfSize.width, pdfSize.height));
        
		[img drawInRect:CGRectMake(0, 0, pdfSize.width, pdfSize.height)];
        
	}
	UIGraphicsEndPDFContext();
    
	
}

NSArray* getAllFontNames(void){
    NSArray *array = [UIFont familyNames];
    NSMutableArray* fontNames_ = [NSMutableArray array];
    
    for(NSString *familyName in array)
    {
        [fontNames_ addObject:familyName];
    }
    [fontNames_ sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    return fontNames_;
}

