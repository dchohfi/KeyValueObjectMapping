//
//  DCObjectMapping.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCKeyValueObjectMapping;

@interface DCObjectMapping : NSObject

@property(nonatomic, readonly) NSString *keyReference;
@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly) Class classReference;
@property (nonatomic, strong) DCKeyValueObjectMapping* parser;

+ (DCObjectMapping *) mapKeyPath: (NSString *) keyPath toAttribute: (NSString *) attributeName onClass: (Class) attributeClass;

+ (DCObjectMapping *)mapKeyPath:(NSString *)keyPath toAttribute:(NSString *)attributeName onClass:(Class)attributeClass parser:(DCKeyValueObjectMapping *)parser;


- (id)initWithClass: (Class) classReference;

- (id)initWithKeyPath:(NSString *)_keyReference toAttribute:(NSString *)_attributeName onClass:(Class)_classReference parser:(DCKeyValueObjectMapping *)_parser;

- (id)initWithClass:(Class)class parser:(DCKeyValueObjectMapping *)parser;

- (BOOL) sameKey: (NSString *) key andClassReference: (Class) classReference;

@end
