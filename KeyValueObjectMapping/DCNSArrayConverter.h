//
//  DCNSArrayConverter.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCValueConverter.h"

@class DCParserConfiguration;
@class DCKeyValueObjectMapping;

@interface DCNSArrayConverter : NSObject <DCValueConverter>


@property (strong, readonly) DCKeyValueObjectMapping* parser;
@property (readonly) BOOL fullSerialization;

- (id)initWithParser:(DCKeyValueObjectMapping *)_parser fullSerialization:(BOOL)_fullSerialization;

+ (DCNSArrayConverter *) arrayConverterForConfiguration: (DCParserConfiguration *)configuration;
@end
