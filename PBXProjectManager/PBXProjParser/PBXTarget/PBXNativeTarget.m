//
//  PBXNativeTarget.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXNativeTarget.h"

#import "PBXFileReference.h"

#import "PBXProjParser.h"

#import "PBXObjects.h"

@interface PBXNativeTarget ()

@property (nonatomic, strong) NSMutableDictionary *targetAttrs;

@end

@implementation PBXNativeTarget

- (instancetype)initWithObjectId:(NSString *)targetId data:(NSDictionary *)data targetAttrs:(NSDictionary *)targetAttrs
{
    self = [super initWithObjectId:targetId data:data];
    if (self)
    {
        self.targetAttrs = (NSMutableDictionary *)targetAttrs;
        
        NSString *productRefId = data[@"productReference"];
        self.productReference = [[PBXFileReference alloc] initWithObjectId:productRefId data:[PBXProjParser sharedInstance].objects.data[productRefId]];
    }
    return self;
}

// 获取产品类型
- (NSString *)getProductType
{
    return self.data[@"productType"];
}

// 设置产品类型
- (void)setProductType:(NSString *)productType
{
    self.data[@"productType"] = productType;
}

// 获取target属性
- (NSString *)getAttribute:(NSString *)name
{
    return self.targetAttrs[name];
}

// 设置target属性
- (void)setAttribute:(NSString *)name value:(NSString *)value
{
    if (!name || !value) return;
    
    self.targetAttrs[name] = value;
}

- (NSMutableDictionary *)targetAttrs
{
    if (!_targetAttrs)
    {
        _targetAttrs = [[NSMutableDictionary alloc] init];
    }
    return _targetAttrs;
}

@end
