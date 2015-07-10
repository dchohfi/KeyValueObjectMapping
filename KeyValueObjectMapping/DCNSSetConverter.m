//
//  DCNSSetConverter.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 6/13/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCNSSetConverter.h"
#import "DCNSArrayConverter.h"
#import "DCDynamicAttribute.h"

@interface DCNSSetConverter()

@property(nonatomic, strong) DCParserConfiguration *configuration;
@property(nonatomic, strong) DCNSArrayConverter *arrayConverter;

@end

@implementation DCNSSetConverter
@synthesize arrayConverter = _arrayConverter;
@synthesize configuration = _configuration;
+ (DCNSSetConverter *) setConverterForConfiguration: (DCParserConfiguration *) configuration {
    return [[self alloc] initWithConfiguration: configuration];
}

- (id)initWithConfiguration: (DCParserConfiguration *) configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
        self.arrayConverter = [DCNSArrayConverter arrayConverterForConfiguration:self.configuration];
    }
    return self;
}

- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    NSArray *result = [self.arrayConverter transformValue:values forDynamicAttribute:attribute dictionary:dictionary parentObject:parentObject];
    return [NSSet setWithArray:result];
}

- (id)serializeValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute {
    return [self.arrayConverter serializeValue:value forDynamicAttribute:attribute];
}

- (BOOL)canTransformValueForClass:(Class)cls {
    return [cls isSubclassOfClass:[NSSet class]];
}

@end
