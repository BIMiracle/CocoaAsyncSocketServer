//
//  ViewController.m
//  CocoaAsyncSocketServer
//
//  Created by BIMiracle on 4/18/19.
//  Copyright © 2019 BIMiracle. All rights reserved.
//

#import "ViewController.h"
#import "KBSocketManager.h"

@interface ViewController () <KBSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextField *portField;
@property (weak, nonatomic) IBOutlet UITextField *sendFiled;
@property (weak, nonatomic) IBOutlet UITextView *reciveText;

@property (nonatomic, strong) KBSocketManager *socket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _socket = KBSocketManager.new;
    _socket.delegate = self;
}

/**
 监听端口
 */
- (IBAction)connectAction{
    [_socket acceptOnPort:[self.portField.text integerValue]];
}

/**
 发送消息
 */
- (IBAction)sendMessage:(id)sender{
    [_socket sendMessage:self.sendFiled.text];
}

- (void)receiveMessage:(NSString *)message{
    self.reciveText.text = message;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
