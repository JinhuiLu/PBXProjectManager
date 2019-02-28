//
//  PBXFileReference.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXFileReference.h"

@implementation PBXFileReference

- (NSString *)getLastKnownFileType
{
    return self.data[@"lastKnownFileType"];
}

- (void)setLastKnownFileType:(NSString *)lastKnownFileType
{
    self.data[@"lastKnownFileType"] = lastKnownFileType;
}

- (NSString *)getIncludeInIndex
{
    return self.data[@"includeInIndex"];
}

- (void)setIncludeInIndex:(NSString *)includeInIndex
{
    self.data[@"includeInIndex"] = includeInIndex;
}

- (NSString *)getExplicitFileType
{
    return self.data[@"explicitFileType"];
}

- (void)setExplicitFileType:(NSString *)explicitFileType
{
    self.data[@"explicitFileType"] = explicitFileType;
}

@end
