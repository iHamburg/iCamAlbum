//
//  FBPhoto.h
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBPhoto : NSObject

@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *thumbURLStr;
@property (nonatomic, assign) float width,height;
@property (nonatomic, strong) NSString *originalURLStr;
@property (nonatomic, strong) NSString *img130URLStr, *img320URLStr, *img480URLStr, *img600URLStr;


- (id)initWithDictionary:(NSDictionary*)dict;


@end
