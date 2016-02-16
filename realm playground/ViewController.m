//
//  ViewController.m
//  realm playground
//
//  Created by jason9075 on 2016/2/15.
//  Copyright (c) 2016 jason9075. All rights reserved.
//


#import <Realm/Realm/RLMResults.h>
#import "ViewController.h"
#import "dbTableCell.h"
#import "MASConstraintMaker.h"
#import "View+MASAdditions.h"
#import "ArticleData.h"
#import "Realm/RLMRealm.h"
#import "Realm/RLMArray.h"

@interface ViewController ()

@property(strong, nonatomic) RLMRealm *realm;

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UITextField *titleTextfield;
@property(strong, nonatomic) UITextField *subtitleTextfield;

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (!self) return nil;

    _realm = [RLMRealm defaultRealm];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    _titleTextfield = [UITextField new];
    _subtitleTextfield = [UITextField new];
    UIButton *addButton = [UIButton new];
    UIButton *deleteButton = [UIButton new];

    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60;
    [self.tableView setAllowsMultipleSelection:YES];
    [self.tableView registerClass:(Class) dbTableCell.self forCellReuseIdentifier:@"dbCell"];

    [self.titleTextfield setBackgroundColor:[UIColor whiteColor]];

    [self.subtitleTextfield setBackgroundColor:[UIColor whiteColor]];

    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [addButton setBackgroundColor:[UIColor orangeColor]];
    [addButton addTarget:self action:@selector(onAddButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

    [deleteButton setTitle:@"Del" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [deleteButton setBackgroundColor:[UIColor redColor]];
    [deleteButton addTarget:self action:@selector(onDeleteButtonTouched:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.titleTextfield];
    [self.view addSubview:self.subtitleTextfield];
    [self.view addSubview:addButton];
    [self.view addSubview:deleteButton];
    [self.view addSubview:self.tableView];


    [self.titleTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(8);
        make.top.mas_equalTo(24);
        make.trailing.mas_equalTo(-8);
    }];

    [self.subtitleTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.titleTextfield);
        make.top.mas_equalTo(self.titleTextfield.mas_bottom).offset(4);
        make.trailing.mas_equalTo(self.titleTextfield);
    }];

    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleTextfield.mas_bottom).offset(4);
        make.trailing.mas_equalTo(deleteButton.mas_leading).offset(-4);
        make.width.mas_equalTo(80);
    }];

    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.subtitleTextfield.mas_bottom).offset(4);
        make.trailing.mas_equalTo(self.subtitleTextfield);
        make.width.mas_equalTo(80);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addButton.mas_bottom).offset(4);
        make.leading.trailing.bottom.mas_equalTo(0);
    }];

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    RLMResults *persons = [ArticleData allObjects];
    return persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    dbTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dbCell"];
    RLMResults *persons = [ArticleData allObjects];

    ArticleData *person = persons[(NSUInteger) indexPath.row];
    cell.titleLabel.text = person.title;
    cell.subtitleLabel.text = person.subtitle;

    return cell;
}

#pragma mark - Actions

- (void)onAddButtonTouched:(id)sender {
    if ([self.titleTextfield.text isEqualToString:@""] || [self.subtitleTextfield.text isEqualToString:@""])
        return;

    ArticleData *person = [[ArticleData alloc] init];

    person.id = (NSNumber <RLMInt> *) @([[NSDate date] timeIntervalSince1970]);
    person.title = self.titleTextfield.text;
    person.subtitle = self.subtitleTextfield.text;

    [self.realm transactionWithBlock:^{
        [self.realm addOrUpdateObject:person];
    }];

    [self.tableView reloadData];
}

- (void)onDeleteButtonTouched:(id)sender {
    NSArray<NSIndexPath *> *selectedIndexPath = self.tableView.indexPathsForSelectedRows;

    RLMResults *persons = [ArticleData allObjects];
    RLMArray *toDeletePersons = [[RLMArray alloc] initWithObjectClassName:[ArticleData className]];
    for (int i = 0; i < [persons count]; i++) {
        if ([selectedIndexPath containsObject:[NSIndexPath indexPathForRow:i inSection:0]]){
            [toDeletePersons addObject:persons[(NSUInteger) i]];
        }
    }

    [self.realm transactionWithBlock:^{
        [self.realm deleteObjects:toDeletePersons];
    }];
    [self.tableView reloadData];
}


@end