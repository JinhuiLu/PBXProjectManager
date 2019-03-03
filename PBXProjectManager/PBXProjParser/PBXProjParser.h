//
//  PBXProjParser.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/13.
//  Copyright © 2019 lujh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PBXProject.h"
#import "PBXObjects.h"
#import "PBXObject.h"

@interface PBXProjParser : NSObject

/**
 pbxproj文件路径
 */
@property (nonatomic, copy, nullable) NSString *pbxprojPath;

/**
 pbxproj的根字典
 */
@property (nonatomic, strong, nullable) NSDictionary *pbxprojDictionary;

/**
 原始pbxproj字典，用于和pbxprojDictionary比较得出变化
 */
@property (nonatomic, copy, nullable) NSDictionary *rawDictionary;

/**
 objects 解析后的工程模型
 */
@property (nonatomic, strong, nullable) PBXProject *project;

@property (nonatomic, strong, nullable) PBXObjects *objects;

/**
 单例

 @return 返回单例对象
 */
+ (instancetype)sharedInstance;

/**
 解析pbxproj文件

 @param projPath 后缀为pbxproj或xcodeproj的文件
 */
- (void)parseProjectWithPath:(NSString *)projPath;

@end

