//
//  DDRichTextViewController.m
//  WFCoretext
//
//  Created by David on 15/2/6.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "DDRichTextViewController.h"

@interface DDRichTextViewController()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate>
{
    UITableView *mainTable;
    UIButton *replyBtn;
    YMReplyInputView *replyView ;
    BOOL hideReply;
}
@end

@implementation DDRichTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableview];
}

#pragma mark - 计算高度
- (YMTextData*)calculateHeights:(YMTextData *)ymData{
    ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
    ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    return ymData;
}


- (void) initTableview{
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    mainTable.backgroundColor = [UIColor groupTableViewBackgroundColor];
     mainTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  [[self dataSource] numberOfRowsInDDRichText];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YMTextData *ym = [self calculateHeights:[[self dataSource] dataForRowAtIndex:[indexPath section]]];
    BOOL unfold = ym.foldOrNot;
    CGFloat height = TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance;
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"hideReplyButtonForIndex:")]) {
		if ([[self delegate] hideReplyButtonForIndex:indexPath.section]) {
			height -= 40;
		}
	}
    return  height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ILTableViewCell";
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.section;
    cell.replyBtn.tag = indexPath.section;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"hideReplyButtonForIndex:")]) {
		if ([[self delegate] hideReplyButtonForIndex:indexPath.section]) {
			cell.hideReply = YES;
		}
	}
    YMTextData *data = [[self dataSource] dataForRowAtIndex:[indexPath section]];
	//这句话让头像 支持异步加载
	[cell.headerImage sd_setImageWithURL:[NSURL URLWithString:data.headPicURL] placeholderImage:[UIImage imageNamed:@"nilPic.png"]];
//    cell.headerImage.image = data.headPic;
    cell.nameLbl.text = data.name;
    cell.introLbl.text = data.intro;
    [cell setYMViewWith:data];
    return cell;
}

-(void)haha{
	NSLog(@"hehe");
}

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    float origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    if (replyBtn) {
        [UIView animateWithDuration:0.25f animations:^{
            replyBtn.frame = CGRectMake(sender.frame.origin.x, origin_Y - 10 , 0, 38);
        } completion:^(BOOL finished) {
            NSLog(@"销毁");
            [replyBtn removeFromSuperview];
            replyBtn = nil;
		}];
    }else{
        replyBtn = [UIButton buttonWithType:0];
        replyBtn.layer.cornerRadius = 5;
        replyBtn.backgroundColor = [UIColor colorWithRed:33/255.0 green:37/255.0 blue:38/255.0 alpha:0.8];
        replyBtn.frame = CGRectMake(sender.frame.origin.x , origin_Y - 10 , 0, 38);
        [replyBtn setTitleColor:[UIColor whiteColor] forState:0];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        replyBtn.tag = sender.tag;
        [mainTable addSubview:replyBtn];
        [replyBtn addTarget:self action:@selector(replyMessage:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:0.25f animations:^{
            replyBtn.frame = CGRectMake(sender.frame.origin.x - 60, origin_Y  - 10 , 60, 38);
        } completion:^(BOOL finished) {
            [replyBtn setTitle:@"评论" forState:0];
        }];
    }
}

#pragma mark - 真の评论
- (void)replyMessage:(UIButton *)sender{
    //NSLog(@"TAG === %d",sender.tag);
    if (replyBtn){
        [replyBtn removeFromSuperview];
        replyBtn = nil;
    }
    // NSLog(@"alloc reply");
    
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = sender.tag;
    [self.view addSubview:replyView];
}


#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (replyBtn) {
        [replyBtn removeFromSuperview];
        replyBtn = nil;
    }
}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    YMTableViewCell *cell = (YMTableViewCell*)[mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:cellStamp]];
    [cell setYMViewWith:ymD];
    [mainTable reloadData];
}

-(void)didHeadPicPressForIndex:(NSInteger)index{
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"didPromulgatorPressForIndex:name:")]) {
		[self.delegate didPromulgatorPressForIndex:index name:@""];
	}
}

-(void)didPromulgatorNameOrHeadPicPressedForIndex:(NSInteger)index name:(NSString *)name{
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"didPromulgatorPressForIndex:name:")]) {
		[self.delegate didPromulgatorPressForIndex:index name:name];
	}
}

-(void)didRichTextPress:(NSString *)text index:(NSInteger)index{
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"didRichTextPressedFromText:index:")]) {
		[self.delegate didRichTextPressedFromText:text index:index];
	}
}

-(void)didRichTextPress:(NSString *)text index:(NSInteger)index replyIndex:(NSInteger)replyIndex{
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"didRichTextPressedFromText:index:replyIndex:")]) {
		[self.delegate didRichTextPressedFromText:text index:index replyIndex:replyIndex];
	}
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
		[[self navigationController] setNavigationBarHidden:NO animated:YES];
        [UIView animateWithDuration:0.5f animations:^{
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    NSLog(@"评论说说回调");
    
    NSString *newString = [NSString stringWithFormat:@"@%@:%@",[[self delegate] senderName],replyText];//此处可扩展。已写死，包括内部逻辑也写死 在YMTextData里 自行添加部分
    YMTableViewCell *cell = (YMTableViewCell*)[mainTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:inputTag]];
    YMTextData *ymData = [cell getYMTextData];
    [ymData.replyDataSource addObject:newString];
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedData removeAllObjects];
    
    NSString *rangeStr = NSStringFromRange(NSMakeRange(0, [[self delegate] senderName].length));
    NSMutableArray *rangeArr = [[NSMutableArray alloc] init];
    [rangeArr addObject:rangeStr];
    [ymData.defineAttrData addObject:rangeArr];
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [cell setYMViewWith:ymData];
    [mainTable reloadData];
	if ([self.delegate respondsToSelector:NSSelectorFromString(@"replyForIndex:replyText:")]) {
		[self.delegate replyForIndex:inputTag replyText:replyText];
	}
    
}

- (void)destorySelf{
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
}


- (void)dealloc{
   
}



@end
