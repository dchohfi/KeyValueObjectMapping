//
// Created by Sergey Klimov on 5/31/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "NSManagedObject+TestCase.h"



@implementation NSManagedObject(TestCase)
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context
{
    return [self respondsToSelector:@selector(entityInManagedObjectContext:)] ?
            [self performSelector:@selector(entityInManagedObjectContext:) withObject:context] :
            [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
}
+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    return [context executeFetchRequest:request error:nil];
}
@end