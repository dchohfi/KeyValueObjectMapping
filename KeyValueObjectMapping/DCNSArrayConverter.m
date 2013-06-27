//
//  DCNSArrayConverter.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCNSArrayConverter.h"
#import "DCSimpleConverter.h"
#import "DCArrayMapping.h"
#import "DCKeyValueObjectMapping.h"
#import "DCDynamicAttribute.h"
#import "DCGenericConverter.h"
@interface DCNSArrayConverter()

@property(nonatomic, strong) DCParserConfiguration *configuration;

@end

@implementation DCNSArrayConverter
@synthesize configuration = _configuration;

+ (DCNSArrayConverter *) arrayConverterForConfiguration: (DCParserConfiguration *)configuration {
    return [[self alloc] initWithConfiguration: configuration];
}

- (id)initWithConfiguration:(DCParserConfiguration *)configuration{
    self = [super init];
    if (self) {
        _configuration = configuration;
    }
    return self;   
}

- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    if (!values || values == [NSNull null] || [values count] == 0) {
        return nil;
    }
    
    BOOL primitiveArray = ![[[values objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]];
    if (primitiveArray) {
        return [self parsePrimitiveValues:values dictionary:dictionary parentObject:parentObject];
    } else {
        DCArrayMapping *mapper = [self.configuration arrayMapperForMapper:attribute.objectMapping];
        if (mapper) {
            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:mapper.classForElementsOnArray andConfiguration:self.configuration];
            return [parser parseArray:values forParentObject:parentObject];
        }
    }
    return nil;
}
- (id)serializeValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute {
    DCGenericConverter* genericConverter = [[DCGenericConverter alloc] initWithConfiguration:self.configuration];
    NSMutableArray *valuesHolder = [NSMutableArray array];
    for(id value in values){
        DCDynamicAttribute *valueClassAsAttribute = [[DCDynamicAttribute alloc] initWithClass:[value class]];
        [valuesHolder addObject:[genericConverter serializeValue:value forDynamicAttribute:valueClassAsAttribute]];
    }    
    return [NSArray arrayWithArray:valuesHolder];
}

- (NSArray *)parsePrimitiveValues:(NSArray *)primitiveValues dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    DCSimpleConverter *simpleParser = [[DCSimpleConverter alloc] init];
    NSMutableArray *valuesHolder = [NSMutableArray array];
    for (id value in primitiveValues) {
        DCDynamicAttribute *valueClassAsAttribute = [[DCDynamicAttribute alloc] initWithClass:[value class]];
        [valuesHolder addObject:[simpleParser transformValue:value forDynamicAttribute:valueClassAsAttribute dictionary:dictionary parentObject:parentObject]];
    }
    return [NSArray arrayWithArray:valuesHolder];
}

- (BOOL)canTransformValueForClass:(Class)class {
    return [class isSubclassOfClass:[NSArray class]];
}
@end
