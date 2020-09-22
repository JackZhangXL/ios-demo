//
//  MockData.h
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MockData : NSObject <NSSecureCoding>
@property(nonatomic, copy, readwrite) NSString *name;
@property(nonatomic, copy, readwrite) NSString *gender;
@property(nonatomic, copy, readwrite) NSString *city;
@end

NS_ASSUME_NONNULL_END
