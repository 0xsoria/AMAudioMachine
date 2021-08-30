//
//  AMAudioMachineTests.m
//  AMAudioMachineTests
//
//  Created by Gabriel Soria Souza on 30/08/21.
//

#import "TargetConditionals.h"
#if !TARGET_OS_IOS
@import AMAudioMachine;
@import CoreAudio;
@import Cocoa;
#import <XCTest/XCTest.h>

@interface AudioOutputTests : XCTestCase

@end

@implementation AudioOutputTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testOuputDevice {
    AudioDeviceID deviceID = [NSSound obtainDefaultOuputDevice];
    XCTAssertTrue(deviceID != kAudioObjectUnknown);
}

- (void)testSystemVolume {
    float volume = [NSSound getSystemVolume];
    XCTAssertTrue(volume != 0.0);
}

- (void)testSetSystemVolume {
    [NSSound setSystemVolume:0.7 muteOff:YES];
    float volume = [NSSound getSystemVolume];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = 2;
    formatter.roundingMode = NSNumberFormatterRoundUp;

    NSString *numberString = [formatter stringFromNumber:@(volume)];
    
    XCTAssertTrue([numberString isEqual:@"0,7"]);
}

- (void)testSystemVolumeMuted {
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
#endif
