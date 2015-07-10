//
//  DCSimpleConverter.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCSimpleConverter.h"
#import "DCDynamicAttribute.h"

@implementation DCSimpleConverter
- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    return value;
}
-(id)serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute{
    return value;
}
- (BOOL)canTransformValueForClass:(Class)cls {
    return YES;
}

@end
