//
//  DCNSSetConverter.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 6/13/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCNSSetConverter.h"
#import "DCNSArrayConverter.h"
@interface DCNSSetConverter()

@property(nonatomic, strong) DCParserConfiguration *configuration;
@property(nonatomic, strong) DCNSArrayConverter *arrayConverter;

@end

@implementation DCNSSetConverter
@synthesize arrayConverter, configuration;
+ (DCNSSetConverter *) setConverterForConfiguration: (DCParserConfiguration *) configuration {
    return [[self alloc] initWithConfiguration: configuration];
}

- (id)initWithConfiguration: (DCParserConfiguration *) _configuration
{
    self = [super init];
    if (self) {
        self.configuration = _configuration;
        self.arrayConverter = [DCNSArrayConverter arrayConverterForConfiguration:_configuration];
    }
    return self;
}

- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute {
    NSArray *result = [arrayConverter transformValue:values forDynamicAttribute:attribute];
    return [NSSet setWithArray:result];
}

- (id)serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return [arrayConverter serializeValue:value forDynamicAttribute:attribute];
}

- (BOOL)canTransformValueForClass:(Class) classe {
    return [classe isSubclassOfClass:[NSSet class]];
}

@end
