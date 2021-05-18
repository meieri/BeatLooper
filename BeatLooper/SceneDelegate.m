//
//  SceneDelegate.m
//  BeatLooper
//
//  Created by Isaak Meier on 4/2/21.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"

@interface SceneDelegate ()
@property BLPCoordinator *coordinator;

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // Create UIWindow using bounds of screen, give it UIScene as UIWindowScene for "windowScene" property
    CGRect frame = UIScreen.mainScreen.bounds;
    UIWindow *window = [[UIWindow alloc] initWithFrame:frame];
    UIWindowScene *windowScene = (UIWindowScene *)scene; // UIWindowScene inherits from UIScene
    window.windowScene = windowScene;

    // Init Coordinator using instance of window
    _coordinator = [[BLPCoordinator alloc] initWithWindow:window];
    
    // kickoff application
    [_coordinator start];
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


/*
 Called when a user opens a file with this app. May be .mp3 or .wav format
 
 Save into Core Data and refresh app. TODO refactor to model.
 */
-(void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    NSURL *openedFileURL = URLContexts.anyObject.URL;
    NSString *urlStr = openedFileURL.absoluteString;
    NSString *fileTitle = [[urlStr lastPathComponent] stringByDeletingPathExtension];
    
    NSError *error1;
	NSData *data = [[NSData alloc] initWithContentsOfURL:openedFileURL options:0 error:&error1];
	if (!data) {
		NSLog(@"Error: %@", error1);
	}
    
    NSString *libraryRootPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];
//    libraryRootPath = [libraryRootPath stringByAppendingPathComponent:@"Songs"];
    NSString *newFilePath = [libraryRootPath stringByAppendingPathComponent:[urlStr lastPathComponent]];
    NSLog(@"Path i made: %@", newFilePath);
    NSURL *newFileURL = [NSURL fileURLWithPath:newFilePath];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager copyItemAtURL:openedFileURL toURL:newFileURL error:&error];
    if (success) {
        NSLog(@"The file was successfully saved to path %@", newFileURL);
    } else {
        NSLog(@"Error saving file: %@", error);
    }
        
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.container.viewContext;
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Beat" inManagedObjectContext:context];
    NSManagedObject *managedObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    [managedObject setValue:data forKey:@"data"];
    [managedObject setValue:fileTitle forKey:@"title"];
    [managedObject setValue:newFilePath forKey:@"fileUrl"];

    @try {
        [context save:nil];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    
    NSLog(@"%@", managedObject);
    
	[_coordinator songAdded];
}


@end
