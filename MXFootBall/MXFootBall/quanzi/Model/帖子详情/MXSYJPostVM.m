//
//  MXSYJPostVM.m
//  MXFootBall
//
//  Created by 尚勇杰 on 2018/4/18.
//  Copyright © 2018年 zt. All rights reserved.
//

#import "MXSYJPostVM.h"

@implementation MXSYJPostVM

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - 帖子详情
- (void)getPostDetail:(NSString *)userId newsId:(NSString *)newsId page:(NSInteger)page limit:(NSInteger)limit success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture{
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:newsId forKey:@"newsId"];
    if (page) {
    [parmet setObject:@(page) forKey:@"page"];
    }
    if (limit) {
    [parmet setObject:@(limit) forKey:@"limit"];
    }
    if ([MXssWodeUtils loadPersonInfo].userId) {
        [parmet setObject:[MXssWodeUtils loadPersonInfo].userId forKey:@"userId"];
    }
    
    NSMutableDictionary *dict = [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemNewsDetailPATH];
    [[WebManager sharedManager] requestWithMethod:GET WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            success(dic);
          
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
                
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        failture(error);
    }];
    
}

#pragma mark - 发送评论
- (void)commentUserId:(NSString *)userId newsId:(NSString *)newsId content:(NSString *)content success:(void (^)(NSDictionary *))success failture:(void (^)(NSError *))failture{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:newsId forKey:@"newsId"];
    [parmet setObject:userId forKey:@"userId"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].token forKey:@"token"];
    [parmet setObject:content forKey:@"content"];
    
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemPostForumComPATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"评论成功~~~"];

            
            success(dic);

        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        failture(error);
    }];
    
}

#pragma mark - 只看楼主
- (void)onlyPosterNewsId:(NSString *)newsId ownerId:(NSString *)ownerId success:(void (^)(NSDictionary *))success failture:(void (^)(NSError *))failture{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:newsId forKey:@"newsId"];
    [parmet setObject:ownerId forKey:@"ownerId"];
    
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemForumOwnerCommentPATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            
            success(dic);
            
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        failture(error);
    }];
}

#pragma mark - 互评
- (void)eachOtherNewsId:(NSString *)newsId userId:(NSString *)userId parentId:(NSString *)parentId firstUserId:(NSString *)firstUserId content:(NSString *)content success:(void (^)(NSDictionary *))success failture:(void (^)(NSError *))failture{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:newsId forKey:@"newsId"];
    [parmet setObject:userId forKey:@"userId"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].token forKey:@"token"];
    [parmet setObject:parentId forKey:@"parentId"];
    [parmet setObject:content forKey:@"content"];
    [parmet setObject:firstUserId forKey:@"commentId"];
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemPostForumUserComPATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"回复成功~~~"];
            
            success(dic);
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        failture(error);
    }];
    
}

#pragma mark - 收藏
- (void)collectNewsId:(NSString *)newsId userId:(NSString *)userId opid:(NSInteger)opid success:(void (^)(NSDictionary *))success failture:(void (^)(NSError *))failture{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:newsId forKey:@"newsId"];
    [parmet setObject:userId forKey:@"userId"];
//    [parmet setObject:[NSString stringWithFormat:@"%ld",opid] forKey:@"opid"];
    [parmet setObject:[MXssWodeUtils loadPersonInfo].token forKey:@"token"];
    
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemCollectForumPATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {

            if (opid == 0) {
                [SVProgressHUD showSuccessWithStatus:@"取消收藏成功~"];
            }else{
                [SVProgressHUD showSuccessWithStatus:@"收藏成功~"];

            }
            
            success(dic);
            
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
        failture(error);
    }];
    
}

#pragma mark - 关注&&取消关注
- (void)attentionType:(NSInteger)type ownerId:(NSString *)ownerId userId:(NSString *)userId success:(void (^)(NSDictionary *))success failture:(void (^)(NSError *))failture{
    
    MXSSToolConfig *userModel = [MXssWodeUtils loadPersonInfo];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    //    [parmet setObject:userModel.userSign forKey:@"sign"];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:userId forKey:@"userId"];
    [parmet setObject:userModel.token forKey:@"token"];
    [parmet setObject:ownerId forKey:@"ownerId"];
    [parmet setObject:[NSString stringWithFormat:@"%ld",type] forKey:@"opid"];
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    
        NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemAddFansPATH];
        
        [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
            
            if ([dic[@"code"] isEqualToString:@"0"]) {
                
                if (type == 0) {
                    [SVProgressHUD showSuccessWithStatus:@"取消关注成功~"];
                }else{
                    [SVProgressHUD showSuccessWithStatus:@"关注成功~"];
                }
                success(dic);
               
            }else{
                [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
                success(dic);
            }
            
            NSLog(@"%@",dic);
            
        } WithFailureBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请求错误"];
            failture(error);
        }];
    
}

#pragma mark - 模块详细信息
- (void)getCircleDetail:(NSString *)userId channleId:(NSString *)channleId page:(NSInteger)page limit:(NSInteger)limit opid:(NSInteger)opid success:(void (^)(NSDictionary *))success failture:(void (^)(NSError *))failture{
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:channleId forKey:@"channelId"];
    [parmet setObject:[NSString stringWithFormat:@"%ld",limit] forKey:@"limit"];
    [parmet setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [parmet setObject:[NSString stringWithFormat:@"%ld",opid] forKey:@"opid"];
    if (userId) {
        [parmet setObject:userId forKey:@"userId"];
    }
    NSMutableDictionary *dict= [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemChannelNewListPATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            success(dic);
         
        }else{
            
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
            return;
        }
        
    } WithFailureBlock:^(NSError *error) {
        failture(error);
        [SVProgressHUD showErrorWithStatus:@"请求错误"];
    }];
    
    
}

#pragma mark - 个人信息
- (void)getPersonUserId:(NSString *)userId ownerId:(NSString *)ownerId page:(NSInteger)page limit:(NSInteger)limit opid:(NSInteger)opid success:(void (^)(NSDictionary *dic))success failture:(void(^)(NSError *error))failture{
    
   
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    NSMutableDictionary *parmet = [NSMutableDictionary dictionary];
    [parmet setObject:[MXLJUtil getNowDateTimeString] forKey:@"time"];
    [parmet setObject:ownerId forKey:@"ownerId"];
    if ([MXssWodeUtils loadPersonInfo].userId) {
        [parmet setObject:[MXssWodeUtils loadPersonInfo].userId forKey:@"userId"];
    }
    [parmet setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [parmet setObject:[NSString stringWithFormat:@"%ld",limit] forKey:@"limit"];
    [parmet setObject:[NSString stringWithFormat:@"%ld",opid] forKey:@"opid"];
    NSMutableDictionary *dict = [MXLJUtil sortedDictionary:parmet];
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVER_HOST,MXWodemPersonalForumListPATH];
    [[WebManager sharedManager] requestWithMethod:POST WithUrl:url WithParams:dict WithSuccessBlock:^(NSDictionary *dic) {
        
        if ([dic[@"code"] isEqualToString:@"0"]) {
            
            [SVProgressHUD dismiss];
            
            success(dic);
        }
        
        
    } WithFailureBlock:^(NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"请求错误!!!"];
        failture(error);
        
    }];
    
    
    
}


@end
