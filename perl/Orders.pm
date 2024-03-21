package Orders;

my $textDocument;
open($textDocument, "<", "../example_orders.txt");

my @lines = <$textDocument>;

our @orders;

1;
