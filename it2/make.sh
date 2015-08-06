DOCNAME=it2
TEXDOC=$DOCNAME.tex
BOOTWATCHSTYLE=journal # Check out https://bootswatch.com
doconce format html $DOCNAME --html_style=bootswatch_$BOOTWATCHSTYLE --html_admon=bootstrap_panel --html_bootstrap_jumbotron=off --html_bootstrap_navbar=on --encoding=utf-8 --pygments_html_linenos --examples_as_exercises
doconce split_html $DOCNAME

doconce format html $DOCNAME --html_output=$DOCNAME-solarized --html_style=solarized --encoding=utf-8 --pygments_html_linenos
doconce split_html $DOCNAME-solarized

doconce format pdflatex $DOCNAME --encoding=utf-8 --latex_admon=mdfbox --latex_font=palatino --latex_papersize=a4 --latex_admon_title_no_period --no_ampersand_quote --pygments_html_linenos --examples_as_exercises
doconce ptex2tex $DOCNAME envir=minted 
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
