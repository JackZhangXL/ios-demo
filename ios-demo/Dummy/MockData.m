//
//  MockData.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "MockData.h"

@implementation MockData

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];      // 处理对象和 key 的关系
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {     // 实现反解方法，需要名字和名称对应
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.city forKey:@"city"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
