//
//  ValueFormatter.h
//  JSONParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCParserConfiguration.h"
#import "DCDynamicAttribute.h"
@protocol DCValueConverter <NSObject>

- (id) transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute;
- (BOOL) canTransformValueForClass: (Class) class;


@end
