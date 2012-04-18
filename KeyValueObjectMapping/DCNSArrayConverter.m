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
@interface DCNSArrayConverter()

@property(nonatomic, strong) DCParserConfiguration *configuration;

@end

@implementation DCNSArrayConverter
@synthesize configuration;

+ (DCNSArrayConverter *) arrayConverterForConfiguration: (DCParserConfiguration *)configuration {
    return [[self alloc] initWithConfiguration: configuration];
}

- (id)initWithConfiguration:(DCParserConfiguration *)_configuration{
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;   
}

- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute {
    BOOL primitiveArray = ![[[values objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]];
    if(primitiveArray){
        return [self parsePrimitveValues:values];
    }else{
        DCArrayMapping *mapper = [configuration arrayMapperForMapper:attribute.objectMapping];
        if(mapper){
            DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:configuration];
            return [parser parseArray:values forClass:mapper.classForElementsOnArray];
        }
    }
    return nil;
}

- (NSArray *) parsePrimitveValues: (NSArray *) primitiveValues {
    DCSimpleConverter *simpleParser = [[DCSimpleConverter alloc] init];
    NSMutableArray *valuesHolder = [NSMutableArray array];
    for(id value in primitiveValues){
        DCDynamicAttribute *valueClassAsAttribute = [[DCDynamicAttribute alloc] initWithClass:[value class]];
        [valuesHolder addObject:[simpleParser transformValue:value forDynamicAttribute:valueClassAsAttribute]];
    }
    return [NSArray arrayWithArray:valuesHolder];
}

- (BOOL)canTransformValueForClass:(Class) classe {
    return [classe isSubclassOfClass:[NSArray class]];
}
@end
