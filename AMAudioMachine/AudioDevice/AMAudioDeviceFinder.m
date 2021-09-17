//
//  AMAudioDeviceFinder.m
//  AMAudioDeviceFinder
//
//  Created by Gabriel Soria Souza on 01/09/21.
//

#import "AMAudioDeviceFinder.h"

@implementation AMAudioDeviceFinder

- (NSArray <AMAudioDevice *>*)findDevices {
    UInt32 propsize = 0;
    NSMutableArray<AMAudioDevice *> *returnArray = [NSMutableArray new];
    
    AudioObjectPropertyAddress address;
    address.mSelector = kAudioHardwarePropertyDevices;
    address.mScope = kAudioObjectPropertyScopeGlobal;
    address.mElement = kAudioObjectPropertyElementMaster;
    
    OSStatus result = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject,
                                                     &address,
                                                     sizeof(AudioObjectPropertyAddress), nil,
                                                     &propsize);
    
    if (result != 0) {
        return returnArray;
    }
    
    int numDevices = propsize / sizeof(AudioDeviceID);
    int devs[numDevices];

    for (int i = 0; i < numDevices; i++) {
        devs[i] = 0;
    }
    
    result = AudioObjectGetPropertyData(kAudioObjectSystemObject,
                                        &address,
                                        0,
                                        nil,
                                        &propsize,
                                        &devs);
    
    if (result != 0) {
        return returnArray;
    }
    
    for (int i = 0; i < numDevices; i++) {
        AMAudioDevice *device = [[AMAudioDevice alloc] initWithAudioDevice: devs[i]];
        [returnArray addObject:device];
    }

    return returnArray;
}

@end
