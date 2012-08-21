//
//  DCParserConfiguration.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCArrayMapping, DCPropertyAggregator, DCObjectMapping, DCCustomInitialize;
@interface DCParserConfiguration : NSObject

@property(nonatomic, strong) NSString *datePattern;
@property(nonatomic, strong) NSString *splitToken;
@property(nonatomic, readonly) NSMutableArray *objectMappers;
@property(nonatomic, readonly) NSMutableArray *aggregators;
@property(nonatomic, readonly) NSMutableArray *customInitializers;

+ (DCParserConfiguration *) configuration;

- (void) addArrayMapper: (DCArrayMapping *)mapper;
- (void) addObjectMapping: (DCObjectMapping *) mapper;
- (void) addAggregator: (DCPropertyAggregator *) aggregator;
- (void) addCustomInitializer: (DCCustomInitialize *) customInitialize;
- (id) instantiateObjectForClass: (Class) classOfObjectToGenerate withValues: (NSDictionary *) values;
- (DCArrayMapping *) arrayMapperForMapper: (DCObjectMapping *) mapper;
@end
