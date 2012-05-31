//
// Created by Sergey Klimov on 5/30/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DCValueConverter.h"

@class DCKeyValueObjectMapping;


@interface DCForeignKeyConverter : NSObject <DCValueConverter>
@property (strong, readonly) DCKeyValueObjectMapping* parser;
@property (readonly) BOOL fullSerialization;

- (id)initWithParser:(DCKeyValueObjectMapping *)_parser fullSerialization:(BOOL)_fullSerialization;

@end