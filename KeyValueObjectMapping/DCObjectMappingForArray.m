//
//  DCObjectMappingForArray.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCObjectMappingForArray.h"

@implementation DCObjectMappingForArray
@synthesize objectMapping, classForElementsOnArray;

- (id)initWithClassForElements: (Class) _classForElementsOnArray forKeyAndAttributeName: (NSString *) keyForAttribute inClass: (Class) classReference
{
    return [self initWithObjectMapping:[[DCObjectMapping alloc] initWithKeyForAttribute:keyForAttribute onClass:classReference] forArrayElementOfType:_classForElementsOnArray];
}
- (id)initWithObjectMapping: (DCObjectMapping *) _objectMapping forArrayElementOfType: (Class) _classForElementsOnArray {
    self = [super init];
    if (self) {
        objectMapping = _objectMapping;
        classForElementsOnArray = _classForElementsOnArray;
    }
    return self;
}

@end
