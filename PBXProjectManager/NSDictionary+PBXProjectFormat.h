//
//  NSDictionary+PBXProjectFormat.h
//  PBXProjectManager
//
//  Created by lujh on 2019/2/15.
//  Copyright © 2019 lujh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (PBXProjectFormat)

- (NSString *)convertToPBXProjFormatString;

@end

NS_ASSUME_NONNULL_END
