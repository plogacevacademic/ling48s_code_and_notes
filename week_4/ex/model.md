---
title             : "A little MPT Tutorial"
shorttitle        : "A little MPT Tutorial"
author: 
    
  - name          : "Pavel Logačev"
    affiliation   : "1"
    corresponding : yes    # Define only one corresponding author
    address       : "Postal address"
    email         : "pavel.logacev@boun.edu.tr"
affiliation:
    
  - id            : "1"
    institution   : "Boğaziçi University University, Istanbul, Turkey"
authornote: |
  Add complete departmental affiliations for each author here. Each new line herein must be indented, like this line.
  Enter author note here.
  
abstract: |
  This is very cool work on an extremely interesting topic.
  
  <!-- https://tinyurl.com/ybremelq -->
keywords          : "keywords"
wordcount         : "X"
bibliography      : []
floatsintext      : no
figurelist        : no
tablelist         : no
footnotelist      : no
linenumbers       : no
mask              : no
draft             : no
documentclass     : "apa6"
classoption       : "doc"
output            : 
  papaja::apa6_pdf:
    keep_md       : true
    includes:
        in_header: model_preamble.tex
editor_options: 
  chunk_output_type: console
---




## A multinomial processing tree generative model

### The model

\begin{forest}
for tree = {
% nodes
    draw, 
    align=center,
    minimum height=5ex,
    minimum width=3em,
    font=\linespread{0.84}\selectfont,
% tree
    grow'=0,
    parent anchor=east,
    child  anchor=west,
    s sep = 4mm,    
    l sep = 12mm, 
% edge
    edge = {semithick},
% level styles
if level = 0{}{rounded corners=2ex},
where n children=0{tier=level, sharp corners}{calign=edge midpoint},
% edge labels
EL/.style={edge label={node [pos=0.5, fill=white,
                             font=\scriptsize\sffamily,
                             inner sep=2pt] {$#1$}}
                    }
            }% end for tree
[,coordinate
 [NP1\\ attachment,no edge
    [recollection\\ certainty, EL=r
        ["NP1"]
    ]
    [recollection\\ uncertainity, EL=1-r,
        [guess "NP1", tier=L1, EL=g,
            ["NP1"]
        ]
        [guess "NP2", tier=L1, EL=1-g
            ["NP2"]
        ]
    ]
  ]
  [,coordinate, no edge]
  [NP2\\ attachment,no edge
    [recollection\\ certainty, EL=r
        ["NP2"]
    ]
    [recollection\\ uncertainity, EL=1-r,
        [guess "NP1", tier=L1, EL=g,
            ["NP1"]
        ]
        [guess "NP2", tier=L1, EL=1-g
            ["NP2"]
        ]
    ]
 ]
 [,coordinate, no edge]
  [ambiguous\\ attachment,no edge
    [recollection\\ certainity, EL=r,
        [preference for "NP1", tier=L1, EL=q,
            ["NP1"]
        ]
        [preference for "NP2", tier=L1, EL=1-q
            ["NP2"]
        ]
    ]
    [recollection\\ uncertainity, EL=1-r,
        [guess "NP1", tier=L1, EL=g,
            ["NP1"]
        ]
        [guess "np2", tier=L1, EL=1-g
            ["NP2"]
        ]
    ]
 ]
]
\end{forest}


### The predictions

In equations \@ref(eq:pNp1Np1), \@ref(eq:pNp1Np2), \@ref(eq:pNp1Amb) xxx.

\begin{equation}
P("NP1"|NP1) = r + (1-r) \cdot g
(\#eq:pNp1Np1)
\end{equation}

\begin{equation}
P("NP1"|NP2) = (1-r) \cdot g
(\#eq:pNp1Np2)
\end{equation}

\begin{equation}
P("NP1"|ambiguous) = r\cdot q + (1-r) \cdot g
(\#eq:pNp1Amb)
\end{equation}
  

### Naive estimation, simple conditions

- Let's use the numbers above as estimates of $P("NP1"|NP1)$, $P("NP1"|NP2)$, and $P("NP1"|ambiguous)$:

\begin{align*}
  0.905 &= r_s + (1-r_s) \cdot g_s \\ 
  0.227 &= (1-r_s) \cdot g_s \\ 
  0.668 &= r_s\cdot q_s + (1-r_s) \cdot g_s
\end{align*}

- This means:

\begin{align*}
  r_s &= 0.678 \\ 
  g_s &= 0.705 \\ 
  q_s &= 0.650
\end{align*}


### Naive estimation, complex conditions

- Let's apply the same logic here, too:

\begin{align*}
  0.919 &= r_c + (1-r_c) \cdot g_c \\ 
  0.241 &= (1-r_c) \cdot g_c \\ 
  0.750 &= r_c \cdot q_c + (1-r_c) \cdot g_c
\end{align*}

- This means:

\begin{align*}
  r_c &= 0.678 \\ 
  g_c &= 0.748 \\
  q_c &= 0.751
\end{align*}

- The parameters $q_s$ and $q_c$ differ by $0.1$, which is more than the difference between ambiguous conditions ($0.08$).
- The fact that $g_s$ and  $g_c$ differ substantially is quite certainly a problem.
- Complexity shouldn't influence g, by definition. Are potentially additional mechanisms at work, or is this just sampling error? It's actually not unlikely that this is sampling error, especially due to the fact that spellout.net doesn't properly balance participants across Latin-square lists.    
- Can we even compare $q$s, given this difference in $g$s?



\begin{center}
\begin{figure}
\begin{forest}
for tree = {
% nodes
    draw, 
    align=center,
    minimum height=5ex,
    minimum width=3em,
    font=\linespread{0.84}\selectfont,
% tree
    grow'=0,
    parent anchor=east,
    child  anchor=west,
    s sep = 4mm,    
    l sep = 12mm, 
% edge
    edge = {semithick},
% level styles
if level = 0{}{rounded corners=2ex},
where n children=0{tier=level, sharp corners}{calign=edge midpoint},
% edge labels
EL/.style={edge label={node [pos=0.5, fill=white,
                             font=\sffamily,
                             inner sep=2pt] {$#1$}}
                    }
            }% end for tree
[,coordinate
  [grammatical\\ sentence,no edge
        [attentive\\ state, EL=a
            ['acceptable']
        ]
        [inattentive\\ state, EL=1-a,
            ['acceptable', EL=g ]
            ['not acceptable', EL=1-g]
        ]
  ]
  [ungrammatical\\ sentence,no edge
        [attentive\\ state, EL=a
            ['not acceptable']
        ]
        [inattentive\\ state, EL=1-a,
            ['acceptable', EL=g ]
            ['not acceptable', EL=1-g]
        ]
  ]
]
\end{forest}
\caption{An MPT model of question answering with equal error rates for (i) N1 attachment, (ii) N2 attachment, and (iii) ambiguous sentences. }
\label{fig:mpt1}
\end{figure}
\end{center}

