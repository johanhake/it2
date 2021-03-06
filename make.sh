DOCNAME=it2
TEXDOC=$DOCNAME.tex
BOOTWATCHSTYLE=journal # Check out https://bootswatch.com

# Compile it2 document using bootstrap theme
doconce format html $DOCNAME --html_style=bootswatch_$BOOTWATCHSTYLE --html_admon=bootstrap_panel --html_bootstrap_jumbotron=off --html_bootstrap_navbar=on --encoding=utf-8 --pygments_html_linenos --html_toc_depth=3  --without_solutions --html_output=index
doconce replace '<a href="laereplan_it.pdf" target="_self">PDF versjon av dette dokumentet (for printing)</a>' '<a href="laereplan_it/laereplan_it.pdf" target="_self">PDF versjon av dette dokumentet (for printing)</a>' index.html

doconce split_html index
doconce extract_exercises tmp_mako__$DOCNAME.do.txt

for f in $(ls part_index*.html); 
do 
    doconce replace '</li></li>' '</li>' $f;
done

# Compile it2 document using solarized theme
doconce format html $DOCNAME --html_output=$DOCNAME-solarized --html_style=solarized --encoding=utf-8 --pygments_html_linenos
doconce split_html $DOCNAME-solarized

# Compile it2 document to pdf
doconce format pdflatex $DOCNAME --encoding=utf-8 --latex_admon=mdfbox --latex_font=palatino --latex_papersize=a4 --latex_admon_title_no_period --no_ampersand_quote --pygments_html_linenos --examples_as_exercises --solutions_at_end --without_solutions --device=paper

doconce ptex2tex $DOCNAME envir=minted --device=paper
doconce replace 'linecolor=black,' 'linecolor=blue!80!black!20,' $TEXDOC
doconce replace 'background}{gray!5' 'background}{yellow!30' $TEXDOC
doconce subst 'frametitlebackgroundcolor=.*?,' 'frametitlebackgroundcolor=yellow!45,' $TEXDOC

# Fix bug when not using springer styles
doconce replace '\usepackage{lmodern}' '%\usepackage{lmodern}' $TEXDOC

# Fix some page settings
doconce replace '10pt]' '12pt]' $TEXDOC
doconce replace '\usepackage[a4paper]{geometry}' '\usepackage[a4paper, margin=1in]{geometry}
\usepackage{titlesec}
\usepackage{fancyhdr}
\titleformat{\chapter}[hang]
  {\Huge\bfseries}{\thechapter{}. }{1pt}{\Huge}
\pagestyle{fancy}
\fancyhf{}\fancyhead[RE]{}\fancyhead[LO]{}\fancyhead[LE,RO]{\thepage}' $TEXDOC

pdflatex -shell-escape $TEXDOC
pdflatex -shell-escape $TEXDOC

# Compile laereplanen
pushd laereplan_it
bash make.sh
popd

# Update kode zip file
rm kode.zip
cd gist
zip -r ../kode.zip eksempler --exclude */.git

# Add more space before list (no sublist looks strange!)
#doconce replace '<ul>' '<p>&nbsp;&nbsp;<p><ul>' index.html
rm -f .*html_file_collection
