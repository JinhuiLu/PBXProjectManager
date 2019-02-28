//
//  PBXBuildFile.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXBuildFile.h"

#import "PBXProjParser.h"

#import "PBXObjects.h"

@implementation PBXBuildFile

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    if (self = [super initWithObjectId:objId data:data])
    {
        NSString *fileRefId = self.data[@"fileRef"];
        _fileRef = [[PBXFileReference alloc] initWithObjectId:fileRefId data:[PBXProjParser sharedInstance].objects.data[fileRefId]];
    }
    return self;
}

@end
