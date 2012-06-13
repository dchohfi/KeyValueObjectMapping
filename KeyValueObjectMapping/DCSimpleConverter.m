//
//  DCSimpleConverter.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCSimpleConverter.h"

@implementation DCSimpleConverter
- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return value;
}
-(id)serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute{
    return value;
}
- (BOOL)canTransformValueForClass:(Class)class {
    return YES;
}

@end
