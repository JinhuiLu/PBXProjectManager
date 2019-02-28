//
//  NSDictionary+PBXProjectFormat.m
//  PBXProjectManager
//
//  Created by lujh on 2019/2/15.
//  Copyright © 2019 lujh. All rights reserved.
//

#import "NSDictionary+PBXProjectFormat.h"

@implementation NSDictionary (PBXProjectFormat)

- (NSString *)convertToPBXProjFormatString
{
    return [self pbxprojStringFromIndent:[@"" mutableCopy]];
}

- (NSString *)pbxprojStringFromIndent:(NSMutableString *)indent
{
    NSMutableString *text = [@"{\n" mutableCopy];
    
    [indent appendString:@"\t"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [text appendFormat:@"%@%@ = %@;\n", indent, key, [self stringFromValue:obj indent:indent]];
    }];
    
    [indent deleteCharactersInRange:NSMakeRange(indent.length - 1, 1)];
    
    [text appendFormat:@"%@}", indent];
    
    return [text copy];
}

- (NSString *)stringFromValue:(id)value indent:(NSMutableString *)indent
{
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return [self stringFromDict:value indent:indent];
    }
    else if ([value isKindOfClass:[NSArray class]])
    {
        return [self stringFromArray:value indent:indent];
    }
    else if ([value isKindOfClass:[NSString class]])
    {
        return [self stringFromString:value indent:indent];
    }
    else
    {
        return value;
    }
}

- (NSString *)stringFromArray:(NSArray *)array indent:(NSMutableString *)indent
{
    NSMutableString *text = [@"(\n" mutableCopy];
    
    [indent appendString:@"\t"];
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [text appendFormat:@"%@%@,\n", indent, [self stringFromValue:obj indent:indent]];
    }];
    
    [indent deleteCharactersInRange:NSMakeRange(indent.length - 1, 1)];
    
    [text appendFormat:@"%@)", indent];
    
    return [text copy];
}

- (NSString *)stringFromDict:(NSDictionary *)dict indent:(NSMutableString *)indent
{
    NSMutableString *text = [@"{\n" mutableCopy];
    
    [indent appendString:@"\t"];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [text appendFormat:@"%@%@ = %@;\n", indent, key, [self stringFromValue:obj indent:indent]];
    }];
    
    [indent deleteCharactersInRange:NSMakeRange(indent.length - 1, 1)];
    
    [text appendFormat:@"%@}", indent];
    
    return [text copy];
}

- (NSString *)stringFromString:(NSString *)string indent:(NSMutableString *)indent
{
    return [NSString stringWithFormat:@"\"%@\"", string];
}

@end
