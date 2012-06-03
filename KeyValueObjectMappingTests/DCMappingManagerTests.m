//
// Created by Sergey Klimov on 5/31/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import "DCMappingManagerTests.h"
#import "DCManagedObjectMapping.h"
#import "DCMapperManager.h"
#import "Artist.h"
#import "Song.h"
#import "Album.h"


@implementation DCMappingManagerTests {
    DCMapperManager *mapperManager;
}

- (void)setUp
{
    [super setUp];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle bundleForClass: [self class]]
                                                                            pathForResource:@"configurationPlist"
                                                                                     ofType:@"plist"]];
    mapperManager = [[DCMapperManager alloc] initWithConfiguration:dict
                                           andManagedObjectContext:ctx];
}

- (DCManagedObjectMapping *)createArtistMapping
{
    DCManagedObjectMapping * mapping = [mapperManager managedMapperForClass:[Artist class]];
    STAssertNotNil(mapping, nil);
    return mapping;
}

- (DCManagedObjectMapping *)createSongMapping
{
    DCManagedObjectMapping * mapping =  [mapperManager managedMapperForClass:[Song class]];
    STAssertNotNil(mapping, nil);
    return mapping;

}

- (DCManagedObjectMapping *)createAlbumMapping
{
    DCManagedObjectMapping * mapping =  [mapperManager managedMapperForClass:[Album class]];
    STAssertNotNil(mapping, nil);
    return mapping;

}

@end