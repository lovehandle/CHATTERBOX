//
//  TalkTalkViewController.h
//  TalkTalk
//
//  Created by Ryan Closner on 2/17/13.
//  Copyright (c) 2013 Ryan Closner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>

@interface TalkTalkViewController : UIViewController {
    NSURL *soundFileURL;
    BOOL recording;
    BOOL playing;
    AVAudioRecorder *soundRecorder;
    AVAudioPlayer *soundPlayer;
    NSTimer *sliderTimer;
}

- (IBAction)recordOrStopButtonClick:(id)sender;
- (IBAction)playOrStopButtonClick:(id)sender;


@property (retain, nonatomic) IBOutlet UIButton *recordOrStopButton;
@property (retain, nonatomic) IBOutlet UIButton *playOrStopButton;
@property (retain, nonatomic) IBOutlet UISlider *progressSlider;

@end
