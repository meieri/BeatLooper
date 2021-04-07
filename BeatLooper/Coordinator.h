//
//  Coordinator.h
//  BeatLooper
//
//  Created by Isaak Meier on 4/4/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HomeViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Coordinator : NSObject
- (instancetype)initWithWindow:(UIWindow*)window;
- (void)start; // kickoff application
- (void)songAdded;

@end

NS_ASSUME_NONNULL_END