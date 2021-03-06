//
//  ViewController.m
//  BeatLooper
//
//  Created by Isaak Meier on 4/2/21.
//

#import "HomeViewController.h"

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *songTableView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) NSMutableArray *songs;
@property (weak, nonatomic) IBOutlet UIImageView *rainbowMusicBanner;
@property BOOL isAddSongsMode;

@end

@implementation HomeViewController

- (id)initWithCoordinator:(BLPCoordinator *)coordinator inAddSongsMode:(BOOL)isAddSongsMode {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ((self = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"])) {
        _coordinator = coordinator;
        _model = [[BLPBeatModel alloc] init];
        _isAddSongsMode = isAddSongsMode;
    }
    return self;
}

- (void)refreshSongsAndReloadData:(BOOL)shouldReloadData {
    NSArray *brandNewSongs = [[self model] getAllSongs];
    [self setSongs:[NSMutableArray arrayWithArray:brandNewSongs]];
    if (shouldReloadData) {
        [[self songTableView] reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self songTableView].dataSource = self;
    [self songTableView].delegate = self;
    [[self songTableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SongCell"];

    if (self.isAddSongsMode) {
        [self.editButton setHidden:YES];
        [self.rainbowMusicBanner setHidden:YES];
    }
    [self refreshSongsAndReloadData:YES];
}

- (IBAction)editButtonTapped:(id)sender {
    if (self.songTableView.isEditing) {
        [self.songTableView setEditing:NO];
        [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    } else {
        [self.songTableView setEditing:YES];
        [self.editButton setTitle:@"Done" forState:UIControlStateNormal];
    }
}

// MARK: UITableView Datasource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.songTableView dequeueReusableCellWithIdentifier:@"SongCell"];
    Beat *beat = self.songs[indexPath.row];
    cell.textLabel.text = beat.title;
    return cell;
    
}


// MARK: UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isAddSongsMode) {
        [self.coordinator addSongToQueue:self.songs[indexPath.row]];
        return;
    }
    // this range encompasses the song we just selected and every song after it.
    NSRange queueRange = NSMakeRange(indexPath.row, self.songs.count - indexPath.row);
    NSIndexSet *indexes = [[NSIndexSet alloc] initWithIndexesInRange:queueRange];
    NSArray *songsForQueue = [NSArray arrayWithArray:[self.songs objectsAtIndexes:indexes]];
    [[self coordinator] openPlayerWithSongs:songsForQueue];
    [self.songTableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Beat *selectedBeat = self.songs[indexPath.row];
        [self.model deleteSong:selectedBeat];
        [self refreshSongsAndReloadData:NO];
        NSArray *indexPaths = @[indexPath];
        [self.songTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.row != destinationIndexPath.row) {
        Beat *beatToMove = self.songs[sourceIndexPath.row];
        [self.songs removeObjectAtIndex:sourceIndexPath.row];
        [self.songs insertObject:beatToMove atIndex:destinationIndexPath.row];
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.songs count];
}


@end
