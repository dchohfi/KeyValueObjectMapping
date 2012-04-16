//
//  DCObjectMapping.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCObjectMapping : NSObject

@property(nonatomic, readonly) NSString *key;
@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly) Class classReference;

- (id)initWithClass: (Class) classReference;
- (id)initWithKeyForAttribute: (NSString *) _attributeAndKey onClass: (Class) _classReference;
- (id)initWithAttributeName: (NSString *) attributeName forKey: (NSString *) key onClass: (Class) classReference;

@end
