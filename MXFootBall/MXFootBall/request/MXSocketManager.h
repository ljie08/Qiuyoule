//
//  MXSocketManager.h
//
//  Created by YY on 2018/4/17.
//  Copyright © 2018年 YY. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    disConnectByServer = 1001, //服务器断开连接
    disConnectByUser           //客户端断开连接
} DisConnectType;

typedef NS_ENUM(NSInteger,ConnectStatusType){
    disConnected   = 0,  //断开连接
    isConnecting   = 1,  //正在连接
    connected      = 2,  //已经连接
    reConnecting   = 3,  //正在重连
    connectFailure   = 4,
};

typedef NS_ENUM(NSInteger,MXUserType){
    MXLoginInUser  = 0,
    MXTourist      = 1,
};

typedef NS_ENUM(NSInteger,MXSendMessageType){
    MXChatMessage      = 0,
    MXBarrageMessage   = 1,
    MXHeartMessage     = 2,
};
typedef void(^MessageFormServer)(id message);

typedef void (^currentSocketConnectStatus)(ConnectStatusType statusType);

@protocol MXSocketMangerDelegate <NSObject>
@optional
-(void)getMessageFormServer:(id) message;

-(void)currentSocketStatusIsConnecting;

-(void)currentSocketStatusReConnecting;

-(void)currentSocketStatusConnectedSuccessed;

@end
@interface MXSocketManager : NSObject

@property (nonatomic,strong)MessageFormServer message;

@property (nonatomic,assign)id <MXSocketMangerDelegate> delegate;

@property (nonatomic,assign)BOOL isConnect;

@property (nonatomic,strong)currentSocketConnectStatus currentStatusType;

//单例
+(instancetype)manager;
//建立socket连接
- (void)connectWithUserInfo:(NSDictionary *)userInfo andUserType:(MXUserType)type  ;
//断开连接
- (void)disConnect;
//发送消息
- (void)sendMsg:(NSString *)msg andMessageType:(MXSendMessageType) messageType;

- (void)ping;



@end
