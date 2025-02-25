#!/bin/bash

echo "Collecting data from remote machines..."

# List of remote machines
MACHINES=("Het Patel@192.168.56.1")

# Clear output file
> machine_info.txt

# Collecting data from remote machines
for MACHINE in "${MACHINES[@]}"; do
    echo "Checking SSH access to $MACHINE..."

    # Test SSH connection
    if ssh -o BatchMode=yes -o ConnectTimeout=5 "$MACHINE" "echo 'SSH connection successful'" 2>/dev/null; then
        echo "Connected to $MACHINE. Collecting data..."
        ssh "$MACHINE" 'find /path/to/scan -type f -exec ls -lh {} + | awk "{print \$9, \$1, int(\$5/1024)\" KB\"}"' >> machine_info.txt 2>>error.log
    else
        echo "Failed to connect to $MACHINE. Skipping..." | tee -a error.log
    fi
done

echo "Data collection complete. Stored in machine_info.txt."

# Step 2: Check if data exists
if [ ! -s machine_info.txt ]; then
    echo "No data collected. Please check SSH access or paths."
    exit 1
fi

# Step 3: Display file details
echo -e "\nFile Information from machine_info.txt:"
awk '{print "Filename: "$1", Type: "$2", Size: "$3}' machine_info.txt

# Step 4: Prepare data for gnuplot
awk '{print $2, $3}' machine_info.txt | sed 's/ KB//g' > file_sizes.dat

# Step 5: Verify plot data
if [ ! -s file_sizes.dat ]; then
    echo "No valid data to plot. Exiting."
    exit 1
fi

# Step 6: Generate gnuplot graph
echo "
set terminal png size 800,600
set output 'file_type_distribution.png'
set title 'File Size Distribution by Type'
set xlabel 'File Type'
set ylabel 'Size (KB)'
set style data histograms
set style fill solid border -1
plot 'file_sizes.dat' using 2:xtic(1) title 'File Size'
" | gnuplot

echo "Graph generated: file_type_distribution.png"
