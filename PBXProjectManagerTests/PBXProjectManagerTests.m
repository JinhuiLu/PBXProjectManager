//
//  PBXProjectManagerTests.m
//  PBXProjectManagerTests
//
//  Created by lujh on 2019/2/28.
//  Copyright © 2019 lujh. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PBXProjectManager.h"

@interface PBXProjectManagerTests : XCTestCase

@property (nonatomic, strong) PBXProjParser *parser;

@end

@implementation PBXProjectManagerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


#pragma mark - 比较文件

// 测试比较两个字典修改的内容
- (void)testPBXCompareDictionary
{
    NSDictionary *data1 = @{@"a" : @"12345",
                            @"b" : @"12345",
                            @"d" : @{
                                    @"e" : @"11111",
                                    @"f" : @"22222",
                                    @"h" : @"44444",
                                    @"j" : @"12345",
                                    @"k" : @[
                                            @"1",
                                            @"2"
                                            ],
                                    @"m" : @{
                                            @"z" : @"8888",
                                            @"y" : @"9999"
                                            }
                                    }
                            };
    NSDictionary *data2 = @{
                            @"a" : @"45678",
                            @"c" : @"12345",
                            @"d" : @{
                                    @"e" : @"11111",
                                    @"f" : @[
                                            @"22222"
                                            ],
                                    @"g" : @"33333",
                                    @"j" : @"55555",
                                    @"k" : @[
                                            @"2",
                                            @"3"
                                            ],
                                    @"m" : @{
                                            @"z" : @"8888"
                                            },
                                    @"q" : @"sss",
                                    @"l" : @"66666"
                                    }
                            };
    
    NSDictionary *compareDic = [PBXCompare compare:data1 withOtherData:data2];
    
    NSLog(@"Dic修改的内容有:%@",compareDic);
    
    NSDictionary *result = [PBXCompare apply:compareDic onProjectData:data1];
    
    XCTAssertEqualObjects(data2, result);
}

// 测试比较两个pbxproj字典修改的内容
- (void)testPBXComparePBXProject
{
    [self.parser parseProjectWithPath:@"/Users/lujh/Desktop/pbxxxx/project3.pbxproj"];
    
    NSDictionary *project1 = self.parser.pbxprojDictionary;
    
    [self.parser parseProjectWithPath:@"/Users/lujh/Desktop/pbxxxx/project4.pbxproj"];
    
    NSDictionary *project2 = self.parser.pbxprojDictionary;
    
    NSDictionary *compareDic = [PBXCompare compare:project1 withOtherData:project2];
    
    NSLog(@"修改的内容有:%@",compareDic);
    
    NSDictionary *result = [PBXCompare apply:compareDic onProjectData:project1];
    
    XCTAssertEqualObjects(project2, result);
}

#pragma mark - 添加文件

/* 测试
 添加 FrameworkSearchPath
 添加 LibrarySearchPath
 添加 OtherLinkerFlag
 */
- (void)testAddBuildSettings
{
    XCBuildConfiguration *debugConfigs = [(PBXTarget *)self.parser.project.targets[0] getBuildConfigs:@"Debug"];
    [debugConfigs addFrameworkSearchPath:@"/abc/abcd/abcdef"];
    [debugConfigs addLibrarySearchPath:@"/def/def/defg"];
    [debugConfigs addOtherLinkerFlag:@"-ObjC"];
    
    [self compareLog:NSStringFromSelector(_cmd)];
}

// 测试添加文件
- (void)testAddFileToMainGroup
{
    [self.parser.project.mainGroup addFileWithPath:@"xxx/AppDelegate+Pbx.m" target:self.parser.project.targets[0]];
    
    [self compareLog:NSStringFromSelector(_cmd)];
}

// 测试添加group到另一个group中
- (void)testAddGroupToGroup
{
    [self.parser.project.mainGroup addGroup:@"TestAddGroup" path:nil];
    
    PBXGroup *TestGroup = (PBXGroup *)[self.parser.project.mainGroup getChild:@"TestAddGroup" recurive:YES];
    
    [TestGroup addGroup:@"TestAddGroup2" path:nil];
    
    [self compareLog:NSStringFromSelector(_cmd)];
    
    // 写入文件
    //    [self.parser save];
}

