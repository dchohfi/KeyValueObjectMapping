//
//  DCReferenceKeyParser.h
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCReferenceKeyParser : NSObject

@property(nonatomic, readonly) NSString *splitToken;

+ (DCReferenceKeyParser *) parserForToken: (NSString *) splitToken;
- (NSString *) splitKeyAndMakeCamelcased: (NSString *) key;

@end
