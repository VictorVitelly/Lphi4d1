set xlabel 'μ^2' font ',18' offset 0,-1
set ylabel 'ξ' font ',18' rotate by 0 offset -2,0
set title 'Correlation Length' font ',18'
set xtics font ',14'
set ytics font ',14'
set grid x,y
set lmargin 14
set bmargin 4
set key font ',14'
set key right
#set key box vertical width -1 height 1
set logscale y
#set yrange [0.0:6]
set xrange [-4.5:0.25]
p 'L16/results.dat' u 1:2:3 w errorbars title 'L=16' lw 2, 'L32/results.dat' u 1:2:3 w errorbars title 'L=32' lw 2, 'L64/results.dat' u 1:2:3 w errorbars title 'L=64' lw 2, 'L128/results.dat' u 1:2:3 w errorbars title 'L=128', 'L256/results.dat' u 1:2:3 w errorbars title 'L=256' lw 2 lc "red"
pause -1
