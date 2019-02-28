//
//  PBXObject.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/13.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@interface PBXObject ()

@end

@implementation PBXObject

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    self = [super init];
    if (self)
    {
        _objectId = objId;
        
        if (![data isKindOfClass:[NSMutableDictionary class]])
        {
            NSLog(@"data格式错误！！通知我立即修改！！！");
        }
        _data = (NSMutableDictionary *)data;
        
        _rawData = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:data]];
        
    }
    return self;
}

- (NSString *)genObjectId
{
    NSString *examplehash = @"D04218DC1BA6CBB90031707C";
    // 创建一个新的 uuid
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    // 获取UUID的字符串表示形式
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    
    uuidString = [[uuidString mutableCopy] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return [uuidString substringToIndex:examplehash.length];
}

- (NSString *)getISA
{
    return self.data[@"isa"];
}


@end
