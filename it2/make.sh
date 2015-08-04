DOCNAM=it2
TEXDOC=$DOCNAM.tex
BOOTWATCHSTYLE=journal # Check out https://bootswatch.com
doconce format html $DOCNAM --html_style=bootswatch_$BOOTWATCHSTYLE --html_admon=bootstrap_panel --html_bootstrap_jumbotron=on --html_bootstrap_navbar=on --encoding=utf-8
doconce split_html $DOCNAM #--html_style=bootswatch_$BOOTWATCHSTYLE --html_bootstrap_jumbotron=off --html_bootstrap_navbar=on  --encoding=utf-8# --html_admon_shadow gray --html_admon_bg_color=F3F781
doconce format pdflatex $DOCNAM --encoding=utf-8 --latex_admon=mdfbox --latex_font=palatino --latex_papersize=a4 --latex_admon_title_no_period
doconce ptex2tex $DOCNAM envir=minted 
doconce replace 'linecolor=black,' 'linecolor=blue!80!black!20,' $TEXDOC
doconce replace 'background}{gray!5' 'background}{yellow!30' $TEXDOC
doconce subst 'frametitlebackgroundcolor=.*?,' 'frametitlebackgroundcolor=yellow!45,' it2.tex

# Fix bug when not using springer styles
doconce replace '\usepackage{lmodern}' '%\usepackage{lmodern}' $TEXDOC

# Fix some page settings
doconce replace '10pt]' '12pt]' $TEXDOC
doconce replace '\usepackage[a4paper]{geometry}' '\usepackage[a4paper, margin=1in]{geometry}' $TEXDOC

pdflatex -shell-escape $TEXDOC
pdflatex -shell-escape $TEXDOC
# Add more space before list (no sublist looks strange!)
#doconce replace '<ul>' '<p>&nbsp;&nbsp;<p><ul>' index.html
rm -f .*html_file_collection
