//
//  PBXBuildPhases.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@class PBXNavigatorItem;

NS_ASSUME_NONNULL_BEGIN

@interface PBXBuildPhases : PBXObject

// 添加编译文件
- (void)addBuildFile:(PBXNavigatorItem *)fileRef;

// 移除编译文件
- (void)removeBuildFile:(PBXNavigatorItem *)fileRef;

// 获取buildActionMask
- (NSString *)getBuildActionMask;

// 设置buildActionMask
- (void)setBuildActionMask:(NSString *)buildActionMask;

@end

NS_ASSUME_NONNULL_END
