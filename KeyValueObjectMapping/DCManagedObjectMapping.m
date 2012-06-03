//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCManagedObjectMapping.h"
#import "DCDynamicAttribute.h"


@implementation DCManagedObjectMapping {
    NSManagedObjectContext *context;

}
+ (DCManagedObjectMapping *)mapperForClass:(Class)classToGenerate andConfiguration:(DCParserConfiguration *)
        configuration
        andManagedObjectContext:(NSManagedObjectContext *)context
{
    return [[self alloc] initWithClass:classToGenerate forConfiguration:configuration
               andManagedObjectContext:context];
}


- (id) initWithClass: (Class) _classToGenerate forConfiguration: (DCParserConfiguration *) _configuration
        andManagedObjectContext: (NSManagedObjectContext *)_context {
    if (self=[self initWithClass:_classToGenerate forConfiguration:_configuration]) {
         context=_context;
    }
    return self;
}

- (id)createObjectWithPrimaryKeyValue:(id)primaryKeyValue
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self.classToGenerate)
                                              inManagedObjectContext:context];
    NSManagedObject * object = [[self.classToGenerate alloc] initWithEntity:entity
                     insertIntoManagedObjectContext:context] ;
    [object setValue:primaryKeyValue forKey:self.primaryKeyAttribute.objectMapping.attributeName];
    return object;
}


- (id)findObjectByPrimaryKeyValue:(id)primaryKeyValue
{
    DCDynamicAttribute * primaryKeyAttribute = [self primaryKeyAttribute];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", primaryKeyAttribute.objectMapping
                                                                                   .attributeName, primaryKeyValue];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(self.classToGenerate)];
    request.predicate = predicate;

    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    assert(objects.count<=1);
    return [objects lastObject];


}

@end