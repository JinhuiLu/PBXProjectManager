//
//  PBXObject.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/13.
//  Copyright © 2019 lujh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PBXProjectConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface PBXObject : NSObject

// 用于修改的字典数据
@property (nonatomic, strong) NSMutableDictionary *data;

@property (nonatomic, copy) NSString *objectId;

@property (nonatomic, copy) NSDictionary *rawData;

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data;

// 创建唯一ID
- (NSString *)genObjectId;

- (NSString *)getISA;



@end

NS_ASSUME_NONNULL_END
