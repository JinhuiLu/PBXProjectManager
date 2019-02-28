//
//  PBXTargetDependency.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

#import "PBXTarget.h"
#import "PBXContainerItemProxy.h"

NS_ASSUME_NONNULL_BEGIN

@interface PBXTargetDependency : PBXObject

@property (nonatomic, strong) PBXTarget *target;
@property (nonatomic, strong) PBXContainerItemProxy *targetProxy;

@end

NS_ASSUME_NONNULL_END
