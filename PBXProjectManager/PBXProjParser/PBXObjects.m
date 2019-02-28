//
//  PBXObjects.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/25.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObjects.h"

#import "PBXProject.h"

@implementation PBXObjects

- (PBXProject *)createPBXProjectWithRootObjectId:(NSString *)rootObjectId data:(NSDictionary *)data
{
    return [[PBXProject alloc] initWithObjectId:rootObjectId data:data];
}


- (void)setObject:(PBXObject *)object
{
    if (!self.data[object.objectId])
    {
        self.data[object.objectId] = object.data;
    }
    else
    {
        NSLog(@"setObject 重复设置");
    }
}

- (void)deleteObject:(PBXObject *)object
{
    if (self.data[object.objectId])
    {
        [self.data removeObjectForKey:object.objectId];
    }
}

@end
