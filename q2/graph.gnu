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
plot 'graph.dat' using 2:xtic(1) with histogram linecolor rgb "skyblue"
