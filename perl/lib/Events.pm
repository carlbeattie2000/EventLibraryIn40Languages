package Events;
use lib './';
use Event;

sub new {
  my $class = shift;
  my $self = bless {
    events => {}
  }, $class;

  return $self;
}

sub new_event {
  my $self = shift;
  my ( $name, $source ) = @_;

  my $event = Event->new($self, $name, $source);
  my %event_hash = %{$self->{events}};

  $events_hash{$name} = $event;

  return $event;
}

sub emit {
  my $self = shift;
  my $name = shift;
  my %event_hash = %{$self->{events}};

  if (!exists $events_hash{$name}) {
    return;
  }

  $event = $events_hash{$name};
  $event->trigger(@_);
}

sub remove {
  my ( $self, $key ) = @_;
  my %event_hash = %{$self->{events}};
  my $event = $events_hash{$key};
  $event->remove($event);

  return delete $events_hash{$key}
}

sub event_names {
  my $self = shift;
  my %event_hash = %{$self->{events}};
  @event_names = ();

  for (keys %event_hash) {
    $event = $event_hash{$_};
    if ($event->listeners_count() > 0) {
      push @event_names, $event->name();
    }
  }

  return @event_names;
}

1;
