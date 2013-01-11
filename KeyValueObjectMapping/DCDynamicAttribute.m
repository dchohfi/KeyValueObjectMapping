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
@synthesize primitive = _primitive;
@synthesize idType = _idType;
@synthesize validObject = _validObject;
@synthesize objectMapping = _objectMapping;
@synthesize typeName = _typeName;
@synthesize classe = _classe;

- (id)initWithClass: (Class) classs {
    self = [super init];
    if (self) {
        _objectMapping = [[DCObjectMapping alloc] initWithClass:classs];
        _validObject = YES;
    }
    return self;
}
- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe {
    return [self initWithAttributeDescription:description
                                       forKey:key
                                      onClass:classe
                                attributeName:nil];
}
- (id)initWithAttributeDescription: (NSString *) description 
                            forKey: (NSString *) key
                           onClass: (Class) classe
                     attributeName: (NSString *) attibuteName {
    return [self initWithAttributeDescription:description 
                                       forKey:key
                                      onClass:classe
                                attributeName:attibuteName
                                    converter:nil];
}
- (id)initWithAttributeDescription: (NSString *) description
                            forKey: (NSString *) key
                           onClass: (Class) classe
                     attributeName: (NSString *) attibuteName
                         converter: (id <DCValueConverter>)converter {
    
    
    self = [super init];
    if (self) {
        _classe = classe;
        NSArray *splitedDescription = [description componentsSeparatedByString:@","];
        NSString *attributeName = [self findTypeName: [splitedDescription lastObject]];
        
        if (attributeName.length == 0 && attibuteName.length){
            attributeName = attibuteName;
        }
        _typeName = [self findTypeInformation:[splitedDescription objectAtIndex:0]];
        
        Class attributeClass = NSClassFromString(self.typeName);
        _objectMapping = [DCObjectMapping mapKeyPath:key toAttribute:attributeName onClass:attributeClass converter:converter];
    }
    return self;
    
}
- (NSString *) findTypeInformation: (NSString *) typeInformation {
    NSString *attrituteClass = nil;
    
    BOOL isType = [[typeInformation substringToIndex:1] isEqualToString:@"T"];
    BOOL isAnObject = [[typeInformation substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"@"];
    if(isType && !isAnObject){
        _primitive = YES;
        attrituteClass = [typeInformation substringWithRange:NSMakeRange(1, 1)];
    }else if ([typeInformation length] == 2) {
        _idType = YES;
    } else {
        _validObject = YES;
        attrituteClass = [typeInformation substringWithRange:NSMakeRange(3, [typeInformation length] - 4)];
    }
    return attrituteClass;
}
- (NSString *) findTypeName: (NSString *) name {
    return [name substringFromIndex:1];
}

@end
