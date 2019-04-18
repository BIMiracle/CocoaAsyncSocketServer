//
//  KBSocketManager.h
//  CocoaAsyncSocketServer
//
//  Created by BIMiracle on 4/18/19.
//  Copyright © 2019 BIMiracle. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KBSocketDelegate <NSObject>

- (void)receiveMessage:(NSString *)message;

@end

@interface KBSocketManager : NSObject

@property (nonatomic, weak) id<KBSocketDelegate> delegate;

- (BOOL)acceptOnPort:(uint16_t)port;

- (void)sendMessage:(NSString *)message;

@end
