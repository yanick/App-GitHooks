#!perl

use strict;
use warnings;

use App::GitHooks;
use App::GitHooks::Test;
use App::GitHooks::Utils;
use Test::Exception;
use Test::FailWarnings -allow_deps => 1;
use Test::Git;
use Test::More;


# Require git.
has_git( '1.7.4.1' );

# List of tests to run.
my $tests =
[
	{
		name     => 'Comma-separated project prefixes.',
		config   => "project_prefixes = OPS, DEV\n",
		expected => [ 'OPS', 'DEV' ],
	},
	{
		name     => 'Space-separated project prefixes.',
		config   => "project_prefixes = OPS DEV\n",
		expected => [ 'OPS', 'DEV' ],
	},
	{
		name     => 'Multiple-spaces-separated project prefixes.',
		config   => "project_prefixes = OPS,    DEV,  TEST\n",
		expected => [ 'OPS', 'DEV', 'TEST' ],
	},
	{
		name     => 'Leading and trailing whitespace.',
		config   => "project_prefixes =    OPS, DEV     \n",
		expected => [ 'OPS', 'DEV' ],
	},
];

# Declare tests.
plan( tests => scalar( @$tests + 1 ) );

# Make sure the function exists before we start.
can_ok(
	'App::GitHooks::Utils',
	'get_project_prefixes',
);

# Run each test in a subtest.
foreach my $test ( @$tests )
{
	subtest(
		$test->{'name'},
		sub
		{
			plan( tests => 4 );

			# Set up githooks config.
			App::GitHooks::Test::ok_reset_githooksrc(
				content => $test->{'config'},
			);

			ok(
				defined(
					my $app = App::GitHooks->new(
						arguments => [],
						name      => 'commit-msg',
					)
				),
				'Instantiate a new App::GitHooks object.',
			);

			my $prefixes;
			lives_ok(
				sub
				{
					$prefixes = App::GitHooks::Utils::get_project_prefixes( $app );
				},
				'Retrieve the project prefixes.',
			);

			is_deeply(
				$prefixes,
				$test->{'expected'},
				'Compare the output and expected results.',
			) || diag( explain( $prefixes ) );
		}
	);
}
