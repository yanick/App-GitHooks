#!perl

use strict;
use warnings;

use App::GitHooks::CommitMessage;
use Test::Exception;
use Test::FailWarnings -allow_deps => 1;
use Test::Git;
use Test::More;


# Require git.
has_git( '1.7.4.1' );
plan( tests => 3 );

can_ok(
	'App::GitHooks::CommitMessage',
	'get_message',
);

my $message = "Test.\n\nThis is a test commit.";

ok(
	defined(
		my $commit_message = App::GitHooks::CommitMessage->new(
			app => bless( {}, 'App::GitHooks' ),
			message => $message,
		)
	),
	'Instantiate a new CommitMessage object.',
);

is(
	$commit_message->get_message(),
	$message,
	'get_message() returns the message originally provided.',
);
