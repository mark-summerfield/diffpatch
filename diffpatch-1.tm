# Copyright © 2025 Mark Summerfield. All rights reserved.

# returns a delta (a list of lists) which can be passed to lcs_patch
proc lcs_diff {old_lst new_lst} {
    set lcs [::struct::list longestCommonSubsequence $old_lst $new_lst]
    set delta [list]
    foreach d [::struct::list lcsInvert $lcs [llength $old_lst] \
                                             [llength $new_lst]] {
        lassign $d what left right
        switch $what {
            added {lappend delta [list i [lindex $left 0] \
                                         [lrange $new_lst {*}$right]]}
            deleted {lappend delta [list d $left]}
            changed {lappend delta [list r $left \
                                           [lrange $new_lst {*}$right]]}
        }
    }
    return $delta
}

# given old_lst and and lcs_diff delta reconstructs and returns new_lst
proc lcs_patch {old_lst delta} {
    set new_lst [lmap x $old_lst {expr {$x}}]
    foreach d $delta {
        lassign $d what left right
        #puts "DEBUG what='$what' left='$left' right='$right'"
        switch $what {
            i {set new_lst [linsert $new_lst $left {*}$right]}
            d {set new_lst [lremove $new_lst {*}$left]}
            r {set new_lst [lreplace $new_lst {*}$left {*}$right]}
        }
    }
    return $new_lst
}
