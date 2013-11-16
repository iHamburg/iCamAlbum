//
//  Validator.h
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ValidatorCompletionHandler)(BOOL completed);

@interface Validator : NSObject<UIAlertViewDelegate>{

    ValidatorCompletionHandler completionHandler;

    
}

@property (nonatomic, copy) ValidatorCompletionHandler completionHandler;


- (id)initWithViewController:(UIViewController*)vc;


- (void)validate;
- (void)execute;

@end
