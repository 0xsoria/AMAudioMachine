//
//  AMAudioDeviceFinder.h
//  AMAudioDeviceFinder
//
//  Created by Gabriel Soria Souza on 01/09/21.
//

#import <Foundation/Foundation.h>
#import "AMAudioDevice.h"
@import Cocoa;
@import AVFoundation;

NS_ASSUME_NONNULL_BEGIN

@interface AMAudioDeviceFinder : NSObject

- (NSArray <AMAudioDevice *>*)findDevices;

@end

NS_ASSUME_NONNULL_END
