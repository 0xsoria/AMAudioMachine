//
//  AMAudioDevice.m
//  AMAudioDevice
//
//  Created by Gabriel Soria Souza on 01/09/21.
//

#import "AMAudioDevice.h"

@interface AMAudioDevice ()

@end

@implementation AMAudioDevice

- (instancetype)initWithAudioDevice:(AudioDeviceID)deviceID {
    if (self = [super init]) {
        self.deviceID = deviceID;
    }
    return self;
}

- (nullable NSString *)UID {
    AudioObjectPropertyAddress address;
    address.mSelector = kAudioDevicePropertyDeviceUID;
    address.mScope = kAudioObjectPropertyScopeGlobal;
    address.mElement = kAudioObjectPropertyElementMain;
    
    CFStringRef name = nil;
    UInt32 propsize = sizeof(CFStringRef);
    OSStatus result = AudioObjectGetPropertyData(self.deviceID,
                                                 &address,
                                                 0,
                                                 nil,
                                                 &propsize,
                                                 &name);
    
    if (result != 0) {
        return nil;
    }
    
    return (__bridge NSString *)name;
}

- (nullable NSString *)deviceName {
    AudioObjectPropertyAddress address;
    address.mSelector = kAudioDevicePropertyDeviceNameCFString;
    address.mScope = kAudioObjectPropertyScopeGlobal;
    address.mElement = kAudioObjectPropertyElementMain;
    
    CFStringRef name = nil;
    UInt32 propsize = sizeof(CFStringRef);
    OSStatus result = AudioObjectGetPropertyData(self.deviceID,
                                                 &address,
                                                 0,
                                                 nil,
                                                 &propsize,
                                                 &name);
    
    if (result != 0) {
        return nil;
    }
    
    return (__bridge NSString *)name;
}

@end
