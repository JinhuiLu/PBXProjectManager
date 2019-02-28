//
//  PBXFileReference.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXNavigatorItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PBXFileReference : PBXNavigatorItem

// 获取文件类型
- (NSString *)getLastKnownFileType;

- (void)setLastKnownFileType:(NSString *)lastKnownFileType;

- (NSString *)getIncludeInIndex;

- (void)setIncludeInIndex:(NSString *)includeInIndex;

- (NSString *)getExplicitFileType;

- (void)setExplicitFileType:(NSString *)explicitFileType;

@end

NS_ASSUME_NONNULL_END
