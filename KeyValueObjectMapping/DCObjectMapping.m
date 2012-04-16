//
//  DCObjectMapping.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCObjectMapping.h"

@implementation DCObjectMapping
@synthesize attributeName, key, classReference;


- (id)initWithClass: (Class) _classReference
{
    self = [super init];
    if (self) {
        classReference = _classReference;
    }
    return self;
}

- (id)initWithKeyForAttribute: (NSString *) _attributeAndKey onClass: (Class) _classReference
{
    return [self initWithAttributeName:_attributeAndKey forKey:_attributeAndKey onClass:_classReference];
}

- (id)initWithAttributeName: (NSString *) _attributeName forKey: (NSString *) _key onClass: (Class) _classReference
{
    self = [super init];
    if (self) {
        attributeName = _attributeName;
        key = _key;
        classReference = _classReference;
    }
    return self;
}

@end
