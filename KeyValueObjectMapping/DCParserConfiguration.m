//
//  DCParserConfiguration.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCParserConfiguration.h"

@interface DCParserConfiguration()

@property(nonatomic, strong) NSMutableArray *arrayMappers;

@end

@implementation DCParserConfiguration
@synthesize datePattern, splitToken, arrayMappers, objectMappers;

- (id)init
{
    self = [super init];
    if (self) {
        arrayMappers = [[NSMutableArray alloc] init];
        objectMappers = [[NSMutableArray alloc] init];
        splitToken = @"_";
        datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    }
    return self;
}

- (void)addArrayMapper: (DCArrayMapping *)mapper{
    [arrayMappers addObject:mapper];
}
- (void) addObjectMapping: (DCObjectMapping *) mapper {
    [objectMappers addObject:mapper];
}
- (DCArrayMapping *) arrayMapperForMapper: (DCObjectMapping *) mapper{
    for(DCArrayMapping *arrayMapper in arrayMappers){
        BOOL sameKey = [arrayMapper.objectMapping.keyReference isEqualToString:mapper.keyReference];
        BOOL sameAttributeName = [arrayMapper.objectMapping.attributeName isEqualToString:mapper.attributeName];
        if(sameKey && sameAttributeName){
            return arrayMapper;
        }
    }
    return nil;
}

@end
