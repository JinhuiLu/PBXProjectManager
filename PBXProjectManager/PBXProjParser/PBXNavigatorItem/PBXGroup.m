//
//  PBXGroup.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXGroup.h"

#import "PBXVariantGroup.h"

#import "PBXFileReference.h"

#import "PBXProjParser.h"

#import "PBXBuildPhases.h"

#import "PBXResourcesBuildPhase.h"

#import "PBXObjects.h"

#import "PBXProject.h"

@interface PBXGroup ()

@end

@implementation PBXGroup

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    if (self = [super initWithObjectId:objId data:data])
    {
        self.children = [[NSMutableArray alloc] init];
        NSArray *childObjIds = data[@"children"];
        if (childObjIds)
        {
            for (NSString *objId in childObjIds)
            {
                NSDictionary *obj = [PBXProjParser sharedInstance].objects.data[objId];
                if (obj)
                {
                    PBXNavigatorItem *item = nil;
                    if ([obj[@"isa"] isEqualToString:@"PBXFileReference"])
                    {
                        item = [[PBXFileReference alloc] initWithObjectId:objId data:obj];
                    }
                    else if ([obj[@"isa"] isEqualToString:@"PBXGroup"])
                    {
                        item = [[PBXGroup alloc] initWithObjectId:objId data:obj];
                    }
                    else if ([obj[@"isa"] isEqualToString:@"PBXVariantGroup"])
                    {
                        item = [[PBXVariantGroup alloc] initWithObjectId:objId data:obj];
                    }
                    
                    if (item)
                    {
                        [self.children addObject:item];
                    }
                }
                else
                {
                    NSLog(@"miss group id = %@", objId);
                }
            }
        }
    }
    return self;
}

static NSDictionary *fileTypeMapping_;
- (NSDictionary *)fileTypeMapping
{
    if (!fileTypeMapping_)
    {
        fileTypeMapping_ = @{
                             @"c"             : @"sourcecode.c.c",
                             @"cpp"           : @"sourcecode.cpp.cpp",
                             @"hpp"           : @"sourcecode.cpp.h",
                             @"h"             : @"sourcecode.c.h",
                             @"swift"         : @"sourcecode.swift",
                             @"mm"            : @"sourcecode.cpp.objcpp",
                             @"m"             : @"sourcecode.c.objc",
                             @"tbd"           : @"sourcecode.text-based-dylib-definition",
                             @"bundle"        : @"wrapper.plug-in",
                             @"a"             : @"archive.ar",
                             @"framework"     : @"wrapper.framework",
                             @"strings"       : @"text.plist.strings",
                             @"applescript"   : @"sourcecode.applescript",
                             @"html"          : @"text.html",
                             @"jpg"           : @"image.jpeg",
                             @"jpeg"          : @"image.jpeg",
                             @"png"           : @"image.png",
                             @"tif"           : @"image.tiff",
                             @"tiff"          : @"image.tiff",
                             @"xcassets"      : @"folder.assetcatalog",
                             @"xib"           : @"file.xib"
                             };
    }
    return fileTypeMapping_;
}



// 获取子项
- (PBXNavigatorItem *)getChild:(NSString *)name recurive:(BOOL)recurive
{
    return [self _getChildWithCurrentItem:self name:name recurive:recurive];
}

// 添加导航条目
- (PBXNavigatorItem *)addChild:(PBXNavigatorItem *)navigatorItem
{
    
    if (!navigatorItem)
    {
        return nil;
    }
    
    [[PBXProjParser sharedInstance].objects setObject:navigatorItem];
    
    BOOL hasExists = NO;
    for (PBXNavigatorItem *child in self.children)
    {
        if ([child.objectId isEqualToString:navigatorItem.objectId])
        {
            hasExists = YES;
            navigatorItem = child;
            break;
        }
    }
    
    if (!hasExists)
    {
        NSMutableArray *children = (NSMutableArray *)self.data[@"children"];
        
        if (![children isKindOfClass:[NSMutableArray class]])
        {
            NSLog(@"类型不一致~~，查看是否需要修改~~");
        }
        
        if (!children)
        {
            children = [[NSMutableArray alloc] init];
        }
        
        [self.children addObject:navigatorItem];
        
        [children addObject:navigatorItem.objectId];
        
        self.data[@"children"] = children;
    }
    
    return navigatorItem;
}

