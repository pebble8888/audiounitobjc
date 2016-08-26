//
//  ViewController.m
//  audiounitobjc
//
//  Created by pebble8888 on 2016/08/27.
//  Copyright © 2016年 pebble8888. All rights reserved.
//

#import "ViewController.h"
#import "MyAudioPlayer.h"

@interface ViewController ()
{
    MyAudioPlayer* myAudioPlayer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAudioPlayer = [[MyAudioPlayer alloc] init];
    [myAudioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
