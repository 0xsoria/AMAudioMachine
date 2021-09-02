//
//  NSSound+Extensions.h
//  NSSound+Extensions
//
//  Created by Gabriel Soria Souza on 30/08/21.
//

#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudioKit/CoreAudioKit.h>

@interface NSSound (NSSoundSystemExtension)

+ (AudioDeviceID)obtainDefaultOuputDevice;
+ (float) getSystemVolume;
+ (void)setSystemVolume:(float)volume muteOff:(BOOL)muteoff;

@end
