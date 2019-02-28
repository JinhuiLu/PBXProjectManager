//
//  PBXNativeTarget.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXTarget.h"

@class PBXFileReference;
NS_ASSUME_NONNULL_BEGIN

@interface PBXNativeTarget : PBXTarget

@property (nonatomic, strong) PBXFileReference *productReference;

- (instancetype)initWithObjectId:(NSString *)targetId data:(NSDictionary *)data targetAttrs:(NSDictionary *)targetAttrs;

// 获取产品类型
- (NSString *)getProductType;

// 设置产品类型
- (void)setProductType:(NSString *)productType;

// 获取target属性
- (NSString *)getAttribute:(NSString *)name;

// 设置target属性
- (void)setAttribute:(NSString *)name value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
