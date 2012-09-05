//
//  DCDynamicAttribute.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCObjectMapping.h"
#import "DCValueConverter.h"
@interface DCDynamicAttribute : NSObject

@property(nonatomic, readonly) DCObjectMapping *objectMapping;
@property(nonatomic, readonly) NSString *typeName;
@property(nonatomic, readonly) Class classe;
@property(nonatomic, readonly, getter = isPrimitive) BOOL primitive;
@property(nonatomic, readonly, getter = isIdType) BOOL idType;
@property(nonatomic, readonly, getter = isValidObject) BOOL validObject;

- (id)initWithClass: (Class) classs;
- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe;

- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe
                     attributeName: (NSString *) attibuteName;

- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe
                     attributeName: (NSString *) attibuteName 
                         converter:(id<DCValueConverter>) converter;
@end
