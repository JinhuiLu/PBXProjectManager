//
//  PBXNavigatorItem.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXNavigatorItem.h"

@implementation PBXNavigatorItem

- (NSString *)getName
{
    return self.data[@"name"];
}

- (void)setName:(NSString *)name
{
    self.data[@"name"] = name;
}

- (NSString *)getPath
{
    return self.data[@"path"];
}

- (void)setPath:(NSString *)path
{
    self.data[@"path"] = path;
}

- (NSString *)getSourceTree
{
    return self.data[@"sourceTree"];
}

- (void)setSourceTree:(NSString *)sourceTree
{
    self.data[@"sourceTree"] = sourceTree;
}

@end
