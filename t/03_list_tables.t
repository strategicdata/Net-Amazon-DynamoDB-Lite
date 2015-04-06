use strict;
use Test::More 0.98;
use Time::Piece;
use Net::Amazon::DynamoDB::Lite;
use URI;

my $dynamo = Net::Amazon::DynamoDB::Lite->new(
    region     => 'ap-northeast-1',
    access_key => 'XXXXXXXXXXXXXXXXX',
    secret_key => 'YYYYYYYYYYYYYYYYY',
    uri => URI->new('http://localhost:8000'),
);

eval {
    $dynamo->list_tables;
};

my $t = localtime;
my $table = 'test_' . $t->epoch;
SKIP: {
    skip $@, 1 if $@;

    $dynamo->create_table($table, 5, 5, {id => 'HASH'}, {id => 'S'});
    $dynamo->create_table($table . '_2', 5, 5, {id => 'HASH'}, {id => 'S'});
    my $res = $dynamo->list_tables;
    is_deeply [sort @{$res}], [$table, $table . '_2'];
    $dynamo->delete_table($table);
    $dynamo->delete_table($table . '_2');
}


done_testing;

