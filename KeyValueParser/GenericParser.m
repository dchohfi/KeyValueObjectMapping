//
//  GenericParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "GenericParser.h"
#import "NSDateParser.h"
#import "NSURLParser.h"
#import "SimpleParser.h"
#import "NSArrayParser.h"

@interface GenericParser()
@property(nonatomic, strong) ParserConfiguration *configuration;
@property(nonatomic, strong) NSArray *parsers;
@end

@implementation GenericParser
@synthesize configuration, parsers;
- (id)initWithConfiguration:(ParserConfiguration *) _configuration
{
    self = [super init];
    if (self) {
        configuration = _configuration;
        parsers = [NSArray arrayWithObjects:
                            [[NSDateParser alloc] initWithConfiguration:configuration],                         
                            [[NSURLParser alloc] initWithConfiguration:configuration],
                            [[NSArrayParser alloc] initWithConfiguration:configuration],
                            nil];
    }
    return self;
}

- (id)transformValue:(id)value forDynamicAttribute: (DynamicAttribute *) attribute {
    if([attribute isValidObject]){
        for(id<ValueParser> parser in parsers){
            if([parser canTransformValueForClass:[attribute attributeClass]]){
                return [parser transformValue:value forDynamicAttribute:attribute];
            }
        }
    }
    SimpleParser *simpleParser = [[SimpleParser alloc] init];
    return [simpleParser transformValue:value forDynamicAttribute:attribute];
}

@end