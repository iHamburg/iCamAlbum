//
//  ImageFilter.h
//  InstaMagazine
//
//  Created by XC  on 10/25/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
	
    ImageFilterTypeColorAdjusting,
    ImageFilterTypeImageProcessing,
    ImageFilterTypeBlending,
    ImageFilterTypeVisualEffect
	
}ImageFilterType;

@interface ImageFilter : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *thumbName;
@property (nonatomic, assign) ImageFilterType type;

- (id)initWithType:(ImageFilterType)type dict:(NSDictionary*)dict;
- (UIImage*)imageByFilteringImage:(UIImage*)originalImage;

@end
