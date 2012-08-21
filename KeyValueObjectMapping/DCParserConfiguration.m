//
//  DCParserConfiguration.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCParserConfiguration.h"
#import "DCArrayMapping.h"
#import "DCPropertyAggregator.h"
#import "DCCustomInitialize.h"

@interface DCParserConfiguration()

@property(nonatomic, strong) NSMutableArray *arrayMappers;

@end

@implementation DCParserConfiguration
@synthesize datePattern = _datePattern;
@synthesize splitToken = _splitToken;
@synthesize arrayMappers = _arrayMappers;
@synthesize objectMappers = _objectMappers;
@synthesize aggregators = _aggregators;
@synthesize customInitializers = _customInitializers;

+ (DCParserConfiguration *) configuration {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        _arrayMappers = [[NSMutableArray alloc] init];
        _objectMappers = [[NSMutableArray alloc] init];
        _aggregators = [[NSMutableArray alloc] init];
        _customInitializers = [[NSMutableArray alloc] init];
        _splitToken = @"_";
        _datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    }
    return self;
}

- (void)addArrayMapper: (DCArrayMapping *)mapper {
    [self.arrayMappers addObject:mapper];
    [self.objectMappers addObject:mapper.objectMapping];
}
- (void) addObjectMapping: (DCObjectMapping *) mapper {
    [self.objectMappers addObject:mapper];
}
- (void) addAggregator: (DCPropertyAggregator *) aggregator {
    [self.aggregators addObject:aggregator];
}
- (void) addCustomInitializer: (DCCustomInitialize *) customInitialize {
    [self.customInitializers addObject:customInitialize];
}
- (id) instantiateObjectForClass: (Class) classOfObjectToGenerate withValues: (NSDictionary *) values {
    for(DCCustomInitialize *customInitialize in self.customInitializers){
        if([customInitialize validToPerformBlock:classOfObjectToGenerate]){
            return customInitialize.blockInitialize(classOfObjectToGenerate, values);
        }
    }
    return [[classOfObjectToGenerate alloc] init];
}
- (DCArrayMapping *) arrayMapperForMapper: (DCObjectMapping *) mapper {
    for(DCArrayMapping *arrayMapper in self.arrayMappers){
        BOOL sameKey = [arrayMapper.objectMapping.keyReference isEqualToString:mapper.keyReference];
        BOOL sameAttributeName = [arrayMapper.objectMapping.attributeName isEqualToString:mapper.attributeName];
        if(sameKey && sameAttributeName){
            return arrayMapper;
        }
    }
    return nil;
}
@end
