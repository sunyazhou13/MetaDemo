//
//  MetaDataViewController.m
//  MetaDemo
//
//  Created by sunyazhou on 2017/6/18.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "MetaDataViewController.h"
#import "MetadataKit.h"


@interface MetaDataViewController ()<UITextFieldDelegate>
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
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageview;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;
@property (nonatomic, strong) MediaItem *mediaItem;


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
    
    self.rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = self.rightButtonItem;
}

- (void)refreshDataByItem:(MediaItem *)item{
    self.nameTextField.text = item.metadata.name;
    self.artistTextField.text = item.metadata.artist;
    self.albumArtistTextField.text = item.metadata.albumArtist;
    self.albumTextField.text = item.metadata.album;
    self.groupingTextField.text = item.metadata.grouping;
    self.commentsTextField.text = item.metadata.comments;
    self.yearTextField.text = item.metadata.year;
    if ([item.metadata.bpm isKindOfClass:[NSNumber class]]) {
        self.bpmTextField.text = [item.metadata.bpm stringValue];
    } else if ([item.metadata.bpm isKindOfClass:[NSString class]]) {
        self.bpmTextField.text = [NSString stringWithString:item.metadata.bpm];
    }
    self.trunkNumberTextField.text = [item.metadata.trackNumber stringValue];
    self.discNumberTextField.text = [item.metadata.discNumber stringValue];
    self.artworkImageview.image = item.metadata.artwork;
    self.genreLabel.text = item.metadata.genre.name;
    self.rightButtonItem.enabled = item.isEditable;
    
    self.mediaItem = item;
}

- (void)rightButtonAction:(UIBarButtonItem *)right{
    if (self.mediaItem) {
        self.mediaItem.metadata.name = self.nameTextField.text;
        self.mediaItem.metadata.artist = self.artistTextField.text;
        self.mediaItem.metadata.albumArtist = self.artistTextField.text;
        self.mediaItem.metadata.album = self.albumTextField.text;
        self.mediaItem.metadata.grouping = self.groupingTextField.text;
        self.mediaItem.metadata.comments = self.commentsTextField.text;
        self.mediaItem.metadata.year = self.yearTextField.text;
        self.mediaItem.metadata.bpm = self.bpmTextField.text;
        self.mediaItem.metadata.trackNumber = [NSNumber numberWithString:self.trunkNumberTextField.text];
        self.mediaItem.metadata.discNumber = [NSNumber numberWithString:self.discNumberTextField.text];
        [self.mediaItem saveWithCompletionHandler:^(BOOL complete) {
            if (complete) {
                NSLog(@"保存成功!😀");
                if ([self.delegate respondsToSelector:@selector(needReload)]) {
                    [self.delegate needReload];
                }
            } else {
                NSLog(@"保存失败!");
            }
            
        }];
    }
}

#pragma mark -
#pragma mark - UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
