//
//  DynamicAttribute.h
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicAttribute : NSObject

@property(nonatomic, readonly) NSString *attributeType;
@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly, getter = isPrimitive) BOOL primitive;
@property(nonatomic, readonly, getter = isIdType) BOOL idType;
@property(nonatomic, readonly, getter = isValidObject) BOOL validObject;

- (id)initWithClass: (Class) class;
- (id)initWithAttributeDescription: (NSString *) description;
- (Class) attributeClass;
@end
