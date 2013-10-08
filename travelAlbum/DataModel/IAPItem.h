//
//  IAP.h
//  InstaMagazine
//
//  Created by AppDevelopper on 20.11.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IAPItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *iapDescription;
@property (nonatomic, strong) NSString *iapTitle;

//--------------- //
@property (nonatomic, strong) NSString *iconImageName;
@property (nonatomic, strong) NSString *previewImageName;
@property (nonatomic, assign) BOOL availableFlag;

- (id)initWithDictionary:(NSDictionary*)dict;
@end
