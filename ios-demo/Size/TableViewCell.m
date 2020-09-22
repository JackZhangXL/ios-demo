//
//  TableViewCell.m
//  ios-demo
//
//  Created by 张歆琳 on 2020/9/22.
//  Copyright © 2020 张歆琳. All rights reserved.
//

#import "TableViewCell.h"
#import "Screen.h"

@interface TableViewCell ()
@property(nonatomic, strong, readwrite) UILabel *titleLabel;
@property(nonatomic, strong, readwrite) UILabel *sourceLabel;
@property(nonatomic, strong, readwrite) UILabel *commentLabel;
@property(nonatomic, strong, readwrite) UILabel *timeLabel;
@property(nonatomic, strong, readwrite) UIImageView *rightImageView;
@property(nonatomic, strong, readwrite) UIButton *deleteButton;
@end

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self.contentView addSubview:({
//            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 270, 50)];
//            self.titleLabel.font = [UIFont systemFontOfSize:16];
            self.titleLabel = [[UILabel alloc] initWithFrame:UIRect(20, 0, 270, 50)];
            self.titleLabel.font = [UIFont systemFontOfSize:UI(16)];
            self.titleLabel.textColor = [UIColor blackColor];
            self.titleLabel.numberOfLines = 2;
            self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//            self.titleLabel.backgroundColor = [UIColor yellowColor];
            self.titleLabel.text = @"在成都开的这个会 让蓬佩奥气到肝疼？";
            self.titleLabel;
        })];

        [self.contentView addSubview:({
//            self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 80, 20)];
//            self.sourceLabel.font = [UIFont systemFontOfSize:12];
            self.sourceLabel = [[UILabel alloc] initWithFrame:UIRect(20, 70, 80, 20)];
            self.sourceLabel.font = [UIFont systemFontOfSize:UI(12)];
            self.sourceLabel.textColor = [UIColor grayColor];
//            self.sourceLabel.backgroundColor = [UIColor greenColor];
            self.sourceLabel.text = @"中国经济网";
            self.sourceLabel;
        })];

        [self.contentView addSubview:({
//            self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 50, 20)];
//            self.commentLabel.font = [UIFont systemFontOfSize:12];
            self.commentLabel = [[UILabel alloc] initWithFrame:UIRect(100, 70, 50, 20)];
            self.commentLabel.font = [UIFont systemFontOfSize:UI(12)];
            self.commentLabel.textColor = [UIColor grayColor];
//            self.commentLabel.backgroundColor = [UIColor redColor];
            self.commentLabel.text = @"评论210";
            self.commentLabel;
        })];

        [self.contentView addSubview:({
//            self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 70, 50, 20)];
//            self.timeLabel.font = [UIFont systemFontOfSize:12];
            self.timeLabel = [[UILabel alloc] initWithFrame:UIRect(150, 70, 50, 20)];
            self.timeLabel.font = [UIFont systemFontOfSize:UI(12)];
            self.timeLabel.textColor = [UIColor grayColor];
//            self.timeLabel.backgroundColor = [UIColor blueColor];
            self.timeLabel.text = @"3小时前";
            self.timeLabel;
        })];
        
        [self.contentView addSubview:({
//            self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(300, 15, 100, 70)];
            self.rightImageView = [[UIImageView alloc] initWithFrame:UIRect(300, 15, 100, 70)];
            self.rightImageView.contentMode = UIViewContentModeScaleToFill;
            self.rightImageView.image = [UIImage imageNamed:@"icon.bundle/news.jpeg"];
            self.rightImageView;
        })];
        
//        [self.contentView addSubview:({
//            self.rightImageView = [[UIImageView alloc] initWithFrame:UIRect(250, 50, 16, 16)];
//            self.rightImageView.contentMode = UIViewContentModeScaleToFill;
//            self.rightImageView.image = [UIImage imageNamed:@"icon.bundle/add@2x.png"];
//            self.rightImageView;
//        })];
//
//        [self.contentView addSubview:({
//            self.rightImageView = [[UIImageView alloc] initWithFrame:UIRect(250, 70, 16, 16)];
//            self.rightImageView.contentMode = UIViewContentModeScaleToFill;
//            self.rightImageView.image = [UIImage imageNamed:@"icon.bundle/add@3x.png"];
//            self.rightImageView;
//        })];
        
        [self.contentView addSubview:({
            self.rightImageView = [[UIImageView alloc] initWithFrame:UIRect(250, 50, 16, 16)];
            self.rightImageView.contentMode = UIViewContentModeScaleToFill;
//            方案二：根据分辨率来适配
//            self.rightImageView.image = [UIScreen mainScreen].scale == 2 ? [UIImage imageNamed:@"icon.bundle/add@2x.png"] : [UIImage imageNamed:@"icon.bundle/add@3x.png"];

//            方案三：用 Assets.xcassets 来自动适配
            self.rightImageView.image = [UIImage imageNamed:@"add2.png"];
            self.rightImageView;
        })];
    }
    return self;
}

@end
