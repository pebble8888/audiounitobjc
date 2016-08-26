//
//  MyAudioPlayer.m
//  audiounitobjc
//
//  Created by pebble8888 on 2016/08/27.
//  Copyright © 2016年 pebble8888. All rights reserved.
//
#include "MyAudioPlayer.h"

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import "ThreadPolicy.h"

static const double _sampleRate = 44100;

@interface MyAudioPlayer ()
{
    AudioUnit _audiounit;
    float _x;
    BOOL _done;
}
- (void)render:(UInt32)inNumberFrames :(AudioBufferList*)ioData;
@end

static OSStatus callback(void * inRefCon, 
                         AudioUnitRenderActionFlags * ioActionFlags, 
                         const AudioTimeStamp * inTimeStamp, 
                         UInt32 inBusNumber, 
                         UInt32 inNumberFrames, 
                         AudioBufferList * ioData)
{
    MyAudioPlayer* myAudioPlayer = (__bridge MyAudioPlayer *)inRefCon;
    [myAudioPlayer render:inNumberFrames :ioData];
    return noErr;
}

@implementation MyAudioPlayer
- (id)init 
{
    self = [super init];
    if (!self) return nil;
    
    _x = 0;
    _done = NO;
#if TARGET_OS_IPHONE
    const int subtype = kAudioUnitSubType_RemoteIO;
#else
    const int subtype = kAudioUnitSubType_HALOutput; 
#endif
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = subtype;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    
    AudioComponent ac = AudioComponentFindNext(nil, &acd);
    AudioComponentInstanceNew(ac, &_audiounit);
    AudioUnitInitialize(_audiounit);
    AVAudioFormat* audioformat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:_sampleRate channels:2];
    AudioStreamBasicDescription asbd = *[audioformat streamDescription];
    AudioUnitSetProperty(_audiounit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &asbd, sizeof(asbd));
    
    return self;
}

- (void)render:(UInt32)inNumberFrames :(AudioBufferList*)ioData
{
    if (!_done) {
        getThreadPolicy();
        _done = YES;
        printf("inNumberFrames %d\n", inNumberFrames);
    }
    float delta = 440 * 2 * M_PI / _sampleRate;
    const int count = ioData->mNumberBuffers;
    float x = 0;
    AudioBuffer* buffer = ioData->mBuffers;
    for (int idx = 0; idx < count; ++idx, ++buffer){
        x = _x;
        float* buf = buffer->mData;
        for (int i = 0; i < inNumberFrames; ++i){
            buf[i] = sin(x);
            x += delta;
        }
    }
    if (count > 0) {
        _x = x;
    }
}

- (void)play
{
    AURenderCallbackStruct callbackstruct;
    callbackstruct.inputProc = callback;
    callbackstruct.inputProcRefCon = (__bridge void *)self;
    AudioUnitSetProperty(_audiounit, kAudioUnitProperty_SetRenderCallback, kAudioUnitScope_Input, 0, &callbackstruct, sizeof(callbackstruct));
    
    AudioOutputUnitStart(_audiounit);
}

@end
