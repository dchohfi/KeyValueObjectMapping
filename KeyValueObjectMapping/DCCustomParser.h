//
//  DCCustomParser.h
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 9/3/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id(^DCCustomParserBlock)(__weak NSDictionary *dictionary, __weak NSString *attributeName, __weak Class destinationClass, __weak id value);

@interface DCCustomParser : NSObject

@property(nonatomic, readonly) NSString *attributeName;
@property(nonatomic, readonly) Class destinationClass;
@property(nonatomic, readonly) DCCustomParserBlock blockParser;

- (id) initWithBlockParser: (DCCustomParserBlock) blockParser
          forAttributeName: (NSString *) attributeName
        onDestinationClass: (Class) classe;

- (BOOL) isValidToPerformBlockOnAttributeName: (NSString *) attributeName
                                     forClass: (Class) classe;
@end
