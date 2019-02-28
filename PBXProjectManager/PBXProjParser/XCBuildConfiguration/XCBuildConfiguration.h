//
//  XCBuildConfiguration.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/15.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XCBuildConfiguration : PBXObject

#pragma mark - 添加 build setting

// 添加 Framework 搜索路径
- (void)addFrameworkSearchPath:(NSString *)path;

// 添加 Library 搜索路径
- (void)addLibrarySearchPath:(NSString *)path;

// 添加Other Linker Flag
- (void)addOtherLinkerFlag:(NSString *)path;

#pragma mark - 删除 build setting

// 删除 Framework 搜索路径
- (void)removeFrameworkSearchPath:(NSString *)path;

// 删除 Library 搜索路径
- (void)removeLibrarySearchPath:(NSString *)path;

#pragma mark - 获取 build setting

// 获取编译配置 build settings
- (id)getBuildSetting:(NSString *)name;

// 获取名字
- (NSString *)getName;

#pragma mark - 设置 build setting

// 设置编译配置
- (void)setBuildSetting:(NSString *)name settingValue:(id)settingValue;

// 设置bitcode
- (void)setBitCode:(BOOL)value;

// 设置名字
- (void)setName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
