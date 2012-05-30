//
//  DCKeyValueObjectMapping.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCParserConfiguration.h"


#define kDCKeyValueObjectMappingObjectLazyCreateNotification @"kDCKeyValueObjectMappingObjectLazyCreateNotification"

@class DCDynamicAttribute;

@interface DCKeyValueObjectMapping : NSObject

@property(nonatomic, readonly) Class classToGenerate;

+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate;
+ (DCKeyValueObjectMapping *) mapperForClass: (Class) classToGenerate andConfiguration: (DCParserConfiguration *) configuration;

- (id) initWithClass: (Class) _classToGenerate forConfiguration: (DCParserConfiguration *) _configuration;

- (id) createObjectWithPrimaryKeyValue:(id)primaryKeyValue;

- (DCDynamicAttribute *)primaryKeyAttribute;


- (id)findObjectByPrimaryKeyValue:(id)primaryKeyValue;

- (id) parseDictionary: (NSDictionary *) dictionary;
- (NSArray *) parseArray: (NSArray *) array;

@end
