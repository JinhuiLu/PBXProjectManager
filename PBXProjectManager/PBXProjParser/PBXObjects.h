//
//  PBXObjects.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/25.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "PBXObject.h"

@class PBXProject;
NS_ASSUME_NONNULL_BEGIN

@interface PBXObjects : PBXObject

- (PBXProject *)createPBXProjectWithRootObjectId:(NSString *)rootObjectId data:(NSDictionary *)data;

- (void)setObject:(PBXObject *)object;

- (void)deleteObject:(PBXObject *)object;

@end

NS_ASSUME_NONNULL_END
