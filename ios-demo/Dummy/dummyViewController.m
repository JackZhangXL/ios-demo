//
//  dummyViewController.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "dummyViewController.h"
#import "MockData.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface dummyViewController ()

@end

@implementation dummyViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tabBarItem.title = @"测试";
        self.tabBarItem.image = [UIImage imageNamed:@"icon.bundle/test@3x.png"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"icon.bundle/test_selected@3x.png"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"width: %f", [[UIScreen mainScreen] bounds].size.width);
    NSLog(@"width: %f", [[UIScreen mainScreen] bounds].size.height);

    [self _jscore];
    [self _archiveListDataWithArray];
}

// 测试 jscore
-(void)_jscore {
    // 创建 JSVirtualMachine 对象 jsvm
    JSVirtualMachine *jsvm = [[JSVirtualMachine alloc] init];
    // 使用 jsvm 的 JSContext 对象 ct
    JSContext *ct = [[JSContext alloc] initWithVirtualMachine:jsvm];

    JSContext *context  = [[JSContext alloc] init];
    // 解析执行 JavaScript 脚本
    [context evaluateScript:@"var i = 4 + 8"];
    // 转换 i 变量为原生对象
    NSNumber *number = [context[@"i"] toNumber];
    NSLog(@"var i is %@, number is %@", context[@"i"], number);

    // 解析执行 JavaScript 脚本
    [context evaluateScript:@"function addition(x, y) { return x + y}"];
    // 获得 addition 函数
    JSValue *addition = context[@"addition"];
    // 传入参数执行 addition 函数
    JSValue *resultValue = [addition callWithArguments:@[@(4), @(8)]];
    // 将 addition 函数执行的结果转成原生 NSNumber 来使用。
    NSLog(@"function is %@; reslutValue is %@",addition, [resultValue toNumber]);
}

// 测试本地数据
-(void)_archiveListDataWithArray {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [pathArray firstObject];
    NSLog(@"%@", cachePath);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 创建文件夹
    NSString *dataPath = [cachePath stringByAppendingPathComponent:@"SampleData"];  // NSPathUtilities.h
    NSError *creatError;
    [fileManager createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:&creatError];

    // 创建 & 查询 & 删除文件
    NSString *listDataPath = [dataPath stringByAppendingPathComponent:@"list"];

    BOOL fileExist = [fileManager fileExistsAtPath:listDataPath];
    if (fileExist) {    // 如果文件存在就先删除
        [fileManager removeItemAtPath:listDataPath error:nil];
    }

    NSData *listData = [@"some cache data" dataUsingEncoding:NSUTF8StringEncoding];     // 将业务数据通过 UTF8 编码方式变成二进制流
    [fileManager createFileAtPath:listDataPath contents:listData attributes:nil];

    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:listDataPath];
    [fileHandler seekToEndOfFile];  // 调整到末尾，在末尾追加
    [fileHandler writeData:[@" more cache data" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler synchronizeFile];  // 从内存写入硬盘
    [fileHandler closeFile];

    // 检查存储
    // 用 NSUserDefaults 将数据以 key-value 的形式存储到 /Library/Preferences 目录下的 info.plist 文件中
    [[NSUserDefaults standardUserDefaults] setObject:@"Jack" forKey:@"loginName"];
    NSString *userDefaultsStr = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginName"];
    NSLog(@"userDefaultsStr --- %@", userDefaultsStr);

    // 复杂存储
    // 序列化自定义数据
    MockData *mockData = [[MockData alloc] init];
    mockData.name = @"Jack";
    mockData.gender = @"male";
    mockData.city = @"Shanghai";

    NSData *aMockData = [NSKeyedArchiver archivedDataWithRootObject:mockData requiringSecureCoding:YES error:nil];
    NSLog(@"aMockData --- %@", aMockData);

    // 反序列化自定义数据
    MockData *uaMockData = [NSKeyedUnarchiver unarchivedObjectOfClass:[MockData class] fromData:aMockData error:nil];
    NSLog(@"MockData.name = %@", uaMockData.name);

    // 硬盘存储位置推荐一：将序列化后的自定义数据保存到 /Library/Preferences 目录下的 info.plist 文件中
    [[NSUserDefaults standardUserDefaults] setObject:aMockData forKey:@"aMockData"];            // 存储
    NSData *encodeMockData = [[NSUserDefaults standardUserDefaults] dataForKey:@"aMockData"];   // 读取
    id unarchiveObj = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class],[MockData class], nil]  fromData:encodeMockData error:nil];
    if([unarchiveObj isKindOfClass:[MockData class]]) {
        NSLog(@"%@", unarchiveObj);
    };

    // 硬盘存储位置推荐二：将序列化后的自定义数据保存到自定义目录中
    [fileManager createFileAtPath:listDataPath contents:aMockData attributes:nil];

    NSData *readListData = [fileManager contentsAtPath:listDataPath];
    id unarchiverData2 = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSData class], [MockData class], nil] fromData:readListData error:nil];
    if([unarchiverData2 isKindOfClass:[MockData class]]) {
        NSLog(@"%@", unarchiverData2);
    };

    NSLog(@"");
}
@end
