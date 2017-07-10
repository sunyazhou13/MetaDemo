//
//  ViewController.m
//  MetaDemo
//
//  Created by sunyazhou on 2017/6/18.
//  Copyright © 2017年 Baidu, Inc. All rights reserved.
//

#import "ViewController.h"
#import "MetaDataViewController.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *urls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urls  = [[NSMutableArray alloc] init];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"urlsnormal"];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self loadData];
}

- (void)loadData {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * mediasPath = [resourcePath stringByAppendingPathComponent:@"Media"];
    
    
    NSError *error = nil;
    NSArray *items = [fileManager contentsOfDirectoryAtURL:[NSURL URLWithString:mediasPath] includingPropertiesForKeys:@[NSURLNameKey, NSURLEffectiveIconKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
//    NSArray *items = [fileManager contentsOfDirectoryAtPath:mediasPath error:&error];
    [items enumerateObjectsUsingBlock:^(NSURL *url, NSUInteger idx, BOOL *stop) {
        [self.urls addObject:url];
    }];
    
    if (error) {
        NSLog(@"err:%@, %@",error,self.urls);
        
    }
    [self.tableview reloadData];
}


#pragma mark -
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.urls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"urlsnormal";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.urls[indexPath.row] lastPathComponent];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSURL *url = [self.urls objectAtIndex:indexPath.row];
    NSLog(@"%@",url);
    
    MetaDataViewController *metaVC = [[MetaDataViewController alloc] initWithNibName:NSStringFromClass([MetaDataViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController showViewController:metaVC sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
