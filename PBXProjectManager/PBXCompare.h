//
//  PBXCompare.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/19.
//  Copyright © 2019 lujh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PBXCompare : NSObject

/**
 比较两个字典数据，并返回data2相对于data1的修改配置的字典

 @param data1 data1
 @param data2 data2
 @return 修改配置的字典
 */
+ (NSDictionary *)compare:(NSDictionary *)data1 withOtherData:(NSDictionary *)data2;


/**
 将修改字典应用到projectData上，并返回修改后的结果

 @param diffDict 修改配置的字典
 @param projectData project字典
 @return 修改后的字典
 */
+ (NSDictionary *)apply:(NSDictionary *)diffDict onProjectData:(NSDictionary *)projectData;


/**
 保存修改的文件
 */
+ (void)save;

@end

NS_ASSUME_NONNULL_END
