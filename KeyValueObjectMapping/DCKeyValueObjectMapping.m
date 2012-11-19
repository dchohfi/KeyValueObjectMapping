//
//  DCKeyValueObjectMapping.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCKeyValueObjectMapping.h"
#import "DCGenericConverter.h"
#import "DCDynamicAttribute.h"
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
@synthesize converter = _converter;
@synthesize propertyFinder = _propertyFinder;
@synthesize configuration = _configuration;
@synthesize classToGenerate = _classToGenerate;

+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate {
    return [self mapperForClass:classToGenerate andConfiguration:[DCParserConfiguration configuration]];
}
+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate andConfiguration: (DCParserConfiguration *) configuration {
    return [[self alloc] initWithClass: classToGenerate
                      forConfiguration: configuration];
}
- (id) initWithClass: (Class) classToGenerate forConfiguration: (DCParserConfiguration *) configuration {
    self = [super init];
    if (self) {
        self.configuration = configuration;
        DCReferenceKeyParser *keyParser = [DCReferenceKeyParser parserForToken: self.configuration.splitToken];
        
        self.propertyFinder = [DCPropertyFinder finderWithKeyParser:keyParser];
        [self.propertyFinder setMappers:[configuration objectMappers]];
        
        self.converter = [[DCGenericConverter alloc] initWithConfiguration:configuration];
        _classToGenerate = classToGenerate;
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
- (id) parseDictionary: (NSDictionary *) dictionary {
    if(!dictionary || !self.classToGenerate){
        return nil;
    }
    NSObject *object = [[self configuration] instantiateObjectForClass:self.classToGenerate
                                                            withValues:dictionary];
    
    [self setValuesOnObject:object withDictionary:dictionary];
    return object;
}
- (void) setValuesOnObject: (id) object withDictionary: (NSDictionary *) dictionary {
    if([object class] != self.classToGenerate){
        return;
    }
    
    dictionary = [DCDictionaryRearranger rearrangeDictionary:dictionary 
                                              forAggregators:self.configuration.aggregators];
    
    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        id value = [dictionary valueForKey:key];
        DCDynamicAttribute *dynamicAttribute = [self.propertyFinder findAttributeForKey:key
                                                                                onClass:self.classToGenerate];
        if(dynamicAttribute){
            [self parseValue:value forObject:object inAttribute:dynamicAttribute];
        }
    }
}
- (NSDictionary *)serializeObject:(id)object
{    
    NSMutableDictionary *serializedObject = [[NSMutableDictionary alloc] init];
    
    for (DCObjectMapping *mapping in self.propertyFinder.mappers) {
        NSString * attributeName = mapping.attributeName;
        id value = [object valueForKey:attributeName];
        DCDynamicAttribute *dynamicAttribute = [self.propertyFinder findAttributeForKey:mapping.keyReference
                                                                                onClass:self.classToGenerate];
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
- (void) parseValue: (id) value
          forObject: (id) object
        inAttribute: (DCDynamicAttribute *) dynamicAttribute {
    DCObjectMapping *objectMapping = dynamicAttribute.objectMapping;
    NSString *attributeName = objectMapping.attributeName;
    
    value = [self.converter transformValue:value
                       forDynamicAttribute:dynamicAttribute];
    
    [DCAttributeSetter assingValue:value 
                  forAttributeName:attributeName 
                 andAttributeClass:objectMapping.classReference 
                          onObject:object];
}

- (void) serializeValue: (id) value toDictionary: (NSMutableDictionary *) dictionary inAttribute: (DCDynamicAttribute *) dynamicAttribute {
    DCObjectMapping *objectMapping = dynamicAttribute.objectMapping;
    if (objectMapping.converter)
        value = [objectMapping.converter serializeValue:value forDynamicAttribute:dynamicAttribute];
    else
        value = [self.converter serializeValue:value forDynamicAttribute:dynamicAttribute];
    [dictionary setValue:value forKeyPath:objectMapping.keyReference];
}
@end
