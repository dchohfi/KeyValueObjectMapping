//
//  DCCustomParser.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 9/3/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCCustomParser.h"

@implementation DCCustomParser
@synthesize blockParser = _blockParser;
@synthesize attributeName = _attributeName;
@synthesize destinationClass = _destinationClass;
- (id) initWithBlockParser: (DCCustomParserBlock) blockParser
          forAttributeName: (NSString *) attributeName
        onDestinationClass: (Class) classe {
    self = [super init];
    if(self){
        _attributeName = attributeName;
        _destinationClass = classe;
        _blockParser = [blockParser copy];
    }
    return self;
}

- (BOOL) isValidToPerformBlockOnAttributeName: (NSString *) attributeName
                                     forClass: (Class) classe {
    return [_attributeName isEqualToString:attributeName] && classe == _destinationClass;
}

@end
