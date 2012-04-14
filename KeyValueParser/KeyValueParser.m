//
//  KeyValueParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueParser.h"
#import "GenericParser.h"
#import "DynamicAttribute.h"
#import <objc/runtime.h>
#import "PropertyNameParser.h"

@interface KeyValueParser()
@property(nonatomic, strong) GenericParser *parser;
@property(nonatomic, strong) ParserConfiguration *configuration;
@property(nonatomic, strong) PropertyNameParser *propertyNameParser;
- (void) parseValue: (id) value forObject: (id) object 
        inAttribute: (NSString *) attributeDetails forKey: (NSString *) key;
@end

@implementation KeyValueParser
@synthesize configuration, propertyNameParser, parser;

- (id) initWithConfiguration: (ParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
        propertyNameParser = [[PropertyNameParser alloc] initWithConfiguration:configuration];
        parser = [[GenericParser alloc] initWithConfiguration:configuration];
    }
    return self;   
}
- (id) parseJson: (NSDictionary *) json forClass: (Class) class{
    NSObject *object = [[class alloc] init];
    NSArray *keys = [json allKeys];
    for (NSString *key in keys) {
        id value = [json valueForKey:key];
        objc_property_t property = class_getProperty(class, [key UTF8String]);
        if (property) {
            NSString *attributeDetails = [NSString stringWithUTF8String:property_getAttributes(property)];
            [self parseValue:value forObject:object inAttribute:attributeDetails forKey:key];
        }else{
            NSString *parsedKey = [propertyNameParser splitKeyAndMakeCamelcased:key];
            objc_property_t property = class_getProperty(class, [parsedKey UTF8String]);
            if (property) {
                NSString *attributeDetails = [NSString stringWithUTF8String:property_getAttributes(property)];
                [self parseValue:value forObject:object inAttribute:attributeDetails forKey:parsedKey];
            }
        }
    }
    return object;
}
- (void) parseValue: (id) value forObject: (id) object 
inAttribute: (NSString *) attributeDetails forKey: (NSString *) key {
    DynamicAttribute *dynamicAttribute = [[DynamicAttribute alloc] initWithAttributeDescription: attributeDetails];
    if([value isKindOfClass:[NSDictionary class]]){
        value = [self parseJson:(NSDictionary *) value forClass:[dynamicAttribute attributeClass]];
    }
    NSError *error;
    value = [parser transformValue:value forDynamicAttribute:dynamicAttribute];
    if([object validateValue:&value forKey:key error:&error]){
        if([value isKindOfClass:[NSNull class]]){
            if([dynamicAttribute attributeClass] == [NSString class]){
                [object setValue:nil forKey:key];
            }else{
                [object setNilValueForKey:key];   
            }
        }else {
            [object setValue:value forKey:key];
        }
    }
}

@end
