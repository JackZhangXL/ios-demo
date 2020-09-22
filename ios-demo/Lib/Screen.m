//
//  Screen.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "Screen.h"

@implementation Screen
+ (CGSize)sizeFor58Inch {   // iphonex
    return CGSizeMake(375, 812);
}

+ (CGSize)sizeFor61Inch {   // iphone xr
    return CGSizeMake(414, 896);
}

+ (CGSize)sizeFor65Inch {   // iphone xs max
    return CGSizeMake(414, 896);
}
@end
