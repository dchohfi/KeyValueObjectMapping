//
//  DCGenericConverter.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCGenericConverter.h"
#import "DCNSDateConverter.h"
#import "DCNSURLConverter.h"
#import "DCSimpleConverter.h"
#import "DCNSArrayConverter.h"

@interface DCGenericConverter()
@property(nonatomic, strong) DCParserConfiguration *configuration;
@property(nonatomic, strong) NSArray *parsers;
@end

@implementation DCGenericConverter
@synthesize configuration, parsers;

- (id)initWithConfiguration:(DCParserConfiguration *) _configuration
{
    self = [super init];
    if (self) {
        configuration = _configuration;
        parsers = [NSArray arrayWithObjects:
                   [DCNSDateConverter dateConverterForPattern:configuration.datePattern],
                   [DCNSURLConverter urlConverter],
                   [DCNSArrayConverter arrayConverterForConfiguration: configuration], nil];
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute: (DCDynamicAttribute *) attribute {
    if([attribute isValidObject]){
        for(id<DCValueConverter> parser in parsers){
            if([parser canTransformValueForClass:attribute.objectMapping.classReference]){
                return [parser transformValue:value forDynamicAttribute:attribute];
            }
        }
    }
    DCSimpleConverter *simpleParser = [[DCSimpleConverter alloc] init];
    return [simpleParser transformValue:value forDynamicAttribute:attribute];
}

@end