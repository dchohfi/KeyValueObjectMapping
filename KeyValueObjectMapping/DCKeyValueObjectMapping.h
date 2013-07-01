//
//  DCKeyValueObjectMapping.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCParserConfiguration;
@interface DCKeyValueObjectMapping : NSObject

@property(nonatomic, readonly) Class classToGenerate;

+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate;
+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate 
                            andConfiguration: (DCParserConfiguration *) configuration;

- (id)initWithClass: (Class) classToGenerate 
   forConfiguration: (DCParserConfiguration *) configuration;

- (id)parseDictionary:(NSDictionary *)dictionary;
- (id)parseDictionary:(NSDictionary *)dictionary forParentObject:(id)parentObject;

- (NSArray *)parseArray:(NSArray *)array;
- (NSArray *)parseArray:(NSArray *)array forParentObject:(id)parentObject;

- (NSDictionary *)serializeObject:(id)object;
- (NSArray *)serializeObjectArray:(NSArray *)objectArray;

- (void)updateObject:(id)object withDictionary:(NSDictionary *)dictionary;

@end
