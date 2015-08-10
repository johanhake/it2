# simple hack to get around the limited table possibilities in doconce

latex_formats = {"code":r"\texttt{%s}",
                 "strong":r"\textbf{%s}",
                 "emph":r"\textit{%s}",
                 None:r"%s"}

html_formats = {"code":r"<xmp>%s</xmp>",
                "strong":r"<strong>%s</strong>",
                "emph":r"<em>%s</em>",
                None:r"%s"}


def tableify(format_, row_contents, col_postions, col_formats):

    if format_ in ["html", "mediawiki"]:
        return html_table(row_contents, col_postions, col_formats)
    elif format_ in ["latex", "pdflatex"]:
        return latex_table(row_contents, col_postions, col_formats)
    
def latex_table(row_contents, col_postions, col_formats):
    
    # add macro for multi line cells
    table_lines = []
    table_lines.append(r"\providecommand{\specialcell}[2][c]{\begin{tabular}[c]{@{}#1@{}}#2\end{tabular}}")
    table_lines.append(r"{\footnotesize\renewcommand{\arraystretch}{1.2}")
    table_lines.append(r"\vspace{2em}")
    table_lines.append(r"\begin{tabular}{%s}" % col_positions)
    table_lines.append(r"\hline")
    N_rows = len(row_contents)
    col_positions_stripped = "".join(col_postions.split("|"))
    N_cols = len(col_positions_stripped)

    for i, row in enumerate(row_contents):
        line = []
        for j, cell in enumerate(row):
            cell_format = latex_formats[col_formats.get(j)] if i != 0 else latex_formats["strong"]
            col_position = col_positions_stripped[j]
            if r"\\" in cell:
                cell = r"\\".join(cell_format % cell_line for cell_line in cell.split(r"\\"))
                line.append(r"\specialcell[%s]{%s}" % (col_position, cell))
            else:
                line.append(cell_format % cell)
        table_lines.append(r" & ".join(line)+r"\\")
        table_lines.append(r"\hline")

    table_lines.append(r"\end{tabular}")
    table_lines.append(r"}\renewcommand{\arraystretch}{1.0}")
    table_lines.append(r"\\")
    return "\n".join(table_lines)+"\n"
    
    with open(".latex_table_file_%d.do.txt" % table_cnt, "w") as f:
        f.write("\n".join(table_lines)+"\n")
    table_cnt += 1
    return table_cnt

def html_table(row_contents, col_postions, col_formats):

    table_lines = ["<p><table class=\"table table-stripped\">"]
    N_rows = len(row_contents)
    
    for i, row in enumerate(row_contents):
        line = []
        row_cell_format = r"<td>%s</td>" if i else r"<th>%s</th>"
        if i == 0:
            table_lines.append(r"<thead>")
        for j, cell in enumerate(row):
            cell_format = html_formats[col_formats.get(j)] if i != 0 else html_formats[None]
            if r"\\" in cell:
                cell = cell_format % cell.replace(r"\\", "\n")
                line.append(cell)
            else:
                line.append(cell_format % cell)
        table_lines.append(r"<tr>%s</tr>" % (r" ".join(row_cell_format % cell for cell in line)))
        if i == 0:
            table_lines.extend([r"</thead>", r"<tbody>"])
        elif i == N_rows-1:
            table_lines.append(r"</tbody>")
        
    table_lines.append(r"</table></p>")
    return "\n".join(table_lines)+"\n"

    with open(".html_table_file_%d.do.txt" % table_cnt, "w") as f:
        f.write("\n".join(table_lines)+"\n")
    table_cnt += 1
    return table_cnt

