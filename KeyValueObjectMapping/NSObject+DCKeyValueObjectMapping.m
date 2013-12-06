//
//  NSObject+DCKeyValueObjectMapping.m
//  KeyValueObjectMapping
//
//  Created by Benjamin Petit on 06/12/2013.
//  Copyright (c) 2013 dchohfi. All rights reserved.
//

#import "NSObject+DCKeyValueObjectMapping.h"
#import "DCKeyValueObjectMapping.h"

@implementation NSObject (DCKeyValueObjectMapping)

+ (instancetype)dc_parseDictionary:(NSDictionary *)dictionary
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:self];
    return [parser parseDictionary:dictionary];
}

+ (instancetype)dc_parseDictionary:(NSDictionary *)dictionary configuration:(DCParserConfiguration *)configuration
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:self andConfiguration:configuration];
    return [parser parseDictionary:dictionary];
}

+ (NSArray *)dc_parseArray:(NSArray *)array
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:self];
    return [parser parseArray:array];
}

+ (NSArray *)dc_parseArray:(NSArray *)array configuration:(DCParserConfiguration *)configuration
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:self andConfiguration:configuration];
    return [parser parseArray:array];
}

- (void)dc_updateWithDictionary:(NSDictionary *)dictionary
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class]];
    return [parser updateObject:self withDictionary:dictionary];
}

- (void)dc_updateWithDictionary:(NSDictionary *)dictionary configuration:(DCParserConfiguration *)configuration
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[self class] andConfiguration:configuration];
    return [parser updateObject:self withDictionary:dictionary];
}

@end
