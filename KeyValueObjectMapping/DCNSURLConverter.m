//
//  DCNSURLConverter.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCNSURLConverter.h"
#import "DCDynamicAttribute.h"

@implementation DCNSURLConverter

+ (DCNSURLConverter *) urlConverter {
    return [[self alloc] init];
}

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    if ([value isKindOfClass:[NSString class]]) {
        return [NSURL URLWithString:[value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return nil;
}
- (id)serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return [((NSURL *)value) absoluteString];
}
- (BOOL)canTransformValueForClass: (Class) cls {
    return [cls isSubclassOfClass:[NSURL class]];
}

@end
