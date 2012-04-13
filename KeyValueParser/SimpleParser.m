//
//  SimpleParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "SimpleParser.h"

@interface SimpleParser()
@property(nonatomic, strong) ParserConfiguration *configuration;
@end

@implementation SimpleParser

@synthesize configuration;

- (id) initWithConfiguration: (ParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;
}

- (id)transformValue:(id)value{
    return value;
}
- (BOOL)canTransformValueForClass:(Class)class {
    return YES;
}

@end
