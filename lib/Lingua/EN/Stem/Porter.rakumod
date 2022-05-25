my regex c {                  # A consonant
    [
    || <-[aeiou]>             # not any of "aeiou" and
    || <?after <[aeiou]>> y   # "y" only if preceded by "aeiou"
    || << y                   # or if at the start of a word
    ]
}

my regex C { <c>+ } # Consonant cluster

my regex V { <v>+ } # Vowel cluster

my regex v {                  # A vowel
    [
    || <[aeiou]>              # "aeiou" and
    || [<!after <[aeiou]>> y] # "y" if not preceded by a "aeiou"
    ]
}

my regex mgt0 {
    ^
    [<c>+]?
    [<v>+ <c>+] ** 1..*
    [<v>+]?
    $
}
my regex mgt1 {
    ^
    [<c>+]?
    [<v>+ <c>+] ** 2..*
    [<v>+]?
    $
}
my regex meq1 {
    ^
    [<c>+]?
    [<v>+ <c>+] ** 1
    [<v>+]?
    $
}

my constant %step2hash =
  ational  => "ate",
  tional   => "tion",
  enci     => "ence",
  anci     => "ance",
  izer     => "ize",
  bli      => "ble",
  alli     => "al",
  entli    => "ent",
  eli      => "e",
  ousli    => "ous",
  ization  => "ize",
  ation    => "ate",
  ator     => "ate",
  alism    => "al",
  iveness  => "ive",
  fulness  => "ful",
  ousness  => "ous",
  aliti    => "al",
  iviti    => "ive",
  biliti   => "ble",
  logi     => "log",
;

my constant %step3hash = 
  icate => 'ic',
  ative => '',
  alize => 'al',
  iciti => 'ic',
  ical  => 'ic',
  ful   => '',
  ness  => '',
;

#| This subroutine uses the Porter stemming algorithm to stem a given word
sub porter(
  Str:D $word is copy #= The word to be stemmed
--> Str:D) is export {

    if $word.chars > 2 {
        # Step 1a
        if $word ~~ /[(ss||i)es||(<-[s]>)s]$/ {
            $word = $/.prematch ~ $0;
        }

        # Step 1b
        if $word ~~ /eed$/ {
            if $/.prematch ~~ /<mgt0>/ {
                $word .= chop;
            }
        }
        elsif $word ~~ /(ed||ing)$/ {
            my $stem = $/.prematch;
            if $stem ~~ /<v>/ {
                $word = $stem;
                if    $word ~~ /[at||bl||iz]$/         { $word ~= "e"; }
                elsif $word ~~ /(<-[aeiouylsz]>)$0$/   { $word .= chop; }
                elsif $word ~~ /^<C><v><-[aeiouwxy]>$/ { $word ~= "e"; }
            }
        }

        # Step 1c
        if $word ~~ /y$/ {
            my $stem = $/.prematch;
            if $stem ~~ /<v>/ {
                $word = $stem ~ "i";
            }
        }

        # Step 2
        if $word ~~ /(
          ational||tional||enci||anci||izer||bli||alli||entli||eli||ousli||ization
            ||ation||ator||alism||iveness||fulness||ousness||aliti||iviti||biliti||logi
        )$/ {
            my $stem   = $/.prematch;
            my $suffix = ~$0;
            if $stem ~~ /<mgt0>/ {
                $word = $stem ~ %step2hash{$suffix};
            }
        }

        # Step 3
        if $word ~~ /(icate||ative||alize||iciti||ical||ful||ness)$/ {
            my $stem   = $/.prematch;
            my $suffix = ~$0;
            if $stem ~~ /<mgt0>/ {
                $word = $stem ~ %step3hash{$suffix};
            }
        }

        # Step 4
        if $word ~~ /(
          al||ance||ence||er||ic||able||ible||ant||ement||ment||ent||ou
          ||ism||ate||iti||ous||ive||ize
        )$/ {
            my $stem = $/.prematch;
            if $stem ~~ /<mgt1>/ {
                $word = $stem;
            }
        }
        elsif $word ~~ /(s||t)(ion)$/ {
            my $stem = $/.prematch ~ $0;
            if $stem ~~ /<mgt1>/ {
                $word = $stem;
            }
        }

        # Step 5
        if $word ~~ /e$/ {
            my $stem = $/.prematch;
            if $stem ~~ /<mgt1>/
              || ($stem ~~ /<meq1>/ && not $stem ~~ /^<C><v><-[aeiouwxy]>$/) {
                $word = $stem;
            }
        }
        if $word ~~ /ll$/ && $word ~~ /<mgt1>/ {
            $word .= chop;
        }
    }
    $word
}

=begin pod

=head1 NAME

Lingua::EN::Stem::Porter - Implementation of the Porter stemming algorithm

=head1 SYNOPSIS

=begin code :lang<raku>

use Lingua::EN::Stem::Porter;

say porter("establishment");  # establish

=end code

=head1 DESCRIPTION

Lingua::EN::Stem::Porter implements the Porter stemming algorithm by
exporting a single subroutone C<porter> which takes an English word and
returns the stem given by the Porter algorithm.

=head1 AUTHOR

John Spurr

=head1 COPYRIGHT AND LICENSE

Copyright 2016 John Spurr

Copyright 2017 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the MIT License 2.0.

=end pod

# vim: expandtab shiftwidth=4
