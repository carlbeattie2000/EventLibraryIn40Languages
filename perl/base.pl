#!/usr/bin/perl -w
use warnings;
use strict;

use lib './';
use lib './lib/';
use Events;
use Orders;

my $events = Events->new();
my $startedEvent = $events->new_event("started", "order_client");
my $endedEvent = $events->new_event("ended", "order_client");

sub print_event_id {
  my $data = shift;

  print(join '', $data->id(), "\n");
}

sub print_event_source {
  my $data = shift;

  print($data->source(), "\n");
}

$startedEvent->listen(\&print_event_id);
$endedEvent->listen(\&print_event_id);

print($events->event_names());
