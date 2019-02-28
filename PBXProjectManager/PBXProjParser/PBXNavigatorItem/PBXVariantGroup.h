//
//  PBXVariantGroup.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXGroup.h"

@class PBXFileReference;
NS_ASSUME_NONNULL_BEGIN

@interface PBXVariantGroup : PBXGroup

// 添加本地化文件
- (PBXFileReference *)addLocalizedFileWithPath:(NSString *)stringsPath language:(NSString *)lang sourceTree:(NSString *)sourceTree;

@end

NS_ASSUME_NONNULL_END
