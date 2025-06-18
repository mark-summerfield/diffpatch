#!/usr/bin/env tclsh9
# Copyright © 2025 Mark Summerfield. All rights reserved.

tcl::tm::path add [file normalize [file dirname [info script]]]

package require diffpatch
package require struct::list 1

proc test1 {} {
    set debug [expr {!$::argc}]
    lcs_check a $::ax $::ay $debug
    lcs_check b $::bx $::by $debug
    lcs_check c $::cx $::cy $debug
    lcs_check d $::dx $::dy $debug
}

proc lcs_check {name x y debug} {
    set delta [lcs_diff $x $y]
    set z [lcs_patch $x $delta]
    if {$debug} {
        puts "${name} ######################"
        puts "${name}x={$x}\n${name}y={$y}\ndelta={$delta}\n${name}z={$z}"
    }
    if {[struct::list equal $y $z]} {
        puts "***** OK   ${name}y == ${name}z *****"
    } else {
        puts "***** FAIL ${name}y != ${name}z *****"
    }
}

set ax {foo bar baz quux}
set ay {foo baz bar quux}
set bx {q a b x c d}
set by {a b y c d f}
set cx {the quick brown fox jumped over the lazy dogs}
set cy {the quick red fox jumped over the very busy dogs}
set dx {private Thread currentThread;}
set dy {private volatile Thread currentThread;}

test1
