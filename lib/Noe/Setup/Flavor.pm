package Noe::Setup::Flavor;
use strict;
use warnings;
use base 'Module::Setup::Flavor';


1;

__DATA__

---
file: Makefile.PL
template: |
  use inc::Module::Install;
  name '[% dist %]';
  all_from 'lib/[% module_unix_path %].pm';

  # requires '';

  tests 't/*.t';
  author_tests 'xt';

  test_requires 'Test::More';
  auto_set_repository;
  auto_include;
  WriteAll;
---
file: t/00_compile.t
template: |
  use strict;
  use Test::More tests => 1;

  BEGIN { use_ok '[% module %]' }
---
file: xt/01_podspell.t
template: |
  use Test::More;
  eval q{ use Test::Spelling };
  plan skip_all => "Test::Spelling is not installed." if $@;
  add_stopwords(map { split /[\s\:\-]/ } <DATA>);
  $ENV{LANG} = 'C';
  all_pod_files_spelling_ok('lib');
  __DATA__
  [% config.author %]
  [% config.email %]
  [% module %]
---
file: xt/02_perlcritic.t
template: |
  use strict;
  use Test::More;
  eval {
      require Test::Perl::Critic;
      Test::Perl::Critic->import( -profile => 'xt/perlcriticrc');
  };
  plan skip_all => "Test::Perl::Critic is not installed." if $@;
  all_critic_ok('lib');
---
file: xt/03_pod.t
template: |
  use Test::More;
  eval "use Test::Pod 1.00";
  plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
  all_pod_files_ok();
---
file: xt/perlcriticrc
template: |
  [TestingAndDebugging::ProhibitNoStrict]
  allow=refs
---
file: Changes
template: |
  Revision history for Perl extension [% module %]

  0.01    [% localtime %]
          - original version
---
file: lib/____var-module_path-var____.pm
template: |
  package [% module %];
  use base 'Noe';
  use strict;
  use warnings;
  our $VERSION = '0.01';

  1;
  __END__

  =head1 NAME

  [% module %] -

  =head1 SYNOPSIS

    use [% module %];

  =head1 DESCRIPTION

  [% module %] is

  =head1 AUTHOR

  [% config.author %] E<lt>[% config.email %]E<gt>

  =head1 SEE ALSO

  =head1 LICENSE

  This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.

  =cut
---
file: lib/____var-module_path-var____/Dispatcher.pm
template: |
  package [% module %]::Dispatcher;
  use strict;
  use warnings;
  use Noe::Dispatcher;

  connect '' => { controller => 'Root', action => 'index' };

  1;
---
file: lib/____var-module_path-var____/Controller/Root.pm
template: |
  package [% module %]::Controller::Root;
  use strict;
  use warnings;

  sub index {
      my ( $self, $c  ) = @_;
      $c->render('index', { message => $c->config->{message} } );
  }

  1;
---
file: MANIFEST.SKIP
template: |
  \bRCS\b
  \bCVS\b
  ^MANIFEST\.
  ^Makefile$
  ~$
  ^#
  \.old$
  ^blib/
  ^pm_to_blib
  ^MakeMaker-\d
  \.gz$
  \.cvsignore
  ^t/9\d_.*\.t
  ^t/perlcritic
  ^tools/
  \.svn/
  ^[^/]+\.yaml$
  ^[^/]+\.pl$
  ^\.shipit$
  ^\.git/
  \.sw[po]$
---
file: README
template: |
  This is Web Application [% module %].

  TEST APPLICATION

  Run noe-server script on your application directory.

      % noe-server

  DOCUMENTATION

  [% module %] documentation is available as in POD. So you can do:

      % perldoc [% module %]

  to read the documentation online with your favorite pager.

  [% config.author %]
---
config:
  plugins:
    - Config::Basic
    - Template

