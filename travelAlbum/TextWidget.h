//
//  TextWidget.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 24.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"




/**

 stroke 没有width设定，固定白色
 
 */


@interface TextWidget : UILabel<Widget>{
	
	
	
}

@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, assign) float fontSizeFaktor; //fontsize = width*faktor
@property (nonatomic, assign) float bgAlpha; //0-1
@property (nonatomic, strong) UIColor *bgColor, *strokeColor;


- (id)initWithCodingText:(id)codingText;

- (void)firstLoad;
- (void)load;

- (void)applyScale:(float)scale;
- (void)adjustFontSize;


@end
