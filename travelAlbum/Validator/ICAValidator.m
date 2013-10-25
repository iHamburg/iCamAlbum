//
//  ICEValidator.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-24.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "ICAValidator.h"

@implementation ICAValidator

- (id)initWithPassword:(NSString*)truePW_{
    if (self = [self init]) {
        truePW = truePW_;
    }
    return self;
}


- (void)validate{
    static UIAlertView *validatePasswordAlert;
    
    if (!validatePasswordAlert) {
        NSLog(@"init validate alert");
        validatePasswordAlert = [[UIAlertView alloc]initWithTitle:SEnterPWToValidate message:nil delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Done"), nil];
        validatePasswordAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        
    }
    
    validatePasswordAlert.delegate = self;
    [[validatePasswordAlert textFieldAtIndex:0] setText:nil];
    
    [validatePasswordAlert show];

}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *tf = [alertView textFieldAtIndex:0];
        NSString *title = tf.text;

        BOOL completed;
        if ([title isEqualToString:truePW]) {
            completed = YES;
        }
        else{
            completed = NO;
        }
        
        
        completionHandler(completed);
    }
}
@end
