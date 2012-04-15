//
//  GenericParser.h
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCDynamicAttribute.h"
#import "DCValueParser.h"
@interface DCGenericParser : NSObject

- (id)initWithConfiguration:(DCParserConfiguration *) configuration;
- (id)transformValue:(id)value forDynamicAttribute: (DCDynamicAttribute *) attribute;
@end
