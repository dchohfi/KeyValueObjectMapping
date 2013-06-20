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
@synthesize customParsers = _customParsers;

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
        _customParsers = [[NSMutableArray alloc] init];
        _splitToken = @"_";
        _nestedPrepertiesSplitToken = @".";
        _datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    }
    return self;
}

- (void)setSplitToken:(NSString *)splitToken
{
    if (splitToken &&
        ![splitToken isEqualToString:_splitToken] &&
        ![splitToken isEqualToString:_nestedPrepertiesSplitToken]) {
        _splitToken = splitToken;
    }
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
- (void) addCustomInitializersObject:(DCCustomInitialize *) customInitialize {
    [self.customInitializers addObject:customInitialize];
}
- (void) addCustomParsersObject:(DCCustomParser *)parser {
    [self.customParsers addObject:parser];
}

- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withValues:(NSDictionary *)values {
    return [self instantiateObjectForClass:classOfObjectToGenerate withValues:values parentObject:nil];
}

- (id)instantiateObjectForClass:(Class)classOfObjectToGenerate withValues:(NSDictionary *)values parentObject:(id)parentObject {
    for(DCCustomInitialize *customInitialize in self.customInitializers){
        if([customInitialize isValidToPerformBlock:classOfObjectToGenerate]){
            return customInitialize.blockInitialize(classOfObjectToGenerate, values, parentObject);
        }
    }
    return [[classOfObjectToGenerate alloc] init];
}
- (DCArrayMapping *) arrayMapperForMapper: (DCObjectMapping *) mapper {
    for(DCArrayMapping *arrayMapper in self.arrayMappers){
        DCObjectMapping *mapping = arrayMapper.objectMapping;
        BOOL sameKey = [mapping.keyReference isEqualToString:mapper.keyReference];
        BOOL sameAttributeName = [mapping.attributeName isEqualToString:mapper.attributeName];
        BOOL sameAttributeNameWithUnderscore = [[self addUnderScoreToPropertyName:mapping.attributeName] isEqualToString:mapper.attributeName];
        if(sameKey && (sameAttributeName || sameAttributeNameWithUnderscore)){
            return arrayMapper;
        }
    }
    return nil;
}
- (NSString *) addUnderScoreToPropertyName: (NSString *) key{
    if(!key || [key isEqualToString:@""]){
        return @"";
    }
    return [NSString stringWithFormat:@"_%@", key];
}
@end
