//
//  XCConfigurationList.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/15.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@class XCBuildConfiguration;
NS_ASSUME_NONNULL_BEGIN

@interface XCConfigurationList : PBXObject

/**
 XCBuildConfiguration 的数组
 */
@property (nonatomic, strong) NSMutableArray<XCBuildConfiguration *> *buildConfigurations;

@end

NS_ASSUME_NONNULL_END
