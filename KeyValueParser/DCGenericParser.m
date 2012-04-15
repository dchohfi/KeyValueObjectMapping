//
//  GenericParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCGenericParser.h"
#import "DCNSDateParser.h"
#import "DCNSURLParser.h"
#import "DCSimpleParser.h"
#import "DCNSArrayParser.h"

@interface DCGenericParser()
@property(nonatomic, strong) DCParserConfiguration *configuration;
@property(nonatomic, strong) NSArray *parsers;
@end

@implementation DCGenericParser
@synthesize configuration, parsers;
- (id)initWithConfiguration:(DCParserConfiguration *) _configuration
{
    self = [super init];
    if (self) {
        configuration = _configuration;
        parsers = [NSArray arrayWithObjects:
                            [[DCNSDateParser alloc] initWithConfiguration:configuration],                         
                            [[DCNSURLParser alloc] initWithConfiguration:configuration],
                            [[DCNSArrayParser alloc] initWithConfiguration:configuration],
                            nil];
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute: (DCDynamicAttribute *) attribute {
    if([attribute isValidObject]){
        for(id<DCValueParser> parser in parsers){
            if([parser canTransformValueForClass:[attribute attributeClass]]){
                return [parser transformValue:value forDynamicAttribute:attribute];
            }
        }
    }
    DCSimpleParser *simpleParser = [[DCSimpleParser alloc] init];
    return [simpleParser transformValue:value forDynamicAttribute:attribute];
}

@end