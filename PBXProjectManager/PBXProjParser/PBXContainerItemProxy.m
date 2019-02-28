//
//  PBXContainerItemProxy.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXContainerItemProxy.h"

#import "PBXProjParser.h"
#import "PBXProject.h"

@implementation PBXContainerItemProxy

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    if (self = [super initWithObjectId:objId data:data])
    {
        // containerPortal
        if ([[PBXProjParser sharedInstance].project.objectId isEqualToString:self.data[@"containerPortal"]])
        {
            self.containerPortal = [PBXProjParser sharedInstance].project;
        }
        // proxyType
        self.proxyType = self.data[@"proxyType"];
        
        // remoteInfo
        self.remoteInfo = self.data[@"remoteInfo"];
        
        // remoteGlobalIDString
        self.remoteGlobalIDString = self.data[@"remoteGlobalIDString"];
    }
    return self;
}

@end
