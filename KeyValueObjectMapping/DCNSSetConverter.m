//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCNSSetConverter.h"


@implementation DCNSSetConverter {

}
- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute {

    NSArray *result = [super transformValue:values forDynamicAttribute:attribute];
    return [NSSet setWithArray:result];
}


- (BOOL)canTransformValueForClass:(Class) classe {
    return [classe isSubclassOfClass:[NSSet class]];
}
@end