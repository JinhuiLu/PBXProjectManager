//
//  PBXVariantGroup.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXVariantGroup.h"

#import "PBXFileReference.h"

@implementation PBXVariantGroup

- (PBXFileReference *)addLocalizedFileWithPath:(NSString *)stringsPath language:(NSString *)lang sourceTree:(NSString *)sourceTree
{
    if (!stringsPath || !lang) return nil;
    PBXFileReference *localizedFile = (PBXFileReference *)[self getChild:stringsPath recurive:NO];
    if (!localizedFile)
    {
        NSMutableDictionary *localizedInfo = [@{} mutableCopy];
        localizedInfo[@"path"] = stringsPath;
        localizedInfo[@"sourceTree"] = sourceTree;
        localizedInfo[@"isa"] = @"PBXFileReference";
        localizedInfo[@"lastKnownFileType"] = @"text.plist.strings";
        localizedInfo [@"name"] = lang;
        localizedFile = [[PBXFileReference alloc] initWithObjectId:[self genObjectId] data:localizedInfo];
        
        [self addChild:localizedFile];
    }
    return localizedFile;
}
@end
