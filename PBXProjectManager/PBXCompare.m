//
//  PBXCompare.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/19.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXCompare.h"

#import "PBXProjParser.h"

#import "NSDictionary+PBXProjectFormat.h"

@implementation PBXCompare

+ (NSDictionary *)compare:(NSDictionary *)data1 withOtherData:(NSDictionary *)data2
{
    if (!([data1 isKindOfClass:[NSDictionary class]]
        && [data2 isKindOfClass:[NSDictionary class]]))
    {
        NSLog(@"data1和data2必须为字典！！");
        return nil;
    }
    
    NSDictionary *dataF1 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:data1]];
    NSDictionary *dataF2 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:data2]];
    
    NSMutableDictionary *insertDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *removeDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *modifyDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *differenceDict = [[NSMutableDictionary alloc] init];
    
    [differenceDict setObject:insertDictionary forKey:@"insert"];
    [differenceDict setObject:removeDictionary forKey:@"remove"];
    [differenceDict setObject:modifyDictionary forKey:@"modify"];
    
    [self _compare:dataF1
     withOtherData:dataF2
         parentKey:nil
  insertDictionary:insertDictionary
  removeDictionary:removeDictionary
  modifyDictionary:modifyDictionary];
    
    return differenceDict;
}


/**
 比较两个project数据
 * 新增数据: 如果是新增的key，直接将key和value都加入新增字典中；
 * 删除数据: 如果是删除的key，如果是root，将key加入数组并加入key为'pbxroot'的字典中。如果不是root，则将key加入父key对应的删除数组中；
 * 修改数据: 如果是相同的key，则比较其value是否相同，
 *          value分三种情况:
 *              1.两个value的类型不相同，那么直接加入修改字典中；
 *              2.两个value都是字符串，判断字符串是否相同，不同则加入修改字典中；
 *              3.两个value都为字典或数组，那么递归 - compare 方法，继续比较。
 
 @param data1 数据1
 @param data2 数据2
 @param parentKey 父键
 */
