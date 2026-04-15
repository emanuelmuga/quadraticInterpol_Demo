package require ::quartus::project
package require fileutil

# Project
set folderName "../quadraticInterpol_Demo" 

foreach file [fileutil::findByPattern $folderName *.v] {
    puts $file
    set_global_assignment -name VERILOG_FILE $file
}

