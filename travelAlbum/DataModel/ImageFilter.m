//
//  ImageFilter.m
//  InstaMagazine
//
//  Created by XC  on 10/25/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ImageFilter.h"
//#import "GPUImage.h"

@implementation ImageFilter

@synthesize name,className,type, thumbName;

- (id)initWithType:(ImageFilterType)_type dict:(NSDictionary*)dict{
    type = _type;
    if (self = [super init]) {
        name = dict[@"name"];
        className = dict[@"class"];
        thumbName = @"filterThumb.png";
    }
    return self;
}

- (UIImage*)imageByFilteringImage:(UIImage*)originalImage{
//    NSString *className = filter.className;
//    NSLog(@"className:%@",className);
//    id selectedFilter = [[NSClassFromString(className) alloc]init];
	
    //    GPUImageFilter *selectedFilter = [[GPUImageAmatorkaFilter alloc]init];
    
//    if ([selectedFilter isKindOfClass:[GPUImageContrastFilter class]]) {
//        [(GPUImageContrastFilter*)selectedFilter setContrast:1.2];
//    }
//    else if([selectedFilter isKindOfClass:[GPUImageExposureFilter class]]){
//        [(GPUImageExposureFilter*)selectedFilter setExposure:0.3];
//    }
//    else if([selectedFilter isKindOfClass:[GPUImageSaturationFilter class]]){
//        [(GPUImageSaturationFilter*)selectedFilter setSaturation:1.5];
//    }
//    else if([selectedFilter isKindOfClass:[GPUImageEmbossFilter class]]){
//        [(GPUImageEmbossFilter*)selectedFilter setIntensity:0.4];
//    }
//    else if([selectedFilter isKindOfClass:[GPUImageHueFilter class]]){
//        [(GPUImageHueFilter*)selectedFilter setHue:60];
//    }
//
//    else if([selectedFilter isKindOfClass:[GPUImageFalseColorFilter class]]){
//        [(GPUImageFalseColorFilter*)selectedFilter setFirstColor:(GPUVector4){0.3f, 0.3f, 0.0f, 1.0f}];
//        [(GPUImageFalseColorFilter*)selectedFilter setSecondColor:(GPUVector4){1.0f, 1.0f, 1.0f, 1.0f}];
//    }
//    else if([selectedFilter isKindOfClass:[GPUImageHighlightShadowFilter class]]){
//        [(GPUImageHighlightShadowFilter*)selectedFilter setShadows:0.0];
//        [(GPUImageHighlightShadowFilter*)selectedFilter setHighlights:0.0];
//    }
//    
//    UIImage *img = [selectedFilter imageByFilteringImage:originalImage];
//
//    return img;


	return originalImage;
}
@end
