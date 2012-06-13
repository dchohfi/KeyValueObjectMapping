//
//  DCObjectMapping.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCValueConverter.h"

@interface DCObjectMapping : NSObject

@property(nonatomic, readonly) NSString *keyReference;
@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly) Class classReference;
@property(nonatomic, readonly) id <DCValueConverter> converter;

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass;

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath 
                     toAttribute: (NSString *) attributeName 
                         onClass: (Class) attributeClass
                       converter:(id <DCValueConverter>)converter;

- (id)initWithClass: (Class) classReference;
- (BOOL) sameKey: (NSString *) key andClassReference: (Class) classReference;

@end