// 移除分组信息
- (void)removeChild:(PBXNavigatorItem *)navigatorItem
{
    [self _removeChild:navigatorItem];
    
    if ([self.children containsObject:navigatorItem])
    {
        [self.children removeObject:navigatorItem];
    }
}

- (PBXGroup *)addGroup:(NSString *)name path:(NSString *)path
{
    return [self _addGroup:name path:path sourceTree:PBXSourceTree_GROUP];
}

// 添加可变分组，用于放入本地化资源文件
- (PBXVariantGroup *)addVariantGroup:(NSString *)name
{
    if (!name) return nil;
    
    NSMutableDictionary *groupInfo = [[NSMutableDictionary alloc] init];
    groupInfo [@"isa"] = @"PBXVariantGroup";
    groupInfo [@"name"] = name;
    groupInfo [@"sourceTree"] = PBXSourceTree_GROUP;
    groupInfo [@"children"] = [[NSMutableArray alloc] init];
    
    PBXVariantGroup *group = [[PBXVariantGroup alloc] initWithObjectId:[self genObjectId] data:groupInfo];
    return (PBXVariantGroup *)[self addChild:group];
}

// 添加系统框架
- (PBXFileReference *)addSystemFrameworkWithName:(NSString *)frameworkName target:(PBXTarget *)target
{
    return (PBXFileReference *)[self _addFileWithPath:[NSString stringWithFormat:@"System/Library/Frameworks/%@", frameworkName] target:target sourceTree:PBXSourceTree_SDK_ROOT];
}

// 添加框架
- (PBXFileReference *)addFrameworkWithPath:(NSString *)frameworkPath target:(PBXTarget *)target
{
    return (PBXFileReference *)[self _addFileWithPath:frameworkPath target:target sourceTree:PBXSourceTree_GROUP];
}

// 添加系统动态库
- (PBXFileReference *)addSystemDylibWithPath:(NSString *)dylibPath target:(PBXTarget *)target
{
    return (PBXFileReference *)[self _addFileWithPath:[NSString stringWithFormat:@"usr/lib/%@", dylibPath] target:target sourceTree:PBXSourceTree_SDK_ROOT];
}

// 添加动态库
- (PBXFileReference *)addDylibWithPath:(NSString *)dylibPath target:(PBXTarget *)target
{
    return (PBXFileReference *)[self _addFileWithPath:dylibPath target:target sourceTree:PBXSourceTree_GROUP];
}

// 添加静态库
- (PBXFileReference *)addStaticLibWithPath:(NSString *)staticLibPath target:(PBXTarget *)target
{
    return (PBXFileReference *)[self _addFileWithPath:staticLibPath target:target sourceTree:PBXSourceTree_GROUP];
}

// 添加头文件
- (PBXFileReference *)addHeaderFileWithPath:(NSString *)headerFilePath
{
    return (PBXFileReference *)[self _addFileWithPath:headerFilePath target:nil sourceTree:PBXSourceTree_GROUP];
}

// 添加Bundle
- (PBXFileReference *)addBundleWithPath:(NSString *)bundlePath target:(PBXTarget *)target
{
    return (PBXFileReference *)[self _addFileWithPath:bundlePath target:target sourceTree:PBXSourceTree_GROUP];
}

