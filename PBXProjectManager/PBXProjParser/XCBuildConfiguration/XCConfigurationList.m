//
//  XCConfigurationList.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/15.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "XCConfigurationList.h"

#import "XCBuildConfiguration.h"

#import "PBXObjects.h"

#import "PBXProjParser.h"

@implementation XCConfigurationList

- (instancetype)initWithObjectId:(NSString *)objId data:(NSDictionary *)data
{
    if (self = [super initWithObjectId:objId data:data])
    {
        self.buildConfigurations = [[NSMutableArray alloc] init];
        
        NSArray *buildConfigIds = self.data[@"buildConfigurations"];
        
        for (NSString *confId in buildConfigIds)
        {
            XCBuildConfiguration *buildConfig = [[XCBuildConfiguration alloc] initWithObjectId:confId data:[PBXProjParser sharedInstance].objects.data[confId]];
            
            [self.buildConfigurations addObject:buildConfig];
        }
    }
    return self;
}

@end
