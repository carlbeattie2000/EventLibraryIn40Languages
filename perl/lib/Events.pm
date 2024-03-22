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

  $self->{events}{$name} = $event;

  return $event;
}

sub emit {
  my $self = shift;
  my $name = shift;

  if (!exists $self->{events}{$name}) {
    return;
  }

  $event = $self->{events}{$name};
  $event->trigger(@_);
}

sub remove {
  my ( $self, $key ) = @_;

  if (!exists $self->{events}{$key}) {
    return;
  }
  my $event = $self->{events}{$key};
  $event->remove($event);

  return delete $self->{events}{$key};
}

sub event_names {
  my $self = shift;
  @event_names = ();

  for (keys %{$self->{events}}) {
    $event = $self->{events}{$_};
    if ($event->listeners_count() > 0) {
      push @event_names, join '', $event->name(), "\n";
    }
  }

  return @event_names;
}

1;