// 添加本地化文件
- (PBXFileReference *)addLocalizedFileWithPath:(NSString *)stringsPath language:(NSString *)lang target:(PBXTarget *)target
{
    NSString *name = [stringsPath lastPathComponent];
    PBXVariantGroup *varGroup = (PBXVariantGroup *)[self getChild:name recurive:NO];
    if (!varGroup)
    {
        varGroup = [self addVariantGroup:name];
        [target.resourceBuildPhase addBuildFile:varGroup];
    }
    
    return [varGroup addLocalizedFileWithPath:stringsPath language:lang sourceTree:PBXSourceTree_GROUP];
}

- (PBXFileReference *)addFileWithPath:(NSString *)path target:(PBXTarget *)target
{
    return (PBXFileReference *)[self _addFileWithPath:path target:target sourceTree:PBXSourceTree_GROUP];
}

- (PBXGroup *)findParentGroupWithPath:(NSString *)path
{
    PBXGroup *group = nil;
    
    if ([path hasPrefix:@"//"])
    {
        // 匹配所有子项
        NSString *targetPath = [path substringFromIndex:2];
        
        NSArray *pathComponets = [targetPath componentsSeparatedByString:@"/"];
        
        // 先找出所有符合的路径
        NSMutableArray *matchItems = [@[] mutableCopy];
        [self _getGroupWithCurrentItem:self name:pathComponets[0] outputChildren:matchItems recurive:YES];
        for (PBXGroup *matchItem in matchItems)
        {
            BOOL hasExists = YES;
            PBXGroup *tmpGroup = matchItem;
            
            for (int i = 0; i < pathComponets.count - 1; i++)
            {
                PBXGroup *group2 = nil;
                NSString *pathComp = pathComponets[i];
                if (pathComp.length > 0)
                {
                    if ([tmpGroup isKindOfClass:[PBXGroup class]])
                    {
                        PBXGroup *group2 = (PBXGroup *)[((PBXGroup *)tmpGroup) getChild:pathComp recurive:NO];
                        if (!group2)
                        {
                            hasExists = NO;
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                    tmpGroup = group2;
                }
            }
            
            if (hasExists)
            {
                group = tmpGroup;
                break;
            }
        }
    }
    else
    {
        NSString *compPath = [path stringByDeletingLastPathComponent];
        if (!compPath || [compPath hasSuffix:@"/"])
        {
            return (PBXGroup *)[self findItemWithPath:path];
        }
        else
        {
            return (PBXGroup *)[self findItemWithPath:compPath];
        }
    }
    
    return group;
}

- (PBXNavigatorItem *)findItemWithPath:(NSString *)path
{
    PBXNavigatorItem *item = nil;
    
    if ([path hasPrefix:@"//"])
    {
        // 匹配所有子项
        NSString *targetPath = [path substringFromIndex:2];
        
        NSArray *pathComponets = [targetPath componentsSeparatedByString:@"/"];
        
        // 先找出所有符合的路径
        NSMutableArray *matchItems = [@[] mutableCopy];
        [self _getChildrenWithCurrentItem:self name:pathComponets[0] outputChildren:matchItems recurive:YES];
        for (PBXNavigatorItem *matchItem in matchItems)
        {
            BOOL hasExists = YES;
            PBXNavigatorItem *tmpItem = matchItem;
            
            for (int i = 1; i < pathComponets.count; i++)
            {
                NSString *pathComp = pathComponets[i];
                if (pathComp.length > 0)
                {
                    if ([tmpItem isKindOfClass:[PBXGroup class]])
                    {
                        tmpItem = [((PBXGroup *)tmpItem) getChild:pathComp recurive:NO];
                        if (!tmpItem)
                        {
                            hasExists = NO;
                            break;
                        }
                    }
                    else
                    {
                        break;
                    }
                }
            }
            
            if (hasExists)
            {
                item = tmpItem;
                break;
            }
        }
    }
    else
    {
        NSString *regexStr = @"[.]?\\/?(.*)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
        NSArray *matches = [regex matchesInString:path options:0 range:NSMakeRange(0, path.length)];
        for (NSTextCheckingResult* match in matches)
        {
            NSRange range = match.range;
            NSString *targetPath = [path substringWithRange:range];
            
            NSArray *pathComponets = [targetPath componentsSeparatedByString:@"/"];
            
            item = self;
            
            for (NSString *pathComp in pathComponets)
            {
                
                if (pathComp.length > 0)
                {
                    if ([item isKindOfClass:[PBXFileReference class]])
                    {
                        continue;
                    }
                    item = [((PBXGroup *)item) getChild:pathComp recurive:NO];
                    if (!item)
                    {
                        break;
                    }
                }
            }
            
            break;
        }
    }
    return item;
}

#pragma mark - private method

/*
 获取匹配名字的子项集合
 
 @param curItem 当前查找父级节点
 @param name 名称
 @param outputChildren 输出的子节点集合
 @param recurive 是否递归子项目
 */
- (void)_getChildrenWithCurrentItem:(PBXGroup *)curItem name:(NSString *)name outputChildren:(NSMutableArray *)outputChildren recurive:(BOOL)recurive
{
    for (PBXNavigatorItem *child in curItem.children)
    {
        if ([[child getName] isEqualToString:name]
            || [[child getPath] isEqualToString:name])
        {
            [outputChildren addObject:child];
        }
        if (recurive && [[child getISA] isEqualToString:@"PBXGroup"])
        {
            [self _getChildrenWithCurrentItem:(PBXGroup *)child name:name outputChildren:outputChildren recurive:recurive];
        }
    }
}

- (void)_getGroupWithCurrentItem:(PBXGroup *)curItem name:(NSString *)name outputChildren:(NSMutableArray *)outputChildren recurive:(BOOL)recurive
{
    for (PBXNavigatorItem *child in curItem.children)
    {
        if ([[child getName] isEqualToString:name]
            || [[child getPath] isEqualToString:name])
        {
            [outputChildren addObject:curItem];
        }
        if (recurive && [[child getISA] isEqualToString:@"PBXGroup"])
        {
            [self _getGroupWithCurrentItem:(PBXGroup *)child name:name outputChildren:outputChildren recurive:recurive];
        }
    }
}

- (PBXNavigatorItem *)_addFileWithPath:(NSString *)path target:(nullable PBXTarget *)target sourceTree:(NSString *)sourceTree
{
    NSString *name = [path lastPathComponent];
    NSString *pathExtension = [path pathExtension];
    NSString *fileType = nil;
    
    if (pathExtension.length > 0)
    {
        pathExtension = [pathExtension lowercaseString];
    }
    
    // 设置fileType
    if ([self fileTypeMapping][pathExtension])
    {
        fileType = [self fileTypeMapping][pathExtension];
    }
    else
    {
        fileType = @"text";
    }
    
    PBXBuildPhases *buildPhase = nil;
    if (target)
    {
        NSDictionary *filePhaseMapping = @{
                                           @"c"           : target.sourcesBuildPhase,
                                           @"cpp"         : target.sourcesBuildPhase,
                                           @"swift"       : target.sourcesBuildPhase,
                                           @"mm"          : target.sourcesBuildPhase,
                                           @"m"           : target.sourcesBuildPhase,
                                           @"tbd"         : target.frameworkBuildPhase,
                                           @"bundle"      : target.resourceBuildPhase,
                                           @"a"           : target.frameworkBuildPhase,
                                           @"framework"   : target.frameworkBuildPhase,
                                           @"strings"     : target.resourceBuildPhase,
                                           @"applescript" : target.sourcesBuildPhase,
                                           @"html"        : target.resourceBuildPhase,
                                           @"jpg"         : target.resourceBuildPhase,
                                           @"jpeg"        : target.resourceBuildPhase,
                                           @"png"         : target.resourceBuildPhase,
                                           @"tif"         : target.resourceBuildPhase,
                                           @"tiff"        : target.resourceBuildPhase,
                                           @"xcassets"    : target.resourceBuildPhase,
                                           @"xib"         : target.resourceBuildPhase
                                           };
        // 拿到 build phase
        if (filePhaseMapping[pathExtension])
        {
            buildPhase = filePhaseMapping[pathExtension];
        }
    }
    
    PBXNavigatorItem *fileObj = [self getChild:path recurive:NO];
    if (!fileObj)
    {
        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
        info[@"path"] = path;
        info[@"sourceTree"] = sourceTree;
        info[@"isa"] = @"PBXFileReference";
        info[@"lastKnownFileType"] = fileType;
        info[@"name"] = name;
        if ([pathExtension isEqualToString:@"xib"])
        {
            info[@"fileEncoding"] = @"4";
        }
        fileObj = [[PBXFileReference alloc] initWithObjectId:[self genObjectId] data:info];
        
        [self addChild:fileObj];
    }
    if (buildPhase)
    {
        [buildPhase addBuildFile:fileObj];
    }
    
    return fileObj;
}

- (PBXNavigatorItem *)_getChildWithCurrentItem:(PBXGroup *)curItem name:(NSString *)name recurive:(BOOL)recurive
{
    if (curItem.children)
    {
        for (PBXNavigatorItem *child in curItem.children)
        {
            if ([child.getName isEqualToString:name]
                || [child.getPath isEqualToString:name])
            {
                return child;
            }
            else if (recurive
                     && [child.getISA isEqualToString:@"PBXGroup"])
            {
                PBXNavigatorItem *tmpItem = [self _getChildWithCurrentItem:(PBXGroup *)child name:name recurive:recurive];
                if (tmpItem)
                {
                    return tmpItem;
                }
            }
        }
    }
    return nil;
}

// 添加分组
- (PBXGroup *)_addGroup:(NSString *)name path:(NSString *)path sourceTree:(NSString *)sourceTree
{
    if (!name || name.length <= 0)
    {
        return nil;
    }
    
    NSMutableDictionary *groupInfo = [[NSMutableDictionary alloc] init];
    groupInfo[@"isa"] = @"PBXGroup";
    groupInfo[@"name"] = name;
    groupInfo[@"sourceTree"] = sourceTree;
    groupInfo[@"children"] = [@[] mutableCopy];
    if (path)
    {
        groupInfo[@"path"] = path;
    }
    
    PBXGroup *group = [[PBXGroup alloc] initWithObjectId:[self genObjectId] data:groupInfo];
    
    return (PBXGroup *)[self addChild:group];
}

- (void)_removeChild:(PBXNavigatorItem *)navigatorItem
{
    if (!navigatorItem) return;
    
    if ([self.children containsObject:navigatorItem])
    {
        if (([[navigatorItem getISA] isEqualToString:@"PBXGroup"]
             || [[navigatorItem getISA] isEqualToString:@"PBXVariantGroup"])
            && ((PBXGroup *)navigatorItem).children)
        {
            if ([[navigatorItem getISA] isEqualToString:@"PBXVariantGroup"])
            {
                for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets)
                {
                    for (PBXBuildPhases *buildPhase in target.buildPhases)
                    {
                        [buildPhase removeBuildFile:navigatorItem];
                    }
                }
            }
            
            for (PBXNavigatorItem *child in ((PBXGroup *)navigatorItem).children)
            {
                [((PBXGroup *)navigatorItem) _removeChild:child];
            }
            
        }
        else if ([[navigatorItem getISA] isEqualToString:@"PBXFileReference"])
        {
            for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets)
            {
                for (PBXBuildPhases *buildPhase in target.buildPhases)
                {
                    [buildPhase removeBuildFile:navigatorItem];
                }
            }
        }
        
        [self.data[@"children"] removeObject:navigatorItem.objectId];
        [[PBXProjParser sharedInstance].objects deleteObject:navigatorItem];
    }
}

@end
