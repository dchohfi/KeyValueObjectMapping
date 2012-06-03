//
// Created by Sergey Klimov on 5/29/12.
// Copyright (c) 2012 Sanders New Media, LLC. All rights reserved.
//


#import <SenTestingKit/SenTestingKit.h>

@class DCManagedObjectMapping;
@class NSManagedObjectContext;


@interface DCManagedObjectsMappingsTests : SenTestCase   {
    NSManagedObjectContext *ctx;

}
- (DCManagedObjectMapping *)createArtistMapping;

- (DCManagedObjectMapping *)createAlbumMapping;


- (DCManagedObjectMapping *)createSongMapping;

- (void)setUp;

- (void)tearDown;


@end