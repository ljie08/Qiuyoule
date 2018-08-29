//
//  MXSocketManager.m
//
//  Created by YY on 2018/4/17.
//  Copyright © 2018年 YY. All rights reserved.
//

#import "NSString+base64.h"
#import <SocketRocket.h>
#import "MXSocketManager.h"
@interface MXSocketManager ()<SRWebSocketDelegate>
{
    SRWebSocket *webSocket;
    NSTimer *heartBeat;
    NSTimeInterval reConnectTime;
    
}
@property (nonatomic,strong)NSDictionary *para;

@property (nonatomic,strong)NSDictionary *messageDict;

//@property (nonatomic,strong)currentSocketConnectStatus currentConnectStatus;

@property (nonatomic,assign)MXUserType type;
@end
static MXSocketManager *_manager;
@implementation MXSocketManager

+(instancetype)manager{
    return [[self alloc] init];
    
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_manager==nil) {
            _manager=[super allocWithZone:zone];
        }
    });
    return _manager;
}

//初始化连接
- (void)initSocketWithUserInfo:(NSDictionary *)userInfo
{
    if (webSocket) {
        return;
    }
    NSString *url=[NSString string];
    if (self.type==MXLoginInUser) {
        url= [NSString stringWithFormat:@"wss://talk.qiuyoule.com/matchSocket/%@::%@::%@::%@::%@::%@::%@",[userInfo objectForKey:@"matchId"],[userInfo objectForKey:@"startTime"],[userInfo objectForKey:@"userId"],[[userInfo objectForKey:@"username"]base64EncodedString],[[userInfo objectForKey:@"headerPic"]base64EncodedString],[userInfo objectForKey:@"level"],[userInfo objectForKey:@"matchStatus"]];
    }else if(self.type==MXTourist){
        url= [NSString stringWithFormat:@"wss://talk.qiuyoule.com/matchSocket/%@::%@::customer111::username111::headerPic111::1::%@",[userInfo objectForKey:@"matchId"],[userInfo objectForKey:@"startTime"],[userInfo objectForKey:@"matchStatus"]];
    }
    NSURLRequest*request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    webSocket=[[SRWebSocket alloc] initWithURLRequest:request];
    webSocket.delegate = self;
    //设置代理线程queue
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 2;
    [webSocket setDelegateOperationQueue:queue];
    //连接
    [webSocket open];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(currentSocketStatusIsConnecting)]) {
        [self.delegate currentSocketStatusIsConnecting];
    }
    self.currentStatusType(isConnecting);
}

//初始化心跳
- (void)initHeartBeat
{
    
    dispatch_main_async_safe(^{
        
        [self destoryHeartBeat];
        
        
        //心跳设置为3分钟，NAT超时一般为5分钟
        heartBeat=[NSTimer scheduledTimerWithTimeInterval:3*60 target:self selector:@selector(heartAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:heartBeat forMode:NSRunLoopCommonModes];
    })
    
}
-(void)heartAction{
    //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小;
    [self sendMsg:@"heart" andMessageType:MXHeartMessage];
}
//取消心跳
- (void)destoryHeartBeat
{
    dispatch_main_async_safe(^{
        if (heartBeat) {
            [heartBeat invalidate];
            heartBeat = nil;
        }
    })
    
}


#pragma mark - 对外的一些接口

//建立连接
- (void)connectWithUserInfo:(NSDictionary *)userInfo andUserType:(MXUserType)type
{
    self.type=type;
    self.isConnect=NO;
    [self initSocketWithUserInfo:userInfo];
    self.para=[NSDictionary dictionaryWithDictionary:userInfo];
    //每次正常连接的时候清零重连时间
    reConnectTime = 0;
}

//断开连接
- (void)disConnect
{
    
    if (webSocket) {
        [webSocket closeWithCode:disConnectByUser reason:@"用户主动断开"];
        webSocket = nil;
    }
}


//发送消息
- (void)sendMsg:(NSString *)msg andMessageType:(MXSendMessageType)messageType
{
    NSString *messagetypeStr=[NSString string];
    switch (messageType) {
        case MXChatMessage:
            messagetypeStr=@"chatmsg";
            break;
        case MXBarrageMessage:
            messagetypeStr=@"barmsg";
            break;
        case MXHeartMessage:
            messagetypeStr=@"heartmsg";
            break;
        default:
            break;
    }
    NSData *data=[NSJSONSerialization dataWithJSONObject:@{@"msgType":messagetypeStr,@"chatMsg":msg} options:kNilOptions error:nil];
    NSString *message=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (self.isConnect) {
         [webSocket send:message];
    }
}
//重连机制
- (void)reConnect
{
    [self disConnect];
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
//    [[MXAlertView new]showErrorInfo:@"重新连接聊天室"];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(currentSocketStatusReConnecting)]) {
        [self.delegate currentSocketStatusReConnecting];
    }
    self.currentStatusType(reConnecting);
    if (reConnectTime > 64) {
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webSocket = nil;
        [self initSocketWithUserInfo:self.para];
    });
    
    
    //重连时间2的指数级增长
    if (reConnectTime == 0) {
        reConnectTime = 2;
    }else{
        reConnectTime *= 2;
    }
    
}


//pingPong
- (void)ping{
    
    if (webSocket) {
        [webSocket sendPing:nil];
    }
}



#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSData *data=[message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    if ([[dict objectForKey:@"msgType"] isEqualToString:@"heartmsg"]) {
        self.isConnect=YES;
    }
    if (self.message) {
        if (message==nil) {
            return ;
        }
        self.message(dict);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(getMessageFormServer:)]) {
        [self.delegate getMessageFormServer:dict];
    }
//    NSLog(@"服务器返回收到消息:%@",message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    self.isConnect=YES;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(currentSocketStatusConnectedSuccessed)]) {
        [self.delegate currentSocketStatusConnectedSuccessed];
    }
    self.currentStatusType(connected);
    //连接成功了开始发送心跳
    [self initHeartBeat];
}

//open失败的时候调用
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败.....\n%@",error);
    self.currentStatusType(connectFailure);
    self.isConnect=NO;
    //失败了就去重连
    [self reConnect];
}

//网络连接中断被调用
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",code,reason,wasClean);
    self.isConnect=NO;
    //如果是被用户自己中断的那么直接断开连接，否则开始重连
    if (code == disConnectByUser) {
        NSLog(@"被用户关闭连接，不重连");
        [self disConnect];
        self.currentStatusType(disConnected);
    }else{
        NSLog(@"其他原因关闭连接，开始重连...");
        [self reConnect];
    }
    
    
    //断开连接时销毁心跳
    [self destoryHeartBeat];
    
}

//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    NSLog(@"收到pong回调");
    
}


//将收到的消息，是否需要把data转换为NSString，每次收到消息都会被调用，默认YES
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket
{
//    NSLog(@"webSocketShouldConvertTextFrameToString");

    return YES;
}
@end
