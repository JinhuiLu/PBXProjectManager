//
//  PBXProjParser.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/13.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXProjParser.h"

@interface PBXProjParser ()

@property (nonatomic, copy) NSString *pbxprojPath;

@end

@implementation PBXProjParser

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)parseProjectWithPath:(NSString *)projPath
{
    //检验projPath格式是否正确，如果是.xcodeproj后缀则拼接上 @"/project.pbxproj"
    if ([projPath.pathExtension isEqualToString:@"xcodeproj"])
    {
        projPath = [projPath stringByAppendingPathComponent:@"project.pbxproj"];
    }
    
    NSError *error = nil;
    NSData *projData = [NSData dataWithContentsOfFile:projPath];
    
    // 将 project.pbxproj 格式转换成字典格式 __NSCFDictionary 为 NSMutableDictionary的子类
    NSDictionary *projectDict = [NSPropertyListSerialization propertyListWithData:projData options:NSPropertyListMutableContainersAndLeaves format:nil error:&error];
    
    if (!error)
    {
        NSLog(@"读取project.pbxproj成功");
        
        self.pbxprojPath = projPath;
        // 解析 project 字典
        self.pbxprojDictionary = projectDict;
        
        self.rawDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:projectDict]];
        
        // objects
        self.objects = [[PBXObjects alloc] initWithObjectId:@"objects" data:projectDict[@"objects"]];
        
        // 将 rootObject 的值作为 Key 在 objects 对应的字典中找到根对象 rootObject
        NSString *rootObjectId = projectDict[@"rootObject"];
        
//        self.project = [[PBXProject alloc] initWithObjectId:rootObjectId data:self.objects.data[rootObjectId]];
        self.project = [self.objects createPBXProjectWithRootObjectId:rootObjectId data:self.objects.data[rootObjectId]];
    }
    else
    {
        NSLog(@"pbxproj无法解析！！");
        self.project = nil;
        self.pbxprojDictionary = nil;
        self.pbxprojPath = nil;
        return;
    }
}


//- (void)save
//{
//    // 写入文件
//    NSString *pbxResultString = [self.pbxprojDictionary convertToPBXProjFormatString];
//    [pbxResultString writeToFile:self.pbxprojPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//}


@end
