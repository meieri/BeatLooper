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
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVComposition.h>
#import <CoreMedia/CMTimeRange.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLPBeatModel : NSObject

- (NSArray *)getAllSongs;
- (NSURL *)getURLForCachedSong:(NSManagedObjectID *)songID;
- (Beat *)getSongForUniqueID:(NSManagedObjectID *)songID;
- (BOOL)saveSongFromURL:(NSURL *)songURL;
- (void)deleteSong:(NSManagedObject *)song;
- (void)deleteAllEntities;

+ (void)exportClippedAudioFromSongURL:(NSURL *)songUrl
                               withTempo:(int)tempo
                    startingAtTimeInBars:(int)startBar
                           endingAtTimeInBars:(int)endBar
                          withCompletion:(void (^)(BOOL, NSURL *))exportedFileCompletion;

+ (CMTimeRange)timeRangeFromBars:(int)startBar to:(int)endBar withTempo:(int)tempo;

@end

NS_ASSUME_NONNULL_END
