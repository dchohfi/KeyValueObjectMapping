//
//  DCGenericConverter.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCGenericConverter.h"
#import "DCNSDateConverter.h"
#import "DCNSURLConverter.h"
#import "DCSimpleConverter.h"
#import "DCNSArrayConverter.h"
#import "DCNSSetConverter.h"
#import "DCCustomParser.h"
#import "DCKeyValueObjectMapping.h"

@interface DCGenericConverter()
@property(nonatomic, strong) DCParserConfiguration *configuration;
@property(nonatomic, strong) NSArray *parsers;
@end

@implementation DCGenericConverter
@synthesize configuration = _configuration;
@synthesize parsers = _parsers;

- (id)initWithConfiguration:(DCParserConfiguration *) configuration {
    self = [super init];
    if (self) {
        _configuration = configuration;
        _parsers = [NSArray arrayWithObjects:
                   [DCNSDateConverter dateConverterForPattern:self.configuration.datePattern],
                   [DCNSURLConverter urlConverter],
                   [DCNSArrayConverter arrayConverterForConfiguration: self.configuration], 
                   [DCNSSetConverter setConverterForConfiguration: self.configuration], nil];
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    if([attribute isValidObject]){
        BOOL valueIsKindOfDictionary = [value isKindOfClass:[NSDictionary class]];
        BOOL attributeNotKindOfDictionary = ![attribute.objectMapping.classReference isSubclassOfClass:[NSDictionary class]];
        if (valueIsKindOfDictionary && attributeNotKindOfDictionary) {
            id parsedValue = [self parseValueForBlock:value forObjectMapping:attribute dictionary:dictionary parentObject:parentObject];
            if (parsedValue) {
                return parsedValue;
            }

            DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:attribute.objectMapping.classReference
                                                                     andConfiguration:self.configuration];
            value = [parser parseDictionary:(NSDictionary *) value forParentObject:parentObject];
        }else {
            id parsedValue = [self parseSimpleValue:value forDynamicAttribute:attribute dictionary:dictionary parentObject:parentObject];
            if (parsedValue) return parsedValue;
        }
    }
    DCSimpleConverter *simpleParser = [[DCSimpleConverter alloc] init];
    return [simpleParser transformValue:value forDynamicAttribute:attribute dictionary:dictionary parentObject:parentObject];
}

- (id)serializeValue:(id)value forDynamicAttribute: (DCDynamicAttribute *) attribute {
    for (id<DCValueConverter> parser in self.parsers) {
        if([parser canTransformValueForClass:attribute.objectMapping.classReference]){
            return [parser serializeValue:value forDynamicAttribute:attribute];
        }
    }
    
    DCSimpleConverter *simpleParser = [[DCSimpleConverter alloc] init];	
    return [simpleParser serializeValue:value forDynamicAttribute:attribute];
}

#pragma mark - private methods

- (id)parseSimpleValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    id parsedValue = [self parseValueForBlock:value forObjectMapping:attribute dictionary:dictionary parentObject:parentObject];
    
    if(parsedValue){
        return parsedValue;
    }
    
    return [self parseValueForParsers:value forDynamicAttribute:attribute dictionary:dictionary parentObject:parentObject];
}

- (id)parseValueForParsers:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    for (id<DCValueConverter> parser in self.parsers) {
        if([parser canTransformValueForClass:attribute.objectMapping.classReference]){
            return [parser transformValue:value forDynamicAttribute:attribute dictionary:dictionary parentObject:parentObject];
        }
    }
    return nil;
}

- (id)parseValueForBlock:(id)value forObjectMapping:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject {
    DCObjectMapping *objectMapping = attribute.objectMapping;
    for(DCCustomParser *parser in self.configuration.customParsers){
        if ([parser isValidToPerformBlockOnAttributeName:objectMapping.attributeName
                                               forClass:attribute.classe]) {
            
            return parser.blockParser(dictionary, objectMapping.attributeName, attribute.classe, value);
        }
    }
    return nil;
}

@end