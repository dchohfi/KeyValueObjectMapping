//
//  KeyValueObjectMapping.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCKeyValueObjectMapping.h"
#import "DCGenericParser.h"
#import "DCDynamicAttribute.h"
#import <objc/runtime.h>
#import "DCPropertyNameParser.h"

@interface DCKeyValueObjectMapping()
@property(nonatomic, strong) DCGenericParser *parser;
@property(nonatomic, strong) DCParserConfiguration *configuration;
@property(nonatomic, strong) DCPropertyNameParser *propertyNameParser;
- (void) parseValue: (id) value forObject: (id) object inAttribute: (DCDynamicAttribute *) dynamicAttribute;
- (DCDynamicAttribute *) findAttributeForKey: (NSString *) key onClass: (Class) class;
- (DCDynamicAttribute *) findPropertyForKey: (NSString *)key onClass: (Class)class;
- (void)setNilValueForKey:(NSString *)key onObject: (id) object forClass: (Class) class;
@end

@implementation DCKeyValueObjectMapping
@synthesize configuration, propertyNameParser, parser;

- (id) initWithConfiguration: (DCParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
        propertyNameParser = [[DCPropertyNameParser alloc] initWithConfiguration:configuration];
        parser = [[DCGenericParser alloc] initWithConfiguration:configuration];
    }
    return self;   
}

- (NSArray *) parseArray: (NSArray *) array forClass: (Class) class {
    if(!array || !class){
        return nil;
    }
    NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:[array count]];
    for (NSDictionary *dictionary in array) {
        id value = [self parseDictionary:dictionary forClass:class];
        [values addObject:value];
    }
    return [NSArray arrayWithArray:values];
}
- (id) parseDictionary: (NSDictionary *) dictionary forClass: (Class) class{
    if(!dictionary || !class){
        return nil;
    }
    NSObject *object = [[class alloc] init];
    NSArray *keys = [dictionary allKeys];
    for (NSString *key in keys) {
        id value = [dictionary valueForKey:key];
        DCDynamicAttribute *dynamicAttribute = [self findAttributeForKey:key onClass:class];
        if(dynamicAttribute){
            [self parseValue:value forObject:object inAttribute:dynamicAttribute];
        }
    }
    return object;
}
- (void) parseValue: (id) value forObject: (id) object inAttribute: (DCDynamicAttribute *) dynamicAttribute {
    if([value isKindOfClass:[NSDictionary class]]){
        value = [self parseDictionary:(NSDictionary *) value forClass:[dynamicAttribute attributeClass]];
    }
    NSError *error;
    NSString *key = [dynamicAttribute key];
    value = [parser transformValue:value forDynamicAttribute:dynamicAttribute];
    if([object validateValue:&value forKey:key error:&error]){
        if([value isKindOfClass:[NSNull class]]){
            [self setNilValueForKey: key onObject: object forClass:dynamicAttribute.attributeClass];
        }else {
            [object setValue:value forKey:key];
        }
    }
}
- (void)setNilValueForKey:(NSString *)key onObject: (id) object forClass: (Class) class {
    if(class == [NSString class]){
        [object setValue:nil forKey:key];
    }else{
        [object setNilValueForKey:key];   
    }
}
- (DCDynamicAttribute *) findPropertyForKey: (NSString *)key onClass: (Class)class{
    objc_property_t property = class_getProperty(class, [key UTF8String]);
    if (property) {
        NSString *attributeDetails = [NSString stringWithUTF8String:property_getAttributes(property)];
        return [[DCDynamicAttribute alloc] initWithAttributeDescription: attributeDetails forKey:key];
    }
    return nil;
}

- (DCDynamicAttribute *) findAttributeForKey: (NSString *) key onClass: (Class) class {
    DCDynamicAttribute *dynamicAttribute = [self findPropertyForKey:key onClass:class];
    if(!dynamicAttribute){
        key = [propertyNameParser splitKeyAndMakeCamelcased:key];
        dynamicAttribute = [self findPropertyForKey:key onClass:class];
    }
    return dynamicAttribute;
}

@end
