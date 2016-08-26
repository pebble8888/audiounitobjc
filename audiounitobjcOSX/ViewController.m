//
//  ViewController.m
//  audiounitobjcOSX
//
//  Created by pebble8888 on 2016/08/27.
//  Copyright © 2016年 pebble8888. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myAudioPlayer = [[MyAudioPlayer alloc] init];
    [myAudioPlayer play];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
