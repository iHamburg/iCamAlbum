//
//  CodingText.h
//  InstaMagazine
//
//  Created by AppDevelopper on 29.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "CodingObj.h"

@interface CodingText : CodingObj

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) UIColor *backgroundColor, *strokeColor, *fontColor;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, assign) float fontSizeFaktor;
@property (nonatomic, assign) int textAlignment;
@property (nonatomic, assign) float bgAlpha;

- (id)initWithTextWidget:(id)textWidget;
@end
