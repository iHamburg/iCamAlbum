//
//  Validator.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "Validator.h"

@implementation Validator

@synthesize completionHandler;

- (id)initWithViewController:(UIViewController*)vc{
    if (self = [self init]) {
        
    }
    return self;
}

- (void)validate{

    completionHandler(YES);
    
}
- (void)execute{
    
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}
@end
