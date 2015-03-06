//
//  YMTableViewCell.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMTextData.h"
#import "WFTextView.h"
#import "YMButton.h"


@protocol cellDelegate <NSObject>

- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger) cellStamp;
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;
-(void)didPromulgatorNameOrHeadPicPressedForIndex:(NSInteger)index name:(NSString*)name;
-(void)didRichTextPress:(NSString*)text index:(NSInteger)index;
-(void)didRichTextPress:(NSString*)text index:(NSInteger)index replyIndex:(NSInteger)index;

@end

@interface YMTableViewCell : UITableViewCell<WFCoretextDelegate>

@property BOOL hideReply;


//界面
@property (nonatomic,strong) UIImageView * headerImage;
@property(nonatomic , strong)UILabel *nameLbl;
@property(nonatomic,strong)UILabel *introLbl;
@property(nonatomic,strong)UIButton *foldBtn;
@property(nonatomic,strong)UIImageView *replyImageView;

//数据
@property (nonatomic,strong) NSMutableArray * imageArray;
@property (nonatomic,strong) NSMutableArray * ymTextArray;
@property (nonatomic,strong) NSMutableArray * ymShuoshuoArray;
@property (nonatomic,assign) id<cellDelegate> delegate;
@property (nonatomic,assign) NSInteger stamp;
@property (nonatomic,strong) YMButton *replyBtn;

- (YMTextData*)getYMTextData;

- (void)setYMViewWith:(YMTextData *)ymData;

@end
