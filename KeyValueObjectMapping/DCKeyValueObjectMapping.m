//
//  KeyValueObjectMapping.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCKeyValueObjectMapping.h"
#import "DCGenericConverter.h"
#import "DCDynamicAttribute.h"
#import "DCPropertyNameParser.h"
#import "DCPropertyFinder.h"

@interface DCKeyValueObjectMapping()
@property(nonatomic, strong) DCGenericConverter *converter;
@property(nonatomic, strong) DCPropertyFinder *propertyFinder;
- (void) parseValue: (id) value forObject: (id) object inAttribute: (DCDynamicAttribute *) dynamicAttribute;
- (void)setNilValueForKey:(NSString *)key onObject: (id) object forClass: (Class) class;
@end

@implementation DCKeyValueObjectMapping
@synthesize converter, propertyFinder;

- (id)init
{
    return [self initWithConfiguration:[[DCParserConfiguration alloc] init]];
}

- (id) initWithConfiguration: (DCParserConfiguration *) configuration {
    self = [super init];
    if (self) {
        DCPropertyNameParser *propertyNameParser = [DCPropertyNameParser parserForToken: configuration.splitToken];
        
        propertyFinder = [DCPropertyFinder finderWithNameParser:propertyNameParser];
        
        converter = [[DCGenericConverter alloc] initWithConfiguration:configuration];
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
        DCDynamicAttribute *dynamicAttribute = [propertyFinder findAttributeForKey:key onClass:class];
        if(dynamicAttribute){
            [self parseValue:value forObject:object inAttribute:dynamicAttribute];
        }
    }
    return object;
}
- (void) parseValue: (id) value forObject: (id) object inAttribute: (DCDynamicAttribute *) dynamicAttribute {
    DCObjectMapping *objectMapping = dynamicAttribute.objectMapping;
    
    if([value isKindOfClass:[NSDictionary class]]){
        value = [self parseDictionary:(NSDictionary *) value forClass:objectMapping.classReference];
    }
    NSError *error;
    NSString *key = objectMapping.key;
    value = [converter transformValue:value forDynamicAttribute:dynamicAttribute];
    if([object validateValue:&value forKey:key error:&error]){
        if([value isKindOfClass:[NSNull class]]){
            [self setNilValueForKey: key onObject: object forClass:objectMapping.classReference];
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
@end
