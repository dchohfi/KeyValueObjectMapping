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

+ (DCObjectMappingForArray *) mapperForClassElements: (Class) classForElementsOnArray forAttribute: (NSString *) attribute onClass: (Class) classReference{
    
    DCObjectMapping *objectMapping = [DCObjectMapping mapKeyPath:attribute toAttribute:attribute onClass:classReference];
    
    return  [[self alloc] initWithObjectMapping:objectMapping forArrayElementOfType:classForElementsOnArray];
}

+ (DCObjectMappingForArray *) mapperForClass: (Class) classForElementsOnArray onMapping: (DCObjectMapping *) objectMapping{
    return [[self alloc] initWithObjectMapping:objectMapping forArrayElementOfType:classForElementsOnArray];
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
