//
//  DCNSURLConverter.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCNSURLConverter.h"

@interface DCNSURLConverter()
@property(nonatomic, strong) DCParserConfiguration *configuration;
@end

@implementation DCNSURLConverter
@synthesize configuration;

- (id) initWithConfiguration: (DCParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;
}
- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return [NSURL URLWithString:value];
}
- (BOOL) canTransformValueForClass: (Class) class {
    return [class isSubclassOfClass:[NSURL class]];
}
@end
