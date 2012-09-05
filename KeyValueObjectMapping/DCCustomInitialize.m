//
//  DCCustomInitialize.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 8/21/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCCustomInitialize.h"

@implementation DCCustomInitialize
@synthesize blockInitialize = _blockInitialize;
@synthesize classOfObjectToGenerate = _classOfObjectToGenerate;
- (id) initWithBlockInitialize: (DCCustomInitializeBlock) blockInitialize
                      forClass: (Class) classOfObjectToGenerate {
    self = [super init];
    if (self) {
        _blockInitialize = [blockInitialize copy];
        _classOfObjectToGenerate = classOfObjectToGenerate;
    }
    return self;
}

- (BOOL) isValidToPerformBlock: (Class) classOfObjectToGenerate {
    return _classOfObjectToGenerate == classOfObjectToGenerate;
}
@end
