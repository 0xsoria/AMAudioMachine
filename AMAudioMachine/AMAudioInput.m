//
//  AMAudioInput.m
//  AMAudioMachine
//
//  Created by Gabriel Soria Souza on 17/09/21.
//

#import "AMAudioInput.h"

@implementation AMAudioInput

- (void)getInput:(void (^)(NSData *))completion {
    completion([NSData alloc]);
}

@end
