//
//  DCObjectMappingForArray.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCObjectMapping.h"
@interface DCObjectMappingForArray : NSObject

@property(nonatomic, readonly) DCObjectMapping *objectMapping;
@property(nonatomic, readonly) Class classForElementsOnArray;


- (id)initWithClassForElements: (Class) classForElementsOnArray withKeyAndAttributeName: (NSString *) keyForAttribute forClass: (Class) classReference;
- (id)initWithObjectMapping: (DCObjectMapping *) objectMapping forArrayElementOfType: (Class) classForElementsOnArray;

@end
