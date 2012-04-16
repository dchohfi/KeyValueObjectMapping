//
//  DCSimpleConverter.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCSimpleConverter.h"

@interface DCSimpleConverter()
@property(nonatomic, strong) DCParserConfiguration *configuration;
@end

@implementation DCSimpleConverter

@synthesize configuration;

- (id) initWithConfiguration: (DCParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return value;
}
- (BOOL)canTransformValueForClass:(Class)class {
    return YES;
}

@end
