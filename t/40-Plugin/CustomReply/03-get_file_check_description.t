#!perl

use strict;
use warnings;

use App::GitHooks::Plugin::Test::CustomReply;
use Test::Exception;
use Test::FailWarnings -allow_deps => 1;
use Test::Git;
use Test::More;
use Test::Type;


# Require git.
has_git( '1.7.4.1' );
plan( tests => 3 );

can_ok(
	'App::GitHooks::Plugin::Test::CustomReply',
	'get_file_check_description',
);

my $file_check_description;
lives_ok(
	sub
	{
		 $file_check_description = App::GitHooks::Plugin::Test::CustomReply->get_file_check_description();
	},
	'Retrieve the description.',
);

ok_string(
	$file_check_description,
	name        => 'The description',
	allow_empty => 0,
);
