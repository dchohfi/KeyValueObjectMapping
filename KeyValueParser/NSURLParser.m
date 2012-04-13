//
//  NSURLParser.m
//  KeyValueParser
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "NSURLParser.h"

@interface NSURLParser()
@property(nonatomic, strong) ParserConfiguration *configuration;
@end

@implementation NSURLParser
@synthesize configuration;

- (id) initWithConfiguration: (ParserConfiguration *) _configuration {
    self = [super init];
    if (self) {
        configuration = _configuration;
    }
    return self;
}
- (id) transformValue: (id) value {
    return [NSURL URLWithString:value];
}
- (BOOL) canTransformValueForClass: (Class) class {
    return [class isSubclassOfClass:[NSURL class]];
}
@end
