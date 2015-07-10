//
//  DCPropertyFinder.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/17/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCPropertyFinder.h"
#import <objc/runtime.h>

@interface DCPropertyFinder()

@property(nonatomic, strong) DCReferenceKeyParser *keyParser;

@end

@implementation DCPropertyFinder
@synthesize keyParser = _keyParser;
@synthesize mappers = _mappers;

#pragma mark - public methods

+ (DCPropertyFinder *) finderWithKeyParser: (DCReferenceKeyParser *) _keyParser {
    return [[self alloc] initWithKeyParser:_keyParser];
}

- (DCDynamicAttribute *) findAttributeForKey: (NSString *) key onClass: (Class) cls {
    NSString *originalKey = key;
    
    DCObjectMapping *mapper = [self findMapperForKey:key onClass:cls];
    
    if(mapper){
        key = mapper.attributeName;
    }
    
    NSString *propertyDetails = [self findPropertyDetailsForKey:key onClass:cls];
    if(!propertyDetails){
        key = [self.keyParser splitKeyAndMakeCamelcased:key];
        propertyDetails = [self findPropertyDetailsForKey:key onClass:cls];
    }
    
    if(!propertyDetails)
        return nil;

    DCDynamicAttribute *dynamicAttribute;
    if (mapper && mapper.converter) {
        dynamicAttribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:propertyDetails
                                                                             forKey:originalKey
                                                                            onClass:cls
                                                                      attributeName:key
                                                                          converter:mapper.converter];
    }
    else {
        dynamicAttribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:propertyDetails
                                                                             forKey:originalKey
                                                                            onClass:cls
                                                                      attributeName:key];
    }

    return dynamicAttribute;
}

- (void) setMappers: (NSArray *) mappers{
    _mappers = [NSArray arrayWithArray:mappers];
}

#pragma mark - private methods
- (id)initWithKeyParser: (DCReferenceKeyParser *) keyParser {
    self = [super init];
    if (self) {
        _keyParser = keyParser;
        _mappers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *) findPropertyDetailsForKey: (NSString *)key onClass: (Class)cls{
    objc_property_t property = class_getProperty(cls, [key UTF8String]);
    if (property) {
        NSString *attributeDetails = [NSString stringWithUTF8String:property_getAttributes(property)];
        return attributeDetails;
    }
    return nil;
}

- (DCObjectMapping *) findMapperForKey: (NSString *) key onClass: (Class) cls {
    for(DCObjectMapping *mapper in self.mappers){
        if([mapper sameKey:key andClassReference:cls]){
            return mapper;
        }
    }
    return nil;
}
@end
