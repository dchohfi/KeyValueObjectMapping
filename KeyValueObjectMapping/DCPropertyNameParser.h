//
//  PropertyNameParser.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCParserConfiguration.h"

@interface DCPropertyNameParser : NSObject
- (id)initWithConfiguration: (DCParserConfiguration *) configuration;
- (NSString *) splitKeyAndMakeCamelcased: (NSString *) key;
@end
