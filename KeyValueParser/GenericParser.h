//
//  GenericParser.h
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValueParser.h"
@interface GenericParser : NSObject
- (id)transformValue:(id)value forClass: (Class) class withConfiguration: (ParserConfiguration *)configuration;
@end
