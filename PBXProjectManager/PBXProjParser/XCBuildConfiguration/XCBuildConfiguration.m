//
//  XCBuildConfiguration.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/15.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "XCBuildConfiguration.h"

#import "PBXCompare.h"

@implementation XCBuildConfiguration

#pragma mark - 添加 build setting

// 添加 Framework 搜索路径
- (void)addFrameworkSearchPath:(NSString *)path
{
    [self _addBuildSettingsWithName:@"FRAMEWORK_SEARCH_PATHS" path:path];
}

// 添加 Library 搜索路径
- (void)addLibrarySearchPath:(NSString *)path
{
    [self _addBuildSettingsWithName:@"LIBRARY_SEARCH_PATHS" path:path];
}

// 添加Other Linker Flag
- (void)addOtherLinkerFlag:(NSString *)path
{
    [self _addBuildSettingsWithName:@"OTHER_LDFLAGS" path:path];
}

#pragma mark - 删除 build setting

// 删除 Framework 搜索路径
- (void)removeFrameworkSearchPath:(NSString *)path
{
    [self _removeBuildSettingsWithName:@"FRAMEWORK_SEARCH_PATHS" path:path];
}

// 删除 Library 搜索路径
- (void)removeLibrarySearchPath:(NSString *)path
{
    [self _removeBuildSettingsWithName:@"LIBRARY_SEARCH_PATHS" path:path];
}


#pragma mark - 获取 build setting

- (id)getBuildSetting:(NSString *)name
{
    if (self.data[@"buildSettings"] && self.data[@"buildSettings"][name])
    {
        return self.data[@"buildSettings"][name];
    }
    return nil;
}

// 获取名字
- (NSString *)getName
{
    return self.data[@"name"];
}

#pragma mark - 设置 build setting

- (void)setBuildSetting:(NSString *)name settingValue:(id)settingValue
{
    self.data[@"buildSettings"][name] = settingValue;
}

// 设置名字
- (void)setName:(NSString *)name
{
    self.data[name] = name;
}

// 设置bitcode
- (void)setBitCode:(BOOL)value
{
    NSString *setting = @"YES";
    if (!value)
    {
        setting = @"NO";
    }
    [self setBuildSetting:@"ENABLE_BITCODE" settingValue:setting];
}

#pragma mark - private method

- (void)_addBuildSettingsWithName:(NSString *)name path:(NSString *)path
{
    if (!path) return;
    
    id searchPaths = [self getBuildSetting:name];
    
    if ([searchPaths isKindOfClass:[NSString class]])
    {
        if ([searchPaths isEqualToString:@""])
        {
            searchPaths = [[NSMutableArray alloc] init];
        }
        else
        {
            searchPaths = [[NSMutableArray alloc] initWithObjects:searchPaths, nil];
        }
    }
    
    if (!searchPaths)
    {
        searchPaths = [[NSMutableArray alloc] init];
    }
    
    if (![(NSMutableArray *)searchPaths containsObject:path])
    {
        [searchPaths addObject:path];
        [self setBuildSetting:name settingValue:searchPaths];
    }
    // 根据配置是否比较 对比rawData和Data
    NSDictionary *compareDic = [PBXCompare compare:self.rawData withOtherData:self.data];
    NSLog(@"Compare Build Settings%@",compareDic);
}


- (void)_removeBuildSettingsWithName:(NSString *)name path:(NSString *)path
{
    if (!path) return;
    
    id searchPaths = [self getBuildSetting:name];
    
    if ([searchPaths isKindOfClass:[NSString class]])
    {
        if ([searchPaths isEqualToString:@""])
        {
            searchPaths = [[NSMutableArray alloc] init];
        }
        else
        {
            searchPaths = [[NSMutableArray alloc] initWithObjects:searchPaths, nil];
        }
    }
    
    if (!searchPaths)
    {
        searchPaths = [[NSMutableArray alloc] init];
    }
    
    if ([(NSMutableArray *)searchPaths containsObject:path])
    {
        [searchPaths removeObject:path];
        [self setBuildSetting:name settingValue:searchPaths];
    }
}


@end
