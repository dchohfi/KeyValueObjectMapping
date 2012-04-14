//
//  GenericParser.h
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DynamicAttribute.h"
#import "ValueParser.h"
@interface GenericParser : NSObject

- (id)initWithConfiguration:(ParserConfiguration *) configuration;
- (id)transformValue:(id)value forDynamicAttribute: (DynamicAttribute *) attribute;
@end
