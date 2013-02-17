//
//  TalkTalkViewController.m
//  TalkTalk
//
//  Created by Ryan Closner on 2/17/13.
//  Copyright (c) 2013 Ryan Closner. All rights reserved.
//

#import "TalkTalkViewController.h"

@interface TalkTalkViewController ()

@end

@implementation TalkTalkViewController

@synthesize recordOrStopButton;
@synthesize playOrStopButton;
@synthesize progressSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *tempDir = NSTemporaryDirectory();
    NSString *soundFilePath = [tempDir stringByAppendingString:@"sound.caf"];
    
    soundFileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    recording = NO;
    playing = NO;
}

- (IBAction)recordOrStopButtonClick:(id)sender {
    if (recording) {
        [soundRecorder stop];
        recording = NO;
        soundRecorder = nil;
        [recordOrStopButton setSelected:NO];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    } else {
        [[AVAudioSession sharedInstance]
         setCategory:AVAudioSessionCategoryPlayAndRecord
         error: nil];
        
        NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                        [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                        [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                        [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
                                        nil];
        
        soundRecorder = [[AVAudioRecorder alloc] initWithURL: soundFileURL
                                                    settings: recordSettings
                                                       error: nil];
        
        soundRecorder.delegate = self;
        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                       target:self selector:@selector(updateSlider)
                                                     userInfo:nil repeats:YES];
        progressSlider.maximumValue = 150;
        [soundRecorder record];
        [recordOrStopButton setSelected:YES];
        
        recording = YES;
    }
}

- (IBAction)playOrStopButtonClick:(id)sender {
    if (playing) {
        [soundPlayer stop];
        playing = NO;
        soundPlayer = nil;
        [playOrStopButton setSelected:NO];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    } else {
        [[AVAudioSession sharedInstance]
         setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                       target:self selector:@selector(updateSlider) userInfo:nil
                                                      repeats:YES];
        
        soundPlayer = [[AVAudioPlayer alloc]
                       initWithContentsOfURL:soundFileURL
                       error:nil];
        soundPlayer.delegate = self;
        progressSlider.maximumValue = soundPlayer.duration;
        [soundPlayer prepareToPlay];
        [soundPlayer play];
        
        [playOrStopButton setSelected:YES];
        
        playing = YES;
    }
}


- (void)audioRecordingDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if (recording) {
        [soundRecorder stop];
        recording = NO;
    
        soundRecorder = nil;
    
        [recordOrStopButton setSelected: NO];
        [[AVAudioSession sharedInstance] setActive: NO error: nil];
    }
    
    
    if (flag) {
        [self performSelector:@selector(updateSlider) withObject:nil afterDelay: 0.1];
        [sliderTimer invalidate];
    }
}

- (void)audioRecordingDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (playing) {
        [soundPlayer stop];
        playing = NO;
        soundPlayer = nil;
        
        [playOrStopButton setSelected: NO];
        [[AVAudioSession sharedInstance] setActive: NO error: nil];
    }
    
    if (flag) {
        [self performSelector:@selector(updateSlider) withObject:nil afterDelay: 0.1];
        [sliderTimer invalidate];
    }
}

- (void)updateSlider {
    if (playing) {
        progressSlider.value = soundPlayer.currentTime;
    }
    if (recording) {
        progressSlider.value = soundRecorder.currentTime;
    }
    if (!playing && !recording) {
        progressSlider.value = progressSlider.minimumValue;
    }
}

@end
