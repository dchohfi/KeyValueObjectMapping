//
//  DCObjectMapping.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCObjectMapping.h"

@implementation DCObjectMapping {
}

@synthesize attributeName, keyReference, classReference, parser;


- (id)initWithClass: (Class) _classReference
{
    return [self initWithClass:_classReference parser:nil];
}

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath toAttribute: (NSString *) attributeName onClass: (Class) attributeClass{
    return [[self alloc] initWithKeyPath:keyPath toAttribute:attributeName onClass:attributeClass];
}

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath toAttribute: (NSString *) attributeName onClass: (Class)
        attributeClass parser:(DCKeyValueObjectMapping *) parser{
    return [[self alloc] initWithKeyPath:keyPath toAttribute:attributeName onClass:attributeClass parser: parser];
}

- (id)initWithKeyPath: (NSString *) _keyReference toAttribute: (NSString *) _attributeName onClass: (Class)
        _classReference {
    return [self initWithKeyPath:_keyReference toAttribute:_attributeName onClass:_classReference parser: nil];
}

- (id)initWithKeyPath: (NSString *) _keyReference toAttribute: (NSString *) _attributeName onClass: (Class)
        _classReference parser:(DCKeyValueObjectMapping *) _parser {
    self = [super init];
    if (self) {
        attributeName = _attributeName;
        keyReference = _keyReference;
        classReference = _classReference;
        parser = _parser;
    }
    return self;
}

- (id)initWithClass:(Class)_classReference parser:(DCKeyValueObjectMapping *)_parser
{
    self = [super init];
    if (self) {
        classReference = _classReference;
        parser = _parser;
    }
    return self;
}

- (BOOL) sameKey: (NSString *) key andClassReference: (Class) _classReference {
    if([self.keyReference isEqualToString:key] && self.classReference == _classReference){
        return YES;
    }
    return NO;
}

@end
