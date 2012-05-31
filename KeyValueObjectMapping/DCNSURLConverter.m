//
//  DCNSURLConverter.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCNSURLConverter.h"

@implementation DCNSURLConverter

+ (DCNSURLConverter *) urlConverter {
    return [[self alloc] init];
}

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return [NSURL URLWithString:value];
}
- (BOOL) canTransformValueForClass: (Class) class {
    return [class isSubclassOfClass:[NSURL class]];
}

- (id) serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute
{
    return [((NSURL *)value) absoluteString];
}

@end
