//
//  DCObjectMapping.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCObjectMapping : NSObject

@property(nonatomic, readonly) NSString *keyReference;
@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly) Class classReference;

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath toAttribute: (NSString *) attributeName onClass: (Class) attributeClass;

- (id)initWithClass: (Class) classReference;
- (BOOL) sameKey: (NSString *) key andClassReference: (Class) classReference;

@end
