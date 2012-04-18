//
//  DCParserConfiguration.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCObjectMappingForArray.h"

@interface DCParserConfiguration : NSObject

@property(nonatomic, strong) NSString *datePattern;
@property(nonatomic, strong) NSString *splitToken;
@property(nonatomic, readonly) NSMutableArray *objectMappers;

- (void) addArrayMapper: (DCObjectMappingForArray *)mapper;
- (void) addObjectMapping: (DCObjectMapping *) mapper;
- (DCObjectMappingForArray *) arrayMapperForMapper: (DCObjectMapping *) mapper;
@end
