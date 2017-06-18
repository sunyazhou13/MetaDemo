//
//  MetaDataViewController.m
//  MetaDemo
//
//  Created by sunyazhou on 2017/6/18.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "MetaDataViewController.h"

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

@end

@implementation MetaDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
