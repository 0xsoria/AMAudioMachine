//
//  NSSound+Extensions.m
//  NSSound+Extensions
//
//  Created by Gabriel Soria Souza on 30/08/21.
//


#import <CoreAudio/CoreAudio.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import "NSSound+Extensions.h"

NS_ASSUME_NONNULL_BEGIN

 @implementation NSSound (NSSoundSystemExtension)

+ (AudioDeviceID)obtainDefaultOuputDevice {
    AudioDeviceID returnData = kAudioObjectUnknown;
    unsigned int size = sizeof(returnData);
    AudioObjectPropertyAddress address;
    address.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
    address.mScope = kAudioObjectPropertyScopeGlobal;
    address.mElement = kAudioObjectPropertyElementMaster;
    
    AudioObjectID objID = kAudioObjectSystemObject;
    if (!AudioObjectHasProperty(objID, &address)) {
        return returnData;
    }
    
    AudioObjectID propertyID = kAudioObjectSystemObject;
    OSStatus audioError = AudioObjectGetPropertyData(propertyID,
                                                     &address,
                                                     0,
                                                     nil,
                                                     &size,
                                                     &returnData);
    
    if (audioError != noErr) {
        return returnData;
    }
    
    
    return returnData;
}

+ (float) getSystemVolume {
    AudioDeviceID defaultDeviceID = kAudioObjectUnknown;
    unsigned int size = sizeof(defaultDeviceID);
    OSStatus theError;
    float volume = 0;
    AudioObjectPropertyAddress address;
    
    defaultDeviceID = [NSSound obtainDefaultOuputDevice];
    
    if (defaultDeviceID == kAudioObjectUnknown) {
        return 0.0;
    }
    address.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMasterVolume;
    address.mScope = kAudioDevicePropertyScopeOutput;
    address.mElement = kAudioObjectPropertyElementMaster;
    
    if (!AudioObjectHasProperty(defaultDeviceID, &address)) {
        return 0.0;
    }
    
    theError = AudioObjectGetPropertyData(defaultDeviceID,
                                          &address,
                                          0,
                                          nil,
                                          &size,
                                          &volume);
    
    if (theError != noErr) {
        return 0.0;
    }
    
    volume = volume > 1.0 ? 1.0 : (volume < 0.0 ? 0.0 : volume);
    
    return volume;
}

+ (void)setSystemVolume:(float)volume muteOff:(BOOL)muteoff {
    float newValue = volume;
    AudioObjectPropertyAddress address;
    AudioDeviceID deviceID;
    OSStatus theError = noErr;
    unsigned int muted;
    Boolean canSetVol = true;
    BOOL muteValue;
    BOOL hasMute = YES;
    Boolean canMute = true;
    
    deviceID = [NSSound obtainDefaultOuputDevice];
    if (deviceID == kAudioObjectUnknown) {
        return;
    }
    
    newValue = volume > 1.0 ? 1.0 : (volume < 0.0 ? 0.0 : volume);
    if (newValue != volume) {
        //
    }
    
    address.mSelector = kAudioDevicePropertyMute;
    address.mScope = kAudioDevicePropertyScopeOutput;
    address.mElement = kAudioObjectPropertyElementMaster;
    
    muteValue = (newValue < 0.05);
    if (muteValue) {
        address.mSelector = kAudioDevicePropertyMute;
        hasMute = AudioObjectHasProperty(deviceID, &address);
        
        if (hasMute) {
            theError = AudioObjectIsPropertySettable(deviceID,
                                                     &address,
                                                     &canMute);
            
            if (theError != noErr || !(canMute)) {
                canMute = false;
            }
        } else {
            canMute = false;
        }
    } else {
        address.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMasterVolume;
    }
    
    if (!AudioObjectHasProperty(deviceID,
                                &address)) {
        return;
    }
    
    theError = AudioObjectIsPropertySettable(deviceID,
                                             &address,
                                             &canSetVol);
    if (theError != noErr || !canSetVol) {
        return;
    }
    
    if (muteValue && hasMute && canMute) {
        muted = 1;
        theError = AudioObjectSetPropertyData(deviceID,
                                              &address,
                                              0,
                                              nil,
                                              sizeof(muted),
                                              &muted);
        
        if (theError != noErr) {
            return;
        }
    } else {
        theError = AudioObjectSetPropertyData(deviceID,
                                              &address,
                                              0,
                                              nil,
                                              sizeof(newValue),
                                              &newValue);
        if (theError != noErr) {
            //
        }
        
        if (muteoff && hasMute && canMute) {
            address.mSelector = kAudioDevicePropertyMute;
            muted = 0;
            theError = AudioObjectSetPropertyData(deviceID,
                                                  &address,
                                                  0,
                                                  nil,
                                                  sizeof(muted),
                                                  &muted);
        }
    }
}

