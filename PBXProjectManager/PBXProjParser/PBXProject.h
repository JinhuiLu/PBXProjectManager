//
//  PBXProject.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@class PBXGroup;
@class XCConfigurationList;
@class PBXTarget;

NS_ASSUME_NONNULL_BEGIN

@interface PBXProject : PBXObject

@property (nonatomic, strong) NSMutableArray<PBXTarget *> *targets;

@property (nonatomic, strong) PBXGroup *mainGroup;

@property (nonatomic, strong) PBXGroup *productRefGroup;

@property (nonatomic, strong) XCConfigurationList *buildConfigurationList;

@end

NS_ASSUME_NONNULL_END
