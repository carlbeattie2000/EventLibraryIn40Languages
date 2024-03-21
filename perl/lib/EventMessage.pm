package EventMessage;

sub new {
  my $class = shift;
  my $producer = shift;
  my $id = join '', $producer->id(), '-', $producer->source();

  my $type = shift;
  my $data_content_type = shift;
  my @data = @_;

  my $self = bless {
    id => $id,
    type => $type,
    data => $data,
    data_content_type => $data_content_type,
    source => $producer->source(),
    time => localtime(time),
  }, $class;

  return $self;
}

sub id {
  my $self = shift;

  return $self->{id};
}

sub type {
  my $self = shift;

  return $self->{type};
}

sub data {
  my $self = shift;

  return $self->{data};
}

sub data_content_type {
  my $self = shift;

  return $self->{data_content_type};
}

sub source {
  my $self = shift;

  return $self->{source};
}

sub time {
  my $self = shift;

  return $self->{time};
}

1;