+ (void)systemVolumeSetMuted :(BOOL)m {
    AudioDeviceID defaultDeviceID = kAudioObjectUnknown;
    AudioObjectPropertyAddress address;
    BOOL hasMute;
    Boolean canMute = true;
    OSStatus theError = noErr;
    unsigned int muted = 0;

    defaultDeviceID = [NSSound obtainDefaultOuputDevice];
    if (defaultDeviceID == kAudioObjectUnknown) {
        return;
    }
    
    address.mSelector = kAudioDevicePropertyMute;
    address.mScope = kAudioDevicePropertyScopeOutput;
    address.mElement = kAudioObjectPropertyElementMaster;
    
    muted = m ? 1 : 0;
    
    hasMute = AudioObjectHasProperty(defaultDeviceID,
                                     &address);
    
    if (hasMute) {
        theError = AudioObjectIsPropertySettable(defaultDeviceID,
                                                 &address,
                                                 &canMute);
        if (theError == noErr && canMute) {
            theError = AudioObjectSetPropertyData(defaultDeviceID,
                                                  &address,
                                                  0,
                                                  nil,
                                                  sizeof(muted),
                                                  &muted);
            
            if (theError != noErr) {
                //
            }
        }
    }
}

+ (void)fadeSystemVolumeToMute :(float)seconds {
    float secs = (seconds > 0) ? seconds : (seconds * (-1.0));
    secs = (secs > 10.0) ? 10.0 : secs;
    
    float currentVolume = [NSSound getSystemVolume];
    float delta = currentVolume / (seconds * 2);
    float secondsLeft = secs;
    
    while (secondsLeft > 0) {
        float volume = [NSSound getSystemVolume];
        [NSSound setSystemVolume:volume - delta muteOff:YES];
        [NSThread sleepForTimeInterval:0.5];
        secondsLeft = secondsLeft - 0.5;
    }
    
    [NSSound systemVolumeSetMuted:YES];
    [NSSound setSystemVolume:currentVolume muteOff:NO];
}

+ (BOOL)getSystemVolumeIsMuted {
    AudioDeviceID defaultDeviceID = kAudioObjectUnknown;
    AudioObjectPropertyAddress address;
    BOOL hasMute;
    Boolean canMute = true;
    OSStatus theError = noErr;
    unsigned int muted = 0;
    unsigned int mutedSize = sizeof(muted);
    
    
    defaultDeviceID = [NSSound obtainDefaultOuputDevice];
    if (defaultDeviceID == kAudioObjectUnknown) {
        return false;
    }
    
    address.mSelector = kAudioDevicePropertyMute;
    address.mScope = kAudioDevicePropertyScopeOutput;
    address.mElement = kAudioObjectPropertyElementMaster;
    
    hasMute = AudioObjectHasProperty(defaultDeviceID,
                                     &address);
    
    if (hasMute) {
        theError = AudioObjectIsPropertySettable(defaultDeviceID,
                                                 &address,
                                                 &canMute);
        
        if (theError == noErr && canMute) {
            theError = AudioObjectGetPropertyData(defaultDeviceID,
                                                  &address,
                                                  0,
                                                  nil,
                                                  &mutedSize,
                                                  &muted);
            if (muted != 0) {
                return true;
            }
        }
    }
    
    return false;
}

+ (void)systemVolumeFateToMuteinSeconds:(float)seconds blocking:(BOOL)blocking {
    if ([NSSound getSystemVolumeIsMuted]) {
        return;
    }
    
    if (blocking) {
        [NSSound fadeSystemVolumeToMute:seconds];
    } else {
        
    }
}

@end

NS_ASSUME_NONNULL_END


