//
//  DCParserConfiguration.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCArrayMapping.h"
#import "DCPropertyAggregator.h"
@interface DCParserConfiguration : NSObject

@property(nonatomic, strong) NSString *datePattern;
@property(nonatomic, strong) NSString *splitToken;
@property(nonatomic, readonly) NSMutableArray *objectMappers;
@property(nonatomic, readonly) NSMutableArray *aggregators;

+ (DCParserConfiguration *) configuration;

- (void) addArrayMapper: (DCArrayMapping *)mapper;
- (void) addObjectMapping: (DCObjectMapping *) mapper;
- (void) addAggregator: (DCPropertyAggregator *) aggregator;
- (DCArrayMapping *) arrayMapperForMapper: (DCObjectMapping *) mapper;
@end
