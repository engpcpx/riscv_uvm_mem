# Verify file exists first
set wcfg_file [lindex $argv 1]
if {![file exists $wcfg_file]} {
    puts "ERROR: Wave config file $wcfg_file not found"
    exit 1
}

# Open with error handling
if {[catch {open_wave_database [lindex $argv 0]} err]} {
    puts "ERROR: Failed to open wave database: $err"
    exit 1
}

if {[catch {open_wave_config $wcfg_file} err]} {
    puts "ERROR: Failed to open wave config: $err"
    exit 1
}

start_gui