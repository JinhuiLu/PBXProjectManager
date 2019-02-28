//
//  PBXShellScriptBuildPhase.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXShellScriptBuildPhase.h"

@implementation PBXShellScriptBuildPhase

- (NSString *)getShellPath
{
    return self.data[@"shellPath"];
}

- (void)setShellPath:(NSString *)shellPath
{
    self.data[@"shellPath"] = shellPath;
}

- (NSString *)getShellScript
{
    return self.data[@"shellScript"];
}

- (void)setShellScript:(NSString *)shellScript
{
    self.data[@"shellScript"] = shellScript;
}

@end
