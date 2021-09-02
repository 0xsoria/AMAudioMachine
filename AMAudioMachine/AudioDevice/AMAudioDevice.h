//
//  AMAudioDevice.h
//  AMAudioDevice
//
//  Created by Gabriel Soria Souza on 01/09/21.
//

#import <Foundation/Foundation.h>
@import Cocoa;
@import CoreAudio;

NS_ASSUME_NONNULL_BEGIN

@interface AMAudioDevice : NSObject

@property AudioDeviceID deviceID;
@property (nonatomic, nullable) NSString *UID;
@property (nonatomic, nullable) NSString *deviceName;

- (instancetype)initWithAudioDevice:(AudioDeviceID)deviceID;

@end

NS_ASSUME_NONNULL_END
