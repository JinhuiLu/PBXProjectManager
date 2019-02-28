//
//  PBXTargetDependency.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXTargetDependency.h"

#import "PBXProject.h"

#import "PBXObjects.h"

#import "PBXProjParser.h"

@implementation PBXTargetDependency

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    if (self = [super initWithObjectId:objId data:data])
    {
        // target
        NSString *targetId = self.data[@"target"];
        
        for (PBXTarget *target in [PBXProjParser sharedInstance].project.targets)
        {
            if ([target.objectId isEqualToString:targetId])
            {
                self.target = target;
                break;
            }
        }
        
        // targetProxy
        NSString *targetProxyId = self.data[@"targetProxy"];
        
        self.targetProxy = [[PBXContainerItemProxy alloc] initWithObjectId:targetProxyId data:[PBXProjParser sharedInstance].objects.data[targetProxyId]];
    }
    return self;
}

@end
