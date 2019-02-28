//
//  PBXContainerItemProxy.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/14.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@class PBXProject;
NS_ASSUME_NONNULL_BEGIN

@interface PBXContainerItemProxy : PBXObject

@property (nonatomic, strong) PBXProject *containerPortal;
@property (nonatomic, strong) NSString *proxyType;
@property (nonatomic, strong) NSString *remoteInfo;
@property (nonatomic, strong) NSString *remoteGlobalIDString;

@end

NS_ASSUME_NONNULL_END