// 测试添加Bundle
- (void)testAddBundle
{
    [self.parser.project.mainGroup addBundleWithPath:@"../ShareSDK.bundle" target:self.parser.project.targets[0]];
    
    [self compareLog:NSStringFromSelector(_cmd)];
    
    //    [self.parser save];
}

// 测试添加静态库
- (void)testAddStaticLib
{
    [self.parser.project.mainGroup addStaticLibWithPath:@"libWeChat.a" target:self.parser.project.targets[0]];
    [self compareLog:NSStringFromSelector(_cmd)];
}

// 测试添加系统动态库
- (void)testAddSystemDylib
{
    [(PBXGroup *)[self.parser.project.mainGroup getChild:@"Frameworks" recurive:YES] addSystemDylibWithPath:@"libz.tbd" target:self.parser.project.targets[0]];
    [self compareLog:NSStringFromSelector(_cmd)];
}

// 测试添加系统框架
- (void)testAddSystemFramework
{
    [self.parser.project.mainGroup addSystemFrameworkWithName:@"AVFoundation.framework" target:self.parser.project.targets[0]];
    [self compareLog:NSStringFromSelector(_cmd)];
}
// 测试添加本地化文件
- (void)testAddLocalizedFile
{
    [self.parser.project.mainGroup addLocalizedFileWithPath:@"Base.lproj/aa.strings" language:@"Base" target:self.parser.project.targets[0]];
    [self.parser.project.mainGroup addLocalizedFileWithPath:@"en.lproj/aa.strings" language:@"en" target:self.parser.project.targets[0]];
    
    [self compareLog:NSStringFromSelector(_cmd)];
}

#pragma mark - 删除文件

// 测试删除组内的子项
- (void)testRemoveChild
{
    PBXNavigatorItem *file = [self.parser.project.mainGroup addFileWithPath:@"xxx/AppDelegate+Pbx.m" target:self.parser.project.targets[0]];
    [self compareLog:NSStringFromSelector(_cmd)];
    
    [self.parser.project.mainGroup removeChild:file];
    
    [self compareLog:NSStringFromSelector(_cmd)];
}

- (void)testDeepDeleteFile
{
    PBXGroup *group = [self.parser.project.mainGroup findParentGroupWithPath:@"//MOBFoundation.framework"];
    PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"//MOBFoundation.framework"];
    
    [group removeChild:item];
    
    [self compareLog:NSStringFromSelector(_cmd)];
}

#pragma mark - 获取proj数据

// 测试获取project中所有target的名字
- (void)testGetTargetsName
{
    for (PBXTarget *target in self.parser.project.targets)
    {
        NSLog(@"TargetName:%@", [target getName]);
    }
}

#pragma mark - 查询数据

// 测试查找文件夹
- (void)testFindGroup
{
    PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"Frameworks"];
    NSLog(@"testFindGroup:\n%@",item.data);
}

// 测试查找Framework
- (void)testFindFrameWorkName
{
    PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"/Frameworks/AVFoundation.framework"];
    NSLog(@"testFindFrameWorkName:\n%@",item.data);
}

// 测试查找文件
- (void)testFindFile
{
    PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"/aa.strings"];
    NSLog(@"testFindFile:\n%@",item.data);
}

// 测试深度查找文件
- (void)testDeepFindFile
{
    PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"//MOBFoundation.framework"];
    
    NSLog(@"testDeepFindFile:\n%@",item.data);
}

- (void)testDeepFindParentGroup
{
    PBXNavigatorItem *item = [self.parser.project.mainGroup findParentGroupWithPath:@"//B"];
    
    NSLog(@"testDeepFindParentGroup:\n%@",item.data);
}

#pragma mark -

- (void)compareLog:(NSString *)methodName
{
    NSDictionary *compareDic = [PBXCompare compare:self.parser.rawDictionary withOtherData:self.parser.pbxprojDictionary];
    
    NSLog(@"%@:\n%@", methodName, compareDic);
}


- (PBXProjParser *)parser
{
    if (!_parser)
    {
        _parser = [PBXProjParser sharedInstance];
        [_parser parseProjectWithPath:@"/Users/lujh/Desktop/TestParse/TestParse.xcodeproj/project.pbxproj"];
    }
    return _parser;
}


@end
