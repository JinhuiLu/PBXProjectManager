//
//  PBXTarget.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@class XCConfigurationList;
@class PBXSourcesBuildPhase;
@class PBXFrameworksBuildPhase;
@class PBXResourcesBuildPhase;
@class PBXShellScriptBuildPhase;
@class PBXTargetDependency;
@class PBXBuildPhases;
@class XCBuildConfiguration;
NS_ASSUME_NONNULL_BEGIN

@interface PBXTarget : PBXObject

@property (nonatomic, strong) NSMutableArray<PBXTargetDependency *> *dependencies;
@property (nonatomic, strong) NSMutableArray<PBXBuildPhases *> *buildPhases;

@property (nonatomic, strong) XCConfigurationList *buildConfigurationList;

@property (nonatomic, strong) PBXSourcesBuildPhase *sourcesBuildPhase;
@property (nonatomic, strong) PBXFrameworksBuildPhase *frameworkBuildPhase;
@property (nonatomic, strong) PBXResourcesBuildPhase *resourceBuildPhase;

// 获取编译配置
- (XCBuildConfiguration *)getBuildConfigs:(NSString *)scheme;

// 获取编译配置
- (id)getBuildSetting:(NSString *)scheme name:(NSString *)name;

// 设置编译配置
- (void)setBuildSetting:(NSString *)scheme name:(NSString *)name value:(id)value;

// 获取Target名字
- (NSString *)getName;

// 设置Target名字
- (void)setName:(NSString *)name;

// 获取产品名称
- (NSString *)getProductName;

// 设置产品名称
- (void)setProductName:(NSString *)productName;

/**
 添加Shell脚本编译设置

 @param shellScript shell 脚本
 @param path shell路径，传nil则默认"/bin/sh".
 */
- (void)addShellScriptBuildPhase:(NSString *)shellScript path:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
