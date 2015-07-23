//
//  DCParserConfiguration.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCMapping.h"

@class DCArrayMapping, DCPropertyAggregator, DCObjectMapping, DCCustomInitialize, DCCustomParser;
@interface DCParserConfiguration : NSObject

@property(nonatomic, strong) NSString *datePattern;
@property(nonatomic, strong) NSString *splitToken;
@property(nonatomic, strong) NSString *nestedPrepertiesSplitToken;
@property(nonatomic, readonly) NSMutableArray *objectMappers;
@property(nonatomic, readonly) NSMutableArray *aggregators;
@property(nonatomic, readonly) NSMutableArray *customInitializers;
@property(nonatomic, readonly) NSMutableArray *customParsers;

+ (DCParserConfiguration *) configuration;

- (void)addMapper: (id<DCMapping>)mapper;
- (void) addArrayMapper: (DCArrayMapping *)mapper;
- (void) addObjectMapping: (DCObjectMapping *) mapper;
- (void) addObjectMappings: (NSArray *)mappers;
- (void) addAggregator: (DCPropertyAggregator *) aggregator;
- (void) addCustomInitializersObject:(DCCustomInitialize *) customInitialize;
- (void) addCustomParsersObject:(DCCustomParser *)parser;

- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withValues:(NSDictionary *)values;
- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withValues:(NSDictionary *)values parentObject:(id)parentObject;
- (DCArrayMapping *) arrayMapperForMapper: (DCObjectMapping *) mapper;
@end
