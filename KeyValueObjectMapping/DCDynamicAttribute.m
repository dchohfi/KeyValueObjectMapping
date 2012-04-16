//
//  DynamicAttribute.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCDynamicAttribute.h"

@interface DCDynamicAttribute()

- (void) findTypeInformation: (NSString *) typeInformation;
- (void) findTypeName: (NSString *) name;
@end

@implementation DCDynamicAttribute
@synthesize attributeType, primitive, idType, attributeName, validObject;


- (id)initWithClass: (Class) class {
    self = [super init];
    if (self) {
        attributeType = NSStringFromClass(class);
        validObject = YES;
    }
    return self;
}
- (id)initWithAttributeDescription: (NSString *) description{
    self = [super init];
    if (self) {
        NSArray *splitedDescription = [description componentsSeparatedByString:@","];
        [self findTypeInformation:[splitedDescription objectAtIndex:0]];
        [self findTypeName: [splitedDescription lastObject]];    
    }
    return self;
}

- (void) findTypeName: (NSString *) name {
    attributeName = [name substringFromIndex:1];
}

- (void) findTypeInformation: (NSString *) typeInformation {
    BOOL isType = [[typeInformation substringToIndex:1] isEqualToString:@"T"];
    BOOL isAnObject = [[typeInformation substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"@"];
    if(isType && !isAnObject){
        attributeType = [typeInformation substringWithRange:NSMakeRange(1, 1)];
        primitive = YES;        
    }else if ([typeInformation length] == 2) {
        idType = YES;
    } else {
        attributeType = [typeInformation substringWithRange:NSMakeRange(3, [typeInformation length] - 4)];
        validObject = YES;
    }
}

- (Class) attributeClass{
    if([self isPrimitive] || [self isIdType]){
        return nil;
    }
    return NSClassFromString(attributeType);
}

@end
