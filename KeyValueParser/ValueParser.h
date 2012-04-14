//
//  ValueFormatter.h
//  JSONParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserConfiguration.h"
#import "DynamicAttribute.h"
@protocol ValueParser <NSObject>

- (id) initWithConfiguration: (ParserConfiguration *) configuration;
- (id)transformValue:(id)values forDynamicAttribute:(DynamicAttribute *)attribute;
- (BOOL) canTransformValueForClass: (Class) class;


@end
