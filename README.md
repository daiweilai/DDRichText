# DDRichText
This Framework is forked from https://github.com/TigerWf/WFCoretext . Just like Weixin Moment and Weibo RichText. On the base of original lib, Add many new features and make it easier to use

Demo Snapshot  
----------------------------------- 
![github](https://github.com/daiweilai/DDRichText/blob/master/DDRichTextGif.gif "github")

Setup
----------------------------------- 
#### CocoaPods
With CocoaPods you can simply add `DDRichText` in your Podfile:
```
pod 'DDRichText', '~> 1.0.0'
```
#### Source File
* Copy DDRichTextLib to your project
* When you want to use DDRichText just like that
		
		#import "DDRichTextViewController.h"
		
* Enjoy it

Using
----------------------------------- 
* Firstly, you should create a viewController and let it inherit DDRichTextViewController and implement DDRichTextViewDataSource,DDRichTextViewDelegate
* Secondly, in your viewController add 
		
		self.delegate = self;
		self.dataSource = self;
		
*Thirdly you need to create an data model inherit YMTextData
		
		YMTextData *ymData = [[YMTextData alloc] init];
		ymData.showImageArray = _imageDataSource;
		 ymData.foldOrNot = YES;
		ymData.showShuoShuo = @"this is contents";
		ymData.replyDataSource = _replyDataSource;
		ymData.name = @"David";
		ymData.intro = @"2015-2-8";
		ymData.headPic = [UIImage imageNamed:@"1.png"];
		
		 
* At last finish the dataSource and delegate methods just like the using of UITableView
		
		//@required
		-(YMTextData *)dataForRowAtIndex:(NSInteger)index{
		return [ymDataArray objectAtIndex:0];
		}
		
		-(NSInteger)numberOfRowsInDDRichText{
		return 5;
		}
		
		-(NSString *)senderName{
		return @"David";
		}
		
		//@optional
		-(BOOL)hideReplyButtonForIndex:(NSInteger)index;//hide replyButton
		-(void)didPromulgatorPressForIndex:(NSInteger)index name:(NSString*)name;//the publisher head was being pressed
		-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index;//the contents was being pressed
		-(void)didRichTextPressedFromText:(NSString*)text index:(NSInteger)index replyIndex:(NSInteger)replyIndex;//the reply was being pressed
		-(void)replyForIndex:(NSInteger)index replyText:(NSString*)text;//reply text callback		
		


Created By
------------
* David Day(daiweilai)

License  
----------------------------------- 
Copyright David Day(daiweilai)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
