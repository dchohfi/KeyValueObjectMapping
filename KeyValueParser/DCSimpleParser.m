//
//  SimpleParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCSimpleParser.h"

@interface DCSimpleParser()
@property(nonatomic, strong) DCParserConfiguration *configuration;
@end

@implementation DCSimpleParser

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
