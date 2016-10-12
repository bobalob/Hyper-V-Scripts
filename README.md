# Hyper-V-Scripts
Random Hyper-V Scripts

    Fix-BrokenMemory.PS1
    
Script will detect Hyper-V VMs on a cluster that are 'stuck' at the Startup Memory value of the VM and won't dynamically grow their memory even though demand is high. Migrating the VM to a new host fixes this issue.
