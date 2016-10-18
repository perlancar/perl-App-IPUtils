package App::IPUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Utilities related to IP address',
};

my %common_args = (
    args => {
        'x.name.is_plural' => 1,
        'x.name.singular' => 'arg',
        schema => ['array*', of=>'str*'],
        req => 1,
        pos => 0,
        greedy => 1,
    },
);

$SPEC{is_ipv4} = {
    v => 1.1,
    summary => "Check if arguments are IPv4 addresses",
    args => {
        %common_args,
    },
    examples => [
        {
            summary => 'Single argument',
            args => {args=>['127.0.0.1']},
        },
        {
            summary => 'Single argument (2)',
            args => {args=>['255.255.255.256']},
        },
        {
            summary => 'Multiple arguments',
            args => {args=>['127.0.0.1', '255.255.255.256']},
        },
    ],
};
sub is_ipv4 {
    require Regexp::IPv4;

    my %args = @_;
    my $args = $args{args};

    my $re = qr/\A$Regexp::IPv4::IPv4_re\z/;

    my @rows;
    for my $arg (@$args) {
        push @rows, {
            arg => $arg,
            is_ipv4 => $arg =~ $re ? 1:0,
        };
    }

    if (@rows > 1) {
        [200, "OK", \@rows, {'table.fields' => [qw/arg is_ipv4/]}];
    } else {
        [200, "OK", $rows[0]{is_ipv4},
         {'cmdline.exit_code' => $rows[0]{is_ipv4} ? 0:1}];
    }
}

$SPEC{is_ipv6} = {
    v => 1.1,
    summary => "Check if arguments are IPv6 addresses",
    args => {
        %common_args,
    },
    examples => [
        {
            summary => 'Single argument',
            args => {args=>['::1']},
        },
        {
            summary => 'Single argument (2)',
            args => {args=>['x']},
        },
        {
            summary => 'Multiple arguments',
            args => {args=>['::1', '127.0.0.1', 'x']},
        },
    ],
};
sub is_ipv6 {
    require Regexp::IPv6;

    my %args = @_;
    my $args = $args{args};

    my $re = qr/\A$Regexp::IPv6::IPv6_re\z/;

    my @rows;
    for my $arg (@$args) {
        push @rows, {
            arg => $arg,
            is_ipv6 => $arg =~ $re ? 1:0,
        };
    }

    if (@rows > 1) {
        [200, "OK", \@rows, {'table.fields' => [qw/arg is_ipv6/]}];
    } else {
        [200, "OK", $rows[0]{is_ipv6},
         {'cmdline.exit_code' => $rows[0]{is_ipv6} ? 0:1}];
    }
}

$SPEC{is_ip} = {
    v => 1.1,
    summary => "Check if arguments are IP (v4 or v6) addresses",
    args => {
        %common_args,
    },
    examples => [
        {
            summary => 'Single argument',
            args => {args=>['::1']},
        },
        {
            summary => 'Single argument (2)',
            args => {args=>['x']},
        },
        {
            summary => 'Multiple arguments',
            args => {args=>['::1', '127.0.0.1', 'x']},
        },
    ],
};
sub is_ip {
    require Regexp::IPv4;
    require Regexp::IPv6;

    my %args = @_;
    my $args = $args{args};

    my $re_v4 = qr/\A$Regexp::IPv4::IPv4_re\z/;
    my $re_v6 = qr/\A$Regexp::IPv6::IPv6_re\z/;

    my @rows;
    for my $arg (@$args) {
        my $is_ipv4 = $arg =~ $re_v4 ? 1:0;
        my $is_ipv6 = $arg =~ $re_v6 ? 1:0;
        push @rows, {
            arg => $arg,
            is_ipv4 => $is_ipv4,
            is_ipv6 => $is_ipv6,
            is_ip   => $is_ipv4 || $is_ipv6 ? 1:0,
        };
    }

    if (@rows > 1) {
        [200, "OK", \@rows,
         {'table.fields' => [qw/arg is_ipv4 is_ipv6 is_ip/]}];
    } else {
        [200, "OK", $rows[0]{is_ip},
         {'cmdline.exit_code' => $rows[0]{is_ip} ? 0:1}];
    }
}

1;
# ABSTRACT:

=head1 DESCRIPTION

This distribution includes several utilities:

#INSERT_EXECS_LIST
