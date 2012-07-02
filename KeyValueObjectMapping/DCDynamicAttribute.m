//
//  DCDynamicAttribute.m
//  DCKeyValueObjectMapping
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCDynamicAttribute.h"

@interface DCDynamicAttribute()

- (NSString *) findTypeInformation: (NSString *) typeInformation;
- (NSString *) findTypeName: (NSString *) name;
@end

@implementation DCDynamicAttribute
@synthesize primitive, idType, validObject, objectMapping, typeName;


- (id)initWithClass: (Class) classs {
    self = [super init];
    if (self) {
        objectMapping = [[DCObjectMapping alloc] initWithClass:classs];
        validObject = YES;
    }
    return self;
}
- (id)initWithAttributeDescription: (NSString *) description 
                            forKey: (NSString *) _key{
    return [self initWithAttributeDescription:description 
                                       forKey:_key 
                                attributeName:nil];
}
- (id)initWithAttributeDescription: (NSString *) description 
                            forKey: (NSString *) _key
                     attributeName: (NSString *) _attibuteName {
    return [self initWithAttributeDescription:description 
                                       forKey:_key 
                                attributeName:_attibuteName 
                                    converter:nil];
}
- (id)initWithAttributeDescription:(NSString *)description 
                            forKey:(NSString *)_key 
                     attributeName:(NSString *)_attibuteName 
                         converter:(id <DCValueConverter>)converter {
    
    
    self = [super init];
    if (self) {
        NSArray *splitedDescription = [description componentsSeparatedByString:@","];
        NSString *attributeName;
        
        if (_attibuteName == nil){
            attributeName = [self findTypeName: [splitedDescription lastObject]];
        }else{
            attributeName = _attibuteName;
        }
        typeName = [self findTypeInformation:[splitedDescription objectAtIndex:0]];
        
        Class attributeClass = NSClassFromString(typeName);
        objectMapping = [DCObjectMapping mapKeyPath:_key toAttribute:attributeName onClass:attributeClass converter:converter];
    }
    return self;
    
}
- (NSString *) findTypeInformation: (NSString *) typeInformation {
    NSString *attrituteClass = nil;
    
    BOOL isType = [[typeInformation substringToIndex:1] isEqualToString:@"T"];
    BOOL isAnObject = [[typeInformation substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"@"];
    if(isType && !isAnObject){
        primitive = YES;
        attrituteClass = [typeInformation substringWithRange:NSMakeRange(1, 1)];
    }else if ([typeInformation length] == 2) {
        idType = YES;
    } else {
        validObject = YES;
        attrituteClass = [typeInformation substringWithRange:NSMakeRange(3, [typeInformation length] - 4)];
    }
    return attrituteClass;
}
- (NSString *) findTypeName: (NSString *) name {
    return [name substringFromIndex:1];
}

@end
