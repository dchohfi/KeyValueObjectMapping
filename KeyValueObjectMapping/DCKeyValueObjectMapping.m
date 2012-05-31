//
//  DCKeyValueObjectMapping.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCKeyValueObjectMapping.h"
#import "DCGenericConverter.h"
#import "DCReferenceKeyParser.h"
#import "DCPropertyFinder.h"
#import "DCAttributeSetter.h"
#import "DCDictionaryRearranger.h"

@interface DCKeyValueObjectMapping()

@property(nonatomic, strong) DCGenericConverter *converter;
@property(nonatomic, strong) DCPropertyFinder *propertyFinder;
@property(nonatomic, strong) DCParserConfiguration *configuration;



@end

@implementation DCKeyValueObjectMapping
@synthesize converter, propertyFinder, configuration, classToGenerate;


+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate {
    return [self mapperForClass:classToGenerate andConfiguration:[DCParserConfiguration configuration]];
}
+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate andConfiguration: (DCParserConfiguration *) configuration {
    return [[self alloc] initWithClass: classToGenerate forConfiguration: configuration];
}

- (id) initWithClass: (Class) _classToGenerate forConfiguration: (DCParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
        DCReferenceKeyParser *keyParser = [DCReferenceKeyParser parserForToken: configuration.splitToken];
        
        propertyFinder = [DCPropertyFinder finderWithKeyParser:keyParser];
        [propertyFinder setMappers:[configuration objectMappers]];
        
        converter = [[DCGenericConverter alloc] initWithConfiguration:configuration];
        classToGenerate = _classToGenerate;
    }
    return self;   
}

- (NSArray *) parseArray: (NSArray *) array {
    if(!array){
        return nil;
    }
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dictionary in array) {
        id value = [self parseDictionary:dictionary];
        [values addObject:value];
    }
    return [NSArray arrayWithArray:values];
}

- (id) createObjectWithPrimaryKeyValue:(id)primaryKeyValue
{
    return [[classToGenerate alloc] init];
}




- (DCDynamicAttribute *)primaryKeyAttribute
{
 return   [propertyFinder findAttributeForKey:configuration.primaryKeyName onClass:classToGenerate];
}

- (id)findObjectByPrimaryKeyValue:(id)primaryKeyValue
{
 return nil;
}

- (NSDictionary *)serializeObject:(id)object
{
    if (NO) { //fixme
        return [object valueForKeyPath:[self primaryKeyAttribute].objectMapping.attributeName];
    }


    NSMutableDictionary *serializedObject = [[NSMutableDictionary alloc] init];

    for (DCObjectMapping *mapping in propertyFinder.mappers) {
        NSString * attributeName = mapping.attributeName;
        id value = [object valueForKey:attributeName];
        DCDynamicAttribute *dynamicAttribute = [propertyFinder findAttributeForKey:mapping.keyReference onClass:classToGenerate];
        if(dynamicAttribute){
            [self serializeValue:value toDictionary:serializedObject
                     inAttribute:dynamicAttribute];
        }

    }

    return [NSDictionary dictionaryWithDictionary:serializedObject];
}


- (NSArray *)serializeObjectArray:(NSArray *)objectArray
{
    NSMutableArray *serializedObjects = [[NSMutableArray alloc] init];

    for (id object in objectArray) {
        [serializedObjects addObject:[self serializeObject:object]];
    }

    return [NSArray arrayWithArray:serializedObjects];
}

- (id) parseDictionary: (NSDictionary *) dictionary {
    if(!dictionary || !classToGenerate){
        return nil;
    }


    dictionary = [DCDictionaryRearranger rearrangeDictionary:dictionary forAggregators:configuration.aggregators];



    id object = nil;
    if (configuration.primaryKeyName) {
        id primaryKeyValue = [dictionary valueForKey:configuration.primaryKeyName];
        id primaryKeyConvertedValue = [converter transformValue:primaryKeyValue forDynamicAttribute:[self primaryKeyAttribute]];
        object = [self findObjectByPrimaryKeyValue:primaryKeyConvertedValue];
        if (!object) {
            object = [self createObjectWithPrimaryKeyValue:primaryKeyValue];
        }
    } else {
        object = [self createObjectWithPrimaryKeyValue:nil];
    }


    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        id value = [dictionary valueForKey:key];
        DCDynamicAttribute *dynamicAttribute = [propertyFinder findAttributeForKey:key onClass:classToGenerate];
        if(dynamicAttribute){
            [self parseValue:value forObject:object inAttribute:dynamicAttribute];
        }
    }
    return object;
}


- (void) parseValue: (id) value forObject: (id) object inAttribute: (DCDynamicAttribute *) dynamicAttribute {
    DCObjectMapping *objectMapping = dynamicAttribute.objectMapping;

    NSString *attributeName = objectMapping.attributeName;
    if (objectMapping.converter)
        value = [objectMapping.converter transformValue:value forDynamicAttribute:dynamicAttribute];
    else
        value = [converter transformValue:value forDynamicAttribute:dynamicAttribute];
    [DCAttributeSetter assingValue:value forAttributeName:attributeName andAttributeClass:objectMapping.classReference onObject:object];
}


- (void) serializeValue: (id) value toDictionary: (NSMutableDictionary *) dictionary inAttribute: (DCDynamicAttribute
*) dynamicAttribute {
    DCObjectMapping *objectMapping = dynamicAttribute.objectMapping;

    if (objectMapping.converter)
        value = [objectMapping.converter serializeValue:value forDynamicAttribute:dynamicAttribute];
    else
        value = [converter serializeValue:value forDynamicAttribute:dynamicAttribute];
    [dictionary setValue:value forKeyPath:objectMapping.keyReference];
}


@end
