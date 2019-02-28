//
//  PBXNavigatorItem.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface PBXNavigatorItem : PBXObject

// 获取条目名称
- (NSString *)getName;

- (void)setName:(NSString *)name;

// 获取文件引用路径
- (NSString *)getPath;

- (void)setPath:(NSString *)path;

- (NSString *)getSourceTree;

- (void)setSourceTree:(NSString *)sourceTree;

@end

NS_ASSUME_NONNULL_END
