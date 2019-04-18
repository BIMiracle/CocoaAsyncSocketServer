//
//  KBSocketManager.m
//  CocoaAsyncSocketServer
//
//  Created by BIMiracle on 4/18/19.
//  Copyright © 2019 BIMiracle. All rights reserved.
//

#import "KBSocketManager.h"
#import <GCDAsyncSocket.h>

@interface KBSocketManager () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *soket;

@property (nonatomic, copy) NSMutableArray *clientSockets;

@end

@implementation KBSocketManager

- (instancetype)init{
    if (self = [super init]) {
        _soket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (BOOL)acceptOnPort:(uint16_t)port{
    NSError *error = nil;
    
    BOOL isSuccess = [_soket acceptOnPort:port error:&error];
    if (isSuccess) {
        if ([self.delegate respondsToSelector:@selector(receiveMessage:)]) {
            [self.delegate receiveMessage:@"监听成功"];
        }
        return YES;
    }else{
        if ([self.delegate respondsToSelector:@selector(receiveMessage:)]) {
            [self.delegate receiveMessage:[NSString stringWithFormat:@"监听失败，原因：%@",error]];
        }
        return NO;
    }
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(nonnull GCDAsyncSocket *)newSocket{
    // 保存客户端的socket
    [self.clientSockets addObject: newSocket];
    
    if ([self.delegate respondsToSelector:@selector(receiveMessage:)]) {
        [self.delegate receiveMessage:@"连接成功"];
    }
    
    [newSocket readDataWithTimeout:-1 tag:0];
}

// 收到消息(sock指客户端的Socket)
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([text isEqualToString:@"beatID"]) {
        [sock readDataWithTimeout:-1 tag:0];
        [self sendMessage:text];
        return;
    }else{
        if ([self.delegate respondsToSelector:@selector(receiveMessage:)]) {
            [self.delegate receiveMessage:text];
        }
    }
    
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err{
    [self.clientSockets removeObject:sock];
    if ([self.delegate respondsToSelector:@selector(receiveMessage:)]) {
        [self.delegate receiveMessage:@"断开连接"];
    }
}


// 给客户端发送消息
- (void)sendMessage:(NSString *)message{
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    for (GCDAsyncSocket *sock in self.clientSockets) {
        [sock writeData:data withTimeout:-1 tag:0];
    }
}


- (NSMutableArray *)clientSockets{
    if (_clientSockets == nil) {
        _clientSockets = [NSMutableArray array];
    }
    return _clientSockets;
}


@end
