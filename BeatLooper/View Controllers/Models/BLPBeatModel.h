//
//  BeatModel.h
//  BeatLooper
//
//  Created by Isaak Meier on 4/7/21.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Beat+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLPBeatModel : NSObject

- (NSArray *)getAllSongs;
- (NSURL *)getURLForCachedSong:(NSManagedObjectID *)songID;
- (Beat *)getSongForUniqueID:(NSManagedObjectID *)songID;
- (BOOL)saveSongFromURL:(NSURL *)songURL;
- (void)deleteSong:(NSManagedObject *)song;
- (void)deleteAllEntities;

@end

NS_ASSUME_NONNULL_END