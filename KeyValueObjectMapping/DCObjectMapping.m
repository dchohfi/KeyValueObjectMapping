//
//  DCObjectMapping.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCObjectMapping.h"

@implementation DCObjectMapping
@synthesize attributeName = _attributeName;
@synthesize keyReference = _keyReference;
@synthesize classReference = _classReference;
@synthesize converter = _converter;

- (id)initWithClass: (Class) classReference {
    self = [super init];
    if (self) {
        _classReference = classReference;
    }
    return self;
}

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass {
    
    return [[self alloc] initWithKeyPath:keyPath 
                             toAttribute:attributeName 
                                 onClass:attributeClass 
                               converter:nil];
}

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass
                       converter:(id <DCValueConverter>)converter {
    return [[self alloc] initWithKeyPath:keyPath 
                             toAttribute:attributeName 
                                 onClass:attributeClass 
                               converter:converter];
}

- (id)initWithKeyPath: (NSString *) keyReference
          toAttribute: (NSString *) attributeName
              onClass: (Class) classReference
            converter: (id <DCValueConverter>) converter {
    
    self = [super init];
    if (self) {
        _attributeName = attributeName;
        _keyReference = keyReference;
        _classReference = classReference;
        _converter = converter;
    }
    return self;
}

- (BOOL) sameKey: (NSString *) key andClassReference: (Class) classReference {
    BOOL sameProperty = [self.keyReference isEqualToString:key];
    if( sameProperty && self.classReference == classReference){
        return YES;
    }
    return NO;
}
@end
