//
//  NSObject+DCKeyValueObjectMapping.h
//  KeyValueObjectMapping
//
//  Created by Benjamin Petit on 06/12/2013.
//  Copyright (c) 2013 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCParserConfiguration.h"

@interface NSObject (DCKeyValueObjectMapping)

+ (instancetype)dc_parseDictionary:(NSDictionary *)dictionary;
+ (instancetype)dc_parseDictionary:(NSDictionary *)dictionary configuration:(DCParserConfiguration *)configuration;

+ (NSArray *)dc_parseArray:(NSArray *)array;
+ (NSArray *)dc_parseArray:(NSArray *)array configuration:(DCParserConfiguration *)configuration;

- (void)dc_updateWithDictionary:(NSDictionary *)dictionary;
- (void)dc_updateWithDictionary:(NSDictionary *)dictionary configuration:(DCParserConfiguration *)configuration;

@end
