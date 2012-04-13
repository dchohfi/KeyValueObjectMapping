//
//  KeyValueParser.h
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserConfiguration.h"

@interface KeyValueParser : NSObject

- (id) initWithConfiguration: (ParserConfiguration *) configuration;
- (id) parseJson: (NSDictionary *) json forClass: (Class) class;

@end
