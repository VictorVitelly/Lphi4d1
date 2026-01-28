
set ylabel 'freq.' font ',18' rotate by 0 offset -2,0
#set title 'Condensate' font ',18'
set xtics font ',14'
set ytics font ',14'
set grid x,y
set lmargin 14
set bmargin 4
set key font ',14'
#set key box vertical width -1 height 1
#set logscale y
#set yrange [0:1.6]
#set xrange [-3.25:0.25]
set multiplot layout 3,1

set title "μ^2=-3" font ',18'
p 'L16/histps3.dat' u 1:2:3 w errorbars title 'L=16' pt 1 lw 2, 'L32/histps3.dat' u 1:2:3 w errorbars title 'L=32' pt 1 lw 2, 'L64/histps3.dat' u 1:2:3 w errorbars title 'L=64' pt 1 lw 2, 'L128/histps3.dat' u 1:2:3 w errorbars title 'L=128' pt 1 lw 2

set title "μ^2=-1.5" font ',18'
p 'L16/hist1p5.dat' u 1:2:3 w errorbars title 'L=16' pt 1 lw 2, 'L32/hist1p5.dat' u 1:2:3 w errorbars title 'L=32' pt 1 lw 2, 'L64/hist1p5.dat' u 1:2:3 w errorbars title 'L=64' pt 1 lw 2, 'L128/hist1p5.dat' u 1:2:3 w errorbars title 'L=128' pt 1 lw 2

set title "μ^2=0" font ',18'
set xlabel 'ϕ' font ',18'
p 'L16/histps0.dat' u 1:2:3 w errorbars title 'L=16' pt 1 lw 2, 'L32/histps0.dat' u 1:2:3 w errorbars title 'L=32' pt 1 lw 2, 'L64/histps0.dat' u 1:2:3 w errorbars title 'L=64' pt 1 lw 2, 'L128/histps0.dat' u 1:2:3 w errorbars title 'L=128' pt 1 lw 2


unset multiplot
pause -1
