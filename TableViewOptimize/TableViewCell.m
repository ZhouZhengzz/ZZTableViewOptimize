//
//  TableViewCell.m
//  TableViewOptimize
//
//  Created by zhouzheng on 2017/12/5.
//  Copyright © 2017年 zhouzheng. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface TableViewCell ()<UITextFieldDelegate>
{
    UIImageView *_imageView;
    UITextField *_textField;
}
@end
@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 150-20)];
        [self.contentView addSubview:_imageView];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 30)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)setModel:(ImageModel *)model {
    _model = model;
    if (model == nil) {
        _imageView.image = [UIImage imageNamed:@"shark"];
    }else {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"shark"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [model setIsLoad:YES];
        }];
    }
    _textField.text = [NSString stringWithFormat:@"%zd",model.index];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.delegate textFieldDidBeginEditing:self];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self endEditing:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
