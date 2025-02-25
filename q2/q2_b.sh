#!/bin/bash

target_dir="/mnt/s"

# Check if the directory exists
if [ ! -d "$target_dir" ]; then
    echo "Error: Directory '$target_dir' not found."
    exit 1
fi

output_file="graph.dat"
echo -e "Type\tSizeKB" > "$output_file"

# Collect data
find "$target_dir" -mindepth 1 -maxdepth 1 -print0 | while IFS= read -r -d '' item; do
    if [ -d "$item" ]; then
        size=$(du -sk "$item" | cut -f1)
        echo -e "Directory\t$size" >> "$output_file"
    elif [ -f "$item" ]; then
        size=$(du -k "$item" | cut -f1)
        echo -e "File\t$size" >> "$output_file"
    else
        echo -e "Other\t0" >> "$output_file"
    fi
done

# Check if file_info.dat has valid data (excluding the header)
if [ $(wc -l < "$output_file") -le 1 ]; then
    echo "Error: No valid data collected for plotting."
    exit 1
fi

# Create Gnuplot script
gnuplot_script="graph.gnu"
cat <<EOF > "$gnuplot_script"
set terminal pngcairo enhanced font 'Arial,12' size 800,600
set output 'graph.png'
set title 'File and Directory Sizes by Type'
set xlabel 'File Type'
set ylabel 'Size (KB)'
set style data histograms
set style fill solid
set boxwidth 0.6
set grid ytics
set key off
plot '$output_file' using 2:xtic(1) with histogram linecolor rgb "skyblue"
EOF

# Run Gnuplot
gnuplot "$gnuplot_script"

# Display the plot
if [ -f "graph.png" ]; then
    echo "Plot generated: graph.png"
    gio open graph.png
else
    echo "Failed to generate plot."
fi
