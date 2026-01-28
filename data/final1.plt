set xlabel 'μ^2' font ',18'
set ylabel 'M' font ',18' rotate by 0 offset -2,0
#set title 'Condensate' font ',18'
set xtics font ',14'
set ytics font ',14'
set grid x,y
set lmargin 14
set bmargin 4
set key font ',14'
#set key box vertical width -1 height 1
#set logscale y
set yrange [0:1.6]
set xrange [-3.25:0.25]
set multiplot layout 1,2

set title "Mean Condensate" font ',18'
p 'L16/magnet.dat' u 1:2:3 w errorbars title 'L=16' pt 1 lw 2, 'L32/magnet.dat' u 1:2:3 w errorbars title 'L=32' pt 1 lw 2, 'L64/magnet.dat' u 1:2:3 w errorbars title 'L=64' pt 1 lw 2, 'L128/magnet.dat' u 1:2:3 w errorbars title 'L=128' pt 1 lw 2

set title "Condensate per Site" font ',18'
p 'L16/magnetps.dat' u 1:2:3 w errorbars title 'L=16' pt 1 lw 2, 'L32/magnetps.dat' u 1:2:3 w errorbars title 'L=32' pt 1 lw 2, 'L64/magnetps.dat' u 1:2:3 w errorbars title 'L=64' pt 1 lw 2, 'L128/magnetps.dat' u 1:2:3 w errorbars title 'L=128' pt 1 lw 2
unset multiplot
pause -1
