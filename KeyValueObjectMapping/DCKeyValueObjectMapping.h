//
//  DCKeyValueObjectMapping.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCParserConfiguration.h"

@interface DCKeyValueObjectMapping : NSObject

@property(nonatomic, readonly) Class classToGenerate;

+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate;
+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate 
                            andConfiguration: (DCParserConfiguration *) configuration;

- (id)initWithClass: (Class) classToGenerate 
   forConfiguration: (DCParserConfiguration *) configuration;

- (void) setValuesOnObject: (id) object withDictionary: (NSDictionary *) dictionary;

- (id) parseDictionary: (NSDictionary *) dictionary;
- (NSArray *) parseArray: (NSArray *) array;

- (NSDictionary *)serializeObject:(id)object;
- (NSArray *)serializeObjectArray:(NSArray *)objectArray;

@end
