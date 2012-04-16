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

- (id)initWithObjectMapping: (DCObjectMapping *) _objectMapping forArrayElementOfType: (Class) classForElementsOnArray;

@end
