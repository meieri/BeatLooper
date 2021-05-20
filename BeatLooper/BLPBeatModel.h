//
//  BeatModel.h
//  BeatLooper
//
//  Created by Isaak Meier on 4/7/21.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLPBeatModel : NSObject

- (NSArray *)getAllSongs;
- (NSURL *)getURLForCachedSong:(NSManagedObjectID *)songID;
- (BOOL)saveSongFromURL:(NSURL *)songURL;
- (void)deleteAllEntities;

@end

NS_ASSUME_NONNULL_END
