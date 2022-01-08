//
//  BLPPlayer.h
//  BeatLooper
//
//  Created by Isaak Meier on 1/4/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Beat+CoreDataClass.h"
#import <CoreMedia/CMTimeRange.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    BLPPlayerSongPlaying,
    BLPPlayerSongPaused,
    BLPPlayerLoopPlaying,
    BLPPlayerLoopPaused,
    BLPPlayerEmpty,
} BLPPlayerState;

@interface BLPPlayer : NSObject <UITableViewDelegate, UITableViewDataSource>

// will return nil if songs array is empty
- (instancetype)initWithSongs:(NSArray *)songs;

// Methods for player, return success
- (BOOL)togglePlayOrPause;
- (BOOL)skipForward;
- (BOOL)skipBackward;
- (BOOL)startLoopingTimeRange:(CMTimeRange)timeRange;
- (BOOL)stopLooping;
// Methods for queue
- (BOOL)changeCurrentSongTo:(Beat *)song;
- (BOOL)addSongToQueue:(Beat *)song;
// removes selected songs from the queue
- (void)removeSelectedSongs;

- (NSProgress *)getProgressForCurrentItem;

@property (readonly) BLPPlayerState playerState;

@end

NS_ASSUME_NONNULL_END