//
//  DCPropertyFinder.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/17/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCPropertyFinder.h"
#import <objc/runtime.h>

@interface DCPropertyFinder()

@property(nonatomic, strong) DCPropertyNameParser *nameParser;

- (DCDynamicAttribute *) findPropertyForKey: (NSString *)key onClass: (Class)class;

@end

@implementation DCPropertyFinder
@synthesize nameParser;

+ (DCPropertyFinder *) finderWithNameParser: (DCPropertyNameParser *) _nameParser {
    return [[self alloc] initWithNameParser:_nameParser];
}

- (id)initWithNameParser: (DCPropertyNameParser *) _nameParser {
    self = [super init];
    if (self) {
        nameParser = _nameParser;
    }
    return self;
}

- (DCDynamicAttribute *) findPropertyForKey: (NSString *)key onClass: (Class)class{
    objc_property_t property = class_getProperty(class, [key UTF8String]);
    if (property) {
        NSString *attributeDetails = [NSString stringWithUTF8String:property_getAttributes(property)];
        return [[DCDynamicAttribute alloc] initWithAttributeDescription: attributeDetails forKey:key];
    }
    return nil;
}

- (DCDynamicAttribute *) findAttributeForKey: (NSString *) key onClass: (Class) class {
    DCDynamicAttribute *dynamicAttribute = [self findPropertyForKey:key onClass:class];
    if(!dynamicAttribute){
        key = [nameParser splitKeyAndMakeCamelcased:key];
        dynamicAttribute = [self findPropertyForKey:key onClass:class];
    }
    return dynamicAttribute;
}
@end
