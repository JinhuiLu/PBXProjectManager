## PBXProjectManager
* PBXProjectManager 是一个基于 Objective-C 开发的，用于解析、修改、比较、保存 xcodeproj 中 pbxproj 文件的通用工具类。


## 功能介绍

* PBXProjectManager中提供了

    * 将pbxproj文件解析成字典，
    * 将pbxproj文件解析成模型类，
    * 通过模型类中提供的简单的方法对Xcode项目进行增删文件、类库或配置的修改。
    * 通过对比修改的内容和原始文件内容返回记录修改变化的字典。

* 从而达到减少重复的工作量，实现自动化管理的目的。

## 集成方法
1. 手动导入PBXProjectManager 文件夹到工程中

## 使用方法（不仅限于示例中的使用）

### 初始化PBXProjParser 并传入pbxproj文件路径或xcodeproj文件路径进行解析
```
PBXProjParser *parser = [PBXProjParser sharedInstance];
[parser parseProjectWithPath:@"xcodeproj或pbxproj路径"];
```

### 添加文件
* 添加FrameSearchPath、LibrarySearchPath、OtherLinkerFlag
```
XCBuildConfiguration *debugConfigs = [(PBXTarget *)self.parser.project.targets[0] getBuildConfigs:@"Debug"];
[debugConfigs addFrameworkSearchPath:@"/abc/abcd/abcdef"];
[debugConfigs addLibrarySearchPath:@"/def/def/defg"];
[debugConfigs addOtherLinkerFlag:@"-ObjC"];
```
* 添加文件
```
[self.parser.project.mainGroup addFileWithPath:@"xxx/AppDelegate+Pbx.m" target:self.parser.project.targets[0]];
```
* 添加group
```
[self.parser.project.mainGroup addGroup:@"TestAddGroup" path:nil];
    
PBXGroup *TestGroup = (PBXGroup *)[self.parser.project.mainGroup getChild:@"TestAddGroup" recurive:YES];
    
[TestGroup addGroup:@"TestAddGroup2" path:nil];
```
* 添加Bundle
```
[self.parser.project.mainGroup addBundleWithPath:@"../ShareSDK.bundle" target:self.parser.project.targets[0]];
```
* 添加静态库
```
[self.parser.project.mainGroup addStaticLibWithPath:@"libWeChat.a" target:self.parser.project.targets[0]];
```

* 添加系统动态库
```
[(PBXGroup *)[self.parser.project.mainGroup getChild:@"Frameworks" recurive:YES] addSystemDylibWithPath:@"libz.tbd" target:self.parser.project.targets[0]];
```

* 添加系统框架
```
[self.parser.project.mainGroup addSystemFrameworkWithName:@"AVFoundation.framework" target:self.parser.project.targets[0]];
```
* 添加本地化文件
```
[self.parser.project.mainGroup addLocalizedFileWithPath:@"Base.lproj/aa.strings" language:@"Base" target:self.parser.project.targets[0]];
[self.parser.project.mainGroup addLocalizedFileWithPath:@"en.lproj/aa.strings" language:@"en" target:self.parser.project.targets[0]];
```

### 删除文件
* 删除组内的子项
```
PBXNavigatorItem *file = [self.parser.project.mainGroup addFileWithPath:@"xxx/AppDelegate+Pbx.m" target:self.parser.project.targets[0]];
    
[self.parser.project.mainGroup removeChild:file];
```

* 深度查找删除对应项
```
PBXGroup *group = [self.parser.project.mainGroup findParentGroupWithPath:@"//MOBFoundation.framework"];
PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"//MOBFoundation.framework"];
    
[group removeChild:item];
```

### 获取项目信息

* 获取project中所有target的名字
```
for (PBXTarget *target in self.parser.project.targets)
{
    NSLog(@"TargetName:%@", [target getName]);
}
```

### 查询数据

* 查找文件夹
```
PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"Frameworks"];
```

* 查找Framework
```
PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"/Frameworks/AVFoundation.framework"];
```

* 查找文件
```
PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"/aa.strings"];
```

* 深度查找文件
```
PBXNavigatorItem *item = [self.parser.project.mainGroup findItemWithPath:@"//MOBFoundation.framework"];
```

* 深度查找文件所属的父文件夹
```
PBXNavigatorItem *item = [self.parser.project.mainGroup findParentGroupWithPath:@"//B"];
```

### 比较数据与保存数据
```
// PBXCompare.h

// 返回数据比较后的字典
NSDictionary *compareDic = [PBXCompare compare:self.parser.rawDictionary withOtherData:self.parser.pbxprojDictionary];

// 保存PBXProjParser修改后的数据
[PBXCompare save];
```
