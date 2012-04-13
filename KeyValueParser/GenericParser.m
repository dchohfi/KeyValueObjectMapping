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
- (NSArray *) parsersWithConfiguration: (ParserConfiguration *) configuration;
@end

@implementation GenericParser

- (id)transformValue:(id)value forClass: (Class) class withConfiguration: (ParserConfiguration *)configuration{
    if(class){
        for(id<ValueParser> parser in [self parsersWithConfiguration:configuration]){
            if([parser canTransformValueForClass:class]){
                return [parser transformValue:value];
            }
        }
    }
    SimpleParser *simpleParser = [[SimpleParser alloc] init];
    return [simpleParser transformValue:value];
}

- (NSArray *) parsersWithConfiguration: (ParserConfiguration *) configuration {
    static NSArray *parsers = nil;
    
    if(!parsers){
        parsers = [NSArray arrayWithObjects:
                   [[NSDateParser alloc] initWithConfiguration:configuration],                         
                   [[NSURLParser alloc] initWithConfiguration:configuration],
                   [[NSArrayParser alloc] initWithConfiguration:configuration],
                   nil];
    }
    return parsers;
}

@end