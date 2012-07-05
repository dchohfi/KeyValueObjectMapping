//
//  DCArrayMapping.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/16/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCObjectMapping.h"
@interface DCArrayMapping : NSObject

@property(nonatomic, readonly) DCObjectMapping *objectMapping;
@property(nonatomic, readonly) Class classForElementsOnArray;


+ (DCArrayMapping *) mapperForClassElements: (Class) classForElementsOnArray 
                               forAttribute: (NSString *) attribute 
                                    onClass: (Class) classReference;

+ (DCArrayMapping *) mapperForClass: (Class) classForElementsOnArray 
                          onMapping: (DCObjectMapping *) objectMapping;

@end
