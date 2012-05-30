//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCManagedObjectToManyConverter.h"
#import "DCManagedObjectMapping.h"

@interface DCNSArrayConverter()

@property(nonatomic, strong) DCParserConfiguration *configuration;

@end

@implementation DCManagedObjectToManyConverter {

}
- (id)transformValue:(id)values forDynamicAttribute:(DCDynamicAttribute *)attribute andParentObject:(id)
        parentObject {

//    DCArrayMapping *mapper = [self.configuration arrayMapperForMapper:attribute.objectMapping];
//    if(mapper){
//        NSManagedObject *parentManagedObject = parentObject;
//        id parser = [DCManagedObjectMapping mapperForClass:mapper.classForElementsOnArray
//                                          andConfiguration:[mapper.classForElementsOnArray mappingConfiguration]
//                                   andManagedObjectContext:[parentManagedObject managedObjectContext]];
//        return [parser parseArray:values];
//    }

    return nil;
}


- (BOOL)canTransformValueForClass:(Class) classe {
    return [classe isSubclassOfClass:[NSSet class]];
}
@end