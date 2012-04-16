//
//  ParserConfiguration.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCParserConfiguration.h"

@interface DCParserConfiguration()

@property(nonatomic, strong) NSMutableArray *arrayMappers;

@end

@implementation DCParserConfiguration
@synthesize datePattern, splitToken, arrayMappers;

- (id)init
{
    self = [super init];
    if (self) {
        self.arrayMappers = [[NSMutableArray alloc] init];
        self.splitToken = @"_";
        self.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    }
    return self;
}

- (void)addMapper: (DCObjectMappingForArray *)mapper{
    [arrayMappers addObject:mapper];
}

- (DCObjectMappingForArray *) arrayMapperForMapper: (DCObjectMapping *) mapper{
    for(DCObjectMappingForArray *arrayMapper in arrayMappers){
        BOOL sameKey = [arrayMapper.objectMapping.key isEqualToString:mapper.key];
        BOOL sameAttributeName = [arrayMapper.objectMapping.attributeName isEqualToString:mapper.attributeName];
        if(sameKey && sameAttributeName){
            return arrayMapper;
        }
    }
    return nil;
}

@end