+ (void)_compare:(id)data1 withOtherData:(id)data2 parentKey:(NSString *)parentKey insertDictionary:(NSMutableDictionary *)insertDictionary removeDictionary:(NSMutableDictionary *)removeDictionary modifyDictionary:(NSMutableDictionary *)modifyDictionary
{
    if ([data1 isKindOfClass:[NSDictionary class]] && [data2 isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary1 = data1;
        NSDictionary *dictionary2 = data2;
        
        NSMutableSet *set1 = [NSMutableSet setWithArray:dictionary1.allKeys];
        NSMutableSet *set2 = [NSMutableSet setWithArray:dictionary2.allKeys];
        
        // 拿到新增key
        [set2 minusSet:set1];
        
        for (NSString *key in set2)
        {
            // 判断 parentKey 是否存在，如果存在则将变化加到 parentKey 对应的字典里
            if (parentKey && parentKey.length > 0)
            {
                id insert = insertDictionary[parentKey];
                if ([insert isKindOfClass:[NSDictionary class]])
                {
                    NSMutableDictionary *insertDic = [insert mutableCopy];
                    [insertDic setObject:dictionary2[key] forKey:key];
                    [insertDictionary setObject:insertDic forKey:parentKey];
                }
                else
                {
                    [insertDictionary setObject:@{key : dictionary2[key]} forKey:parentKey];
                }
            }
            else
            {
                [insertDictionary setObject:dictionary2[key] forKey:key];
            }
        }
        
        
        // 拿到已删除的key
        set2 = [NSMutableSet setWithArray:dictionary2.allKeys];
        
        [set1 minusSet:set2];
        
        for (NSString *key in set1)
        {
            if (parentKey && parentKey.length > 0)
            {
                id remove = removeDictionary[parentKey];
                if ([remove isKindOfClass:[NSArray class]])
                {
                    NSMutableArray *removeDic = [remove mutableCopy];
                    [removeDic addObject:key];
                    [removeDictionary setObject:removeDic forKey:parentKey];
                }
                else
                {
                    [removeDictionary setObject:@[key] forKey:parentKey];
                }
            }
            else
            {
                [removeDictionary setObject:@[key] forKey:@"pbxroot"];
            }
        }
        
        // 拿到改变的key
        set1 = [NSMutableSet setWithArray:dictionary1.allKeys];
        
        [set1 intersectSet:set2];
        
        for (NSString *key in set1)
        {
            if (parentKey && parentKey.length > 0)
            {
                NSString *keyPath = [NSString stringWithFormat:@"%@.%@", parentKey, key];
                id value1 = dictionary1[key];
                id value2 = dictionary2[key];
                
                if ([value1 isKindOfClass:[NSString class]] && [value2 isKindOfClass:[NSString class]])
                {
                    if (![value1 isEqualToString:value2])
                    {
                        [modifyDictionary setObject:value2 forKey:keyPath];
                    }
                }
                else if (![[value1 class] isEqualTo:[value2 class]])
                {
                    id modify = modifyDictionary[parentKey];
                    if ([modify isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *modifyDic = [modify mutableCopy];
                        [modifyDic setObject:value2 forKey:key];
                        // 如果key存在，再加个递归
                        [modifyDictionary setObject:modifyDic forKey:parentKey];
                    }
                    else
                    {
                        // 直接加入modify
                        [modifyDictionary setObject:value2 forKey:keyPath];
                    }
                }
                else
                {
                    [self _compare:value1 withOtherData:value2 parentKey:keyPath insertDictionary:insertDictionary removeDictionary:removeDictionary modifyDictionary:modifyDictionary];
                }
            }
            else
            {
                id value1 = dictionary1[key];
                id value2 = dictionary2[key];
                if ([value1 isKindOfClass:[NSString class]] && [value2 isKindOfClass:[NSString class]])
                {
                    if (![value1 isEqualToString:value2])
                    {
                        [modifyDictionary setObject:value2 forKey:key];
                    }
                }
                else if (![[value1 class] isEqualTo:[value2 class]])
                {
                    id modify = modifyDictionary[key];
                    if ([modify isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *modifyDic = [modify mutableCopy];
                        [modifyDic setObject:value2 forKey:key];
                        [modifyDictionary setObject:modifyDic forKey:key];
                    }
                    else
                    {
                        // 直接加入modify
                        [modifyDictionary setObject:value2 forKey:key];
                    }
                }
                else
                {
                    [self _compare:value1 withOtherData:value2 parentKey:key insertDictionary:insertDictionary removeDictionary:removeDictionary modifyDictionary:modifyDictionary];
                }
            }
        }
    }
    
    // pbx数组的元素全部是字符串
    if ([data1 isKindOfClass:[NSArray class]] && [data2 isKindOfClass:[NSArray class]])
    {
        NSArray *array1 = data1;
        NSArray *array2 = data2;
        
        NSMutableSet *set1 = [NSMutableSet setWithArray:array1];
        NSMutableSet *set2 = [NSMutableSet setWithArray:array2];
        
        // 拿到新增key
        [set2 minusSet:set1];
        
        for (NSString *element in set2)
        {
            id insert = insertDictionary[parentKey];
            if ([insert isKindOfClass:[NSArray class]])
            {
                NSMutableArray *insertArr = [insert mutableCopy];
                [insertArr addObject:element];
                
                [insertDictionary setObject:insertArr forKey:parentKey];
            }
            else
            {
                [insertDictionary setObject:@[element] forKey:parentKey];
            }
        }
        
        // 拿到已删除的key
        set2 = [NSMutableSet setWithArray:array2];
        
        [set1 minusSet:set2];
        
        for (NSString *element in set1)
        {
            id remove = removeDictionary[parentKey];
            if ([remove isKindOfClass:[NSArray class]])
            {
                NSMutableArray *removeArr = [remove mutableCopy];
                [removeArr addObject:element];
                
                [removeDictionary setObject:removeArr forKey:parentKey];
            }
            else
            {
                [removeDictionary setObject:@[element] forKey:parentKey];
            }
        }
    }
}


/**
 根据配置文件修改工程文件

 @param diffDict 对工程文件操作的配置文件
 @param projectData 工程文件
 @return 修改后的结果
 */
+ (NSDictionary *)apply:(NSDictionary *)diffDict onProjectData:(NSDictionary *)projectData
{
    __block NSMutableDictionary *resultDic = [projectData mutableCopy];
    // 添加 将diffDict 加入到projectData中
    [diffDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *_Nonnull obj, BOOL * _Nonnull stop) {
        [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull keyPath, id  _Nonnull data, BOOL * _Nonnull stop) {
            
            NSArray *keys = [keyPath componentsSeparatedByString:@"."];
            
            // 调用 walkIn 方法
            id result = [self walkInAtIndex:0 withCurrentValue:resultDic withKeys:keys complete:^id(id value) {
                
                // 添加数据时 data 和 value 类型要统一，要么都是数组，要么都是字典，否则不做变更
                if ([key isEqualToString:@"insert"])
                {
                    // 原始数据
                    id projectValue = value;
                    // 新增的数据
                    id insertData = data;
                    
                    if ([projectValue isKindOfClass:[NSDictionary class]]
                        && [insertData isKindOfClass:[NSDictionary class]])
                    {
                        NSMutableDictionary *projectDic = [projectValue mutableCopy];
                        [projectDic addEntriesFromDictionary:insertData];
                        return projectDic;
                    }
                    
                    if ([projectValue isKindOfClass:[NSArray class]]
                        && [insertData isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *projectArr = [projectValue mutableCopy];
                        [projectArr addObjectsFromArray:insertData];
                        return projectArr;
                    }
                    
                    // 如果对应的key没有找到值，说明是新增的
                    if (!projectValue)
                    {
                        return insertData;
                    }
                    
                    return projectValue;
                }
                else if ([key isEqualToString:@"remove"])
                {
                    // 原始数据
                    id projectValue = value;
                    // 删除的数据
                    id removeData = data;
                    
                    if ([projectValue isKindOfClass:[NSDictionary class]]
                        && [removeData isKindOfClass:[NSArray class]])
                    {
                        NSMutableDictionary *projectDic = [projectValue mutableCopy];
                        [projectDic removeObjectsForKeys:removeData];
                        return projectDic;
                    }
                    
                    if ([projectValue isKindOfClass:[NSArray class]]
                        && [removeData isKindOfClass:[NSArray class]])
                    {
                        NSMutableArray *projectArr = [projectValue mutableCopy];
                        [projectArr removeObjectsInArray:removeData];
                        return projectArr;
                    }
                    
                    return projectValue;
                }
                else if ([key isEqualToString:@"modify"])
                {
                    return data;
                }
                return value;
            }];
            
            if ([result isKindOfClass:[NSDictionary class]])
            {
                resultDic = result;
            }
        }];
    }];
    
    return resultDic;
}


/**
 根据keyPath递归找到最终子节点，并赋值complete返回的值，在递归过程中往上返回修改后的结果，完成整个路径上数据的修改。

 @param index 路径深度
 @param value 当前路径对应的值
 @param keys 每段路径组成的数组
 @param complete 路径终点所要做的操作
 @return 当前路径层级修改后的值
 */
+ (id)walkInAtIndex:(int)index
   withCurrentValue:(id)value
           withKeys:(NSArray *)keys
           complete:(id(^)(id))complete
{
    // 当循环小于路径深度时
    if (index < keys.count)
    {
        NSString *key = keys[index];
        // 判断value是否为字典，判断下一个value是否存在。
        id dicValue = value;
        id nextValue = value[key];
        
        if ([key isEqualToString:@"pbxroot"])
        {
            
            return complete(value);
        }
        
        if ([dicValue isKindOfClass:[NSDictionary class]])
        {
            // 将下一层级的修改应用到当前层级的数据
            NSMutableDictionary *dicMValue = [dicValue mutableCopy];
            dicMValue[key] = [self walkInAtIndex:index + 1
                                withCurrentValue:nextValue
                                        withKeys:keys
                                        complete:complete];
            
            return dicMValue;
        }
        else
        {
            NSLog(@"KeyPath 错误！");
            return nil;
        }
    }
    else  // 调用complete修改最终节点的value，然后递归返回修改后的数据给上一级
    {
        return complete(value);
    }
    
}

+ (void)save
{
    if ([PBXProjParser sharedInstance].pbxprojPath)
    {
        // 写入文件
        NSString *pbxResultString = [[PBXProjParser sharedInstance].pbxprojDictionary convertToPBXProjFormatString];
        [pbxResultString writeToFile:[PBXProjParser sharedInstance].pbxprojPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

@end
