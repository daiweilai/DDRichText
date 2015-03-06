//
//  ContantHead.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#ifndef WFCoretext_ContantHead_h
#define WFCoretext_ContantHead_h

#define dataCount 10
#define kLocationToBottom 20

#define TableHeader 50
#define ShowImage_H 80
#define PlaceHolder @" "
#define offSet_X 20
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"
#define NamePattern @"@\\w*\\s|@\\w*:|@\\w*：" //只能匹配 @姓名 @姓名: @姓名：  姓名只能使用数字、字母、下划线、汉字

#define kDistance 20 //说说和图片的间隔
#define kReplyBtnDistance 30 //回复按钮距离
#define AttributedImageNameKey      @"ImageName"

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

#define limitline 4
#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#endif
