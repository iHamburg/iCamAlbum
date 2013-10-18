//
//  TextModelView.h
//  Everalbum
//
//  Created by AppDevelopper on 30.07.13.
//  Copyright (c) 2013 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Protocols.h"
@interface LabelModelView : UILabel<Widget>


@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, assign) float fontSizeFaktor; //fontsize = width*faktor
@property (nonatomic, assign) float bgAlpha; //0-1


+ (id)defaultInstance;


- (void)applyScale:(float)scale;



@end
