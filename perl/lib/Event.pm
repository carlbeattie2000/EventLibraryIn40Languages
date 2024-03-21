package Event;
use lib './';
use EventMessage;

sub new {
  $class = shift;

  my ( $producer, $name, $source ) = @_;
  my $timestamp = localtime(time);
  my @listeners = ();

  my $self = bless {
    name => $name,
    timestamp => $timestamp,
    max_listeners => 10,
    listeners_count => 0,
    listeners => \@listeners,
    id => 0,
    source => $source,
    valid => 1,
  }, $class;

  return $self;
}

sub is_valid {
  my $self = shift;
  if (!$self->{valid}) {
    warn("Invalid Object\n");
    return 0;
  }
  return 1;
}

# Event Data
sub name {
  $self = shift;
  return if !$self->is_valid();
  return $self->{name};
}

sub timestamp {
  $self = shift;
  return if !$self->is_valid();
  return $self->{timestamp}
}

sub id {
  my $self = shift;
  return if !$self->is_valid();
  return $self->{id}++;
}

sub source {
  my $self = shift;
  return if !$self->is_valid();
  return $self->{source};
}

sub producer {
  my $self = shift;
  return if !$self->is_valid();
  return $self->{producer};
}

# Listeners
sub set_max_listeners {
  my $self = shift;
  return if !$self->is_valid();

  if (@_) {
    $self->{max_listeners} = shift;
  }
}

sub max_listeners {
  my $self = shift;
  return if !$self->is_valid();

  return $self->{max_listeners};
}

sub listeners_count {
  my $self = shift;
  return if !$self->is_valid();

  return $self->{listeners_count};
}

# Adding/removing listeners
sub listen {
  my $self = shift;
  return if !$self->is_valid();
  if ($self->listeners_count() >= $self->max_listeners()) {
    warn("Max Listeners Reached!");
    return
  }
  my $method = shift;
  push @{$self->{listeners}}, {
    method => $method,
    once => 0
  };
  $self->{listeners_count}++;
}

sub listen_once {
  my $self = shift;
  return if !$self->is_valid();
  if ($self->listeners_count() >= $self->max_listeners()) {
    warn("Max Listeners Reached!");
    return;
  }
  my $method = shift;
  push @{$self->{listeners}}, {
    method => $method,
    once => 1
  };
  $self->{listeners_count}++;
}

sub remove {
  my $self = shift;
  my $event_ref = shift;

  return if !$self->is_valid();
  return if $event_ref && $event_ref != $self;

  $self->remove_all_listeners();
  $self->{valid} = 0;

  if (!event_ref) {
    $self->producer()->remove();
  }
}

sub remove_listener {
  my $self = shift;
  return if !$self->is_valid();
  my $listener = shift;

  for (my $i = 0; $i < @{$self->{listeners}}; $i++) {
    my %listener = %{$self->{listeners}[$i]};
    if ($listener{method} == $listener) {
      splice(@{$self->{listeners}}, $i, 1);
      return;
    }
  }
}

sub remove_all_listeners {
  my $self = shift;
  return if !$self->is_valid();

  splice(@{$self->{listeners}}, 0, @{$self->{listeners}});
}

sub prepend_listener {
  my $self = shift;
  return if !$self->is_valid();
  if ($self->listeners_count() >= $self->max_listeners()) {
    warn("Max Listeners Reached!");
    return;
  }
  my $method = shift;
  unshift @{$self->{listeners}}, {
    method => $method,
    once => 0
  };
  $self->{listeners_count}++;
}

sub prepend_once_listener {
  my $self = shift;
  return if !$self->is_valid();
  if ($self->listeners_count() >= $self->max_listeners()) {
    warn("Max Listeners Reached!");
    return;
  }
  my $method = shift;
  unshift @{$self->{listeners}}, {
    method => $method,
    once => 0
  };
  $self->{listeners_count}++;
}

sub trigger {
  my $self = shift;
  return if !$self->is_valid();
  my $index = 0;

  foreach (@{$self->{listeners}}) {
    my %listener = %{$_};
    my $message = EventMessage->new($self, shift, shift, @_);
    if ($listener{once}) {
      splice(@{$self->{listeners}}, $index, 1);
    }
    $listener{method}($message);
    $index++;
  }
}

1;
