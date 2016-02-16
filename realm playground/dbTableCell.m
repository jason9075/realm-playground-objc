//
// Created by jason9075 on 2016/2/15.
// Copyright (c) 2016 ___FULLUSERNAME___. All rights reserved.
//

#import "dbTableCell.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"


@implementation dbTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [UILabel new];
        self.subtitleLabel = [UILabel new];

        [self addSubview:self.titleLabel];
        [self addSubview:self.subtitleLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.leading.mas_equalTo(@21).priority(999);
            make.trailing.mas_equalTo(@-20).priority(999);
        }];

        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
            make.leading.mas_equalTo(@21).priority(999);
            make.trailing.mas_equalTo(@-20).priority(999);
        }];
    }
    return self;
}

@end