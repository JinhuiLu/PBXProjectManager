//
//  PBXGroup.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXNavigatorItem.h"

#import "PBXTarget.h"

@class PBXVariantGroup;
@class PBXFileReference;

NS_ASSUME_NONNULL_BEGIN

@interface PBXGroup : PBXNavigatorItem

@property (nonatomic, strong) NSMutableArray<PBXNavigatorItem *> *children;

// 获取子项
- (nullable PBXNavigatorItem *)getChild:(NSString *)name recurive:(BOOL)recurive;

// 添加导航条目
- (nullable PBXNavigatorItem *)addChild:(PBXNavigatorItem *)navigatorItem;

// 添加分组
- (nullable PBXGroup *)addGroup:(NSString *)name path:(nullable NSString *)path;

// 添加可变分组，用于放入本地化资源文件
- (nullable PBXVariantGroup *)addVariantGroup:(NSString *)name;

// 移除分组信息
- (void)removeChild:(PBXNavigatorItem *)navigatorItem;

// 添加系统框架
- (PBXFileReference *)addSystemFrameworkWithName:(NSString *)frameworkName target:(PBXTarget *)target;

// 添加框架
- (PBXFileReference *)addFrameworkWithPath:(NSString *)frameworkPath target:(PBXTarget *)target;

// 添加系统动态库
- (PBXFileReference *)addSystemDylibWithPath:(NSString *)dylibPath target:(PBXTarget *)target;

// 添加动态库
- (PBXFileReference *)addDylibWithPath:(NSString *)dylibPath target:(PBXTarget *)target;

// 添加静态库
- (PBXFileReference *)addStaticLibWithPath:(NSString *)staticLibPath target:(PBXTarget *)target;

// 添加头文件
- (PBXFileReference *)addHeaderFileWithPath:(NSString *)headerFilePath;

// 添加Bundle
- (PBXFileReference *)addBundleWithPath:(NSString *)bundlePath target:(PBXTarget *)target;

// 添加本地化文件
- (PBXFileReference *)addLocalizedFileWithPath:(NSString *)stringsPath language:(NSString *)lang target:(PBXTarget *)target;

// 添加文件
- (PBXFileReference *)addFileWithPath:(NSString *)path target:(PBXTarget *)target;

// 查找子项 路径前加"//"匹配所有子节点
- (PBXNavigatorItem *)findItemWithPath:(NSString *)path;

// 查找子项的父文件夹 @path 子项路径 //
- (PBXGroup *)findParentGroupWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
