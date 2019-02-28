//
//  PBXShellScriptBuildPhase.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXBuildPhases.h"

NS_ASSUME_NONNULL_BEGIN

@interface PBXShellScriptBuildPhase : PBXBuildPhases

- (NSString *)getShellPath;

- (void)setShellPath:(NSString *)shellPath;

- (NSString *)getShellScript;

- (void)setShellScript:(NSString *)shellPath;

@end

NS_ASSUME_NONNULL_END
