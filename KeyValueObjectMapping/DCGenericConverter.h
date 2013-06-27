//
//  DCGenericConverter.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDynamicAttribute.h"
#import "DCParserConfiguration.h"

@interface DCGenericConverter : NSObject
- (id)initWithConfiguration:(DCParserConfiguration *) configuration;

- (id)transformValue:(id)value forDynamicAttribute:(DCDynamicAttribute *)attribute dictionary:(NSDictionary *)dictionary parentObject:(id)parentObject;
- (id)serializeValue:(id)value forDynamicAttribute: (DCDynamicAttribute *) attribute;
@end
