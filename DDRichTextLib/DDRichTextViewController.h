//
//  DDRichTextViewController.h
//  Created by David on 15/2/6.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"


@protocol DDRichTextViewDelegate <NSObject>
@required
-(NSString*)senderName;//评论的时候自己的名字
@optional
-(BOOL)hideReplyButtonForIndex:(NSInteger)index;//是否隐藏回复按钮
-(void)didPromulgatorPressForIndex:(NSInteger)index name:(NSString*)name;//发布者的头像或者名字被点击
-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index;//正文的富文本被点击的回调
-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index replyIndex:(NSInteger)replyIndex;//评论的富文本被点击的回调
-(void)replyForIndex:(NSInteger)index replyText:(NSString*)text;//回复文字的回调
@end


@protocol DDRichTextViewDataSource <NSObject>
@required
-(YMTextData*)dataForRowAtIndex:(NSInteger)index;
-(NSInteger)numberOfRowsInDDRichText;
@end

@interface DDRichTextViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate>
@property (weak, nonatomic) id<DDRichTextViewDelegate> delegate;
@property (weak, nonatomic) id<DDRichTextViewDataSource> dataSource;

@end
