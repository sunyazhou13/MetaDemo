//
//  MetaDataViewController.m
//  MetaDemo
//
//  Created by sunyazhou on 2017/6/18.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "MetaDataViewController.h"
#import "MetadataKit.h"

@interface MetaDataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) IBOutlet UITextField *albumArtistTextField;
@property (weak, nonatomic) IBOutlet UITextField *albumTextField;
@property (weak, nonatomic) IBOutlet UITextField *groupingTextField;
@property (weak, nonatomic) IBOutlet UITextField *composerTextField;
@property (weak, nonatomic) IBOutlet UITextField *commentsTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *bpmTextField;
@property (weak, nonatomic) IBOutlet UITextField *trunkNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *discNumberTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *genrePickView;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageview;

@end

@implementation MetaDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.url) {
        __weak typeof(self) weakSelf = self;
        MediaItem *item = [[MediaItem alloc] initWithURL:self.url];
        [item prepareWithCompletionHandler:^(BOOL complete) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf refreshDataByItem:item];
            NSLog(@"%@",[item modelDescription]);
        }];
    }
}

- (void)refreshDataByItem:(MediaItem *)item{
    self.nameTextField.text = item.metadata.name;
    self.artistTextField.text = item.metadata.artist;
    self.albumArtistTextField.text = item.metadata.albumArtist;
    self.albumTextField.text = item.metadata.album;
    self.groupingTextField.text = item.metadata.grouping;
    self.commentsTextField.text = item.metadata.comments;
    self.yearTextField.text = item.metadata.year;
    self.bpmTextField.text = [item.metadata.bpm stringValue];
    self.trunkNumberTextField.text = [item.metadata.trackNumber stringValue];
    self.discNumberTextField.text = [item.metadata.discNumber stringValue];
    
    self.artworkImageview.image = item.metadata.artwork;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
